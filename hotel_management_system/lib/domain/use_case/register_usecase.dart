import 'package:hotel_management_system/data/model/register_model.dart';
import 'package:hotel_management_system/data/repositorise/register_repositorise.dart';
import 'package:hotel_management_system/domain/entitise/register_entitise.dart';

class RegisterUsecase {
  final RegisterRepositorise repositorise;

  RegisterUsecase({required this.repositorise});

  Future<RegisterModel> register(RegisterEntitise entities) {
    return repositorise.register(
        username: entities.username,
        email: entities.email,
        address: entities.address,
        phoneNumber: entities.phoneNumber,
        password: entities.password);
  }
}
