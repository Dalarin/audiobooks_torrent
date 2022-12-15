import 'package:flutter/material.dart';
import 'package:rutracker_app/providers/storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  static final ColorScheme defaultColorScheme = ColorScheme.fromSeed(seedColor: Colors.green);

  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.dark,
  );

  final darkTheme = ThemeData(
    fontFamily: "Product-Sans",
    useMaterial3: true,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: darkColorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: darkColorScheme.onInverseSurface),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: darkColorScheme.primary,
      inactiveTrackColor: darkColorScheme.surfaceVariant,
      thumbColor: darkColorScheme.primary,
    ),
    colorScheme: darkColorScheme,
  );

  final lightTheme = ThemeData(
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

  ThemeMode getTheme() => _themeMode;

  ThemeMode _themeMode = ThemeMode.light;

  bool _lightTheme = true;

  bool isLightTheme() => _lightTheme;

  void changeTheme() async {
    _lightTheme = !_lightTheme;
    _themeMode = _lightTheme ? ThemeMode.light : ThemeMode.dark;
    StorageManager.saveData('theme', _lightTheme);
    notifyListeners();
  }

  ThemeNotifier() {
    StorageManager.readData('theme').then((value) {
      if (value != _lightTheme) {
        changeTheme();
      }
    });
    notifyListeners();
  }
}
