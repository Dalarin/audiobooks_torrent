library rutracker_api;

import 'dart:developer';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/models/query_response.dart';
import 'package:rutracker_app/rutracker/page-provider.dart';
import 'package:rutracker_app/rutracker/parser.dart';
import 'package:rutracker_app/rutracker/providers/cp1251.dart';

class RutrackerApi {
  PageProvider pageProvider;
  Parser parser = Parser();

  RutrackerApi({required this.pageProvider});

  /// Авторизация на сайте
  Future<bool> login(String username, String password) async {
    try {
      return await pageProvider.login(username, password);
    } catch (E) {
      return false;
    }
  }

  /// Поиск аудиокниг по запросу/категории
  Future<List<QueryResponse>?> search(String query, String category) async {
    http.Response response = await pageProvider.search(query, category);
    var body = cp1251.decodeCp1251(response.body);
    Document document = parse(body);
    return parser.parseQuery(document);
  }

  /// Получить книгу
  Future<Book?> parseBook(String link) async {
    http.Response response = await pageProvider.page(link);
    var body = cp1251.decodeCp1251(response.body);
    Document document = parse(body);
    return parser.parseBook(document, link);
  }

  /// Получить прикрепленные книги
  Future<List<Book?>?> getPinnedBooks(String link, RutrackerApi api) async {
    http.Response response = await pageProvider.page(link);
    var body = cp1251.decodeCp1251(response.body);
    Document document = parse(body);
    return parser.getSimilarBooks(document, api);
  }

  /// Скачать .torrent файл
  Future<File> downloadFile(dynamic link, String directory) async {
    return await pageProvider.downloadTorrent(link.toString(), directory);
  }

  /// Восстановить cookies
  Future<bool> restoreCookies(String cookies) async {
    bool response = await pageProvider.restoreCookies(cookies);
    return response;
  }
}
