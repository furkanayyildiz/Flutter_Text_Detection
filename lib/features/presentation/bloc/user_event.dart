part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends UserEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class LogoutEvent extends UserEvent {
  const LogoutEvent();

  @override
  List<Object> get props => [];
}
