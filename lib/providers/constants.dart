// ignore_for_file: camel_case_types

import 'package:rutracker_app/rutracker/models/list_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class constants {
  static String fontFamily = "Gotham";
  static String bookCover =
      "https://timvandevall.com/wp-content/uploads/2014/01/Book-Cover-Template.jpg";

  static Future<void> saveCookies(String cookies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("cookies", cookies);
  }

  static Future<void> saveRecentlyListened(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("recentlyListened", id);
  }

  static Future<String> getRecentlyListened() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("recentlyListened") ?? "";
  }

  static Future<void> saveSort(int sortType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("sortType", sortType);
  }

  static Future<int> getSort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("sortType") ?? 0;
  }

  static Future<void> saveTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("theme", isDark);
  }

  static Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("theme") ?? false;
  }

  static Future<String> getCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("cookies") ?? "";
  }

  static bool listContains(List<ListObject> list, int id) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].idBook == id) return true;
    }
    return false;
  }
}
