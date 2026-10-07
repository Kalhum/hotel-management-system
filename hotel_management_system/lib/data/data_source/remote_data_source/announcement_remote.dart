import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/announcement_model.dart';
import 'package:hotel_management_system/data/model/responseModelRemote/response_model.dart';

abstract class AnnouncementRemoteDataSource {
  Future<List<AnnouncementModel>> getActiveAnnouncements();
}

class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  final Dio dio;

  AnnouncementRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AnnouncementModel>> getActiveAnnouncements() async {
    try {
      final response = await dio.get('announcements');
      final responseModel =
          ResponseModel.fromJson(response.data as Map<String, dynamic>);
      final data = responseModel.data;

      if (responseModel.statusCode == 200 && data is List) {
        return data
            .whereType<Map>()
            .map((item) => AnnouncementModel.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .toList();
      }

      throw Exception(responseModel.message ?? 'โหลดข่าวสารไม่สำเร็จ');
    } on DioException catch (error) {
      throw Exception(
          error.response?.data?['message'] ?? 'โหลดข่าวสารไม่สำเร็จ');
    }
  }
}
