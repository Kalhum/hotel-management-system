import 'package:dio/dio.dart';

import '../../model/responseModelRemote/response_model.dart';

abstract class BookingHistoryRemoteDataSource {
  Future<List<Map<String, dynamic>>> getBookingHistory();

  Future<bool> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  });
}

class BookingHistoryRemoteDataSourceImpl
    implements BookingHistoryRemoteDataSource {
  final Dio dio;

  static const String _endpoint = "history/";

  BookingHistoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Map<String, dynamic>>> getBookingHistory() async {
    try {
      final response = await dio.get(
        _endpoint,
      );

      final ResponseModel responseModel = ResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (responseModel.isSuccess) {
        final data = responseModel.data;

        if (data is List) {
          return data
              .whereType<Map>()
              .map(
                (item) => Map<String, dynamic>.from(item),
              )
              .toList();
        }

        throw Exception(
          "Invalid history data format",
        );
      } else {
        throw Exception(
          responseModel.message ?? "Failed to load history",
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception(
          "Token หมดอายุ กรุณา Login ใหม่",
        );
      }

      throw Exception(
        e.response?.data["message"] ?? "เกิดข้อผิดพลาดจาก server",
      );
    } catch (e) {
      throw Exception(
        "Failed to fetch history: $e",
      );
    }
  }

  @override
  @override
  Future<bool> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await dio.post(
        "history/$bookingId/review",
        data: {
          "rating": rating,
          "comment": comment,
        },
      );

      return response.data["statusCode"] == 201;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Submit review failed",
      );
    }
  }
}
