// this presenter will be a abstract class which will reference the needs that the
// respective page has (in this case, the needs of the login_page). For example,
// login_page has to validate the email and password fields typed in.

// so, the LoginPresenter is generic, but his implementation will be related to
// some third party library such as Mobx, for example. Though, this is going to
// use Streams (so no 3rd party libs) and the name will be StreamLoginPresenter.
// Therefore, depending on the action made by the user, validations will occur and
// the UI will rerender after notified via streams.

import '../../helpers/errors/errors.dart';

abstract class SignUpPresenter {
  // a stream which will listen each time we have a new error
  Stream<UiError> get nameErrorStream;
  Stream<UiError> get emailErrorStream;
  Stream<UiError> get passwordErrorStream;
  Stream<UiError> get passwordConfirmationErrorStream;
  Stream<UiError> get mainErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<String> get navigateToStream;

  void validateName(String name);
  void validateEmail(String email);
  void validatePassword(String password);
  void validatePasswordConfirmation(String password);
  Future<void> signUp();
  void goToLogin();
}
