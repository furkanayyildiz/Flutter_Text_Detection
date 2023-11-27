import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_text_recognition/features/data/datasources/auth.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {
    on<LoginEvent>(_onLoginEvent);
    on<LogoutEvent>(_onLogoutEvent);
  }

  FutureOr<void> _onLoginEvent(
      LoginEvent event, Emitter<UserState> emit) async {
    try {
      await Auth().signInWithEmailAndPassword(event.email, event.password);

      //Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    var user = Auth().currentUser;
    if (user != null) {
      emit(state.copyWith(isLogin: true));
    } else {
      emit(state.copyWith(isLogin: false));
    }
  }

  FutureOr<void> _onLogoutEvent(
      LogoutEvent event, Emitter<UserState> emit) async {
    try {
      await Auth().signOut();
      emit(state.copyWith(isLogin: false));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}
