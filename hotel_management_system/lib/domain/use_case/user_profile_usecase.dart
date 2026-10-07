// domain/use_case/user_profile_usecase.dart
import '../../data/repositorise/user_profile_respositorise.dart';
import '../entitise/user_profile_entity.dart';

class UserProfileUseCase {
  final UserProfileRepository repository;

  UserProfileUseCase({required this.repository});

  Future<UserProfileEntity> getMyProfile() => repository.getMyProfile();

  Future<UserProfileEntity> updateMyProfile({
    required String name,
    String? phone,
    String? address,
  }) {
    return repository.updateMyProfile(
      name: name,
      phone: phone,
      address: address,
    );
  }
}