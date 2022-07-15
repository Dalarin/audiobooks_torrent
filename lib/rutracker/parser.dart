import 'dart:developer';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/models/listeningInfo.dart';
import 'package:rutracker_app/rutracker/models/torrent.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

class Parser {
  int findQuery(String query, List<String> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].toLowerCase().contains(query.toLowerCase())) {
        return i;
      }
    }
    throw Exception("Не найдено");
  }

  bool contains(List<String> list, String query) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].toLowerCase().contains(query.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  List<Torrent> parseQuery(Document document) {
    List<Torrent> torrents = [];
    var tracks = document
        .getElementsByTagName("#tor-tbl tbody")[0]
        .getElementsByTagName("tr");
    for (int i = 0; i < tracks.length; i++) {
      var documents = tracks[i].getElementsByTagName("td");
      if (documents.length > 1) {
        torrents.add(Torrent(
            forum: documents[2].text.trim(),
            theme: documents[3].text.trim(),
            size: documents[5].text.trim(),
            link: documents[3]
                .getElementsByTagName('a')[0]
                .attributes['data-topic_id']
                .toString()));
      } else {
        throw Exception("Не найдено");
      }
    }
    return torrents;
  }

  List<String> _getTitle(String text) => text.split("Год");

  String _getRelease(List<String> list) {
    try {
      return list[findQuery("Выпуска:", list)].split(":")[1].trim();
    } catch (_) {
      return 'Не найдено';
    }
  }

  String _getAuthor(List<String> list) {
    try {
      return contains(list, "Имя")
          ? list[findQuery("Имя автора", list)].split(":")[1].trim() +
              " " +
              list[findQuery("Фамилия автора", list)].split(":")[1].trim()
          : list[findQuery("Автор", list)].trim().split(":")[1];
    } catch (_) {
      return 'Не найдено';
    }
  }

  String _getExecutor(List<String> list) {
    try {
      return list[findQuery("Исполнитель", list)].trim().split(":")[1].trim();
    } catch (E) {
      return 'Не найдено';
    }
  }

  String _getBitrate(List<String> list) {
    try {
      return list[findQuery("Битрейт", list)].trim().split(":")[1].trim();
    } catch (E) {
      return 'Не найдено';
    }
  }

  String _getTime(List<String> list) {
    try {
      String string = list[findQuery("Время", list)].trim();
      return string
          .substring(string.indexOf(":") + 1, string.indexOf(":") + 10)
          .trim()
          .replaceAll(RegExp(r'[A-Za-zА-Яа-я]'), "");
    } catch (E) {
      log("Time not loaded");
      return 'Не найдено';
    }
  }

  String _getOverview(Document documents) {
    try {
      return documents.body!.text
          .trim()
          .substring(documents.body!.text.trim().indexOf("/span>: ") + 7)
          .trim();
    } catch (E) {
      return 'Не найдено';
    }
  }

  String? _getImage(Document document) {
    try {
      return document
          .getElementsByClassName("postImg postImgAligned img-right")[0]
          .attributes['title'];
    } catch (E) {
      log("Image not loaded");
    }
  }

  String _getSeries(List<String> list) {
    try {
      return list[findQuery("серия:", list)].split(":")[1].trim();
    } catch (e) {
      return 'Не найдено';
    }
  }

  String _getBookNumber(List<String> list) {
    try {
      return list[findQuery("книги:", list)].split(":")[1];
    } catch (E) {
      return 'Не найдено';
    }
  }

  String _getGenre(List<String> list) {
    try {
      var genre = list[findQuery("Жанр", list)].trim().split(":")[1].trim();
      return genre.contains(",")
          ? genre.split(",")[0].capitalize()
          : genre.capitalize();
    } catch (E) {
      return 'Не найдено';
    }
  }

  List<String> similarBooks(var outerHtml) {
    List<String> linkedBooks = [];
    for (int i = 0; i < outerHtml.length; i++) {
      try {
        var outerHtmls = outerHtml[i].outerHtml.toString();
        var substring = outerHtmls.substring(
            outerHtmls.indexOf("viewtopic.php?t="),
            outerHtmls.indexOf('class="postLink"'));
        linkedBooks.add(substring.substring(
            substring.indexOf("=") + 1, substring.indexOf('"')));
      } catch (_) {}
    }
    return linkedBooks;
  }

  String _getSize(Document document) {
    try {
      var size = document
          .getElementsByClassName("post_wrap")[0]
          .getElementsByClassName("row1")[3]
          .text;
      size = size.substring(size.indexOf(":") + 1, size.indexOf("С")).trim();
      return size;
    } catch (e) {
      return "Не найдено";
    }
  }

  Future<List<Book>> getSimilarBooks(
      Document document, RutrackerApi api) async {
    List<String> similarBook = similarBooks(document
        .getElementsByClassName("post_body")[0]
        .getElementsByTagName('a'));
    similarBook.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    int endIndex = similarBook.length >= 5 ? 5 : similarBook.length;
    similarBook = similarBook.sublist(0, endIndex).toSet().toList();
    List<Book> books = [];
    for (int i = 0; i < similarBook.length; i++) {
      books.add(await api.openBook(similarBook[i]));
    }
    return books;
  }

  Book parseBook(Document document, String link) {
    var doc =
        document.getElementsByClassName("post_wrap")[0].children[0].text.trim();
    var docs = _getTitle(doc)[1].toString().split("\n");
    var docses = document.getElementsByClassName("post_wrap")[0].outerHtml;
    Document documents = parse(docses.substring(
        docses.indexOf("Описание") + 9, docses.lastIndexOf('class="clear"')));
    var overview = _getOverview(documents);
    return Book(
        series: _getSeries(docs),
        bookNumber: _getBookNumber(docs),
        size: _getSize(document),
        id: int.parse(link),
        genre: _getGenre(docs),
        title: _getTitle(doc)[0].toString().replaceAll("\n", ""),
        releaseYear: _getRelease(docs),
        author: _getAuthor(docs),
        executor: _getExecutor(docs),
        bitrate: _getBitrate(docs),
        image: _getImage(document) ?? " ",
        time: _getTime(docs),
        description:
            overview.startsWith(':') ? overview.substring(1).trim() : overview,
        listeningInfo: listeningInfo(
            bookID: int.parse(link),
            maxIndex: 0,
            isCompleted: false,
            index: 0,
            position: 0,
            speed: 1.0),
        isDownloaded: false,
        isFavorited: false);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
