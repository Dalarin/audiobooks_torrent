import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_proxy_adapter/dio_proxy_adapter.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:rutracker_api/rutracker_api.dart';
import 'package:rutracker_api/src/providers/enums.dart';
import 'package:rutracker_api/src/providers/page_provider.dart';
import 'package:rutracker_api/src/providers/parser.dart';
import 'package:cookie_jar/cookie_jar.dart';

class RutrackerApi {
  final Dio _dio = Dio();
  late final PageProvider _pageProvider;
  late final Parser _parser;

  /// The [proxyUrl] variable should have the form username:password@host:port,
  ///
  /// in the absence of a login and password, the variable should have the form host:port
  ///
  /// Example with login and password: jafprrvt:rnvnodrqf6p2@185.199.229.156:7492
  Future<List<Object>> create({required String proxyUrl, required String cookieDirectory}) async {
    var cookieJar = PersistCookieJar(storage: FileStorage(cookieDirectory));
    _dio.useProxy(proxyUrl);
    _dio.interceptors.add(CookieManager(cookieJar));
    _dio.options = BaseOptions(validateStatus: (status) => status! < 500);
    _parser = Parser();
    List<Object> object = await PageProvider.create(_dio, cookieJar);
    _pageProvider = object[0] as PageProvider;
    return [this, object[1]];
  }

  /// Use it for authentication.
  Future<bool> authentication({
    required String login,
    required String password,
  }) {
    return _pageProvider.authentication(login, password);
  }

  Future<Map<String, dynamic>> getPage({required String link}) async {
    Response response = await _pageProvider.getPageResponse(link);
    Document document = parse(response.data);
    return _parser.parsePage(document);
  }

  Future<List<Map<String, dynamic>>> getComments({required String link, String start = '0'}) async {
    Response response = await _pageProvider.getCommentsResponse(link, start);
    Document document = parse(response.data);
    return _parser.parseCommentsResponse(document);
  }

  Future<List<Map<String, dynamic>>> searchByQuery({required String query, required Categories categories}) async {
    Response response = await _pageProvider.searchByQuery(query, categories);
    Document document = parse(response.data);
    return _parser.parseQueryResponse(document);
  }

  Future<File> downloadTorrentFile({required String link, required String pathDirectory}) {
    return _pageProvider.downloadTorrentFile(link, pathDirectory);
  }
}
