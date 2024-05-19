import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_homework/network/remote_service.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final remoteService = GetIt.I<RemoteService>();

  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>(_onLoginSubmit);
    on<LoginAutoLoginEvent>(_onAutoLogin);
  }

  void _onLoginSubmit(LoginSubmitEvent event, Emitter<LoginState> emit) async {
    if (state is LoginLoading) return;
    try {
      emit(LoginLoading());
      final token = await remoteService.login(event.email, event.password);
      if (event.rememberMe) {
        GetIt.I<SharedPreferences>().setString("token", token);
      }
      remoteService.setToken(token);
      emit(LoginSuccess());
    } on DioException catch (e) {
      emit(LoginError(e.response?.data["message"] ?? 'Unknown error'));
    } finally {
      emit(LoginForm());
    }
  }

  void _onAutoLogin(LoginAutoLoginEvent event, Emitter<LoginState> emit) async {
    if (state is LoginLoading) return;
    try {
      if (GetIt.I<SharedPreferences>().containsKey("token")) {
        final token = GetIt.I<SharedPreferences>().getString("token")!;
        if (token.isNotEmpty) {
          remoteService.setToken(token);
          emit(LoginSuccess());
        }
      }
    } catch (e) {
      emit(LoginError(e.toString()));
      emit(LoginForm());
    }
  }
}
