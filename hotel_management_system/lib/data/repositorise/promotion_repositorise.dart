import 'dart:io';
import 'package:hotel_management_system/data/data_source/remote_data_source/promotion_remote.dart';
import 'package:hotel_management_system/data/model/promotion_model.dart';

abstract class PromotionRepositorise {
  Future<List<PromotionModel>> getActivePromotions();
  Future<PromotionModel> getPromotionById(String id);
  Future<int> claimPromotion(String promotionId);
  Future<List<UserCouponModel>> getMyCoupons({String status});
}

class PromotionRepositoriseImpl implements PromotionRepositorise {
  final PromotionRemoteDataSource remoteDataSource;
  PromotionRepositoriseImpl(this.remoteDataSource);

  @override
  Future<List<PromotionModel>> getActivePromotions() async {
    try {
      return await remoteDataSource.getActivePromotions();
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Future<PromotionModel> getPromotionById(String id) async {
    try {
      return await remoteDataSource.getPromotionById(id);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Future<int> claimPromotion(String promotionId) async {
    try {
      return await remoteDataSource.claimPromotion(promotionId);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserCouponModel>> getMyCoupons(
      {String status = "available"}) async {
    try {
      return await remoteDataSource.getMyCoupons(status: status);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }
}
