import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:miniwalletfintechapp/features/auth/domain/entities/user.dart';
import 'package:miniwalletfintechapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:miniwalletfintechapp/features/auth/domain/usecases/login_user.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';


// ---------------------------
// Mock Auth Repository
// ---------------------------
class AuthRepositoryMock implements AuthRepository {
  final Map<String, String> _users = {
    'test@example.com': '1234',
    'user@example.com': 'password',
  };

  User? _currentUser;
  bool _loggedIn = false;

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 50));

    if (!_users.containsKey(email)) {
      throw Exception('User not found');
    }

    if (_users[email] != password) {
      throw Exception('Invalid password');
    }

    _currentUser = User(id: email, email: email, name: 'Test User');
    _loggedIn = true;
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    _loggedIn = false;
  }

  @override
  Future<bool> isLoggedIn() async => _loggedIn;

  @override
  Future<User?> getCurrentUser() async => _currentUser;
}

// ---------------------------
// Integration Test
// ---------------------------
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AuthRepositoryMock authRepository;
  late LoginUser loginUser;

  setUp(() {
    authRepository = AuthRepositoryMock();
    loginUser = LoginUser(authRepository);
  });

  test('Login succeeds with valid email and password', () async {
    final user = await loginUser.call('test@example.com', '1234');

    expect(user, isA<User>());
    expect(user.email, 'test@example.com');
    expect(user.name, 'Test User');

    // Check that repository state updated
    expect(await authRepository.isLoggedIn(), true);
    expect(await authRepository.getCurrentUser(), user);
  });

  test('Login fails with wrong password', () async {
    expect(
          () => loginUser.call('test@example.com', 'wrong'),
      throwsA(isA<Exception>().having(
            (e) => e.toString(),
        'message',
        contains('Invalid password'),
      )),
    );
  });

  test('Login fails with non-existing user', () async {
    expect(
          () => loginUser.call('notfound@example.com', '1234'),
      throwsA(isA<Exception>().having(
            (e) => e.toString(),
        'message',
        contains('User not found'),
      )),
    );
  });

  test('Login fails with empty email or password', () async {
    expect(
          () => loginUser.call('', '1234'),
      throwsA(isA<Exception>().having(
            (e) => e.toString(),
        'message',
        contains('Email and password cannot be empty'),
      )),
    );

    expect(
          () => loginUser.call('test@example.com', ''),
      throwsA(isA<Exception>().having(
            (e) => e.toString(),
        'message',
        contains('Email and password cannot be empty'),
      )),
    );
  });

  test('Login fails with password less than 4 characters', () async {
    expect(
          () => loginUser.call('test@example.com', '123'),
      throwsA(isA<Exception>().having(
            (e) => e.toString(),
        'message',
        contains('Password must be at least 4 characters'),
      )),
    );
  });

  test('Logout clears current user', () async {
    // Login first
    await loginUser.call('test@example.com', '1234');
    await authRepository.logout();

    expect(await authRepository.isLoggedIn(), false);
    expect(await authRepository.getCurrentUser(), null);
  });

}