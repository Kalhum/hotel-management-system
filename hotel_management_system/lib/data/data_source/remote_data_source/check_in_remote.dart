import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/check_in_model.dart';

abstract class CheckInRemoteDataSource {
  Future<bool> getCheckInData(CheckInModel checkInData);
  Future<bool> checkOut(String bookingId);
}

class CheckInRemoteDataSourceImpl implements CheckInRemoteDataSource {
  final Dio dio;
  CheckInRemoteDataSourceImpl(this.dio);

  @override
  @override
Future<bool> getCheckInData(CheckInModel checkInData) async {
    try {
      final formData = FormData.fromMap({
        "bookingId": checkInData.bookingId,
        "idCardNumber": checkInData.idCardNumber,
        "fullName": checkInData.fullName,
        "gender": checkInData.gender,
        "address": checkInData.address,
        "paymentStatus": checkInData.paymentStatus,
        // เพิ่ม: ส่งเฉพาะตอนมีการเลือกคูปอง (ไม่ใส่ key นี้เลยถ้าไม่ได้เลือก
        // เพราะ backend เช็ค data.userPromotionId ด้วย if (userPromotionId) เฉยๆ)
        if (checkInData.userPromotionId != null)
          "userPromotionId": checkInData.userPromotionId.toString(),
        if (checkInData.signatureImage != null)
          "signatureImage": checkInData.signatureImage,
        if (checkInData.idCardImage != null &&
            checkInData.idCardImage!.isNotEmpty)
          "idCardImage":
              await MultipartFile.fromFile(checkInData.idCardImage!),
        if (checkInData.paymentSlipImage != null &&
            checkInData.paymentSlipImage!.isNotEmpty)
          "paymentSlipImage":
              await MultipartFile.fromFile(checkInData.paymentSlipImage!),
      });
      final response = await dio.post("checkin", data: formData);
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
        case DioExceptionType.connectionError:
          throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้');
        case DioExceptionType.badResponse:
          throw Exception(
              'เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${e.response?.statusCode}');
        default:
          throw Exception('เกิดข้อผิดพลาด: ${e.message}');
      }
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาด: $e');
    }
}


   @override
  Future<bool> checkOut(String bookingId) async {
    try {
      final response = await dio.patch("bookings/$bookingId/checkout");
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
        case DioExceptionType.connectionError:
          throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้');
        case DioExceptionType.badResponse:
          throw Exception('เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${e.response?.statusCode}');
        default:
          throw Exception('เกิดข้อผิดพลาด: ${e.message}');
      }
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาด: $e');
    }
  }
}