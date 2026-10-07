import 'dart:io';

import '../../data/repositorise/houseKeeper_repositorise.dart';
import '../entitise/housekeeper_room_entity.dart';

class HousekeeperRoomUseCase {
  final HousekeeperRoomRepository repository;

  HousekeeperRoomUseCase({required this.repository});

  Future<List<HousekeeperRoomEntity>> getRooms() async {
    return await repository.getRooms();
  }

  Future<List<Map<String, dynamic>>> getRoomFurniture(String roomNo) {
    return repository.getRoomFurniture(roomNo);
  }

  Future<bool> submitFurnitureReport(
    String roomNo,
    List<Map<String, dynamic>> items,
    Map<int, File> photosByIndex,
  ) {
    return repository.submitFurnitureReport(roomNo, items, photosByIndex);
  }

  Future<bool> createIssue({
    required String roomNo,
    required String issueType,
    required String description,
    required List<File> imageFiles,
    String priority = 'medium',
  }) async {
    try {
      return await repository.createIssue(
        roomNo: roomNo,
        issueType: issueType,
        description: description,
        imageFiles: imageFiles,
        priority: priority,
      );
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }

  Future<bool> saveRoomDetail({
    required String roomNo,
    required String cleaningStatus,
  }) async {
    try {
      return await repository.saveRoomDetail(
        roomNo: roomNo,
        cleaningStatus: cleaningStatus,
      );
    } catch (e) {
      throw Exception("UseCase error: $e");
    }
  }
}
