// ignore_for_file: prefer_final_fields, unused_import, must_be_immutable, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/main.dart';
import 'package:rutracker_app/pages/search.dart';
import 'package:rutracker_app/providers/storageManager.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc()..add(ApplicationStarted()),
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is AuthenticationSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BottomNavBar(
                    authenticationBloc: context.read<AuthenticationBloc>(),
                  );
                },
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthenticationInitial) {
            return AuthenticationPageContent();
          } else if (state is AuthenticationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return AuthenticationPageContent();
        },
      ),
    );
  }
}

class AuthenticationPageContent extends StatefulWidget {
  const AuthenticationPageContent({Key? key}) : super(key: key);

  @override
  State<AuthenticationPageContent> createState() =>
      _AuthenticationPageContentState();
}

class _AuthenticationPageContentState extends State<AuthenticationPageContent> {
  TextEditingController titleController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Авторизация',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return BottomNavBar(
                      authenticationBloc: AuthenticationBloc(),
                    );
                  },
                ),
              );
            },
            child: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _authorizationPageBody(context),
          ),
        ),
      ),
    );
  }

  Widget _image(double height) {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(maxHeight: height * 0.35),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Image.asset('assets/login.png'),
    );
  }

  Widget _authorizationPageBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _image(MediaQuery.of(context).size.height),
            const SizedBox(height: 20),
            Text("Логин", style: TextStyle(fontSize: 17)),
            const SizedBox(height: 10),
            _textInput(false, titleController),
            const SizedBox(height: 15),
            Text("Пароль", style: TextStyle(fontSize: 17)),
            const SizedBox(height: 10),
            _textInput(true, passwordController),
            const SizedBox(height: 30),
            _authorizationButton(context)
          ],
        ),
      ),
    );
  }

  Widget _textInput(bool obscureText, TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      obscureText: obscureText,
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

  Widget _authorizationButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        fixedSize: Size(MediaQuery.of(context).size.width * 0.95, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      onPressed: () {
        final bloc = context.read<AuthenticationBloc>();
        bloc.add(
          Authentication(
            username: titleController.text,
            password: passwordController.text,
          ),
        );
      },
      child: Text(
        'Войти',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
