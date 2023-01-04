import 'package:rutracker_api/rutracker_api.dart';

class AuthenticationRepository {
  final RutrackerApi api;

  const AuthenticationRepository({required this.api});

  Future<bool> login(String username, String password) => api.authentication(login: username, password: password);
}
