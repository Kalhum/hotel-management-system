import 'package:flutter/material.dart';

import '../../data/model/login_model.dart';
import '../widget/core/storage/secure_storage_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool get isLogin => _user != null;

  String? get email => _user?.email;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    await SecureStorageService.instance.removeToken();
    _user = null;
    notifyListeners();
  }

  // เก็บ clear() ไว้เผื่อที่อื่นเรียกใช้อยู่ (แต่ภายในเรียก logout() แทน)
  void clear() {
    logout();
  }
  // void clear() {
  //   _user = null;
  //   notifyListeners();
  // }
}


// class UserProvider extends ChangeNotifier {

//   User? _user;
//   User? _email;
//   User? get user => _user;
//   User? get email => _email;

//   bool get isLogin => _user != null;

//   void setUser(User user){
//     _user = user;
//     notifyListeners();
//   }

//   void clear(){
//     _user = null;
//     notifyListeners();
//   }

// }