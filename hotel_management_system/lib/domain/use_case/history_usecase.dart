import '../../data/repositorise/history_repository.dart';
import '../entitise/history_entitise.dart';
import '../entitise/review_entitise.dart';

class BookingHistoryUseCase {
  final BookingHistoryRepository repository;

  BookingHistoryUseCase({required this.repository});

  Future<List<BookingHistoryEntity>> getBookingHistory() async {
    final models = await repository.getBookingHistory();

    return models.map((model) {
      return BookingHistoryEntity(
        bookingId: model.bookingId ?? '',
        roomNumber: model.roomNumber ?? '',
        checkInDate: model.checkInDate,
        checkOutDate: model.checkOutDate,
        totalAmount: model.totalAmount ?? "0",
        isReviewed: model.review != null,
        selectedRating: model.review?.rating ?? 0,
        reviewComment: model.review?.comment ?? "ไม่ได้แสดงความคิดเห็น",
        reviewStatus: model.review != null
            ? "ให้คะแนนแล้ว (${model.review!.rating}/5)"
            : "ยังไม่ได้ให้คะแนน",
        review: model.review != null
            ? ReviewEntity(
                rating: model.review!.rating ?? 0,
                comment: model.review!.comment ?? '',
                reviewedAt: model.review!.reviewedAt,
              )
            : null,
      );
    }).toList();
  }

  Future<bool> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    try {
      return await repository.submitReview(
        bookingId: bookingId,
        rating: rating,
        comment: comment,
      );
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }
}
