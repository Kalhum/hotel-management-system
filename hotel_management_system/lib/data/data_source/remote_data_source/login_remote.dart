import 'package:dio/dio.dart';

abstract class LoginRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio dio;

  static const String _endpoint = "auth/login";

  LoginRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        _endpoint,
        data: {
          "email": email,
          "password": password,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Login Failed",
      );
    }
  }
}