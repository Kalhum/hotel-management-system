class FurnitureEntitise {
  int? id;
  String? roomID;
  String? bookingId;
  String? title;
  String? image;
  String? status;
  String? note;
  bool? isCustom;

  // รูปความเสียหายของการตรวจครั้งนี้
  String? damageImage;

  // รูปที่แม่บ้านตรวจล่าสุด
  String? housekeeperInspectionImage;

  FurnitureEntitise({
    this.id,
    this.roomID,
    this.bookingId,
    this.title,
    this.image,
    this.status,
    this.note,
    this.isCustom,
    this.damageImage,
    this.housekeeperInspectionImage,
  });
}


// class FurnitureEntitise {
//   int? id;
//   String? roomID;
//   String? bookingId;
//   String? title;
//   String? image;
//   String? status;
//   String? note;
//   bool? isCustom;
//   String? damageImage;

//   FurnitureEntitise({
//     this.id,
//     this.roomID,
//     this.bookingId,
//     this.title,
//     this.image,
//     this.status,
//     this.note,
//     this.isCustom,
//     this.damageImage,
//   });
// }