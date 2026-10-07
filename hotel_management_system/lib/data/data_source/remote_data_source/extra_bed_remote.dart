import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/responseModelRemote/response_model.dart';

abstract class ExtraBedRemoteDataSource {
  Future<List<dynamic>> getExtraBedTypes();
}

class ExtraBedRemoteDataSourceImpl implements ExtraBedRemoteDataSource {
  final Dio dio;
  static const String _endpoint = 'rooms/extra-bed-types';

  ExtraBedRemoteDataSourceImpl(this.dio);

  @override
  Future<List<dynamic>> getExtraBedTypes() async {
    try {
      final response = await dio.get(_endpoint);
      final responseModel =
          ResponseModel.fromJson(response.data as Map<String, dynamic>);

      if (responseModel.statusCode != 200) {
        throw Exception(
          responseModel.message ?? 'Failed to load extra bed types',
        );
      }

      final data = responseModel.data;
      if (data is! List) {
        throw Exception('Invalid extra bed data format');
      }

      return data;
    } on DioException catch (error) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
        case DioExceptionType.connectionError:
          throw Exception(
            'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ',
          );
        case DioExceptionType.badResponse:
          throw Exception(
            'เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${error.response?.statusCode}',
          );
        default:
          throw Exception('เกิดข้อผิดพลาด: ${error.message}');
      }
    } catch (error) {
      throw Exception('Failed to fetch extra bed types: $error');
    }
  }
}
