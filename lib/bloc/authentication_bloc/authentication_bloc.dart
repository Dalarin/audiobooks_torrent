import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutracker_api/rutracker_api.dart';
import 'package:rutracker_app/providers/settings_manager.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  late final RutrackerApi rutrackerApi;
  final SettingsNotifier notifier;

  AuthenticationBloc(this.notifier) : super(AuthenticationInitial()) {
    on<ApplicationStarted>((event, emit) => _applicationStarted(event, emit));
    on<Authentication>((event, emit) => _authentication(event, emit));
  }

  void _applicationStarted(
    ApplicationStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationLoading());
      _initDirectory("torrents");
      _initDirectory("books");
      Directory appDocDir = await getApplicationDocumentsDirectory();
      appDocDir = Directory('${appDocDir.path}/.cookies/');
      List<Object> objects = await RutrackerApi().create(
        proxyUrl: notifier.proxy.url,
        cookieDirectory: appDocDir.path,
      );
      rutrackerApi = objects[0] as RutrackerApi;
      print(objects[1]);
      if (objects[1] as bool) {
        emit(AuthenticationSuccess());
      } else {
        emit(AuthenticationInitial());
      }
    } on AuthenticationError {
      emit(AuthenticationInitial());
    } on Exception {
      emit(const AuthenticationError(message: 'Ошибка аутенфикации'));
    }
  }

  Future<void> _initDirectory(String subPath) async {
    Directory path = await getApplicationDocumentsDirectory();
    final Directory directory = Directory('${path.path}/$subPath/');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  _authentication(
    Authentication event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationLoading());
      if (event.password.isEmpty || event.username.isEmpty) {
        emit(const AuthenticationError(message: 'Заполните все поля и попробуйте снова'));
      } else {
        if (await rutrackerApi.authentication(login: event.username, password: event.password)) {
          emit(AuthenticationSuccess());
        } else {
          emit(const AuthenticationError(message: 'Неверный логин и/или пароль'));
        }
      }
    } on Exception catch (exception) {
      emit(AuthenticationError(message: exception.message));
    } on AuthenticationError {
      emit(const AuthenticationError(message: 'Неверный логин и/или пароль'));
    }
  }
}

extension ExceptionMessage on Exception {
  String get message {
    if (toString().contains("Exception:")) {
      return toString().substring(10);
    }
    return toString();
  }
}
