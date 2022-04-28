library rutracker_api;

import 'dart:developer';

import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:rutracker_app/rutracker/models/book.dart';
import 'package:rutracker_app/rutracker/models/torrent.dart';
import 'package:rutracker_app/rutracker/page-provider.dart';
import 'package:rutracker_app/rutracker/parser.dart';
import 'package:rutracker_app/rutracker/providers/cp1251.dart';

class RutrackerApi {
  PageProvider pageProvider = PageProvider();
  Parser parser = Parser();

  Future<bool> login(String username, String password) async {
    try {
      return await pageProvider.login(username, password);
    } catch (E) {
      log("Authorization error.");
      return false;
    }
  }

  Future<List<Torrent>> search(String query, String category) async {
    http.Response response = await pageProvider.search(query, category);
    var body = cp1251.decodeCp1251(response.body);
    Document document = parse(body);
    return parser.parseQuery(document);
  }

// получить книгу
  Future<Book> openBook(String link) async {
    http.Response response = await pageProvider.page(link);
    var body = cp1251.decodeCp1251(response.body);
    Document document = parse(body);
    return parser.parseBook(document, link);
  }

  Future<List<Book>> getSimilarBooks(String link, RutrackerApi api) async {
    http.Response response = await pageProvider.page(link);
    var body = cp1251.decodeCp1251(response.body);
    Document document = parse(body);
    return parser.getSimilarBooks(document, api);
  }

  Future<bool> restoreCookies(String cookies) async {
    bool response = await pageProvider.restoreCookies(cookies);
    return response;
  }
}
