import 'dart:io';

import '../../domain/entitise/housekeeper_room_entity.dart';
import '../data_source/remote_data_source/houseKeeper_remote.dart';

abstract class HousekeeperRoomRepository {
  Future<List<HousekeeperRoomEntity>> getRooms();
  Future<List<Map<String, dynamic>>> getRoomFurniture(String roomNo);

  Future<bool> submitFurnitureReport(
    String roomNo,
    List<Map<String, dynamic>> items,
    Map<int, File> photosByIndex,
  );

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

class HousekeeperRoomRepositoryImpl implements HousekeeperRoomRepository {
  final HousekeeperRoomRemoteDataSource remoteDataSource;

  HousekeeperRoomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HousekeeperRoomEntity>> getRooms() async {
    try {
      final models = await remoteDataSource.getRooms();
      return models
          .map((m) => HousekeeperRoomEntity(
                roomNo: m.roomNo,
                building: m.building,
                status: m.cleaningStatus,
                hasGuest: m.hasGuest,
              ))
          .toList();
    } catch (e) {
      throw Exception("Repository error: $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRoomFurniture(String roomNo) async {
    try {
      final models = await remoteDataSource.getRoomFurniture(roomNo);
      return models
          .map((m) => {
                'id': m.id,
                'title': m.title,
                'image': m.image,
                'isCustom': m.isCustom,
                'lastStatus': m.lastStatus,
                'lastNote': m.lastNote,
                // ✅ ตอนนี้เป็น URL เต็มแล้ว (backend แปลงให้ก่อนส่งออก)
                // ใช้ทั้งโชว์รูปเดิม และส่งกลับไปเป็น fallback ตอน submit
                // รอบถัดไปถ้ายังไม่ได้ถ่ายรูปใหม่
                'lastDamageImage': m.lastDamageImage,
              })
          .toList();
    } catch (e) {
      throw Exception("Repository error: $e");
    }
  }

  @override
  Future<bool> submitFurnitureReport(
    String roomNo,
    List<Map<String, dynamic>> items,
    Map<int, File> photosByIndex,
  ) async {
    try {
      return await remoteDataSource.submitFurnitureReport(
        roomNo,
        items,
        photosByIndex,
      );
    } catch (e) {
      throw Exception("Repository error: $e");
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
      return await remoteDataSource.createIssue(
        roomNo: roomNo,
        issueType: issueType,
        description: description,
        imageFiles: imageFiles,
        priority: priority,
      );
    } catch (e) {
      throw Exception("Repository error: $e");
    }
  }

  @override
  Future<bool> saveRoomDetail({
    required String roomNo,
    required String cleaningStatus,
  }) async {
    try {
      return await remoteDataSource.saveRoomDetail(
        roomNo: roomNo,
        cleaningStatus: cleaningStatus,
      );
    } catch (e) {
      throw Exception("Repository error: $e");
    }
  }
}
