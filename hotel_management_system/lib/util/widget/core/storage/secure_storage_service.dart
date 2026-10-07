import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {

  SecureStorageService._();

  static final SecureStorageService instance =
      SecureStorageService._();


  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();


  static const String accessTokenKey = "access_token";


  // เก็บ Token หลัง Login
  Future<void> saveToken(String token) async {

    await _storage.write(
      key: accessTokenKey,
      value: token,
    );

  }


  // อ่าน Token เพื่อส่ง API
  Future<String?> getToken() async {

    return await _storage.read(
      key: accessTokenKey,
    );

  }


  // ลบ Token
  Future<void> removeToken() async {

    await _storage.delete(
      key: accessTokenKey,
    );

  }


  // ล้างข้อมูลทั้งหมด
  Future<void> clear() async {

    await _storage.deleteAll();

  }

}