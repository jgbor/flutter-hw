import 'package:dio/dio.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:get_it/get_it.dart';

class RemoteService {
  final _dio = GetIt.I<Dio>();

  Future<List<UserItem>> getUsers() async {
    return [];
  }

  Future<String> login(String email, String password) async {
    final response = await _dio.post("/login", data: {"email": email, "password": password});
    if (response.data.containsKey("token")) {
      return response.data["token"];
    }
    throw Exception(response.data["message"]);
  }
}

final remoteService = RemoteService();
