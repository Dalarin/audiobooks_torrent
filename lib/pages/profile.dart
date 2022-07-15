// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutracker_app/providers/storageManager.dart';
import 'package:rutracker_app/providers/themeManager.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool similarBooks = false;

  void _loadAsyncInfo() async {
    similarBooks = await StorageManager.readData('similarBooks');
    setState(() {});
  }

  @override
  void initState() {
    _loadAsyncInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) {
        return Scaffold(
          extendBody: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: body(theme),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget showLinkedBooksWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Показывать привязанные книги',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: similarBooks,
          onChanged: (value) {
            setState(() {
              similarBooks = !similarBooks;
              StorageManager.saveData('similarBooks', similarBooks);
            });
          },
        ),
      ],
    );
  }

  Widget changeThemeWidget(ThemeNotifier themeNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Темная тема',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: !themeNotifier.isLightTheme(),
          onChanged: (bool? value) {
            themeNotifier.changeTheme();
          },
        ),
      ],
    );
  }

  Widget warningNotificationWidget() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: const Text(
            'Экспериментальная функция. Включать на свой страх и риск',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget body(ThemeNotifier themeNotifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Профиль', style: Theme.of(context).textTheme.headline1),
            const SizedBox(height: 25),
            Material(
              elevation: 5.0,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        changeThemeWidget(themeNotifier),
                        showLinkedBooksWidget(),
                        warningNotificationWidget()
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('v.0.3.5'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
