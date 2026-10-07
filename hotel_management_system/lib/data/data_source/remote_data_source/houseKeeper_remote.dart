import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../util/widget/core/network/dio_client.dart';
import '../../model/housekeeper_model.dart';

abstract class HousekeeperRoomRemoteDataSource {
  Future<List<HousekeeperRoomModel>> getRooms();
  Future<List<HousekeeperFurnitureModel>> getRoomFurniture(String roomNo);

  /// ✅ เปลี่ยนเป็น multipart: ส่ง items เป็น JSON string ในฟิลด์ "items" +
  /// แนบไฟล์รูปที่มีจริง (บาง item อาจไม่มีรูปเลยก็ได้ ใช้ sparse map)
  /// ชื่อฟิลด์ไฟล์ต้องเป็น "photo_<index>" ตรงกับตำแหน่งใน items array เป๊ะ
  /// (ดู furniture_service.js -> submitReport: fileMap[`photo_${i}`])
  Future<bool> submitFurnitureReport(
    String roomNo,
    List<Map<String, dynamic>> items,
    Map<int, File> photosByIndex,
  );

  /// ✅ เปลี่ยนเป็น multipart: roomNo/issueType/description/priority เป็น
  /// form field ธรรมดา + ไฟล์รูปทั้งหมดแนบใต้ชื่อฟิลด์ "images" ซ้ำกัน
  /// (ดู houskeeper_issues_routes.js -> uploadImage.array("images", 5))
  Future<bool> createIssue({
    required String roomNo,
    required String issueType,
    required String description,
    required List<File> imageFiles,
    String priority = 'medium',
  });

  Future<bool> saveRoomDetail({
    required String roomNo,
    required String cleaningStatus,
  });
}

class HousekeeperRoomRemoteDataSourceImpl
    implements HousekeeperRoomRemoteDataSource {
  final Dio _dio = DioClient.dio;

  String _fileNameOf(File file) => file.path.split(Platform.pathSeparator).last;

  @override
  Future<List<HousekeeperRoomModel>> getRooms() async {
    try {
      final response = await _dio.get('housekeeper');
      final rawData = response.data['data'];

      if (rawData is! List) {
        throw Exception('รูปแบบข้อมูลห้องจาก server ไม่ถูกต้อง');
      }

      return rawData
          .whereType<Map>()
          .map((item) =>
              HousekeeperRoomModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'ไม่สามารถโหลดข้อมูลห้องได้',
      );
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาด: $e');
    }
  }

  @override
  Future<List<HousekeeperFurnitureModel>> getRoomFurniture(
      String roomNo) async {
    try {
      final response = await _dio.get(
        'furniture',
        queryParameters: {
          'roomId': roomNo,
          'bookingId': '',
        },
      );
      final rawData = response.data['data'];

      if (rawData is! List) {
        throw Exception('รูปแบบข้อมูลเฟอร์นิเจอร์จาก server ไม่ถูกต้อง');
      }

      return rawData
          .whereType<Map>()
          .map((item) => HousekeeperFurnitureModel.fromJson(
              Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'ไม่สามารถโหลดรายการในห้องได้',
      );
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาด: $e');
    }
  }

  @override
  Future<bool> submitFurnitureReport(
    String roomNo,
    List<Map<String, dynamic>> items,
    Map<int, File> photosByIndex,
  ) async {
    try {
      final formData = FormData();

      // ✅ backend ทำ JSON.parse(req.body.items) เอง ต้อง stringify ก่อนส่ง
      formData.fields.add(MapEntry('items', jsonEncode(items)));

      // ✅ ชื่อฟิลด์ต้องอิง index ใน items array ตรงเป๊ะ ไม่ใช่ furniture id
      // (ตรงกับที่ backend ทำ fileMap[`photo_${i}`] โดย i คือ index ของ loop)
      for (final entry in photosByIndex.entries) {
        final index = entry.key;
        final file = entry.value;
        formData.files.add(MapEntry(
          'photo_$index',
          await MultipartFile.fromFile(file.path, filename: _fileNameOf(file)),
        ));
      }

      final response = await _dio.post('furniture/report', data: formData);
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'ไม่สามารถบันทึกผลตรวจของในห้องได้',
      );
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาด: $e');
    }
  }

  @override
  Future<bool> createIssue({
    required String roomNo,
    required String issueType,
    required String description,
    required List<File> imageFiles,
    String priority = 'medium',
  }) async {
    try {
      final formData = FormData.fromMap({
        'roomNo': roomNo,
        'issueType': issueType,
        'description': description,
        'priority': priority,
      });

      // ✅ multer ใช้ .array("images", 5) -> ต้องส่งไฟล์ทุกไฟล์ใต้ชื่อฟิลด์
      // "images" ซ้ำกัน (ไม่ใช่ images_0, images_1 แบบ furniture/report)
      for (final file in imageFiles) {
        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(file.path, filename: _fileNameOf(file)),
        ));
      }

      final response = await _dio.post('housekeeper/issues', data: formData);
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'ไม่สามารถส่งรายงานแจ้งซ่อมได้',
      );
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาด: $e');
    }
  }

  @override
  Future<bool> saveRoomDetail({
    required String roomNo,
    required String cleaningStatus,
  }) async {
    try {
      final response = await _dio.put(
        'housekeeper/rooms/${Uri.encodeComponent(roomNo)}/cleaning-status',
        data: {
          'cleaningStatus': cleaningStatus,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'ไม่สามารถบันทึกสถานะห้องได้',
      );
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาด: $e');
    }
  }
}
