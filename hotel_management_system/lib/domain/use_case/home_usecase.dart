import 'package:hotel_management_system/data/model/home_model.dart';
import 'package:hotel_management_system/data/repositorise/home_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/home_entitise.dart';

import '../../util/function/image_url.dart';

class HomeUsecase {
  final HomeRepositoryImpl repository;
  HomeUsecase(this.repository);

  HomeEntitise _toEntity(HomeModel item) {
    final fullImageUrls = ImageUrlHelper.toFullImageUrlList(item.imageUrls);

    return HomeEntitise(
      roomId: item.roomId ?? '',
      roomType: item.roomType ?? "",
      name: item.name ?? "",
      description: item.description ?? "",
      pricePerNight: double.tryParse(item.pricePerNight ?? '') ?? 0.0,
      building: item.building ?? '1',
      bedType: item.bedType ?? 'เตียงเดี่ยว',
      capacity: item.capacity ?? 2,
      imageUrls: fullImageUrls,
      bedCount: 1,
    );
  }

  Future<List<HomeEntitise>> getRooms() async {
    try {
      final model = await repository.getRooms();
      return model.map(_toEntity).toList();
    } catch (e) {
      throw Exception("error home usecase: $e");
    }
  }

  Future<List<HomeEntitise>> getAvailableRooms({
    required String checkIn,
    required String checkOut,
    String? roomType,
  }) async {
    try {
      final model = await repository.getAvailableRooms(
        checkIn: checkIn,
        checkOut: checkOut,
        roomType: roomType,
      );
      return model.map(_toEntity).toList();
    } catch (e) {
      throw Exception("error home usecase (available rooms): $e");
    }
  }
}
