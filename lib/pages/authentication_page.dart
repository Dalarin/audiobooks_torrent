// ignore_for_file: prefer_final_fields, unused_import, must_be_immutable, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/main.dart';
import 'package:rutracker_app/pages/search_page.dart';
import 'package:rutracker_app/providers/theme_manager.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc()..add(ApplicationStarted()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text('Авторизация'),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return BottomNavBar(
                            authenticationBloc: context.read<AuthenticationBloc>(),
                          );
                        },
                      ),
                    );
                  },
                  child: const Icon(Icons.exit_to_app),
                )
              ],
            ),
            body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                print(state);
                if (state is AuthenticationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                } else if (state is AuthenticationSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
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
        },
      ),
    );
  }
}

class AuthenticationPageContent extends StatefulWidget {
  const AuthenticationPageContent({Key? key}) : super(key: key);

  @override
  State<AuthenticationPageContent> createState() => _AuthenticationPageContentState();
}

class _AuthenticationPageContentState extends State<AuthenticationPageContent> {
  TextEditingController titleController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: _authorizationPageBody(context),
        ),
      ),
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
      obscureText: obscureText,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _authorizationButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final bloc = context.read<AuthenticationBloc>();
        bloc.add(
          Authentication(
            username: titleController.text.trim(),
            password: passwordController.text,
          ),
        );
      },
      child: Text('Войти'),
    );
  }
}
