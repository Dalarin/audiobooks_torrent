import 'package:flutter/material.dart';

import '../models/settings.dart';


class SettingsNotifier with ChangeNotifier {
  late Settings _settings;

  static ColorScheme defaultColorScheme = ColorScheme.fromSeed(seedColor: Colors.green);

  SettingsNotifier() {
    _loadSettings();
  }


  Settings get settings => _settings;

  set settings(Settings value) {
    _settings = value;
    notifyListeners();
  }

  void _loadSettings() async {
    _settings = await Settings.load();
    defaultColorScheme = ColorScheme.fromSeed(seedColor: settings.color, brightness: settings.brightness);
    theme = ThemeData(
      fontFamily: "Product-Sans",
      useMaterial3: true,
      colorScheme: defaultColorScheme,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: defaultColorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: defaultColorScheme.onInverseSurface),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: defaultColorScheme.primary,
        inactiveTrackColor: defaultColorScheme.surfaceVariant,
        thumbColor: defaultColorScheme.primary,
      ),
    );
    notifyListeners();
  }


  ThemeData theme = ThemeData(
    fontFamily: "Product-Sans",
    useMaterial3: true,
    colorScheme: defaultColorScheme,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: defaultColorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: defaultColorScheme.onInverseSurface),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: defaultColorScheme.primary,
      inactiveTrackColor: defaultColorScheme.surfaceVariant,
      thumbColor: defaultColorScheme.primary,
    ),
  );


}
