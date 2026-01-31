
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

/// Concrete implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;



  AuthRepositoryImpl({
    required AuthLocalDataSource local,
    required AuthRemoteDataSource remote,
  })  : localDataSource = local,
        remoteDataSource = remote;

  @override
  Future<User> login(String email, String password) async {
    try {

      final token = await remoteDataSource.login(email, password);


      await localDataSource.saveToken(token);


      final user = User(id: '1', email: email, name: 'sandeep');
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      final token = await localDataSource.getToken();
      if (token != null) {
        await remoteDataSource.logout(token);
        await localDataSource.deleteToken();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    return await localDataSource.getCurrentUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getToken();
    return token != null;
  }
}