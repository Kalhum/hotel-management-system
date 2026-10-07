import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/responseModelRemote/response_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<dynamic>> getRooms(); // แก้: คืน raw list
  Future<List<dynamic>> getAvailableRooms({
    required String checkIn,
    required String checkOut,
    String? roomType,
  });

  Future<Map<String, dynamic>> getRoomById(String roomID); // แก้: คืน raw map
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;
  static const String _endpoint = 'rooms';
  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<dynamic>> getRooms() async {
    // แก้
    try {
      final response = await dio.get(_endpoint);
      final ResponseModel responseModel =
          ResponseModel.fromJson(response.data as Map<String, dynamic>);
      if (responseModel.statusCode == 200) {
        final data = responseModel.data;
        if (data is List) {
          return data; // แก้: คืน raw list ตรงๆ ไม่แปลงเป็น HomeModel แล้ว
        }
        throw Exception('Invalid room data format');
      } else {
        throw Exception(responseModel.message ?? 'Failed to load rooms');
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
        case DioExceptionType.connectionError:
          throw Exception(
              'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
        case DioExceptionType.badResponse:
          throw Exception(
              'เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${e.response?.statusCode}');
        default:
          throw Exception('เกิดข้อผิดพลาด: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch rooms: $e');
    }
  }

  @override
  Future<List<dynamic>> getAvailableRooms({
    // แก้
    required String checkIn,
    required String checkOut,
    String? roomType,
  }) async {
    try {
      final response = await dio.get(
        '$_endpoint/available',
        queryParameters: {
          'checkIn': checkIn,
          'checkOut': checkOut,
          if (roomType != null) 'roomType': roomType,
        },
      );
      final ResponseModel responseModel =
          ResponseModel.fromJson(response.data as Map<String, dynamic>);
      if (responseModel.statusCode == 200) {
        final data = responseModel.data;
        if (data is List) {
          return data; // แก้: คืน raw list ตรงๆ
        }
        throw Exception('Invalid room data format');
      } else {
        throw Exception(
            responseModel.message ?? 'Failed to load available rooms');
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
        case DioExceptionType.connectionError:
          throw Exception(
              'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
        case DioExceptionType.badResponse:
          throw Exception(e.response?.data?['message'] ??
              'เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${e.response?.statusCode}');
        default:
          throw Exception('เกิดข้อผิดพลาด: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch available rooms: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getRoomById(String roomId) async {
    // แก้
    try {
      final response = await dio.get('$_endpoint/$roomId');
      final ResponseModel responseModel =
          ResponseModel.fromJson(response.data as Map<String, dynamic>);
      if (responseModel.statusCode == 200) {
        final data = responseModel.data;
        if (data is Map) {
          return Map<String, dynamic>.from(data); // แก้: คืน raw map ตรงๆ
        }
        throw Exception('Invalid room data format');
      } else {
        throw Exception(responseModel.message ?? 'ไม่พบข้อมูลห้องพัก');
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
        case DioExceptionType.connectionError:
          throw Exception(
              'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 404) {
            throw Exception('ไม่พบห้องพักหมายเลข $roomId');
          }
          throw Exception(
              'เซิร์ฟเวอร์ตอบกลับผิดพลาด: ${e.response?.statusCode}');
        default:
          throw Exception('เกิดข้อผิดพลาด: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch room: $e');
    }
  }
}
