class HousekeeperRoomEntity {
  String roomNo;
  // ✅ เพิ่มใหม่: field นี้ขาดหายไปจากเดิม ทั้งที่
  // housekeeper_room_check_screen.dart เรียกใช้ room.building เพื่อจัดกลุ่ม
  // ห้องตามตึกอยู่แล้ว (_groupByBuilding) ถ้าไม่มี field นี้ โค้ดจะคอมไพล์
  // ไม่ผ่านทันที
  String building;
  String status;
  bool hasGuest;

  HousekeeperRoomEntity({
    this.roomNo = '',
    this.building = '1',
    this.status = '',
    this.hasGuest = false,
  });
}
