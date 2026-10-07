
import 'dart:io';

import 'package:hotel_management_system/data/data_source/remote_data_source/check_in_remote.dart';
import 'package:hotel_management_system/data/model/check_in_model.dart';

abstract class CheckInRepositorise {
  Future<bool> getCheckInData(CheckInModel checkInData);

  Future<bool> checkOut(String bookingId);
}

class CheckInRepositoriseImpl implements CheckInRepositorise{
  final CheckInRemoteDataSourceImpl remoteDataSource ;

  CheckInRepositoriseImpl(this.remoteDataSource);

  @override
  Future<bool>getCheckInData(CheckInModel checkInData) async {
    try{
      return await remoteDataSource.getCheckInData(checkInData) ;
    } on SocketException{
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException{
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch(e){
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }

  @override
  Future<bool> checkOut(String bookingId) async {
    try {
      return await remoteDataSource.checkOut(bookingId);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}