import 'package:notes_project/services/auth/auth_exceptions.dart';
import 'package:notes_project/services/auth/auth_provider.dart';
import 'package:notes_project/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  //we take a test and we failed we should fix it :flutter test test/auth_test.dart
  group('Muck Athentication', () {
    final provider = MuckAuthProvider();

    test('should not be initialized to bigin with', () {
      expect(provider.isInitialezed, false);
    });

    test('Can not log out if not initialized', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });
    test('should be able to initialized', () async {
      await provider.initialize();
      expect(provider.isInitialezed, true);
    });

    test('User should be null after initialized', () {
      expect(provider.currentUser, null);
    });

    test('should be able to initialize after 2 secound', () async {
      await provider.initialize();
      expect(provider.isInitialezed, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Create user should be delegate to the login function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anypass',
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: 'someome@bar.com',
        password: 'foobar',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('Logged in user should be able to verifyied', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('should be able to log in and log out in again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MuckAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialezed = false;
  bool get isInitialezed => _isInitialezed;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialezed) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialezed = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialezed) throw NotInitializedException();

    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();

    const user = AuthUser(
        isEmailVerified: false, email: 'mortezaj015@gmail.com', id: 'my_id');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialezed) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialezed) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
        isEmailVerified: true, email: 'mortezaj015@gmail.com', id: 'my_id');
    _user = newUser;
  }
}
