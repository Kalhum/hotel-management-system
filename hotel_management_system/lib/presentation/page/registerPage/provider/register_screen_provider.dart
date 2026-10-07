// register_screen_provider.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/domain/entitise/register_entitise.dart';
import 'package:hotel_management_system/domain/use_case/register_usecase.dart';

enum RegisterStatus { initial, loading, success, error }

class RegisterScreenProvider extends ChangeNotifier {
  final RegisterUsecase usecase;
  // --- State ---
  RegisterStatus _status = RegisterStatus.initial;
  String _errorMessage = '';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  RegisterScreenProvider({required this.usecase});

  // --- Getter ---
  RegisterStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get isLoading => _status == RegisterStatus.loading;

  // --- Functions ---
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  bool _validate() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _errorMessage = 'กรุณากรอกข้อมูลให้ครบ';
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _errorMessage = 'รหัสผ่านไม่ตรงกัน';
      return false;
    }
    return true;
  }

  Future<void> register() async {
    if (!_validate()) {
      _status = RegisterStatus.error;
      notifyListeners();
      return;
    }
    _status = RegisterStatus.loading;
    notifyListeners();
    try {
      await usecase.register(RegisterEntitise(
          username: usernameController.text.trim(),
          email: emailController.text.trim(),
          address: addressController.text.trim(),
          phoneNumber: phoneNumberController.text.trim(),
          password: passwordController.text.trim()));
      _status = RegisterStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'สมัครสมาชิกไม่สำเร็จ กรุณาลองใหม่อีกครั้ง';
      _status = RegisterStatus.error;
      notifyListeners();
    }
  }

  /// เช็คสถานะ register แล้วจัดการผลลัพธ์
  /// [onSuccess] คือ dialog ที่แต่ละแพลตฟอร์ม (mobile/desktop) กำหนดเอง
  void handleRegisterResult(BuildContext context, VoidCallback onSuccess) {
    if (_status == RegisterStatus.success) {
      onSuccess();
      resetStatus();
    } else if (_status == RegisterStatus.error) {
      if (!context.mounted) return; // กัน context ตายหลัง async
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage), backgroundColor: Colors.red),
      );
      resetStatus();
    }
  }

  void resetStatus() {
    _status = RegisterStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
