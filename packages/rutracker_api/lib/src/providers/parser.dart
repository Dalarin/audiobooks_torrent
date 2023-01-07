import 'dart:developer';

import 'package:html/dom.dart';

class Parser {
  List<Map<String, dynamic>> parseQueryResponse(Document document) {
    List<Map<String, dynamic>> responses = [];
    try {
      Element? mainContent = document.getElementById('search-results')?.children[1];
      if (mainContent != null) {
        for (Element response in mainContent.getElementsByClassName('tCenter hl-tr')) {
          var link = response.getElementsByClassName('row1 t-ico').first.attributes['id'];
          var forum = response.getElementsByClassName('row1 f-name-col').first.text.trim();
          var theme = response.getElementsByClassName('row4 med tLeft t-title-col tt').first.text.trim();
          var author = response.getElementsByClassName('row1 u-name-col').first.text.trim();
          var size = response.getElementsByClassName('row4 small nowrap tor-size').first.text.trim();
          var added = response.getElementsByClassName('row4 small nowrap')[1].text.trim();
          responses.add({
            'link': link,
            'forum': forum,
            'theme': theme,
            'author': author,
            'size': size.substring(0, size.length - 1),
            'added': added,
          });
        }
      }
      return responses;
    } on Exception {
      throw Exception('Ошибка парсинга');
    }
  }

  String _findOptionalLine(List<String> elements, String query) {
    List<String> filteredElements = elements.where((element) {
      return element.contains(query);
    }).toList();
    if (filteredElements.isNotEmpty) {
      String filteredElement = filteredElements.first;
      return filteredElement.substring(filteredElement.indexOf(':') + 1).trim();
    } else {
      return 'Не найдено';
    }
  }

  String _findImage(Element element) {
    try {
      String? image = element.getElementsByClassName('postImg postImgAligned img-right').first.attributes['title'];
      return image ?? 'nothing';
    } on Exception {
      return 'nothing';
    }
  }

  String _findImageInComment(Element element) {
    try {
      String? image = element.getElementsByClassName('avatar').first.children.first.attributes['src'];
      image ??= 'nothing';
      return image;
    } catch (exception) {
      return 'nothing';
    }
  }

  List<Map<String, dynamic>> parseCommentsResponse(Document document, int start) {
    List<Map<String, dynamic>> response = [];
    int skipLength = start > 0 ? 1 : 2;
    try {
      Element? element = document.getElementById('topic_main');
      if (element != null) {
        for (Element comment in element.children.sublist(skipLength)) {
          response.add({
            'nickname': comment.getElementsByClassName('nick').first.text.trim(),
            'avatar': _findImageInComment(comment),
            'date': comment.getElementsByClassName('p-link small').first.text.trim(),
            'message': comment.getElementsByClassName('post_body').first.text.trim(),
          });
        }
      }
    } catch (exception) {
      throw Exception('Ошибка получения комментариев');
    }
    return response;
  }

  Map<String, dynamic> parsePage(Document document) {
    try {
      Element element = document.getElementsByClassName('post_body').first;
      List<String> info = element.text.substring(0, element.text.indexOf('Описание')).split('\n');
      Map<String, dynamic> response = {};
      response['title'] = info.firstWhere((element) => element.trim().isNotEmpty);
      response['image'] = _findImage(element);
      response['author'] = '${_findOptionalLine(info, 'Имя')} ${_findOptionalLine(info, 'Фамилия')}';
      response['executor'] = _findOptionalLine(info, 'Исполнитель');
      response['genre'] = _findOptionalLine(info, 'Жанр');
      response['audio'] = _findOptionalLine(info, 'Время звучания');
      response['description'] = element.text.substring(element.text.indexOf('Описание:')).trim();
      response['optionalInfo'] = Map.from({
        'releaseYear': _findOptionalLine(info, 'Год выпуска'),
        'series': _findOptionalLine(info, 'Цикл'),
        'bookNumber': _findOptionalLine(info, 'Номер книги'),
        'bitrate': _findOptionalLine(info, 'Битрейт'),
      });
      return response;
    } on Exception catch (exception) {
      log(exception.toString());
      throw Exception('Ошибка парсинга страницы');
    }
  }
}
