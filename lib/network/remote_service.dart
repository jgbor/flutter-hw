import 'package:dio/dio.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:get_it/get_it.dart';

class _RemoteService {
  final _dio = GetIt.I<Dio>();

  Future<List<UserItem>> getUsers() async {
    final response = await _dio.get("/users");
    return [
      for (final item in response.data) UserItem(item["name"], item["avatarUrl"])
    ];
  }

  Future<String> login(String email, String password) async {
    final response = await _dio.post("/login", data: {"email": email, "password": password});
    return  response.data["token"];
  }

  void setToken(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }
}

final remoteService = _RemoteService();
