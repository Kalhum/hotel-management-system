import 'dart:io';

import 'package:hotel_management_system/data/data_source/remote_data_source/furniture_remote.dart';
import 'package:hotel_management_system/data/model/furniture_model.dart';

abstract class FurnitureRepositorise {
  Future<List<FurnitureModel>> getFurnitureData(
    String roomID,
    String bookingId,
  );

  Future<bool> submitReport(
    List<FurnitureModel> submitData,
    Map<String, File> photosByField,
  );

  Future<bool> confirmUserCondition(String bookingId);
}

class FurnitureRepositoriseImpl implements FurnitureRepositorise {
  final furnitureRemoteDataSource remoteDataSource;

  FurnitureRepositoriseImpl(this.remoteDataSource);

  @override
  Future<List<FurnitureModel>> getFurnitureData(
    String roomID,
    String bookingId,
  ) async {
    try {
      final furnitureData = await remoteDataSource.getFurnitureData(
        roomID,
        bookingId,
      );

      return furnitureData
          .map((json) => FurnitureModel.fromJson(json))
          .toList();
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Future<bool> submitReport(
    List<FurnitureModel> submitData,
    Map<String, File> photosByField,
  ) async {
    try {
      return await remoteDataSource.userFurnitureReport(
        submitData,
        photosByField,
      );
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }

  @override
  Future<bool> confirmUserCondition(String bookingId) async {
    try {
      return await remoteDataSource.confirmUserCondition(bookingId);
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }
}



// import 'dart:io';
// import 'package:hotel_management_system/data/data_source/remote_data_source/furniture_remote.dart';
// import 'package:hotel_management_system/data/model/furniture_model.dart';

// abstract class FurnitureRepositorise {
//   Future<List<FurnitureModel>> getFurnitureData(String roomID, String bookingId);

//   Future<bool> submitReport(
//     List<FurnitureModel> submitData,
//     Map<int, File> photosByIndex,
//   );

//   // ✅ เพิ่มใหม่: แจ้งชำรุดฝั่ง user (ยิง endpoint เดียวกับแม่บ้าน)
//   Future<bool> createRepairReport({
//     required String roomNo,
//     required String issueType,
//     required String description,
//     required List<File> imageFiles,
//   });
// }

// class FurnitureRepositoriseImpl implements FurnitureRepositorise {
//   final furnitureRemoteDataSource remoteDataSource;
//   FurnitureRepositoriseImpl(this.remoteDataSource);

//   @override
//   Future<List<FurnitureModel>> getFurnitureData(
//       String roomID, String bookingId) async {
//     try {
//       final furnitureData =
//           await remoteDataSource.getFurnitureData(roomID, bookingId);
//       return furnitureData
//           .map((json) => FurnitureModel.fromJson(json))
//           .toList();
//     } on SocketException {
//       throw Exception("ไม่มีการเชื่อมต่ออินเตอร์เน็ต");
//     } on HttpException {
//       throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
//     } catch (e) {
//       throw Exception("เกิดข้อผิดพลาด: $e");
//     }
//   }

//   @override
//   Future<bool> submitReport(
//     List<FurnitureModel> submitData,
//     Map<int, File> photosByIndex,
//   ) async {
//     try {
//       return await remoteDataSource.userFurnitureReport(
//         submitData,
//         photosByIndex,
//       );
//     } on SocketException {
//       throw Exception("ไม่มีการเชื่อมต่อ internet");
//     } on HttpException {
//       throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
//     } catch (e) {
//       throw Exception("เกิดข้อผิดพลาด $e");
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
//       return await remoteDataSource.createRepairReport(
//         roomNo: roomNo,
//         issueType: issueType,
//         description: description,
//         imageFiles: imageFiles,
//       );
//     } on SocketException {
//       throw Exception("ไม่มีการเชื่อมต่อ internet");
//     } on HttpException {
//       throw Exception("ไม่สามารถเชื่อมต่อ server ได้");
//     } catch (e) {
//       throw Exception("เกิดข้อผิดพลาด $e");
//     }
//   }
// }