import 'package:dio/dio.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:get_it/get_it.dart';

class _RemoteService {
  final _dio = GetIt.I<Dio>();

  Future<List<UserItem>> getUsers() async {
    return [];
  }

  Future<String> login(String email, String password) async {
    final response = await _dio.post("/login", data: {"email": email, "password": password});
    final token = response.data["token"];
    _dio.options.headers["Authorization"] = "Bearer $token";
    return token;
  }
}

final remoteService = _RemoteService();
