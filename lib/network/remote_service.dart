import 'package:dio/dio.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:get_it/get_it.dart';
import 'package:username_gen/username_gen.dart';

class RemoteService {
  var dio = GetIt.I<Dio>();

  Future<List<UserItem>> getUsers() async {
    return [];
  }

  Future<Response> login(String email, String password) async {
    return dio.post("/login", data: {"email": email, "password": password});
  }
}

final remoteService = RemoteService();
