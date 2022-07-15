
import 'package:flutter/material.dart';
import 'package:rutracker_app/providers/storageManager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    fontFamily: "Gotham",
    accentColor: Colors.red.withOpacity(0.2),
    toggleableActiveColor: Colors.red.withOpacity(0.5),
    hintColor: Colors.black,
    primaryColor: Colors.white,
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  final lightTheme = ThemeData(
    fontFamily: "Gotham",
    disabledColor: Colors.grey,
    accentColor: const Color(0xFF4A73E7),
    toggleableActiveColor: const Color(0xFF4A73E7),
    primaryColor: Colors.black,
    scaffoldBackgroundColor: const Color(0xFFFDFDFD),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
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
