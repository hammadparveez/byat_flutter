import 'package:byat_flutter/domain/exceptions/auth_exceptions.dart';
import 'package:byat_flutter/domain/repository/auth_repo.dart';

class AuthService {
  final _authRepo = AuthRepo();

  BaseException authExceptionFactory(String? code) {
    switch (code) {
      case 'weak-password':
        throw WeakPasswordException();
      case 'wrong-password':
        throw WrongPasswordException();
      case 'email-already-in-use':
        throw WeakPasswordException();
      default:
        throw SomethingWentWrongException();
    }
  }

  Future<bool> loginViaEmailAndPassword(String email, String password) async {
    try {
      return await _authRepo.loginViaEmailAndPassword(email, password);
    } on BaseException catch (e) {
      throw authExceptionFactory(e.code);
    }
  }
}
