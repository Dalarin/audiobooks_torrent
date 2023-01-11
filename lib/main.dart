import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/generated/l10n.dart';
import 'package:rutracker_app/pages/authentication_page.dart';
import 'package:rutracker_app/pages/favorite_page.dart';
import 'package:rutracker_app/pages/home_page.dart';
import 'package:rutracker_app/pages/search_page.dart';
import 'package:rutracker_app/pages/settings_page.dart';
import 'package:rutracker_app/providers/settings_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rutracker_app/providers/storage_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  JustAudioBackground.init(
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  final settings = await StorageManager.readSettings();
  return runApp(
    ChangeNotifierProvider<SettingsNotifier>(
      create: (_) => SettingsNotifier(settings),
      child: const Application(),
    ),
  );
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, settings, _) {
        return MaterialApp(
          theme: settings.theme,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          title: 'Аудиокниги - Торрент',
          home: AuthenticationPage(notifier: settings),
        );
      },
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final SettingsNotifier notifier;
  final AuthenticationBloc authenticationBloc;

  const BottomNavBar({
    Key? key,
    required this.authenticationBloc,
    required this.notifier,
  }) : super(key: key);

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
      SettingsPage(authenticationBloc: widget.authenticationBloc, notifier: widget.notifier),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: onTap,
        selectedIndex: _currentIndex,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: S.of(context).home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search),
            label: S.of(context).search,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite),
            label: S.of(context).favorite,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: S.of(context).settings,
          ),
        ],
      ),
    );
  }

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
