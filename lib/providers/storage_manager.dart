// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:rutracker_app/rutracker/models/proxy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static bool similarBooks = false;

  static void saveData(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, jsonEncode(value));
    } else if (value is bool) {
      prefs.setBool(key, value);
    }
  }

  static void saveProxy(Proxy proxy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('proxy', jsonEncode(proxy.toJson()));
  }

  static Future<Proxy?> readProxy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final object = prefs.getString("proxy");
    if (object != null) {
      return Proxy.fromJson(jsonDecode(object));
    } else {
      return null;
    }
  }

  static Future<dynamic> readData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic object = prefs.get(key);
    return object;
  }

}
