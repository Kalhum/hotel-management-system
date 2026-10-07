import '../data_source/remote_data_source/home_remote.dart';
import '../model/home_model.dart';

abstract class HomeRepository {
  Future<List<HomeModel>> getRooms();
  Future<List<HomeModel>> getAvailableRooms({
    required String checkIn,
    required String checkOut,
    String? roomType,
  });
  Future<HomeModel> getRoomById(
      String roomId); // เพิ่ม: ให้ interface ครบ (เผื่อยังไม่มี)
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HomeModel>> getRooms() async {
    final rawList = await remoteDataSource.getRooms(); // ได้ raw List<dynamic>
    return rawList
        .whereType<Map>()
        .map((item) => HomeModel.fromJson(Map<String, dynamic>.from(item)))
        .toList(); // แก้: แปลงเป็น Model ตรงนี้แทน
  }

  @override
  Future<List<HomeModel>> getAvailableRooms({
    required String checkIn,
    required String checkOut,
    String? roomType,
  }) async {
    final rawList = await remoteDataSource.getAvailableRooms(
      checkIn: checkIn,
      checkOut: checkOut,
      roomType: roomType,
    );
    return rawList
        .whereType<Map>()
        .map((item) => HomeModel.fromJson(Map<String, dynamic>.from(item)))
        .toList(); // แก้: แปลงเป็น Model ตรงนี้แทน
  }

  @override
  Future<HomeModel> getRoomById(String roomId) async {
    final rawMap = await remoteDataSource.getRoomById(roomId);
    return HomeModel.fromJson(rawMap); // แก้: แปลงเป็น Model ตรงนี้แทน
  }
}
