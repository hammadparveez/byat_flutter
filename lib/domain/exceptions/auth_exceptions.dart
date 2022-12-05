
class BaseException implements Exception {
  final String? code;
  final String? message;
  BaseException({this.code, this.message});
}

class UserNotFoundException extends BaseException {
  UserNotFoundException({super.message = 'no_user_found'});
}

class EmailAlreadyExistsException extends BaseException {
  EmailAlreadyExistsException(
      {super.message = 'email_exists'});
}

class WrongPasswordException extends BaseException {
  WrongPasswordException({super.message = 'password_incorrect'});
}

class WeakPasswordException extends BaseException {
  WeakPasswordException({super.message = 'strong_password'});
}

class UserSignedOutException extends BaseException {
  UserSignedOutException({super.message = 'you_signed_out'});
}

class SomethingWentWrongException extends BaseException {
  SomethingWentWrongException({super.message = 'something_went_wrong'});
}
