// ignore_for_file: prefer_final_fields, unused_import, must_be_immutable, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rutracker_app/main.dart';
import 'package:rutracker_app/pages/search.dart';
import 'package:rutracker_app/providers/constants.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

class Authorization extends StatefulWidget {
  RutrackerApi api;

  Authorization(this.api, {Key? key}) : super(key: key);

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  List<TextEditingController> _controller =
      List.generate(2, (i) => TextEditingController());
  late double width;
  late double heigth;

  void pushToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => bottomNavigationBar(widget.api),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    heigth = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: appBar(),
        body: Center(
          child: SingleChildScrollView(
            child: body(context),
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0.0,
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text("Авторизация", style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget image() {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(maxHeight: heigth * 0.35),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Image.asset('assets/login.png'),
    );
  }

  void _login(String username, String password) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      if (await widget.api.login(username, password)) {
        pushToMain();
        return null;
      }
    }
    FunkyNotification(
      notificationText: "Ошибка авторизации",
    ).showNotification(context);
  }

  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            image(),
            const SizedBox(height: 20),
            Text("Логин", style: TextStyle(fontSize: 17)),
            const SizedBox(height: 10),
            textInput(false, _controller[0]),
            const SizedBox(height: 15),
            Text("Пароль", style: TextStyle(fontSize: 17)),
            const SizedBox(height: 10),
            textInput(true, _controller[1]),
            const SizedBox(height: 30),
            elevatedButton(context)
          ],
        ),
      ),
    );
  }

  Widget textInput(bool obsecureText, TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      obscureText: obsecureText,
      decoration: const InputDecoration(
        filled: false,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget elevatedButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        fixedSize: Size(MediaQuery.of(context).size.width * 0.95, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      onPressed: () => _login(_controller[0].text, _controller[1].text),
      child: Text('Войти', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
