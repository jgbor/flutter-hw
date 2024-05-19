part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {}

class LoginForm extends LoginState {
  final bool rememberMe;

  LoginForm({this.rememberMe = false});

  @override
  List<Object?> get props => [rememberMe];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);

  @override
  List<Object?> get props => [message];
}
