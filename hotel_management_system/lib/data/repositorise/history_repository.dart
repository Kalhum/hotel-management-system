

import '../data_source/remote_data_source/history_remote.dart';
import '../model/history_model.dart';

abstract class BookingHistoryRepository {
  Future<List<HistoryModel>> getBookingHistory();
  Future<bool> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  });
}

class BookingHistoryRepositoryImpl implements BookingHistoryRepository {
  final BookingHistoryRemoteDataSource remoteDataSource;

  BookingHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HistoryModel>> getBookingHistory() async {
    try {
      // รับ List<Map> จาก DataSource
      final List<Map<String, dynamic>> rawData =
          await remoteDataSource.getBookingHistory();

      // แปลง Map → HistoryModel
      return rawData.map((item) => HistoryModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception("Repository error: $e");
    }
  }

  @override
  Future<bool> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    try {
      return await remoteDataSource.submitReview(
        bookingId: bookingId,
        rating: rating,
        comment: comment,
      );
    } catch (e) {
      throw Exception("Repository error: $e");
    }
  }
}