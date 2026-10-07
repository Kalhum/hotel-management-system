import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/use_case/history_usecase.dart';

import '../../../../domain/entitise/history_entitise.dart';

class HistoryScreenProvider extends ChangeNotifier {
  final BookingHistoryUseCase _useCase;
  HistoryScreenProvider(this._useCase);

  List<BookingHistoryEntity> _bookingList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<BookingHistoryEntity> get bookingList => _bookingList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> getBookingHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      _bookingList = await _useCase.getBookingHistory();
    } catch (e) {
      _errorMessage = 'ไม่สามารถโหลดข้อมูลได้';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitReview({
    required BookingHistoryEntity booking,
    required int rating,
    required String comment,
  }) async {
    try {
      final result = await _useCase.submitReview(
        bookingId: booking.bookingId,
        rating: rating,
        comment: comment,
      );
      if (result) {
        booking.selectedRating = rating;
        booking.reviewComment =
            comment.isEmpty ? "ไม่ได้แสดงความคิดเห็น" : comment;
        booking.reviewStatus = "ให้คะแนนแล้ว ($rating/5)";
        booking.isReviewed = true;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'ไม่สามารถส่งรีวิวได้';
      notifyListeners();
    }
  }
}
