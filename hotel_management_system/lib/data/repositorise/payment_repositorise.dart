import 'dart:io';

import 'package:hotel_management_system/data/data_source/remote_data_source/payment_remote.dart';
import 'package:hotel_management_system/domain/entitise/cart_item_entitise.dart';

abstract class PaymentRepositorise {
  Future<String> getBookingCartQrPayload(List<CartItemEntitise> items);
  Future<String> getCheckinQrPayload(String bookingId, {int? userPromotionId});
}

class PaymentRepositoriseImpl implements PaymentRepositorise {
  final PaymentRemoteDataSourceImpl remoteDataSource;
  PaymentRepositoriseImpl(this.remoteDataSource);

  @override
  Future<String> getBookingCartQrPayload(List<CartItemEntitise> items) async {
    try {
      return await remoteDataSource.getBookingCartQrPayload(items);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }

  @override
  Future<String> getCheckinQrPayload(String bookingId,
      {int? userPromotionId}) async {
    try {
      return await remoteDataSource.getCheckinQrPayload(bookingId,
          userPromotionId: userPromotionId);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}
