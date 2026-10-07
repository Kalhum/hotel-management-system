class BookingListEntity {
  final String bookingId;
  final String userId;
  final String customerName;
  final String roomId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int roomsCount;
  final int personCount;
  final double amount;
  final double remainingAmount;
  final String phone;
  final String email;
  final String? bankAccount;
  final String address;
  final String status;
  final String paymentStatus;
  final String? slipUrl;
  final String checkInStatus;
  final String checkOutStatus;
  final String inspectionStatus;
  final String?
      checkinStatus; // เพิ่ม: nullable เพราะอาจยังไม่เคย submit checkin เลย
  final String? roomKey;
  final DateTime? createdAt;
  final String? cancelReason;
  final String? cancelledBy;
  final DateTime? cancelledAt;
  final bool doNotDisturb;

  BookingListEntity({
    required this.bookingId,
    required this.userId,
    required this.customerName,
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
    required this.roomsCount,
    required this.personCount,
    required this.amount,
    required this.remainingAmount,
    required this.phone,
    required this.email,
    required this.bankAccount,
    required this.address,
    required this.status,
    required this.paymentStatus,
    required this.slipUrl,
    required this.checkInStatus,
    required this.checkOutStatus,
    required this.inspectionStatus,
    this.checkinStatus, // เพิ่ม (optional เพราะ nullable)
    required this.roomKey,
    required this.createdAt,
    this.cancelReason,
    this.cancelledBy,
    this.cancelledAt,
    this.doNotDisturb = false,
  });
}
