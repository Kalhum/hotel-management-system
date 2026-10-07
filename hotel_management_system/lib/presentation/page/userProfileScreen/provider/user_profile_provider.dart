// presentation/page/ProfilePage/provider/profile_screen_provider.dart
import 'package:flutter/material.dart';

import '../../../../domain/entitise/user_profile_entity.dart';
import '../../../../domain/use_case/user_profile_usecase.dart';

class ProfileScreenProvider extends ChangeNotifier {
  final UserProfileUseCase userProfileUseCase;

  ProfileScreenProvider(this.userProfileUseCase);

  UserProfileEntity? _profile;
  UserProfileEntity? get profile => _profile;

  bool _isLoading = false;
  bool _isSaving = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String get errorMessage => _errorMessage;

  String _cleanError(dynamic e) =>
      e.toString().replaceAll('Exception: ', '').trim();

  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _profile = await userProfileUseCase.getMyProfile();
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveProfile({
    required String name,
    String? phone,
    String? address,
  }) async {
    if (name.trim().isEmpty) {
      _errorMessage = 'กรุณากรอกชื่อ';
      notifyListeners();
      return false;
    }

    // ป้องกันเบอร์โทรยาวเกินไปตั้งแต่ต้นทาง ไม่ต้องรอ backend ตีกลับเป็น 500
    if (phone != null && phone.trim().length > 15) {
      _errorMessage = 'เบอร์โทรยาวเกินไป';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _profile = await userProfileUseCase.updateMyProfile(
        name: name.trim(),
        phone: phone?.trim(),
        address: address?.trim(),
      );
      return true;
    } catch (e) {
      _errorMessage = _cleanError(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
