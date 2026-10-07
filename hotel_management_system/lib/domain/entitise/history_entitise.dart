// booking_history_entity.dart
import 'review_entitise.dart';

class BookingHistoryEntity {
  String bookingId;
  String roomNumber;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  String totalAmount;
  bool isReviewed;
  int selectedRating;
  String reviewComment;
  String reviewStatus;
  ReviewEntity? review;

  BookingHistoryEntity({
    this.bookingId = '',
    this.roomNumber = '',
    this.checkInDate,
    this.checkOutDate,
    this.totalAmount = "0",
    this.isReviewed = false,
    this.selectedRating = 0,
    this.reviewComment = "ไม่ได้แสดงความคิดเห็น",
    this.reviewStatus = "ยังไม่ได้ให้คะแนน",
    this.review,
  });

  //getter
  String get formattedCheckIn => checkInDate != null
      ? "${checkInDate!.day}-${checkInDate!.month}-${checkInDate!.year}"
      : "-";

  String get formattedCheckOut => checkOutDate != null
      ? "${checkOutDate!.day}-${checkOutDate!.month}-${checkOutDate!.year}"
      : "-";

  String get formattedAmount => "$totalAmount บาท";
}