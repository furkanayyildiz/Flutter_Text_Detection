part of 'user_bloc.dart';

class UserState extends Equatable {
  final bool isLogin;
  const UserState({
    this.isLogin = false,
  });

  @override
  List<Object> get props => [isLogin];

  @override
  String toString() => "UserState{ isLogin: $isLogin}";

  UserState copyWith({
    bool? isLogin,
  }) {
    return UserState(
      isLogin: isLogin ?? this.isLogin,
    );
  }
}
