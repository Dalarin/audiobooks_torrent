import 'package:flutter/material.dart';
import 'package:rutracker_app/providers/storage_manager.dart';

import '../models/proxy.dart';
import 'enums.dart';

class SettingsNotifier with ChangeNotifier {
  late Proxy _proxy;
  late Color _color;
  late Brightness _brightness;
  late Sort _sort;
  static ColorScheme _defaultColorScheme = ColorScheme.fromSeed(seedColor: Colors.green);

  static final SettingsNotifier standart = SettingsNotifier.from(
    Proxy.standartProxy,
    '0xFF008000',
    'По умолчанию',
    false,
  );

  SettingsNotifier() {
    StorageManager.readSettings().then((settings) {
      if (settings != null) {
        _proxy = Proxy.fromJson(settings['proxy']);
        _color = Color(settings['color']);
        _brightness = settings['brightness'] == 1 ? Brightness.dark : Brightness.light;
        _sort = Sort.fromValue(settings['sort']);
      } else {
        _brightness = standart._brightness;
        _proxy = standart._proxy;
        _color = standart._color;
        _sort = standart._sort;
      }
      _loadSettings();
      notifyListeners();
    });
  }

  SettingsNotifier.from(this._proxy, String color, String sort, bool isDarkTheme) {
    _color = Color(int.parse(color));
    _sort = Sort.fromValue(sort);
    _brightness = isDarkTheme ? Brightness.dark : Brightness.light;
    notifyListeners();
  }

  void save() async {
    StorageManager.saveSettings(toMap());
    _loadSettings();
    notifyListeners();
  }

  void _loadSettings() async {
    _defaultColorScheme = ColorScheme.fromSeed(
      seedColor: _color,
      brightness: _brightness,
    );
    theme = ThemeData(
      fontFamily: "Product-Sans",
      useMaterial3: true,
      colorScheme: _defaultColorScheme,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _defaultColorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: _defaultColorScheme.onInverseSurface),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: _defaultColorScheme.primary,
        inactiveTrackColor: _defaultColorScheme.surfaceVariant,
        thumbColor: _defaultColorScheme.primary,
      ),
    );
    notifyListeners();
  }

  ThemeData theme = ThemeData(
    fontFamily: "Product-Sans",
    useMaterial3: true,
    colorScheme: _defaultColorScheme,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: _defaultColorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: _defaultColorScheme.onInverseSurface),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: _defaultColorScheme.primary,
      inactiveTrackColor: _defaultColorScheme.surfaceVariant,
      thumbColor: _defaultColorScheme.primary,
    ),
  );

  Proxy get proxy => _proxy;

  set proxy(Proxy value) {
    _proxy = value;
    save();
  }

  Color get color => _color;

  set color(Color value) {
    _color = value;
    save();
  }

  Brightness get brightness => _brightness;

  set brightness(Brightness value) {
    _brightness = value;
    save();
  }

  Sort get sort => _sort;

  set sort(Sort value) {
    _sort = value;
    save();
  }

  Map<String, dynamic> toMap() {
    return {
      'proxy': _proxy.toJson(),
      'color': _color.value,
      'brightness': _brightness == Brightness.dark ? 1 : 0,
      'sort': _sort.text,
    };
  }

  factory SettingsNotifier.fromMap(Map<String, dynamic> map) {
    return SettingsNotifier.from(
      Proxy.fromJson(map['proxy']),
      map['color'],
      map['sort'],
      map['brightness'] == 1,
    );
  }
}
