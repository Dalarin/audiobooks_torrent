// ignore_for_file: camel_case_types, void_checks, import_of_legacy_library_into_null_safe, must_be_immutable

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import 'package:rutracker_app/pages/authorization.dart';
import 'package:rutracker_app/pages/favorited.dart';
import 'package:rutracker_app/pages/profile.dart';
import 'package:rutracker_app/pages/search.dart';
import 'package:rutracker_app/pages/subHome.dart';
import 'package:rutracker_app/providers/storageManager.dart';
import 'package:rutracker_app/providers/themeManager.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';
import 'package:provider/provider.dart';

import 'providers/database.dart';

void main() async {
  JustAudioBackground.init(
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  RutrackerApi api = RutrackerApi();
  String cookies = await StorageManager.readData('cookies');
  bool isRestored = await api.restoreCookies(cookies);
  var homePage = isRestored ? HomePage(api) : Authorization(api);
  return runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Home(homePage: homePage),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({Key? key, required this.homePage}) : super(key: key);
  final StatefulWidget homePage;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) {
        return MaterialApp(
          themeMode: theme.getTheme(),
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          title: 'Аудиокниги - Торрент',
          home: homePage,
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  RutrackerApi api;

  HomePage(this.api, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    _initDirectory("torrents");
    _initDirectory("books");
    _children = [
      subHome(widget.api),
      Search(widget.api),
      Favorited(widget.api),
      Profile(),
    ];
    IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    super.initState();
  }

  @override
  void dispose() {
    DBHelper.instance.close();
    super.dispose();
  }

  Future<void> _initDirectory(String subPath) async {
    Directory path = await getApplicationDocumentsDirectory();
    final Directory directory = Directory('${path.path}}/$subPath/');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  int _currentIndex = 0;
  List<Widget> _children = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: _children[_currentIndex],
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget bottomNavigationBar() {
    return FloatingNavbar(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
      borderRadius: 15.0,
      currentIndex: _currentIndex,
      backgroundColor: Theme.of(context).bottomAppBarColor,
      elevation: 75.0,
      selectedItemColor: Theme.of(context).toggleableActiveColor,
      unselectedItemColor: Colors.grey[500],
      selectedBackgroundColor: Colors.transparent,
      items: [
        FloatingNavbarItem(icon: Icons.collections_bookmark),
        FloatingNavbarItem(icon: Icons.search),
        FloatingNavbarItem(icon: Icons.bookmark_border),
        FloatingNavbarItem(icon: Icons.person_outline),
      ],
      onTap: (int val) => onTap(val),
    );
  }
}
