import 'package:hotel_management_system/data/repositorise/payment_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/cart_item_entitise.dart';

class PaymentUsecase {
  final PaymentRepositoriseImpl repository;
  PaymentUsecase(this.repository);

  Future<String> getBookingCartQrPayload(List<CartItemEntitise> items) async {
    if (items.isEmpty) {
      throw Exception("ไม่พบห้องพักในตะกร้า");
    }
    return await repository.getBookingCartQrPayload(items);
  }

  Future<String> getCheckinQrPayload(String bookingId,
      {int? userPromotionId}) async {
    if (bookingId.isEmpty) {
      throw Exception("ต้องระบุ booking ID");
    }
    return await repository.getCheckinQrPayload(bookingId,
        userPromotionId: userPromotionId);
  }
}
