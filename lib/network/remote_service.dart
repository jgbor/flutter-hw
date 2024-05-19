import 'package:dio/dio.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:get_it/get_it.dart';

class RemoteService {
  Future<List<UserItem>> getUsers() async {
    final response = await GetIt.I<Dio>().get("/users");
    return [
      for (final item in response.data) UserItem(item["name"], item["avatarUrl"])
    ];
  }

  Future<String> login(String email, String password) async {
    final response = await GetIt.I<Dio>().post("/login", data: {"email": email, "password": password});
    return  response.data["token"];
  }

  void setToken(String token) {
    GetIt.I<Dio>().options.headers["Authorization"] = "Bearer $token";
  }
}