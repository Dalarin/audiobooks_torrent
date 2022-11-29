// ignore_for_file: camel_case_types, void_checks, import_of_legacy_library_into_null_safe, must_be_immutable

import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:rutracker_app/pages/authentication_page.dart';
import 'package:rutracker_app/pages/favorite_page.dart';
import 'package:rutracker_app/pages/home_page.dart';
import 'package:rutracker_app/pages/search.dart';
import 'package:rutracker_app/providers/themeManager.dart';

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
          themeMode: ThemeMode.system,
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
  _BottomNavBarState createState() => _BottomNavBarState();
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
    ]);
    super.initState();
  }


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
        FloatingNavbarItem(icon: Icons.favorite),
      ],
      onTap: onTap,
    );
  }
}
