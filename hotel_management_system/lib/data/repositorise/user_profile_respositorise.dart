// data/repositorise/user_profile_repositorise.dart
import '../../domain/entitise/user_profile_entity.dart';
import '../data_source/remote_data_source/user_profile_remote.dart';

abstract class UserProfileRepository {
  Future<UserProfileEntity> getMyProfile();
  Future<UserProfileEntity> updateMyProfile({
    required String name,
    String? phone,
    String? address,
  });
}

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfileEntity> getMyProfile() async {
    try {
      return await remoteDataSource.getMyProfile();
    } catch (e) {
      throw Exception("Repository error: $e");
    }
  }

  @override
  Future<UserProfileEntity> updateMyProfile({
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      return await remoteDataSource.updateMyProfile(
        name: name,
        phone: phone,
        address: address,
      );
    } catch (e) {
      throw Exception("Repository error: $e");
    }
  }
}