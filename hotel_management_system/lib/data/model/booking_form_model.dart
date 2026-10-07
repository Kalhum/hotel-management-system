// To parse this JSON data, do
//
//     final bookingFormModel = bookingFormModelFromJson(jsonString);
import 'dart:convert';

BookingFormModel bookingFormModelFromJson(String str) =>
    BookingFormModel.fromJson(json.decode(str));

String bookingFormModelToJson(BookingFormModel data) =>
    json.encode(data.toJson());

/// ห้องพัก 1 รายการในตะกร้า map กับคอลัมน์ในตาราง cart:
/// room_id, check_in, check_out, adult_count, child_count,
/// extra_bed_type_id, extra_bed_quantity, room_price, extra_bed_price
class CartOrderItemModel {
  String? roomId;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int? adultCount;
  int? childCount;
  int? extraBedTypeId;
  int? extraBedQuantity;
  double? roomPrice;
  double? extraBedPrice;

  CartOrderItemModel({
    this.roomId,
    this.checkInDate,
    this.checkOutDate,
    this.adultCount,
    this.childCount,
    this.extraBedTypeId,
    this.extraBedQuantity,
    this.roomPrice,
    this.extraBedPrice,
  });

  factory CartOrderItemModel.fromJson(Map<String, dynamic> json) =>
      CartOrderItemModel(
        roomId: json["roomId"],
        checkInDate: json["checkInDate"] == null
            ? null
            : DateTime.parse(json["checkInDate"]),
        checkOutDate: json["checkOutDate"] == null
            ? null
            : DateTime.parse(json["checkOutDate"]),
        adultCount: json["adultCount"],
        childCount: json["childCount"],
        extraBedTypeId: json["extraBedTypeId"],
        extraBedQuantity: json["extraBedQuantity"],
        roomPrice: json["roomPrice"] != null
            ? (json["roomPrice"] as num).toDouble()
            : null,
        extraBedPrice: json["extraBedPrice"] != null
            ? (json["extraBedPrice"] as num).toDouble()
            : null,
      );

  Map<String, dynamic> toJson() => {
        "roomId": roomId,
        "checkInDate": checkInDate?.toIso8601String(),
        "checkOutDate": checkOutDate?.toIso8601String(),
        "adultCount": adultCount,
        "childCount": childCount,
        "extraBedTypeId": extraBedTypeId,
        "extraBedQuantity": extraBedQuantity,
        "roomPrice": roomPrice,
        "extraBedPrice": extraBedPrice,
      };
}

class BookingFormModel {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? address;
  String? paymentSlip;
  List<CartOrderItemModel> items;
  double? totalPrice;
  double? depositAmount; // ค่ามัดจำที่คำนวณจริงจาก backend/repository
  double? remainingAmount; // ยอดคงเหลือหลังหักมัดจำ

  BookingFormModel({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.address,
    this.paymentSlip,
    this.items = const [],
    this.totalPrice,
    this.depositAmount,
    this.remainingAmount,
  });

  factory BookingFormModel.fromJson(Map<String, dynamic> json) =>
      BookingFormModel(
        fullName: json["fullName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        paymentSlip: json["paymentSlip"],
        items: json["items"] == null
            ? []
            : List<CartOrderItemModel>.from(
                json["items"].map((item) => CartOrderItemModel.fromJson(item))),
        totalPrice: json["totalPrice"] != null
            ? (json["totalPrice"] as num).toDouble()
            : null,
        depositAmount: json["depositAmount"] != null
            ? (json["depositAmount"] as num).toDouble()
            : null,
        remainingAmount: json["remainingAmount"] != null
            ? (json["remainingAmount"] as num).toDouble()
            : null,
      );

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "address": address,
      "paymentSlip": paymentSlip,
      "items": items.map((item) => item.toJson()).toList(),
      "totalPrice": totalPrice,
      "depositAmount":
          depositAmount, // สำคัญมาก ถ้าลืมใส่ backend จะไม่ได้รับค่านี้เลย
      "remainingAmount": remainingAmount,
    };
  }
}
