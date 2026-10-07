// login_screen_provider.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';

import '../../../../domain/entitise/login_entitise.dart';
import '../../../../domain/use_case/login_usecase.dart';
import '../../../../util/widget/core/storage/secure_storage_service.dart';

enum LoginStatus { initial, loading, success, error }

class LoginScreenProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginScreenProvider(this.userProvider, this.loginUseCase);

  // --- State ---
  LoginStatus _status = LoginStatus.initial;
  String _errorMessage = '';
  final UserProvider userProvider;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  // --- Getter ---

  LoginStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _status == LoginStatus.loading;

  // --- Functions ---
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _errorMessage = "กรุณากรอกข้อมูล";
      _status = LoginStatus.error;
      notifyListeners();
      return;
    }

    _status = LoginStatus.loading;
    notifyListeners();

    try {
      final result = await loginUseCase.login(
        LoginEntities(
          email: usernameController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );

      if (result.success == true) {
        // เก็บ Token
        if (result.token != null && result.token!.isNotEmpty) {
          await SecureStorageService.instance.saveToken(
            result.token!,
          );
        }

        // เก็บ User
        if (result.user != null) {
          userProvider.setUser(
            result.user!,
          );
        }

        _status = LoginStatus.success;
      } else {
        _errorMessage = result.message ?? "Login Failed";

        _status = LoginStatus.error;
      }
    } catch (e) {
      _errorMessage = e.toString();

      _status = LoginStatus.error;
    }

    notifyListeners();
  }

  /// เช็คสถานะ login แล้วจัดการผลลัพธ์
  /// onSucess คือ dialog ที่แต่ละแพลตฟอร์ม (mobile/desktop) กำหนดเอง
  void handleLoginResult(BuildContext context, VoidCallback onSuccess) {
    if (_status == LoginStatus.success) {
      onSuccess();
      resetStatus();
    } else if (_status == LoginStatus.error) {
      if (!context.mounted) return; // กัน context ตายหลัง async
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage), backgroundColor: Colors.red),
      );
      resetStatus();
    }
  }

  void loginWithGoogle() async {
    // TODO: เชื่อม Google Auth
  }

  void loginWithFacebook() async {
    // TODO: เชื่อม Facebook Auth
  }

  void resetStatus() {
    _status = LoginStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
