import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static void saveSettings(Map<String, dynamic> map) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('settings', jsonEncode(map));
  }

  static Future<Map<String, dynamic>?> readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? settingsString = prefs.getString('settings');
    return settingsString != null ? jsonDecode(settingsString) : null;
  }
}
