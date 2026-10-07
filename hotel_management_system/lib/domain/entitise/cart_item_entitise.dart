// domain/entitise/cart_item_entitise.dart
//
// รายการห้องพักหนึ่งรายการในตะกร้า (แต่ละห้องเลือกวันที่/จำนวนผู้เข้าพักแยกกันเอง)
import '../../presentation/page/homePage/companents/typeRoom_enum.dart';
import 'extra_bed_entitise.dart';

class CartItemEntitise {
  final int id;
  final String roomId;
  final RoomType roomType;
  final String? imageUrl;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adultCount;
  final int childCount;
  final ExtraBedTypeEntitise? extraBedType;
  final int extraBedQuantity;
  final double pricePerNight;

  CartItemEntitise({
    int? id,
    required this.roomId,
    required this.roomType,
    this.imageUrl,
    required this.checkIn,
    required this.checkOut,
    required this.adultCount,
    required this.childCount,
    required this.extraBedType,
    required this.extraBedQuantity,
    required this.pricePerNight,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch;

  int get nights => checkOut.difference(checkIn).inDays;

  double get roomPrice => pricePerNight * nights;

  double get extraBedPrice =>
      (extraBedType?.price ?? 0) * extraBedQuantity * nights;

  double get totalPrice => roomPrice + extraBedPrice;
}
