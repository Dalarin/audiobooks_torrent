// ignore_for_file: file_names

import 'dart:convert' show utf8;
import 'dart:developer';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proxies/proxies.dart';

import 'package:http/http.dart' as http;
import 'package:rutracker_app/providers/storageManager.dart';

class PageProvider {
  bool authorized = false;
  String cookie = "";
  final String _host = "https://rutracker.org";
  String _loginURL = "";
  String _searchURL = "";
  String _threadURL = "";
  http.Response? response;
  late SimpleProxyProvider proxyProvider;
  late Proxy proxy;
  late IOClient client;

  void loadInfo() async {
    proxyProvider = SimpleProxyProvider(
      '45.142.28.83',
      8094,
      'ppxvhriy',
      'san9ra7rjh3v',
    );
    proxy = await proxyProvider.getProxy();
    client = proxy.createIOClient();
  }

  PageProvider() {
    loadInfo();
    _loginURL = "$_host/forum/login.php";
    _searchURL = "$_host/forum/tracker.php";
    _threadURL = "$_host/forum/viewtopic.php";
  }

  Future<bool> login(String username, String password) async {
    response = await client
        .post(Uri.parse(_loginURL),
            body: {
              "login_username": username,
              "login_password": password,
              "login": "Вход"
            },
            encoding: utf8)
        .then((response) {
      if (response.statusCode == 302) {
        cookie = response.headers['set-cookie'].toString();
        cookie = cookie.substring(
          cookie.indexOf('bb_session'),
          cookie.lastIndexOf('expires'),
        );
        authorized = true;
        StorageManager.saveData('cookies', cookie);
      } else {
        throw Exception("Ошибка авторизации = ${response.statusCode}");
      }
    });
    return true;
  }

  search(String query, String categories) async {
    if (!authorized) {
      throw Exception("Ошибка авторизации");
    } else {
      var response = await client.post(Uri.parse(_searchURL), body: {
        "nm": query,
        "o": "10",
        'f': categories,
      }, headers: {
        "Cookie": cookie
      });
      log(response.statusCode.toString());
      return response;
    }
  }

  downloadTorrent(String link, String directory) async {
    var applicationDirectory = await getApplicationDocumentsDirectory();
    final directory = Directory('${applicationDirectory.path}/torrents/');
    var response = await client.get(
      Uri.parse('https://rutracker.org/forum/dl.php?t=$link'),
      headers: {'Cookie': cookie},
    );
    File torrentFile = File('${directory.path}/$link.torrent');
    torrentFile.writeAsBytes(response.bodyBytes);
  }

  page(String link) async {
    if (!authorized) {
      throw Exception("Ошибка авторизации");
    } else {
      var url = Uri.parse(_threadURL + "?t=$link");
      var response = await client.get(url, headers: {"Cookie": cookie});
      return response;
    }
  }

  restoreCookies(String cookies) async {
    try {
      if (cookies.isNotEmpty) {
        var response = await client.get(
          Uri.parse(_searchURL),
          headers: {"Cookie": cookies},
        );
        if (!response.headers.keys.contains("redirect")) {
          cookie = cookies;
          authorized = true;
          return true;
        }
      }
    } on SocketException {
      return true;
    } catch (_) {
      return false;
    }
    return false;
  }
}
