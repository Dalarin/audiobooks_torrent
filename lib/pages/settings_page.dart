// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/providers/theme_manager.dart';

class SettingsPage extends StatelessWidget {
  final AuthenticationBloc authenticationBloc;
  const SettingsPage({Key? key, required this.authenticationBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
    );
  }
}
