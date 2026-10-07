import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hotel_management_system/data/model/furniture_model.dart';

import '../../../util/widget/core/network/dio_client.dart';

abstract class furnitureRemoteDataSource {
  Future<List<Map<String, dynamic>>> getFurnitureData(
    String roomID,
    String bookingId,
  );

  Future<bool> userFurnitureReport(
    List<FurnitureModel> reportData,
    Map<String, File> photosByField,
  );

  Future<bool> confirmUserCondition(String bookingId);
}

class furnitureRemoteDataSourceImpl implements furnitureRemoteDataSource {
  final Dio _dio = DioClient.dio;

  String _fileNameOf(File file) {
    return file.path.split(Platform.pathSeparator).last;
  }

  // ============================================================
  // GET FURNITURE
  // ============================================================

  @override
  Future<List<Map<String, dynamic>>> getFurnitureData(
    String roomID,
    String bookingId,
  ) async {
    try {
      final response = await _dio.get(
        "furniture",
        queryParameters: {
          "roomId": roomID,
          "bookingId": bookingId,
        },
      );

      final List<dynamic> data = response.data["data"] ?? [];

      return data.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ?? "ไม่สามารถโหลดข้อมูลเฟอร์นิเจอร์ได้",
      );
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }

  // ============================================================
  // SUBMIT REPORT
  // ============================================================

  @override
  Future<bool> userFurnitureReport(
    List<FurnitureModel> reportData,
    Map<String, File> photosByField,
  ) async {
    try {
      final formData = FormData();

      // --------------------------------------------------------
      // items JSON
      // --------------------------------------------------------

      final body = reportData.map((e) => e.toJson()).toList();

      formData.fields.add(
        MapEntry(
          'items',
          jsonEncode(body),
        ),
      );

      // --------------------------------------------------------
      // images
      //
      // photo_0
      // photo_1
      //
      // photo_0_damage
      // photo_1_damage
      // --------------------------------------------------------

      for (final entry in photosByField.entries) {
        final fieldName = entry.key;
        final file = entry.value;

        formData.files.add(
          MapEntry(
            fieldName,
            await MultipartFile.fromFile(
              file.path,
              filename: _fileNameOf(file),
            ),
          ),
        );
      }

      final response = await _dio.post(
        "furniture/report",
        data: formData,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ?? "ส่งรายงานไม่สำเร็จ",
      );
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Future<bool> confirmUserCondition(String bookingId) async {
    try {
      final response = await _dio.post(
        'furniture/confirm',
        data: {'bookingId': bookingId},
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?["message"] ?? "ไม่สามารถยืนยันสภาพห้องได้",
      );
    }
  }
}




// import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:hotel_management_system/data/model/furniture_model.dart';

// import '../../../util/widget/core/network/dio_client.dart';

// abstract class furnitureRemoteDataSource {
//   Future<List<Map<String, dynamic>>> getFurnitureData(
//       String roomID, String bookingId);

//   Future<bool> userFurnitureReport(
//     List<FurnitureModel> reportData,
//     Map<int, File> photosByIndex,
//   );

//   // ✅ เพิ่มใหม่: แจ้งชำรุดฝั่ง user ยิง endpoint เดียวกับแม่บ้าน
//   // (POST /housekeeper/issues -> uploadImage.array("images", 5))
//   Future<bool> createRepairReport({
//     required String roomNo,
//     required String issueType,
//     required String description,
//     required List<File> imageFiles,
//   });
// }

// class furnitureRemoteDataSourceImpl implements furnitureRemoteDataSource {
//   final Dio _dio = DioClient.dio;

//   String _fileNameOf(File file) =>
//       file.path.split(Platform.pathSeparator).last;

//   @override
//   Future<List<Map<String, dynamic>>> getFurnitureData(
//       String roomID, String bookingId) async {
//     try {
//       final response = await _dio.get(
//         "furniture",
//         queryParameters: {
//           "roomId": roomID,
//           "bookingId": bookingId,
//         },
//       );

//       final List<dynamic> data = response.data["data"] ?? [];
//       return data.cast<Map<String, dynamic>>();
//     } on DioException catch (e) {
//       throw Exception(
//           e.response?.data?["message"] ?? "ไม่สามารถโหลดข้อมูลเฟอร์นิเจอร์ได้");
//     } catch (e) {
//       throw Exception("เกิดข้อผิดพลาด: $e");
//     }
//   }

//   @override
//   Future<bool> userFurnitureReport(
//     List<FurnitureModel> reportData,
//     Map<int, File> photosByIndex,
//   ) async {
//     try {
//       final formData = FormData();

//       final body = reportData.map((e) => e.toJson()).toList();
//       formData.fields.add(MapEntry('items', jsonEncode(body)));

//       for (final entry in photosByIndex.entries) {
//         final index = entry.key;
//         final file = entry.value;
//         formData.files.add(MapEntry(
//           'photo_$index',
//           await MultipartFile.fromFile(file.path, filename: _fileNameOf(file)),
//         ));
//       }

//       final response = await _dio.post(
//         "furniture/report",
//         data: formData,
//       );

//       return response.statusCode == 200 || response.statusCode == 201;
//     } on DioException catch (e) {
//       throw Exception(e.response?.data?["message"] ?? "ส่งรายงานไม่สำเร็จ");
//     } catch (e) {
//       throw Exception("เกิดข้อผิดพลาด: $e");
//     }
//   }

//   @override
//   Future<bool> createRepairReport({
//     required String roomNo,
//     required String issueType,
//     required String description,
//     required List<File> imageFiles,
//   }) async {
//     try {
//       final formData = FormData.fromMap({
//         'roomNo': roomNo,
//         'issueType': issueType,
//         'description': description,
//         'priority': 'medium',
//       });

//       // ✅ ต้องซ้ำชื่อฟิลด์ "images" ทุกไฟล์ ให้ตรงกับ
//       // uploadImage.array("images", 5) ฝั่ง backend (เหมือนที่แม่บ้านใช้)
//       for (final file in imageFiles) {
//         formData.files.add(MapEntry(
//           'images',
//           await MultipartFile.fromFile(file.path, filename: _fileNameOf(file)),
//         ));
//       }

//       final response = await _dio.post('housekeeper/issues', data: formData);
//       return response.statusCode == 201 || response.statusCode == 200;
//     } on DioException catch (e) {
//       throw Exception(
//         e.response?.data?['message'] ?? 'ไม่สามารถส่งรายงานแจ้งซ่อมได้',
//       );
//     } catch (e) {
//       throw Exception('เกิดข้อผิดพลาด: $e');
//     }
//   }
// }