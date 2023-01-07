import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rutracker_api/src/providers/enums.dart';
import 'package:rutracker_api/src/providers/exceptions.dart';

class PageProvider {
  late String _host;
  late String _loginUrl;
  late String _searchUrl;
  late String _topicUrl;
  bool _authenticated = false;
  final Dio _dio;

  PageProvider._create(this._dio) {
    _host = 'https://rutracker.org';
    _loginUrl = '$_host/forum/login.php';
    _searchUrl = '$_host/forum/tracker.php';
    _topicUrl = '$_host/forum/viewtopic.php';
  }

  static Future<List<Object>> create(Dio dio) async {
    var component = PageProvider._create(dio);
    return [component, await _checkAuthentication(dio, component)];
  }

  static Future<bool> _checkAuthentication(Dio dio, PageProvider pageProvider) async {
    try {
      Response response = await dio.get('https://rutracker.org/forum/tracker.php');
      if (response.data.contains('logged-in-username')) {
        pageProvider._authenticated = true;
        return Future.value(true);
      }
      return Future.value(false);
    } on DioError catch (error) {
      if (error.message.contains('HttpException')) {
        return Future.value(false);
      }
      return Future.value(true);
    }
  }

  Future<bool> authentication(String username, String password) async {
    Response response = await _dio.post(
      _loginUrl,
      data: FormData.fromMap({
        'login_username': username,
        'login_password': password,
        'login': 'Вход',
      }),
    );
    if (response.statusCode == 302) {
      _authenticated = true;
      return true;
    } else {
      throw AuthenticationError('Ошибка авторизации');
    }
  }

  Future<Response> searchByQuery(String query, Categories categories) async {
    if (!_authenticated) {
      throw AuthenticationError('Пользователь не авторизован');
    } else {
      Response response = await _dio.post(
        _searchUrl,
        data: FormData.fromMap({
          "nm": query,
          'o': '10', // SORT BY SEEDERS
          'f': categories.code,
        }),
      );
      return response;
    }
  }

  Future<Response> getCommentsResponse(String link, int start) async {
    if (!_authenticated) {
      throw AuthenticationError('Пользователь не авторизован');
    } else {
      Response response = await _dio.get(
        _topicUrl,
        queryParameters: {'t': link, 'start': start},
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Ошибка получения данных страницы');
      }
    }
  }

  Future<Response> getPageResponse(String link) async {
    if (!_authenticated) {
      throw AuthenticationError('Пользователь не авторизован');
    } else {
      Response response = await _dio.get(
        _topicUrl,
        queryParameters: {'t': link},
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Ошибка получения данных страницы');
      }
    }
  }

  Future<File> downloadTorrentFile(String link, String pathDirectory) async {
    if (!_authenticated) {
      throw AuthenticationError('Пользователь не авторизован');
    } else {
      final urlPath = '$_host/forum/dl.php';
      await _dio.download(
        urlPath,
        pathDirectory,
        queryParameters: {'t': link},
      );
      return File.fromUri(Uri.parse(pathDirectory));
    }
  }
}
