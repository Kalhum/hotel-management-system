class ListModel {
  String? id;
  String? userId;
  String? customerName;
  String? roomId;
  DateTime? checkIn;
  DateTime? checkOut;
  int? roomsCount;
  int? personCount;
  String? amount;
  String? remainingAmount;
  String? phone;
  String? email;
  dynamic bankAccount;
  String? address;
  String? status;
  String? paymentStatus;
  String? slipUrl;
  String? checkInStatus;
  String? checkOutStatus;
  String? inspectionStatus;
  String?
      checkinStatus; // เพิ่ม: มาจาก c.status AS checkin_status ที่ backend JOIN มา
  dynamic roomKey;
  DateTime? createdAt;
  dynamic updatedAt;
  String? cancelReason;
  String? cancelledBy;
  DateTime? cancelledAt;
  bool doNotDisturb;

  ListModel({
    this.id,
    this.userId,
    this.customerName,
    this.roomId,
    this.checkIn,
    this.checkOut,
    this.roomsCount,
    this.personCount,
    this.amount,
    this.remainingAmount,
    this.phone,
    this.email,
    this.bankAccount,
    this.address,
    this.status,
    this.paymentStatus,
    this.slipUrl,
    this.checkInStatus,
    this.checkOutStatus,
    this.inspectionStatus,
    this.checkinStatus, // เพิ่ม
    this.roomKey,
    this.createdAt,
    this.updatedAt,
    this.cancelReason,
    this.cancelledBy,
    this.cancelledAt,
    this.doNotDisturb = false,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) => ListModel(
        id: json["id"],
        userId: json["user_id"],
        customerName: json["customer_name"],
        roomId: json["room_id"],
        checkIn: json["check_in"] == null
            ? null
            : DateTime.parse(json["check_in"]).toLocal(),
        checkOut: json["check_out"] == null
            ? null
            : DateTime.parse(json["check_out"]).toLocal(),
        roomsCount: json["rooms_count"],
        personCount: json["person_count"],
        amount: json["amount"],
        remainingAmount: json["remaining_amount"],
        phone: json["phone"],
        email: json["email"],
        bankAccount: json["bank_account"],
        address: json["address"],
        status: json["status"],
        paymentStatus: json["payment_status"],
        slipUrl: json["slip_url"],
        checkInStatus: json["check_in_status"],
        checkOutStatus: json["check_out_status"],
        inspectionStatus: json["inspection_status"],
        checkinStatus:
            json["checkin_status"], // เพิ่ม: ตรงกับ alias จาก backend
        roomKey: json["room_key"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: json["updated_at"],
        cancelReason: json["cancel_reason"],
        cancelledBy: json["cancelled_by"],
        cancelledAt: json["cancelled_at"] == null
            ? null
            : DateTime.tryParse(json["cancelled_at"].toString()),
        doNotDisturb: json["do_not_disturb"] == true ||
            json["do_not_disturb"] == 1 ||
            json["do_not_disturb"] == "1",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "customer_name": customerName,
        "room_id": roomId,
        "check_in": checkIn?.toIso8601String(),
        "check_out": checkOut?.toIso8601String(),
        "rooms_count": roomsCount,
        "person_count": personCount,
        "amount": amount,
        "remaining_amount": remainingAmount,
        "phone": phone,
        "email": email,
        "bank_account": bankAccount,
        "address": address,
        "status": status,
        "payment_status": paymentStatus,
        "slip_url": slipUrl,
        "check_in_status": checkInStatus,
        "check_out_status": checkOutStatus,
        "inspection_status": inspectionStatus,
        "checkin_status": checkinStatus, // เพิ่ม
        "room_key": roomKey,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
        "cancel_reason": cancelReason,
        "cancelled_by": cancelledBy,
        "cancelled_at": cancelledAt?.toIso8601String(),
        "do_not_disturb": doNotDisturb,
      };
}
