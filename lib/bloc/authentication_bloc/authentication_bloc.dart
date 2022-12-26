import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutracker_api/rutracker_api.dart';
import '../../models/proxy.dart';

import '../../providers/storage_manager.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  late final RutrackerApi rutrackerApi;

  AuthenticationBloc() : super(AuthenticationInitial()) {
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
      Proxy? proxy = await StorageManager.readProxy();
      proxy ??= Proxy.standartProxy;
      String proxyUrl = '${proxy.username}:${proxy.password}@${proxy.host}:${proxy.port}';
      List<Object> objects = await RutrackerApi().create(proxyUrl: proxyUrl, cookieDirectory: "${appDocDir.path}/.cookies/");
      rutrackerApi = objects[0] as RutrackerApi;
      if (objects[1] as bool) {
        emit(AuthenticationSuccess());
      } else {
        emit(AuthenticationInitial());
      }
    } on AuthenticationError {
      emit(AuthenticationInitial());
    } on Exception catch (exception) {
      emit(AuthenticationError(message: exception.message));
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
        Proxy? proxy = await StorageManager.readProxy();
        proxy ??= Proxy.standartProxy;
        bool authenticated = await rutrackerApi.authentication(
          login: event.username,
          password: event.password,
        );
        if (authenticated == true) {
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
