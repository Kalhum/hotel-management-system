import 'dart:io';

import 'package:hotel_management_system/data/data_source/remote_data_source/list_remote.dart';
import 'package:hotel_management_system/data/model/list_model.dart';

abstract class ListRepositorise {
  Future<List<ListModel>> getListData();
  Future<bool> cancelBooking(String bookingId, String reason);
  Future<bool> setDoNotDisturb(String bookingId, bool enabled);
}

class ListRepositoriseImpl implements ListRepositorise {
  final ListRemoteDatasourceImpl remoteDataSource;
  ListRepositoriseImpl(this.remoteDataSource);
  @override
  Future<List<ListModel>> getListData() async {
    try {
      final listData = await remoteDataSource.getListData();
      return listData.map((item) => ListModel.fromJson(item)).toList();
    } on SocketException {
      throw Exception("ไม่มีการเขื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }

  @override
  Future<bool> cancelBooking(String bookingId, String reason) {
    return remoteDataSource.cancelBooking(bookingId, reason);
  }

  @override
  Future<bool> setDoNotDisturb(String bookingId, bool enabled) {
    return remoteDataSource.setDoNotDisturb(bookingId, enabled);
  }
}
