// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:rutracker_app/providers/constants.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              child: body(),
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Темная тема',
                          style: TextStyle(
                              fontFamily: constants.fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value:
                              Theme.of(context).brightness == Brightness.dark,
                          onChanged: (value) {
                            setState(() {
                              bool isDarkTheme = Theme.of(context).brightness ==
                                  Brightness.dark;
                              constants.saveTheme(isDarkTheme);
                              EasyDynamicTheme.of(context).changeTheme();
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Показывать привязанные книги',
                              style: TextStyle(
                                  fontFamily: constants.fontFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Switch(
                              value: constants.similarBooks,
                              onChanged: (value) {
                                setState(() {
                                  constants.similarBooks =
                                      !constants.similarBooks;
                                  constants.saveSimilarBooks();
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                'Экспериментальная функция. Включать на свой страх и риск',
                                style: TextStyle(
                                    fontFamily: constants.fontFamily,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
