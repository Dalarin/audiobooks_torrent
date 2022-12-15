// ignore_for_file: camel_case_types, void_checks, import_of_legacy_library_into_null_safe, must_be_immutable

import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:rutracker_app/pages/authentication_page.dart';
import 'package:rutracker_app/pages/favorite_page.dart';
import 'package:rutracker_app/pages/home_page.dart';
import 'package:rutracker_app/pages/search_page.dart';
import 'package:rutracker_app/pages/settings_page.dart';
import 'package:rutracker_app/providers/theme_manager.dart';

import 'bloc/authentication_bloc/authentication_bloc.dart';

void main() async {
  JustAudioBackground.init(
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: const Home(),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) {
        return MaterialApp(
          themeMode: ThemeMode.light,
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          title: 'Аудиокниги - Торрент',
          home: const AuthenticationPage(),
        );
      },
    );
  }
}

class BottomNavBar extends StatefulWidget {
  AuthenticationBloc authenticationBloc;

  BottomNavBar({Key? key, required this.authenticationBloc}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [];

  @override
  void initState() {
    _children.addAll([
      HomePage(authenticationBloc: widget.authenticationBloc),
      SearchPage(authenticationBloc: widget.authenticationBloc),
      FavoritePage(authenticationBloc: widget.authenticationBloc),
      SettingsPage(authenticationBloc: widget.authenticationBloc),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _children[_currentIndex],
      bottomNavigationBar: _navigationBar(),
    );
  }

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _navigationBar() {
    return NavigationBar(
      onDestinationSelected: onTap,
      selectedIndex: _currentIndex,
      animationDuration: const Duration(seconds: 2),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Дом'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Поиск'),
        NavigationDestination(icon: Icon(Icons.favorite), label: 'Избранное'),
        NavigationDestination(icon: Icon(Icons.settings), label: 'Настройки'),
      ],
    );
  }

}
