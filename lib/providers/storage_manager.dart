import 'dart:convert';

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

  static void saveSettings(Map<String, dynamic> map) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('settings', jsonEncode(map));
  }

  static Future<Map<String, dynamic>?> readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? settingsString = prefs.getString('settings');
    return settingsString != null ? jsonDecode(settingsString) : null;
  }

  static Future<dynamic> readData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic object = prefs.get(key);
    return object;
  }
}
