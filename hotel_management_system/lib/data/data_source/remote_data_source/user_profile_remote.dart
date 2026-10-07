// data/data_source/remote_data_source/user_profile_remote.dart
import 'package:dio/dio.dart';

import '../../../domain/entitise/user_profile_entity.dart';
import '../../../util/widget/core/network/dio_client.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileEntity> getMyProfile();
  Future<UserProfileEntity> updateMyProfile({
    required String name,
    String? phone,
    String? address,
  });
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final Dio _dio = DioClient.dio;

  @override
  Future<UserProfileEntity> getMyProfile() async {
    try {
      final response = await _dio.get('users/me');
      return UserProfileEntity.fromJson(
        Map<String, dynamic>.from(response.data['data']),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'ไม่สามารถโหลดข้อมูลโปรไฟล์ได้',
      );
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาด: $e');
    }
  }

  @override
  Future<UserProfileEntity> updateMyProfile({
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await _dio.put('users/me', data: {
        'name': name,
        'phone': phone,
        'address': address,
      });
      return UserProfileEntity.fromJson(
        Map<String, dynamic>.from(response.data['data']),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'ไม่สามารถบันทึกโปรไฟล์ได้',
      );
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาด: $e');
    }
  }
}