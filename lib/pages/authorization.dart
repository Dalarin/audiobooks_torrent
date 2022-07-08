// ignore_for_file: prefer_final_fields, unused_import, must_be_immutable, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rutracker_app/main.dart';
import 'package:rutracker_app/providers/constants.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

class Authorization extends StatefulWidget {
  RutrackerApi api;

  Authorization(this.api, {Key? key}) : super(key: key);

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  void pushToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => bottomNavigationBar(widget.api),
      ),
    );
  }

  List<TextEditingController> _controller =
      List.generate(2, (i) => TextEditingController());
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: appBar(),
        body: Center(
          child: SingleChildScrollView(child: body(context)),
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
      title: Text("Авторизация",
          style: TextStyle(
              fontFamily: constants.fontFamily, fontWeight: FontWeight.bold)),
    );
  }

  Widget image(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .35),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: Image.asset('assets/login.png'));
  }

  void login(String username, String password) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      if (await widget.api.login(username, password)) {
        pushToMain();
      } else {
        setState(() => isError = true);
      }
    } else {
      setState(() => isError = true);
    }
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
            image(context),
            const SizedBox(height: 20),
            Text(
              "Логин",
              style: TextStyle(
                fontFamily: constants.fontFamily,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10),
            textInput(false, _controller[0]),
            const SizedBox(height: 15),
            Text(
              "Пароль",
              style: TextStyle(
                fontFamily: constants.fontFamily,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10),
            textInput(true, _controller[1]),
            const SizedBox(height: 15),
            isError
                ? Text(
                    "Ошибка авторизации. Попытайтесь снова через несколько минут",
                    style: TextStyle(
                      fontFamily: constants.fontFamily,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Container(),
            const SizedBox(height: 15),
            elevatedButton(context)
          ],
        ),
      ),
    );
  }

  Widget textInput(bool obsecureText, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(fontFamily: constants.fontFamily),
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
      onPressed: () => login(_controller[0].text, _controller[1].text),
      child: Text(
        'Войти',
        style: TextStyle(
          fontFamily: constants.fontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
