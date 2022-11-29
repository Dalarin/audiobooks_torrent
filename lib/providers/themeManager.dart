import 'package:flutter/material.dart';
import 'package:rutracker_app/providers/storageManager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    fontFamily: "Gotham",
    toggleableActiveColor: Colors.red.withOpacity(0.5),
    hintColor: Colors.black,
    primaryColor: Colors.white,
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.red.withOpacity(0.2),
      brightness: Brightness.dark,
    ),
  );

  final lightTheme = ThemeData(
    fontFamily: "Gotham",
    disabledColor: Colors.grey,
    toggleableActiveColor: const Color(0xFF4A73E7),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),

    scaffoldBackgroundColor: const Color(0xFFFDFDFD),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.light,
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
