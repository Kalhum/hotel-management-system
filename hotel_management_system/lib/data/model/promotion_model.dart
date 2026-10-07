// To parse this JSON data, do
//
//     final promotionModel = promotionModelFromJson(jsonString);

import 'dart:convert';
import '../../domain/entitise/promotion_entitise.dart';

// ---------- PromotionModel: ใช้กับ GET /promotions และ /promotions/:id (snake_case) ----------

PromotionModel promotionModelFromJson(String str) =>
    PromotionModel.fromJson(json.decode(str));

// เพิ่ม helper function ไว้บนสุดไฟล์ (นอก class)
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

class PromotionModel {
  int? id;
  String? code;
  String? title;
  String? description;
  String? imageUrl;
  String? discountType;
  double? discountValue;
  double? minBookingAmount;
  double? maxDiscountAmount;
  int? usageLimit;
  int? usedCount;
  int? claimedCount;
  DateTime? startDate;
  DateTime? endDate;
  bool? isActive;

  PromotionModel({
    this.id,
    this.code,
    this.title,
    this.description,
    this.imageUrl,
    this.discountType,
    this.discountValue,
    this.minBookingAmount,
    this.maxDiscountAmount,
    this.usageLimit,
    this.usedCount,
    this.claimedCount,
    this.startDate,
    this.endDate,
    this.isActive,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
        id: json["id"],
        code: json["code"],
        title: json["title"],
        description: json["description"],
        imageUrl: json["image_url"],
        discountType: json["discount_type"],
        discountValue: _parseDouble(json["discount_value"]),
        minBookingAmount: _parseDouble(json["min_booking_amount"]),
        maxDiscountAmount: _parseDouble(json["max_discount_amount"]),
        usageLimit: json["usage_limit"],
        usedCount: json["used_count"],
        claimedCount: json["claimed_count"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        isActive: json["is_active"] == 1 || json["is_active"] == true,
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "title": title,
        "description": description,
        "image_url": imageUrl,
        "discount_type": discountType,
        "discount_value": discountValue,
        "min_booking_amount": minBookingAmount,
        "max_discount_amount": maxDiscountAmount,
        "usage_limit": usageLimit,
        "used_count": usedCount,
        "claimed_count": claimedCount,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "is_active": isActive,
      };

  PromotionEntitise toEntity() => PromotionEntitise(
        id: id ?? 0,
        code: code ?? '',
        title: title ?? '',
        description: description,
        imageUrl: imageUrl,
        discountType: discountType ?? 'fixed',
        discountValue: discountValue ?? 0,
        minBookingAmount: minBookingAmount ?? 0,
        maxDiscountAmount: maxDiscountAmount,
        usageLimit: usageLimit,
        usedCount: usedCount ?? 0,
        claimedCount: claimedCount ?? 0,
        startDate: startDate,
        endDate: endDate,
        isActive: isActive ?? false,
      );
}

// ---------- UserCouponModel: ใช้กับ GET /promotions/my-coupons (camelCase) ----------

class UserCouponModel {
  int? userPromotionId;
  String? status;
  DateTime? receivedAt;
  DateTime? usedAt;
  String? bookingId;
  int? promotionId;
  String? code;
  String? title;
  String? description;
  String? discountType;
  double? discountValue;
  double? minBookingAmount;
  double? maxDiscountAmount;
  DateTime? endDate;

  UserCouponModel({
    this.userPromotionId,
    this.status,
    this.receivedAt,
    this.usedAt,
    this.bookingId,
    this.promotionId,
    this.code,
    this.title,
    this.description,
    this.discountType,
    this.discountValue,
    this.minBookingAmount,
    this.maxDiscountAmount,
    this.endDate,
  });

  factory UserCouponModel.fromJson(Map<String, dynamic> json) =>
      UserCouponModel(
        userPromotionId: json["userPromotionId"],
        status: json["status"],
        receivedAt: json["receivedAt"] == null
            ? null
            : DateTime.tryParse(json["receivedAt"]),
        usedAt:
            json["usedAt"] == null ? null : DateTime.tryParse(json["usedAt"]),
        bookingId: json["bookingId"],
        promotionId: json["promotionId"],
        code: json["code"],
        title: json["title"],
        description: json["description"],
        discountType: json["discountType"],
        discountValue: _parseDouble(json["discountValue"]),
        minBookingAmount: _parseDouble(json["minBookingAmount"]),
        maxDiscountAmount: _parseDouble(json["maxDiscountAmount"]),
        endDate:
            json["endDate"] == null ? null : DateTime.tryParse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "userPromotionId": userPromotionId,
        "status": status,
        "receivedAt": receivedAt?.toIso8601String(),
        "usedAt": usedAt?.toIso8601String(),
        "bookingId": bookingId,
        "promotionId": promotionId,
        "code": code,
        "title": title,
        "description": description,
        "discountType": discountType,
        "discountValue": discountValue,
        "minBookingAmount": minBookingAmount,
        "maxDiscountAmount": maxDiscountAmount,
        "endDate": endDate?.toIso8601String(),
      };

  UserCouponEntitise toEntity() => UserCouponEntitise(
        userPromotionId: userPromotionId ?? 0,
        status: status ?? 'available',
        receivedAt: receivedAt,
        usedAt: usedAt,
        bookingId: bookingId,
        promotionId: promotionId ?? 0,
        code: code ?? '',
        title: title ?? '',
        description: description,
        discountType: discountType ?? 'fixed',
        discountValue: discountValue ?? 0,
        minBookingAmount: minBookingAmount ?? 0,
        maxDiscountAmount: maxDiscountAmount,
        endDate: endDate,
      );
}
