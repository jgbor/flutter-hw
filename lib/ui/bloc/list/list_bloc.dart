import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:meta/meta.dart';

import '../../../network/remote_service.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<ListLoadEvent>(
        (event, emit) async {
          if (state is ListLoading) return;
          emit(ListLoading());
          try {
            var users = await remoteService.getUsers();
            emit(ListLoaded(users));
          } on DioException catch (e) {
            emit(ListError(e.response?.data["message"] ?? 'Unknown error'));;
          }
        }
    );
  }
}
