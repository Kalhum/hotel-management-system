import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/booking_form_model.dart';

abstract class BookingFormRemoteDataSource {
  Future<bool> bookingForm(BookingFormModel bookingData);
}

class BookingFormRemoteDataSourceImpl implements BookingFormRemoteDataSource {
  final Dio dio;
  BookingFormRemoteDataSourceImpl(this.dio);

  // เตรียมไว้รอ backend เปิด endpoint สำหรับสั่งจองหลายห้องพร้อมกัน (ระบบตะกร้า)
  static const String _endpoint = "bookings/cart";

  @override
  Future<bool> bookingForm(BookingFormModel bookingData) async {
    final Map<String, dynamic> fields = {
      "fullName": bookingData.fullName,
      "email": bookingData.email,
      "phoneNumber": bookingData.phoneNumber,
      "address": bookingData.address,
      "totalPrice": bookingData.totalPrice,
      "depositAmount": bookingData.depositAmount,
      "remainingAmount": bookingData.remainingAmount,
      // ส่งเป็น JSON string เพราะ multipart/form-data ไม่รองรับ list ของ object โดยตรง
      "items":
          jsonEncode(bookingData.items.map((item) => item.toJson()).toList()),
    };

    // เช็ค null ก่อนใช้ ด้วย local variable ที่ non-nullable
    final String? slipPath = bookingData.paymentSlip;
    if (slipPath != null &&
        slipPath.isNotEmpty &&
        File(slipPath).existsSync()) {
      fields["paymentSlip"] = await MultipartFile.fromFile(
        slipPath,
        filename: slipPath.split('/').last,
      );
    }

    final formData = FormData.fromMap(fields);

    final response = await dio.post(
      _endpoint,
      data: formData,
      // ไม่ต้องตั้ง Content-Type เอง — Dio จะใส่ multipart/form-data; boundary=... ให้อัตโนมัติ
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
