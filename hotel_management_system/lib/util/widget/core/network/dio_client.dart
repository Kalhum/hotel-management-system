import 'package:dio/dio.dart';

import 'auth_interceptor.dart';

class DioClient {
  DioClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:2000/api/",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  )
    ..interceptors.add(
      AuthInterceptor(),
    )
    ..interceptors.add(
      LogInterceptor(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      ),
    );
}