class AuthenticationException implements Exception {
  String message;

  AuthenticationException(this.message);

  @override
  String toString() {
    return message;
  }
}
