// ignore_for_file: camel_case_types

import 'package:rutracker_app/rutracker/models/list_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static bool similarBooks = false;

  static void saveData(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    }
  }

  static Future<dynamic> readData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic object = prefs.get(key);
    return object;
  }

  static bool listContains(List<ListObject> list, int id) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].idBook == id) return true;
    }
    return false;
  }
}
