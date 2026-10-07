import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_management_system/domain/entitise/booking_form_entitise.dart';
import 'package:hotel_management_system/domain/entitise/cart_item_entitise.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotel_management_system/domain/use_case/booking_form_usecase.dart';
import 'package:hotel_management_system/domain/use_case/payment_usecase.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../data/model/login_model.dart';

enum BookingFormStatus { initial, loading, success, error }

enum SaveQRStatus { initial, success, error }

enum QrPayloadStatus { initial, loading, loaded, error }

class BookingFormScreenProvider extends ChangeNotifier {
  final BookingFormUsecase bookingFormUseCase;
  final PaymentUsecase paymentUsecase;
  BookingFormScreenProvider(this.bookingFormUseCase, this.paymentUsecase);

  // --- QR payload (สร้างโดย backend เท่านั้น) ---
  String? _qrPayload;
  QrPayloadStatus _qrPayloadStatus = QrPayloadStatus.initial;
  String _qrPayloadError = '';

  String? get qrPayload => _qrPayload;
  QrPayloadStatus get qrPayloadStatus => _qrPayloadStatus;
  String get qrPayloadError => _qrPayloadError;

  Future<void> loadQrPayload(List<CartItemEntitise> items) async {
    _qrPayloadStatus = QrPayloadStatus.loading;
    notifyListeners();
    try {
      _qrPayload = await paymentUsecase.getBookingCartQrPayload(items);
      _qrPayloadStatus = QrPayloadStatus.loaded;
    } catch (e) {
      _qrPayloadError = 'ไม่สามารถสร้าง QR code ได้';
      _qrPayloadStatus = QrPayloadStatus.error;
    }
    notifyListeners();
  }

  // --- State ---
  BookingFormStatus _status = BookingFormStatus.initial;
  String _errorMessage = '';
  File? _paymentSlipImage;

  SaveQRStatus _saveQRStatus = SaveQRStatus.initial;
  String _saveQRErrorMessage = '';

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void prefillUserInfo(User? user) {
    if (user != null && fullNameController.text.isEmpty) {
      fullNameController.text = user.name ?? '';

      if (emailController.text.isEmpty) {
        emailController.text = user.email ?? '';
      }
    }
  }

  // --- Getter ---
  BookingFormStatus get status => _status;
  String get errorMessage => _errorMessage;
  File? get paymentSlipImage => _paymentSlipImage;
  bool get isLoading => _status == BookingFormStatus.loading;

  SaveQRStatus get saveQRStatus => _saveQRStatus;
  String get saveQRErrorMessage => _saveQRErrorMessage;

  // --- Functions ---
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

  /// ส่งข้อมูลการจองของทุกห้องในตะกร้าเป็น order เดียว
  Future<void> submitBooking({required List<CartItemEntitise> items}) async {
    if (items.isEmpty) {
      _errorMessage = 'ไม่พบห้องพักในตะกร้า';
      _status = BookingFormStatus.error;
      notifyListeners();
      return;
    }

    _status = BookingFormStatus.loading;
    notifyListeners();
    try {
      final bookingFormData = BookingFormEntitise(
        fullName: fullNameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text,
        address: "",
        paymentSlip: _paymentSlipImage?.path ?? "",
        items: items,
      );

      final result = await bookingFormUseCase.bookingForm(bookingFormData);
      if (result) {
        _status = BookingFormStatus.success;
      } else {
        _errorMessage = 'กรุณากรอกข้อมูลให้ครบถ้วน';
        _status = BookingFormStatus.error;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';
      _status = BookingFormStatus.error;
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
    _status = BookingFormStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
