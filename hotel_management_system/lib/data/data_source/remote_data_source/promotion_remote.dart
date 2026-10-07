import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/responseModelRemote/response_model.dart';

import '../../model/promotion_model.dart';

abstract class PromotionRemoteDataSource {
  Future<List<PromotionModel>> getActivePromotions();
  Future<PromotionModel> getPromotionById(String id);
  Future<int> claimPromotion(String promotionId);

  Future<List<UserCouponModel>> getMyCoupons({String status = "available"});
}

class PromotionRemoteDataSourceImpl implements PromotionRemoteDataSource {
  final Dio dio;
  static const String _endpoint = "promotions";
  PromotionRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PromotionModel>> getActivePromotions() async {
    try {
      final response = await dio.get(_endpoint);
      final responseModel =
          ResponseModel.fromJson(response.data as Map<String, dynamic>);
      if (responseModel.statusCode == 200) {
        final data = responseModel.data;
        if (data is List) {
          return data
              .whereType<Map>()
              .map((item) =>
                  PromotionModel.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }
        throw Exception('Invalid promotion data format');
      } else {
        throw Exception(responseModel.message ?? 'โหลดโปรโมชั่นไม่สำเร็จ');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          'เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${e.response?.statusCode}');
    } catch (e) {
      throw Exception('Failed to fetch promotions: $e');
    }
  }

  @override
  Future<PromotionModel> getPromotionById(String id) async {
    try {
      final response = await dio.get('$_endpoint/$id');
      final responseModel =
          ResponseModel.fromJson(response.data as Map<String, dynamic>);
      if (responseModel.statusCode == 200) {
        final data = responseModel.data;
        if (data is Map) {
          return PromotionModel.fromJson(Map<String, dynamic>.from(data));
        }
        throw Exception('Invalid promotion data format');
      } else {
        throw Exception(responseModel.message ?? 'ไม่พบโปรโมชั่นนี้');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('ไม่พบโปรโมชั่นหมายเลข $id');
      }
      throw Exception(e.response?.data?['message'] ??
          'เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${e.response?.statusCode}');
    } catch (e) {
      throw Exception('Failed to fetch promotion: $e');
    }
  }

  @override
  Future<int> claimPromotion(String promotionId) async {
    try {
      final response = await dio.post('$_endpoint/$promotionId/claim');
      final responseModel =
          ResponseModel.fromJson(response.data as Map<String, dynamic>);
      if (responseModel.statusCode == 201 || responseModel.statusCode == 200) {
        final data = responseModel.data;
        if (data is Map && data['userPromotionId'] != null) {
          return data['userPromotionId'] as int;
        }
        return 0;
      } else {
        throw Exception(responseModel.message ?? 'รับคูปองไม่สำเร็จ');
      }
    } on DioException catch (e) {
      // 409 = รับไปแล้ว, 400 = โปรโมชั่นหมดอายุ/ปิดใช้งาน ฯลฯ — ส่ง message จาก backend ตรงๆ
      throw Exception(e.response?.data?['message'] ?? 'รับคูปองไม่สำเร็จ');
    } catch (e) {
      throw Exception('Failed to claim promotion: $e');
    }
  }

  @override
  Future<List<UserCouponModel>> getMyCoupons(
      {String status = "available"}) async {
    try {
      final response = await dio.get(
        '$_endpoint/my-coupons',
        queryParameters: {'status': status},
      );
      final responseModel =
          ResponseModel.fromJson(response.data as Map<String, dynamic>);
      if (responseModel.statusCode == 200) {
        final data = responseModel.data;
        if (data is List) {
          return data
              .whereType<Map>()
              .map((item) =>
                  UserCouponModel.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }
        throw Exception('Invalid coupon data format');
      } else {
        throw Exception(responseModel.message ?? 'โหลดคูปองไม่สำเร็จ');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Token หมดอายุ กรุณา Login ใหม่');
      }
      throw Exception(e.response?.data?['message'] ??
          'เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${e.response?.statusCode}');
    } catch (e) {
      throw Exception('Failed to fetch coupons: $e');
    }
  }
}
