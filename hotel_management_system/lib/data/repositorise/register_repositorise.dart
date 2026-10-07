import 'dart:io';

import 'package:hotel_management_system/data/data_source/remote_data_source/register_remote.dart';
import 'package:hotel_management_system/data/model/register_model.dart';

abstract class RegisterRepositorise {
  Future<RegisterModel> register(
      {required String username,
      required String email,
      required String address,
      required String phoneNumber,
      required String password});
}

class RegisterRepositoriseImpl implements RegisterRepositorise {
  final RegisterRemoteDataSource remoteDataSource;

  RegisterRepositoriseImpl({required this.remoteDataSource});

  @override
  Future<RegisterModel> register(
      {required String username,
      required String email,
      required String address,
      required String phoneNumber,
      required String password}) {
    try {
      return remoteDataSource.register(
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          address: address,
          password: password);
    } on SocketException {
      throw Exception("ไม่มีการเขื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}
