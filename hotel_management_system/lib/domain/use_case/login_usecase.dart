import '../../data/model/login_model.dart';
import '../../data/repositorise/login_repositorise.dart';
import '../entitise/login_entitise.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<LoginModel> login(LoginEntities entity) {
    return repository.login(
      email: entity.email,
      password: entity.password,
    );
  }
}