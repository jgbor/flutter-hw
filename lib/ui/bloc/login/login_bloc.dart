import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>(
          (event, emit) async {
        if (state is LoginLoading) return;
        emit(LoginLoading());
        try {
          emit(LoginSuccess());
        } catch (e) {
          emit(LoginError(e.toString()));
          emit(LoginForm());
        }
      },
    );

    on<LoginAutoLoginEvent>(
      (event, emit) async {
        if (state is LoginLoading) return;
        emit(LoginLoading());
        try {
          emit(LoginSuccess());
        } catch (e) {
          emit(LoginError(e.toString()));
          emit(LoginForm());
        }
      }
    );

    on<ChangeRememberMeEvent>(
      (event, emit) async {
        if (state is! LoginForm) return;
        emit(LoginForm(rememberMe: event.rememberMe));
      }
    );
  }
}
