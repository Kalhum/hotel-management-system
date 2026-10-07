import 'dart:io';

import 'package:hotel_management_system/data/repositorise/furniture_repositorise.dart';
import 'package:hotel_management_system/data/model/furniture_model.dart';
import 'package:hotel_management_system/domain/entitise/furniture_entitise.dart';

class FurnitureUsecase {
  final FurnitureRepositoriseImpl repository;

  FurnitureUsecase(this.repository);


  // GET FURNITURE

  Future<List<FurnitureEntitise>> getFurnitureData(
    String roomID,
    String bookingId,
  ) async {
    try {
      final modelData = await repository.getFurnitureData(roomID, bookingId);

      return modelData.map((item) {
        return FurnitureEntitise(
          id: item.id,
          roomID: roomID,
          bookingId: bookingId,
          title: item.title,
          image: item.image,
          isCustom: item.isCustom ?? false,

          // สถานะล่าสุดของแม่บ้านเป็น baseline ก่อน user ยืนยัน
          status: item.housekeeperStatus ?? "ยังไม่ได้ตรวจสอบ",

          // Note ของแม่บ้าน
          note: item.housekeeperNote,

          // รูปความเสียหายของ user รอบนี้
          damageImage: null,

          // รูปที่แม่บ้านตรวจล่าสุด
          housekeeperInspectionImage: item.housekeeperInspectionImage,
        );
      }).toList();
    } on SocketException {
      throw Exception("ไม่มีการเชื่อมต่อ internet");
    } on HttpException {
      throw Exception("ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้");
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด $e");
    }
  }

  Future<bool> submitReport(
    List<FurnitureEntitise> reportData,
    String bookingId,
    Map<String, File> photosByField,
  ) async {
    try {
      final reportModels = reportData.map((e) {
        return FurnitureModel(
          id: e.id,
          roomId: e.roomID,
          bookingId: bookingId,
          title: e.title,
          image: e.image,
          isCustom: e.isCustom,
          inspections: [
            Inspection(
              status: e.status,
              note: e.note,
              damageImage: e.damageImage,
              inspectedAt: DateTime.now(),
            ),
          ],
        );
      }).toList();

      return await repository.submitReport(
        reportModels,
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

  Future<bool> confirmUserCondition(String bookingId) {
    return repository.confirmUserCondition(bookingId);
  }
}
