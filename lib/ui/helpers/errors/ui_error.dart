import '../helpers.dart';

enum UiError {
  requiredField,
  invalidadField,
  unexpected,
  invalidCredentials,
  emailInUse,
}

extension UiErrorErrorExtension on UiError {
  String get description {
    switch (this) {
      // this is the enum UiError
      case UiError.requiredField:
        return R.strings.msgRequiredField;

      case UiError.invalidadField:
        return R.strings.msgInvalidField;

      case UiError.invalidCredentials:
        return R.strings.msgInvalidCredentials;

      case UiError.emailInUse:
        return R.strings.msgEmailInUse;

      default:
        return R.strings.msgUnexpectedError;
    }
  }
}
