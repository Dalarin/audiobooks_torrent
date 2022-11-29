import 'package:rutracker_app/rutracker/rutracker.dart';

class AuthenticationRepository {
  final RutrackerApi api;


  const AuthenticationRepository({required this.api});

  Future<bool> login(String username, String password) =>
      api.login(username, password);

  Future<bool> restoreLogin(String cookies) => api.restoreCookies(cookies);
}
