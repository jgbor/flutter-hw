import 'package:dio/dio.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:get_it/get_it.dart';

class _RemoteService {
  final _dio = GetIt.I<Dio>();

  Future<List<UserItem>> getUsers() async {
    return [];
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post("/login", data: {"email": email, "password": password});
      return response.data["token"];
    } catch (e) {
      rethrow;
    }
  }
}

final remoteService = _RemoteService();
