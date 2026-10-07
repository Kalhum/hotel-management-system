import '../data_source/remote_data_source/login_remote.dart';
import '../model/login_model.dart';

abstract class LoginRepository {
  Future<LoginModel> login({
    required String email,
    required String password,
  });
}

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final data = await remoteDataSource.login(
      email: email,
      password: password,
    );

    return LoginModel.fromJson(data);
  }
}