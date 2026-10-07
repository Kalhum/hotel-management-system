import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/register_model.dart';

abstract class RegisterRemoteDataSource {
  Future<RegisterModel> register({
    required String username,
    required String email,
    required String phoneNumber,
    required String address,
    required String password,
  });
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final Dio dio;
  static const String _endpoint = "auth/register";
  RegisterRemoteDataSourceImpl({required this.dio});

  @override
  Future<RegisterModel> register({
    required String username,
    required String email,
    required String phoneNumber,
    required String address,
    required String password,
  }) async {
    try {
      final response = await dio.post(_endpoint, data: {
        "name": username,
        "email": email,
        "password": password,
        "phone": phoneNumber,
        "address": address
      });
      return RegisterModel.fromJson(response.data);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}
