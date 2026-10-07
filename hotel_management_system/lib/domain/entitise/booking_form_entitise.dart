import '../../util/widget/core/constants.dart';
import 'cart_item_entitise.dart';

/// ข้อมูลการจอง 1 order ที่อาจมีหลายห้อง (จากตะกร้า) แต่ข้อมูลผู้จอง/ชำระเงินใช้ร่วมกัน
class BookingFormEntitise {
  String fullName;
  String email;
  String phoneNumber;
  String address;
  String paymentSlip;
  List<CartItemEntitise> items;

  BookingFormEntitise({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.paymentSlip,
    required this.items,
  });

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get depositAmount => totalPrice * Constants.depositPercent;

  double get remainingAmount => totalPrice - depositAmount;
}
