import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proxies/proxies.dart';
import 'package:rutracker_app/providers/storageManager.dart';
import 'package:rutracker_app/rutracker/models/proxy.dart' as m;
import 'package:rutracker_app/rutracker/page-provider.dart';
import 'package:rutracker_app/rutracker/rutracker.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  late final RutrackerApi? rutrackerApi;

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<ApplicationStarted>((event, emit) => _applicationStarted(event, emit));
    on<Authentication>((event, emit) => _authentication(event, emit));
  }

  void _applicationStarted(
    ApplicationStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      _initDirectory("torrents");
      _initDirectory("books");
      m.Proxy? proxy = await StorageManager.readProxy();
      if (proxy != null) {
        String? cookies = await StorageManager.readData("cookies");
        SimpleProxyProvider proxyProvider = SimpleProxyProvider(
          proxy.host,
          proxy.port,
          proxy.username,
          proxy.password,
        );
        PageProvider pageProvider = PageProvider(proxyProvider: proxyProvider);
        RutrackerApi api = RutrackerApi(pageProvider: pageProvider);
        rutrackerApi = api;
        if (cookies != null) {
          bool loggedIn = await api.restoreCookies(cookies);
          if (loggedIn) {
            emit(AuthenticationSuccess());
          } else {
            emit(AuthenticationInitial());
          }
        } else {
          emit(AuthenticationInitial());
        }
      } else {
        emit(
          const AuthenticationError(
            message: 'Отсутствует заданный прокси-сервер. '
                'Перейдите на страницу настройки',
          ),
        );
      }
    } on Exception catch (exception) {
      emit(AuthenticationError(message: exception.toString()));
    }
  }

  Future<void> _initDirectory(String subPath) async {
    Directory path = await getApplicationDocumentsDirectory();
    final Directory directory = Directory('${path.path}}/$subPath/');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  _authentication(
    Authentication event,
    Emitter<AuthenticationState> emit,
  ) {}
}
