import 'package:dio/dio.dart';
import 'package:hotel_management_system/domain/entitise/cart_item_entitise.dart';

abstract class PaymentRemoteDataSource {
  Future<String> getBookingCartQrPayload(List<CartItemEntitise> items);
  Future<String> getCheckinQrPayload(String bookingId, {int? userPromotionId});
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;
  PaymentRemoteDataSourceImpl(this.dio);

  // ยอดเงินคำนวณโดย backend เองจากราคาห้อง/เตียงเสริมใน DB ป้องกัน client ปลอมยอด
  @override
  Future<String> getBookingCartQrPayload(List<CartItemEntitise> items) async {
    final payload = items
        .map((item) => {
              "roomId": item.roomId,
              "checkInDate": item.checkIn.toIso8601String(),
              "checkOutDate": item.checkOut.toIso8601String(),
              "adultCount": item.adultCount,
              "childCount": item.childCount,
              "extraBedTypeId": item.extraBedType?.id,
              "extraBedQuantity": item.extraBedQuantity,
            })
        .toList();
    return _post("payments/promptpay-qr/booking-cart", {"items": payload});
  }

  @override
  Future<String> getCheckinQrPayload(String bookingId,
      {int? userPromotionId}) async {
    return _post("payments/promptpay-qr/checkin", {
      "bookingId": bookingId,
      if (userPromotionId != null) "userPromotionId": userPromotionId,
    });
  }

  Future<String> _post(String path, Map<String, dynamic> data) async {
    try {
      final response = await dio.post(path, data: data);
      final qrPayload = response.data["qrPayload"] as String?;
      if (qrPayload == null || qrPayload.isEmpty) {
        throw Exception("ไม่พบข้อมูล QR code จาก server");
      }
      return qrPayload;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
        case DioExceptionType.connectionError:
          throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้');
        case DioExceptionType.badResponse:
          final message =
              e.response?.data is Map ? e.response?.data["message"] : null;
          throw Exception(message ??
              'เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${e.response?.statusCode}');
        default:
          throw Exception('เกิดข้อผิดพลาด: ${e.message}');
      }
    }
  }
}
