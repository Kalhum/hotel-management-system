class CheckInEntitise {
  String? bookingId;
  String? idCardNumber;
  String? fullName;
  String? gender;
  String? address;
  String? idCardImage;
  String? signatureImage;
  String? paymentSlipImage;
  String? paymentStatus;
  int? userPromotionId; // เพิ่ม

  CheckInEntitise(
      {this.bookingId,
      this.idCardNumber,
      this.fullName,
      this.gender,
      this.address,
      this.idCardImage,
      this.signatureImage,
      this.paymentSlipImage,
      this.paymentStatus,
      this.userPromotionId}); // เพิ่ม
}