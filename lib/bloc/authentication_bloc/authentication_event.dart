part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class ApplicationStarted extends AuthenticationEvent {}

class Authentication extends AuthenticationEvent {
  final String username;
  final String password;

  const Authentication({required this.username, required this.password});
}
