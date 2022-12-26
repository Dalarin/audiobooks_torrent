import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rutracker_api/src/providers/enums.dart';
import 'package:rutracker_api/src/providers/exceptions.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'cp1251_decoder.dart';

class PageProvider {
  late String _host;
  late String _loginUrl;
  late String _searchUrl;
  late String _topicUrl;
  bool _authenticated = false;
  final Dio _dio;
  final PersistCookieJar _cookieJar;

  PageProvider._create(this._dio, this._cookieJar) {
    _host = 'https://rutracker.org';
    _loginUrl = '$_host/forum/login.php';
    _searchUrl = '$_host/forum/tracker.php';
    _topicUrl = '$_host/forum/viewtopic.php';
  }

  static Future<List<Object>> create(Dio dio, PersistCookieJar cookieJar) async {
    var component = PageProvider._create(dio, cookieJar);
    return [component, await _checkAuthentication(dio, component)];
  }

  static Future<bool> _checkAuthentication(Dio dio, PageProvider pageProvider) async {
    Response response = await dio.get('https://rutracker.org/forum/tracker.php');
    if (response.data.contains('logged-in-username')) {
      pageProvider._authenticated = true;
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<bool> authentication(String username, String password) async {
    await _dio.post(
      _loginUrl,
      data: FormData.fromMap({
        'login_username': username,
        'login_password': password,
        'login': 'Вход',
      }),
    ).then((Response response) {
      if (response.statusCode == 302) {
        String cookies = response.headers['set-cookie'].toString();
        cookies = cookies.substring(
          cookies.indexOf('bb_session'),
          cookies.lastIndexOf('expires'),
        );
        _authenticated = true;
        _cookieJar.saveFromResponse(Uri.parse(_host), [Cookie.fromSetCookieValue(cookies)]);
        return true;
      } else {
        throw AuthenticationError('Ошибка авторизации');
      }
    });
    return false;
  }

  Future<Response> searchByQuery(String query, Categories categories) async {
    if (!_authenticated) {
      throw AuthenticationError('Пользователь не авторизован');
    } else {
      Response response = await _dio.post(
        _searchUrl,
        data: FormData.fromMap({
          "nm": query,
          'o': '10',
          'f': categories.code,
        }),
        options: Options(
          responseDecoder: (codeUnits, _, __) => Cp1251Decoder().decode(codeUnits),
        ),
      );
      return response;
    }
  }

  Future<Response> getCommentsResponse(String link, String start) async {
    Map<String, dynamic> parameters = start == '0' ? {'t': link} : {'t': link, 'start': start};
    if (!_authenticated) {
      throw AuthenticationError('Пользователь не авторизован');
    } else {
      Response response = await _dio.get(
        _topicUrl,
        queryParameters: parameters,
        options: Options(
          responseDecoder: (codeUnits, _, __) => Cp1251Decoder().decode(codeUnits),
        ),
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
        options: Options(
          responseDecoder: (codeUnits, _, __) => Cp1251Decoder().decode(codeUnits),
        ),
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
