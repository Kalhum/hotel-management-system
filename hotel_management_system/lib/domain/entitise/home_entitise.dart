// Entity ของ Room หน้า home page
class HomeEntitise {
  final String roomId;
  final String roomType;
  final String name;
  final String description;
  final double pricePerNight;
  final String building;
  final String bedType;
  final int capacity;
  final List<String> imageUrls;
  final int bedCount;

  HomeEntitise({
    required this.roomId,
    required this.roomType,
    this.name = '',
    required this.description,
    required this.pricePerNight,
    this.building = '1',
    this.bedType = 'เตียงเดี่ยว',
    this.capacity = 2,
    required this.imageUrls,
    this.bedCount = 1,
  });
}

class RoomTypeEntitise {}
