import 'translations.dart';

class EnUs implements Translations {
  String get msgRequiredField => 'Required field.';
  String get msgInvalidField => 'Invalid field.';
  String get msgInvalidCredentials => 'Invalid credentials.';
  String get msgUnexpectedError => 'Something went wrong. Try again later.';
  String get msgEmailInUse => 'Email already in use';

  String get addAccount => 'Create account';
  String get email => 'Email';
  String get signIn => 'Sign In';
  String get password => 'Password';
  String get confirmPassword => 'Confirm password';
  String get login => 'Login';
  String get name => 'Name';
  String get wait => 'Wait...';

  String get surveys => 'Surveys';
  String get reload => 'Reload';
}
