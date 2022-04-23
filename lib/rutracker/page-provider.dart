// ignore_for_file: file_names

import 'dart:convert' show utf8;
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rutracker_app/providers/constants.dart';

class PageProvider {
  bool authorized = false;
  String cookie = "";
  // bb_ssl=1; bb_session=0-47422465-bBHZpgxhZFC9lILrKbm3; // <--- нужны куки такого вида
  final String _host = "https://rutracker-org.appspot.com";
  String _loginURL = "";
  String _searchURL = "";
  String _threadURL = "";
  http.Response? response;
  PageProvider() {
    _loginURL = "$_host/forum/login.php";
    _searchURL = "$_host/forum/tracker.php";
    _threadURL = "$_host/forum/viewtopic.php";
  }

  Future<bool> login(String username, String password) async {
    response = await http
        .post(Uri.parse(_loginURL),
            body: {
              "login_username": username,
              "login_password": password,
              "login": "Вход"
            },
            encoding: utf8)
        .then((response) {
      if (response.statusCode == 302) {
        cookie = response.headers.toString().substring(
            response.headers.toString().indexOf("bb_session"),
            response.headers.toString().lastIndexOf("expires"));
        authorized = true;
        constants.saveCookies(cookie);
      } else {
        throw Exception("Ошибка авторизации = ${response.statusCode}");
      }
    });
    return true;
  }

//  '1036,1279,1350,2127,2137,2152,2165,2324,2325,2326,2327,2328,2342,2348,2387,2388,2389,399,400,401,402,403,467,490,499,530,574,661,695,716'
  search(String query, String categories) async {
    if (!authorized) {
      throw Exception("Ошибка авторизации");
    } else {
      var url = Uri.parse(_searchURL);
      var response = await http.post(url, body: {
        "nm": query,
        "o": "10",
        'f': categories,
      }, headers: {
        "Cookie": cookie
      });
      return response;
    }
  }

  page(String link) async {
    if (!authorized) {
      throw Exception("Ошибка авторизации");
    } else {
      var url = Uri.parse(_threadURL + "?t=$link");
      var response = await http.get(url, headers: {"Cookie": cookie});
      return response;
    }
  }

  restoreCookies(String cookies) async {
    try {
      var response =
          await http.get(Uri.parse(_searchURL), headers: {"Cookie": cookies});
      if (!response.headers.toString().contains("redirect")) {
        log("Cookies restored. Current cookies: $cookies");
        cookie = cookies;
        authorized = true;
        return true;
      } else {
        log("Cookies not restored. Current cookies: $cookies");
        return false;
      }
    } on SocketException {
      log("No internet connection");
      return true;
    }
  }
}
