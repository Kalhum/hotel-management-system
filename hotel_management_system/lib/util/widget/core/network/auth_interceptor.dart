import 'package:dio/dio.dart';

import '../../../../main.dart';
import '../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ไม่ส่ง token ตอน login
    if (options.path.contains('/auth/login')) {
      return handler.next(options);
    }

    final token = await SecureStorageService.instance.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    print("STATUS : ${err.response?.statusCode}");
    print("ERROR : ${err.response?.data}");

    if (err.response?.statusCode == 401) {
      print("TOKEN EXPIRED");

      await SecureStorageService.instance.clear();

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        "/login",
        (route) => false,
      );
    }

    handler.next(err);
  }
}