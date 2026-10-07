// housekeeper_model.dart
// โมเดลสำหรับแปลง JSON จาก backend ให้เป็น object ที่มี type ชัดเจน
// แทนการงมกับ Map<String, dynamic> ตรงๆ ใน remote data source

/// ตรงกับ response ของ GET /housekeeper (houskeeper_service.js -> getHousekeeperData)
class HousekeeperRoomModel {
  final String roomNo;
  final String building;
  final String cleaningStatus;
  final bool hasGuest;
  final String? roomType;
  final String? roomName;
  final String? description;
  final num? price;

  HousekeeperRoomModel({
    required this.roomNo,
    required this.building,
    required this.cleaningStatus,
    this.hasGuest = false,
    this.roomType,
    this.roomName,
    this.description,
    this.price,
  });

  factory HousekeeperRoomModel.fromJson(Map<String, dynamic> json) {
    return HousekeeperRoomModel(
      roomNo: (json['roomNo'] ?? '').toString(),
      // backend ส่ง building เป็น string แปลงมาแล้ว (String(row.building || 1))
      building: (json['building'] ?? '1').toString(),
      // backend ส่งมาทั้ง 'status' และ 'cleaningStatus' เป็นค่าเดียวกัน
      // (ดู houskeeper_service.js) กันเหนียวรับได้ทั้งคู่เผื่อ backend เปลี่ยน
      cleaningStatus:
          (json['cleaningStatus'] ?? json['status'] ?? '').toString(),
      hasGuest: json['hasGuest'] == true,
      roomType: json['roomType']?.toString(),
      roomName: json['roomName']?.toString(),
      description: json['description']?.toString(),
      price: json['price'] is num ? json['price'] as num : null,
    );
  }
}

/// ตรงกับ response ของ GET /furniture (furniture_model.js ->
/// getFurnitureByRoomAndBooking) แต่ละชิ้นมีผลตรวจล่าสุด (ถ้ามี) แนบมาด้วย
/// สูงสุด 1 รายการ เพราะฝั่ง backend เลือกแถวล่าสุดที่ตรงเงื่อนไข
/// (booking_id ตรงกัน หรือ booking_id เป็น null + role เป็นแม่บ้าน) ไว้ให้แล้ว
class HousekeeperFurnitureModel {
  final int id;
  final String roomId;
  final String title;
  final dynamic image;
  final bool isCustom;

  final String? lastStatus;
  final String? lastNote;
  final String? lastDamageImage;
  final String? lastInspectedAt;

  HousekeeperFurnitureModel({
    required this.id,
    required this.roomId,
    required this.title,
    required this.image,
    required this.isCustom,
    this.lastStatus,
    this.lastNote,
    this.lastDamageImage,
    this.lastInspectedAt,
  });

  factory HousekeeperFurnitureModel.fromJson(Map<String, dynamic> json) {
    final inspections = json['inspections'];
    Map<String, dynamic>? latest;
    if (inspections is List && inspections.isNotEmpty) {
      latest = Map<String, dynamic>.from(inspections.first as Map);
    }

    return HousekeeperFurnitureModel(
      id: json['id'] as int,
      roomId: (json['roomId'] ?? '').toString(),
      title: (json['title'] ?? 'รายการเฟอร์นิเจอร์').toString(),
      image: json['image'],
      isCustom: json['isCustom'] == true,
      lastStatus: latest?['status']?.toString(),
      lastNote: latest?['note']?.toString(),
      lastDamageImage: latest?['damageImage']?.toString(),
      lastInspectedAt: latest?['inspectedAt']?.toString(),
    );
  }
}
