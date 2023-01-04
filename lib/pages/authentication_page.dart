import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/main.dart';
import 'package:rutracker_app/providers/settings_manager.dart';

class AuthenticationPage extends StatelessWidget {
  final SettingsNotifier notifier;

  const AuthenticationPage({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  void _navBarPush(BuildContext context, AuthenticationBloc bloc) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BottomNavBar(
            authenticationBloc: bloc,
            notifier: notifier,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(notifier)..add(ApplicationStarted()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<AuthenticationBloc>();
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: const Text('Авторизация'),
              actions: [
                IconButton(
                  tooltip: 'Кнопка перехода в приложение без авторизации. '
                           'Рекомендуется нажимать после появления формы ввода',
                  onPressed: () => _navBarPush(context, bloc),
                  icon: const Icon(Icons.exit_to_app),
                ),
              ],
            ),
            body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is AuthenticationSuccess) {
                  _navBarPush(context, bloc);
                }
              },
              builder: (context, state) {
                if (state is AuthenticationInitial) {
                  return const AuthenticationPageContent();
                } else if (state is AuthenticationLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const AuthenticationPageContent();
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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

  Widget _authorizationPageBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text("Логин", style: TextStyle(fontSize: 17)),
            const SizedBox(height: 10),
            _textInput(false, titleController),
            const SizedBox(height: 15),
            const Text("Пароль", style: TextStyle(fontSize: 17)),
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
      child: const Text('Войти'),
    );
  }
}
