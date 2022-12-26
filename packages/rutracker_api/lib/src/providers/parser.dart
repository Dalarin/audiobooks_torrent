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

  List<Map<String, dynamic>> parseCommentsResponse(Document document) {
    List<Map<String, dynamic>> response = [];
    try {
      print(document.getElementsByClassName('topic'));
      Element element = document.getElementsByClassName('topic').first;
      List<Element> commentsElements = element.getElementsByTagName('tbody');
      commentsElements = commentsElements.sublist(1);
      for (Element comment in commentsElements) {
        Element mainInfo = comment.getElementsByClassName('poster_info td1 hide-for-print').first;
        String message = comment.getElementsByClassName('message td2').first.getElementsByClassName('post_body').first.text;
        response.add({
          'nickname': comment.getElementsByClassName('nick').first.text,
          'avatar': comment.getElementsByTagName('img').first.attributes['title'],
          'date': comment.getElementsByClassName('p-link small').first.text,
        });
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
      response['image'] = element.getElementsByClassName('postImg postImgAligned img-right').first.attributes['title'];
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
