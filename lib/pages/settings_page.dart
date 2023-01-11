import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rutracker_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:rutracker_app/generated/l10n.dart';
import 'package:rutracker_app/models/proxy.dart';
import 'package:rutracker_app/providers/settings_manager.dart';

class SettingsPage extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final SettingsNotifier notifier;

  const SettingsPage({
    Key? key,
    required this.authenticationBloc,
    required this.notifier,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController hostController;
  late final TextEditingController portController;
  late final TextEditingController userController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    Proxy proxy = widget.notifier.proxy;
    hostController = TextEditingController();
    hostController.text = widget.notifier.proxy.host;
    portController = TextEditingController();
    portController.text = widget.notifier.proxy.port;
    userController = TextEditingController();
    passwordController = TextEditingController();
    if (proxy.username != null && proxy.password != null) {
      userController.text = proxy.username!;
      passwordController.text = proxy.password!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, theme, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).settings),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _themeSettingsRow(context, theme),
                    _proxySettings(context, theme),
                    _colorSettings(context, theme),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _gridColorElement(
    BuildContext context,
    Color color,
    SettingsNotifier notifier,
  ) {
    return InkWell(
      onTap: () => notifier.color = color,
      borderRadius: BorderRadius.circular(40),
      child: CircleAvatar(
        backgroundColor: color,
        child: notifier.color.value == color.value ? const Icon(Icons.check) : null,
      ),
    );
  }

  void _showSelectColorDialog(BuildContext context, SettingsNotifier notifier) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).colorSelecting),
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

  void _showProxySettingsDialog(BuildContext context, SettingsNotifier notifier) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).proxySettings),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).proxySettingsTooltip,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.justify,
              ),
              _textField(
                context: context,
                controller: hostController,
                hint: S.of(context).ip,
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'\d*\.?\d*')),
                ],
              ),
              _textField(
                context: context,
                controller: portController,
                hint: S.of(context).port,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
              ),
              _textField(
                context: context,
                controller: userController,
                hint: S.of(context).username,
              ),
              _textField(
                context: context,
                controller: passwordController,
                hint: S.of(context).password,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).save),
              onPressed: () {
                notifier.proxy = Proxy(
                  host: hostController.text,
                  port: portController.text,
                  username: userController.text,
                  password: passwordController.text,
                );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _textField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    List<TextInputFormatter> formatters = const [],
  }) {
    return TextField(
      controller: controller,
      inputFormatters: formatters,
      decoration: InputDecoration(
        hintText: hint,
        label: Text(hint),
      ),
    );
  }

  Widget _colorSettings(
    BuildContext context,
    SettingsNotifier settingsNotifier,
  ) {
    return ListTile(
      onTap: () => _showSelectColorDialog(context, settingsNotifier),
      title: Text(
        S.of(context).colorSettings,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _proxySettings(BuildContext context, SettingsNotifier settingsNotifier) {
    return ListTile(
      onTap: () => _showProxySettingsDialog(context, settingsNotifier),
      title: Text(
        S.of(context).proxySettings,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Switch(
        value: settingsNotifier.proxy.useProxy,
        onChanged: (bool value) {
          settingsNotifier.proxy = settingsNotifier.proxy.copyWith(
            useProxy: value,
          );
        },
      ),
    );
  }

  Widget _themeSettingsRow(BuildContext context, SettingsNotifier settingsNotifier) {
    return ListTile(
      title: Text(
        S.of(context).darkTheme,
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
