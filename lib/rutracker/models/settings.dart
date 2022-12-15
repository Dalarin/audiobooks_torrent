import 'dart:ui';

import 'package:rutracker_app/rutracker/models/proxy.dart';

class Settings {
  Proxy proxy;
  late Color color;
  late Brightness brightness;


  Settings(this.proxy, bool isDarkTheme, String colorValue) {
    brightness = isDarkTheme ? Brightness.dark : Brightness.light;
    color = Color(int.parse(colorValue));
  }
}