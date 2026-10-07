import 'package:hotel_management_system/data/repositorise/booking_form_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/booking_form_entitise.dart';
import '../../data/model/booking_form_model.dart';

class BookingFormUsecase {
  final BookingFormRepositoriseImpl repository;
  BookingFormUsecase(this.repository);

  // ดึงราคาต่อคืนของห้อง ไว้ให้ provider คำนวณ preview ราคารวม/มัดจำ
  Future<double> getRoomPricePerNight(String roomId) async {
    try {
      return await repository.getRoomPricePerNight(roomId);
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }

  Future<bool> bookingForm(BookingFormEntitise bookingData) async {
    try {
      final model = BookingFormModel(
        fullName: bookingData.fullName,
        email: bookingData.email,
        phoneNumber: bookingData.phoneNumber,
        address: bookingData.address,
        paymentSlip: bookingData.paymentSlip,
        items: bookingData.items
            .map((item) => CartOrderItemModel(
                  roomId: item.roomId,
                  checkInDate: item.checkIn,
                  checkOutDate: item.checkOut,
                  adultCount: item.adultCount,
                  childCount: item.childCount,
                  extraBedTypeId: item.extraBedType?.id,
                  extraBedQuantity: item.extraBedQuantity,
                  roomPrice: item.roomPrice,
                  extraBedPrice: item.extraBedPrice,
                ))
            .toList(),
      );
      return await repository.bookingForm(model);
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }
}
