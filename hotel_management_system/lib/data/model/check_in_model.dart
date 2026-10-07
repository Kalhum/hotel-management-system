import 'dart:convert';
CheckInModel checkInModelFromJson(String str) => CheckInModel.fromJson(json.decode(str));
String checkInModelToJson(CheckInModel data) => json.encode(data.toJson());
class CheckInModel {
    String? bookingId;
    String? idCardNumber;
    String? fullName;
    String? gender;
    String? address;
    String? idCardImage;
    String? signatureImage;
    String? paymentSlipImage;
    String? paymentStatus;
    int? userPromotionId; // เพิ่ม

    CheckInModel({
        this.bookingId,
        this.idCardNumber,
        this.fullName,
        this.gender,
        this.address,
        this.idCardImage,
        this.signatureImage,
        this.paymentSlipImage,
        this.paymentStatus,
        this.userPromotionId, // เพิ่ม
    });

    factory CheckInModel.fromJson(Map<String, dynamic> json) => CheckInModel(
        bookingId: json["bookingId"],
        idCardNumber: json["idCardNumber"],
        fullName: json["fullName"],
        gender: json["gender"],
        address: json["address"],
        idCardImage: json["idCardImage"],
        signatureImage: json["signatureImage"],
        paymentSlipImage: json["paymentSlipImage"],
        paymentStatus: json["paymentStatus"],
        userPromotionId: json["userPromotionId"], // เพิ่ม
    );

    Map<String, dynamic> toJson() => {
        "bookingId": bookingId,
        "idCardNumber": idCardNumber,
        "fullName": fullName,
        "gender": gender,
        "address": address,
        "idCardImage": idCardImage,
        "signatureImage": signatureImage,
        "paymentSlipImage": paymentSlipImage,
        "paymentStatus": paymentStatus,
        "userPromotionId": userPromotionId, // เพิ่ม
    };
}