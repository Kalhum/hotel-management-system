import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_management_system/domain/entitise/check_in_entitise.dart';
import 'package:hotel_management_system/domain/entitise/promotion_entitise.dart';
import 'package:hotel_management_system/domain/use_case/check_in_usecase.dart';
import 'package:hotel_management_system/domain/use_case/payment_usecase.dart';
import 'package:hotel_management_system/domain/use_case/promotion_usecase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../domain/entitise/user_profile_entity.dart';

enum CheckInStatus { initial, loading, success, error }

enum SaveQRStatus { initial, success, error }

enum CouponLoadStatus { initial, loading, loaded, error }

enum QrPayloadStatus { initial, loading, loaded, error }

class CheckInScreenProvider extends ChangeNotifier {
  final CheckInUsecase usecase;
  final PromotionUsecase promotionUsecase;
  final PaymentUsecase paymentUsecase;
  CheckInScreenProvider(
      this.usecase, this.promotionUsecase, this.paymentUsecase);

  // --- QR payload (สร้างโดย backend เท่านั้น) ---
  String? _qrPayload;
  QrPayloadStatus _qrPayloadStatus = QrPayloadStatus.initial;
  String _qrPayloadError = '';

  String? get qrPayload => _qrPayload;
  QrPayloadStatus get qrPayloadStatus => _qrPayloadStatus;
  String get qrPayloadError => _qrPayloadError;

  String? _bookingId;

  /// ยอด QR คำนวณโดย backend เองจาก bookingId + คูปองที่เลือก (กัน client ปลอมยอด)
  Future<void> loadQrPayload() async {
    final bookingId = _bookingId;
    if (bookingId == null) return;
    _qrPayloadStatus = QrPayloadStatus.loading;
    notifyListeners();
    try {
      _qrPayload = await paymentUsecase.getCheckinQrPayload(
        bookingId,
        userPromotionId: _selectedCoupon?.userPromotionId,
      );
      _qrPayloadStatus = QrPayloadStatus.loaded;
    } catch (e) {
      _qrPayloadError = 'ไม่สามารถสร้าง QR code ได้';
      _qrPayloadStatus = QrPayloadStatus.error;
    }
    notifyListeners();
  }

  // --- State
  CheckInStatus _status = CheckInStatus.initial;
  String _errorMessage = '';
  String _gender = "ชาย";
  File? _idCardImage;
  File? _paymentSlipImage;

  SaveQRStatus _saveQRStatus = SaveQRStatus.initial;
  String _saveQRErrorMessage = '';

  final TextEditingController idCardNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final SignatureController sigController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  // --- Coupon & Price State ---
  double _totalPrice = 0;
  double _depositAmount = 0;

  CouponLoadStatus _couponLoadStatus = CouponLoadStatus.initial;
  String _couponLoadError = '';
  List<UserCouponEntitise> _coupons = [];
  UserCouponEntitise? _selectedCoupon; // null = ไม่ใช้คูปอง

  CouponLoadStatus get couponLoadStatus => _couponLoadStatus;
  String get couponLoadError => _couponLoadError;
  double get totalPrice => _totalPrice;
  double get depositAmount => _depositAmount;
  List<UserCouponEntitise> get coupons => _coupons;
  UserCouponEntitise? get selectedCoupon => _selectedCoupon;

  /// baseAmount สำหรับคำนวณส่วนลด = ยอดคงเหลือหลังหักมัดจำ
  /// (ตรงกับ backend ที่ใช้ booking.remaining_amount เป็น baseAmount)
  double get _baseAmountForDiscount {
    final base = _totalPrice - _depositAmount;
    return base < 0 ? 0 : base;
  }

  double get discountAmount {
    if (_selectedCoupon == null) return 0;
    return _selectedCoupon!.calculateDiscount(_baseAmountForDiscount);
  }

  double get amountDue {
    final result = _totalPrice - _depositAmount - discountAmount;
    return result < 0 ? 0 : result;
  }

  void setPricing({
    required double totalPrice,
    required double depositAmount,
    String? bookingId,
  }) {
    _totalPrice = totalPrice;
    _depositAmount = depositAmount;
    if (bookingId != null) _bookingId = bookingId;
    notifyListeners();
    loadQrPayload();
  }

  void prefillProfile(UserProfileEntity profile) {
    fullNameController.text = profile.name ?? '';
    addressController.text = profile.address ?? '';
    notifyListeners();
  }

  /// เรียกตอนเปิดหน้า check-in เพื่อโหลดคูปองจริงของ user คนนี้
  Future<void> loadCoupons() async {
    _couponLoadStatus = CouponLoadStatus.loading;
    notifyListeners();
    try {
      _coupons = await promotionUsecase.getMyCoupons();

      // ถ้าคูปองที่เคยเลือกไว้กลายเป็นใช้ไม่ได้ (หมดอายุ/ใช้แล้ว) เคลียร์ทิ้ง
      if (_selectedCoupon != null &&
          !_selectedCoupon!.isUsable(_baseAmountForDiscount)) {
        _selectedCoupon = null;
      }

      _couponLoadStatus = CouponLoadStatus.loaded;
      notifyListeners();
    } catch (e) {
      _couponLoadError = 'ไม่สามารถโหลดคูปองได้';
      _couponLoadStatus = CouponLoadStatus.error;
      notifyListeners();
    }
  }

  // --- Getter เดิม (ไม่แก้) ---
  CheckInStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get gender => _gender;
  File? get idCardImage => _idCardImage;
  File? get paymentSlipImage => _paymentSlipImage;
  bool get isLoading => _status == CheckInStatus.loading;

  SaveQRStatus get saveQRStatus => _saveQRStatus;
  String get saveQRErrorMessage => _saveQRErrorMessage;

  // --- Functions เดิม (ไม่แก้) ---
  void setGender(String value) {
    _gender = value;
    notifyListeners();
  }

  Future<void> takeIdCardPhoto(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('ถ่ายรูป'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('เลือกจากคลังรูปภาพ'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status.isPermanentlyDenied) openAppSettings();
      if (!status.isGranted) return;
    }

    final XFile? photo =
        await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (photo != null) {
      _idCardImage = File(photo.path);
      notifyListeners();
    }
  }

  Future<void> pickSlipImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      _paymentSlipImage = File(image.path);
      notifyListeners();
    }
  }

  void clearSignature() {
    sigController.clear();
    notifyListeners();
  }

  String? _validateForm() {
    if (idCardNumberController.text.trim().isEmpty) {
      return 'กรุณากรอกเลขบัตรประชาชน';
    }
    if (fullNameController.text.trim().isEmpty) {
      return 'กรุณากรอกชื่อ-นามสกุล';
    }
    if (addressController.text.trim().isEmpty) {
      return 'กรุณากรอกที่อยู่';
    }
    if (sigController.isEmpty) {
      return 'กรุณาเซ็นลายเซ็นยืนยัน';
    }
    if (_paymentSlipImage == null) {
      return 'กรุณาแนบหลักฐานการโอนเงิน';
    }
    return null;
  }

  Future<void> submitCheckIn(String bookingId) async {
    final validationError = _validateForm();
    if (validationError != null) {
      _errorMessage = validationError;
      _status = CheckInStatus.error;
      notifyListeners();
      return;
    }

    _status = CheckInStatus.loading;
    notifyListeners();

    try {
      final signatureBytes = await sigController.toPngBytes();
      final String? signatureBase64 =
          signatureBytes != null ? base64Encode(signatureBytes) : null;

      final checkInData = CheckInEntitise(
        bookingId: bookingId,
        idCardNumber: idCardNumberController.text.trim(),
        fullName: fullNameController.text.trim(),
        gender: _gender,
        address: addressController.text.trim(),
        idCardImage: _idCardImage?.path ?? '',
        paymentSlipImage: _paymentSlipImage?.path ?? '',
        signatureImage: signatureBase64,
        userPromotionId: _selectedCoupon?.userPromotionId,
      );

      await usecase.getCheckInData(checkInData);

      _status = CheckInStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';
      _status = CheckInStatus.error;
      notifyListeners();
    }
  }

  Future<void> saveQRCode(double amount) async {
    try {
      final payload = _qrPayload;
      if (payload == null) throw Exception('ยังไม่มี QR code ให้บันทึก');
      final painter = QrPainter(
        data: payload,
        version: QrVersions.auto,
        gapless: true,
      );
      final byteData = await painter.toImageData(1024);
      if (byteData == null) throw Exception('สร้าง QR code ไม่สำเร็จ');
      final Uint8List bytes = byteData.buffer.asUint8List();
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: "Hotel_QR_Payment_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess']) {
        _saveQRStatus = SaveQRStatus.success;
      } else {
        throw Exception("Save failed");
      }
    } catch (e) {
      _saveQRErrorMessage = "เกิดข้อผิดพลาด: $e";
      _saveQRStatus = SaveQRStatus.error;
    }
    notifyListeners();
  }

  void resetSaveQRStatus() {
    _saveQRStatus = SaveQRStatus.initial;
    _saveQRErrorMessage = '';
  }

  void resetStatus() {
    _status = CheckInStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }

  // เพิ่ม getter สำหรับให้ screen เรียกดูเหตุผลว่าคูปองแต่ละใบใช้ได้ไหม
  String? couponUnavailableReason(UserCouponEntitise coupon) =>
      coupon.unavailableReason(_baseAmountForDiscount);

  /// เลือกคูปอง — ส่ง null เพื่อ "ไม่ใช้คูปอง"
  void selectCoupon(int? userPromotionId) {
    if (userPromotionId == null) {
      _selectedCoupon = null;
      notifyListeners();
      loadQrPayload();
      return;
    }

    final coupon = _coupons.firstWhere(
      (c) => c.userPromotionId == userPromotionId,
      orElse: () => _coupons.first,
    );

    // กันเลือกคูปองที่ใช้ไม่ได้ (หมดอายุ/ใช้แล้ว/ยอดไม่ถึงขั้นต่ำ)
    // แม้ UI จะ disable ปุ่มไว้แล้ว เผื่อมีทางอื่นเรียก selectCoupon เข้ามา
    if (!coupon.isUsable(_baseAmountForDiscount)) {
      return;
    }

    _selectedCoupon = coupon;
    notifyListeners();
    loadQrPayload();
  }

  @override
  void dispose() {
    idCardNumberController.dispose();
    fullNameController.dispose();
    addressController.dispose();
    sigController.dispose();
    super.dispose();
  }
}
