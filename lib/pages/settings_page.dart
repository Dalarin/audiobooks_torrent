// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/providers/theme_manager.dart';

class SettingsPage extends StatelessWidget {
  final AuthenticationBloc authenticationBloc;

  const SettingsPage({Key? key, required this.authenticationBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, theme, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Настройки'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Column(
                    children: [
                      _themeSettingsRow(context, theme),
                      _colorSettings(context, theme),
                      _proxySettings(context, theme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _gridColorElement(BuildContext context, Color color, SettingsNotifier notifier) {
    return InkWell(
      onTap: () {
        notifier.color = color;
      },
      child: CircleAvatar(
        backgroundColor: color,
        child: notifier.color == color ? const Icon(Icons.check) : null,
      ),
    );
  }

  void _selectColorDialog(BuildContext context, SettingsNotifier notifier) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Выбор основного цвета'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _gridColorElement(context, Colors.red, notifier),
                _gridColorElement(context, Colors.pink, notifier),
                _gridColorElement(context, Colors.purple, notifier),
                _gridColorElement(context, Colors.blue, notifier),
                _gridColorElement(context, Colors.lightBlueAccent, notifier),
                _gridColorElement(context, Colors.green, notifier),
                _gridColorElement(context, Colors.yellow, notifier),
                _gridColorElement(context, Colors.orange, notifier),
                _gridColorElement(context, Colors.teal, notifier),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _colorSettings(BuildContext context, SettingsNotifier settingsNotifier) {
    return ListTile(
      onTap: () => _selectColorDialog(context, settingsNotifier),
      title: Text(
        'Настройка основного цвета',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _proxySettings(BuildContext context, SettingsNotifier settingsNotifier) {
    return ListTile(
      onTap: () {},
      title: Text(
        'Настройка прокси',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _themeSettingsRow(BuildContext context, SettingsNotifier settingsNotifier) {
    return ListTile(
      title: Text(
        'Темная тема',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Switch(
        value: settingsNotifier.brightness == Brightness.dark,
        onChanged: (bool value) {
          if (value == true) {
            settingsNotifier.brightness = Brightness.dark;
          } else {
            settingsNotifier.brightness = Brightness.light;
          }
        },
      ),
    );
  }
}
