// ignore_for_file: file_names

import 'dart:convert' show utf8;
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proxies/proxies.dart';

import '../providers/storage_manager.dart';

class PageProvider {
  final String _host = "https://rutracker.org";
  bool authorized = false;
  String cookie = "";
  String _loginURL = "";
  String _searchURL = "";
  String _threadURL = "";
  SimpleProxyProvider proxyProvider;
  late final IOClient client;

  PageProvider._create(this.client, this.proxyProvider) {
    _loginURL = "$_host/forum/login.php";
    _searchURL = "$_host/forum/tracker.php";
    _threadURL = "$_host/forum/viewtopic.php";
  }

  static Future<PageProvider> create({
    required SimpleProxyProvider proxyProvider,
  }) async {
    return PageProvider._create(
      (await proxyProvider.getProxy()).createIOClient(),
      proxyProvider,
    );
  }

  Future<bool> login(String username, String password) async {
    Response response = await client.post(
      Uri.parse(_loginURL),
      body: {
        "login_username": username,
        "login_password": password,
        "login": "Вход"
      },
      encoding: utf8,
    );
    if (response.statusCode == 302) {
      cookie = response.headers['set-cookie'].toString();
      cookie = cookie.substring(
        cookie.indexOf('bb_session'),
        cookie.lastIndexOf('expires'),
      );
      authorized = true;
      log(response.reasonPhrase.toString());
      StorageManager.saveData('cookies', cookie);
    } else {
      throw Exception("Ошибка авторизации = ${response.statusCode}");
    }
    return true;
  }

  search(String query, String categories) async {
    if (!authorized) {
      throw Exception("Ошибка авторизации");
    } else {
      var response = await client.post(Uri.parse(_searchURL), body: {
        "nm": query,
        'o': '10',
        'f': categories,
      }, headers: {
        "Cookie": cookie
      });
      return response;
    }
  }

  Future<File> downloadTorrent(String link, String directory) async {
    var applicationDirectory = await getApplicationDocumentsDirectory();
    final directory = Directory('${applicationDirectory.path}/torrents');
    var response = await client.get(
      Uri.parse('https://rutracker.org/forum/dl.php?t=$link'),
      headers: {'Cookie': cookie},
    );
    File torrentFile = File('${directory.path}/$link.torrent');
    return torrentFile.writeAsBytes(response.bodyBytes);
  }

  page(String link) async {
    if (!authorized) {
      throw Exception("Ошибка авторизации");
    } else {
      var url = Uri.parse("$_threadURL?t=$link");
      var response = await client.get(url, headers: {"Cookie": cookie});
      return response;
    }
  }

  restoreCookies(String cookies) async {
    try {
      cookies = cookies.substring(1, cookies.length - 1).trim();
      if (cookies.isNotEmpty) {
        var response = await client.get(
          Uri.parse(_searchURL),
          headers: {"Cookie": cookies},
        );
        if (response.body.contains('logged-in-username')) {
          cookie = cookies;
          authorized = true;
          return true;
        }
      }
      return false;
    } on SocketException {
      return true;
    } catch (_) {
      throw Exception('Ошибка восстановления данных входа');
    }
  }
}
