class AuthenticationError implements Exception {
  String message;

  AuthenticationError(this.message);

  @override
  String toString() {
    return message;
  }
}
