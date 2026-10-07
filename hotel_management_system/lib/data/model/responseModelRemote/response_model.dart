// To parse this JSON data, do
//
//     final responseModel = responseModelFromJson(jsonString);
import 'dart:convert';

ResponseModel responseModelFromJson(String str) =>
    ResponseModel.fromJson(json.decode(str));
String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  int? statusCode;
  bool? success;
  dynamic data;
  String? message;

  ResponseModel({
    this.statusCode,
    this.success,
    this.data,
    this.message,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        statusCode: json["statusCode"],
        success: json["success"],
        data: json["data"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "data": data,
        "message": message,
      };

  /// เช็คว่า request สำเร็จไหม โดยไม่สนว่า backend ใช้ schema แบบไหน
  /// - ถ้ามี statusCode มา -> เช็คว่าเท่ากับ 200
  /// - ถ้ามี success มา -> เช็คว่าเป็น true
  bool get isSuccess {
    if (statusCode != null) return statusCode == 200;
    if (success != null) return success == true;
    return false;
  }
}