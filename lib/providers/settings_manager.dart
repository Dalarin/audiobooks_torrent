import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rutracker_app/models/proxy.dart';
import 'package:rutracker_app/providers/enums.dart';
import 'package:rutracker_app/providers/storage_manager.dart';

class   SettingsNotifier with ChangeNotifier {
  late Proxy _proxy;
  late Color _color;
  late Brightness _brightness;
  late Sort _sort;
  late List<Filter> _filter;

  static ColorScheme _defaultColorScheme = ColorScheme.fromSeed(seedColor: Colors.green);

  static final SettingsNotifier standart = SettingsNotifier.from(
    Proxy.standartProxy,
    '0xFF008000',
    'По умолчанию',
    false,
    Filter.values,
  );

  SettingsNotifier(Map<String, dynamic>? settings) {
    if (settings != null) {
      _proxy = Proxy.fromMap(settings['proxy']);
      _color = Color(settings['color']);
      _brightness = settings['brightness'] == 1 ? Brightness.dark : Brightness.light;
      _sort = Sort.fromValue(settings['sort']);
      _filter = List.from(jsonDecode(settings['filter'])).map((e) => Filter.fromValue(e)).toList();
    } else {
      _brightness = standart._brightness;
      _proxy = standart._proxy;
      _color = standart._color;
      _sort = standart._sort;
      _filter = standart._filter;
    }
    _loadSettings();
    notifyListeners();
  }

  SettingsNotifier.from(this._proxy, String color, String sort, bool isDarkTheme, List<Filter> filter) {
    _color = Color(int.parse(color));
    _sort = Sort.fromValue(sort);
    _brightness = isDarkTheme ? Brightness.dark : Brightness.light;
    _filter = filter;
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
    );
    notifyListeners();
  }

  ThemeData theme = ThemeData(
    fontFamily: "Product-Sans",
    useMaterial3: true,
    colorScheme: _defaultColorScheme,
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

  List<Filter> get filter => _filter;

  set filter(List<Filter> value) {
    _filter = value;
    save();
  }

  Map<String, dynamic> toMap() {
    return {
      'proxy': _proxy.toMap(),
      'color': _color.value,
      'brightness': _brightness == Brightness.dark ? 1 : 0,
      'sort': _sort.text,
      'filter': jsonEncode(_filter.map((e) => e.text).toList())
    };
  }

  factory SettingsNotifier.fromMap(Map<String, dynamic> map) {
    return SettingsNotifier.from(
      Proxy.fromMap(map['proxy']),
      map['color'],
      map['sort'],
      map['brightness'] == 1,
      jsonDecode(map['filter']),
    );
  }
}
