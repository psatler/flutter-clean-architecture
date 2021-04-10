import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

class GetxLoginPresenter extends GetxController
    with LoadingManager, FormManager, NavigationManager, UIErrorManager
    implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  GetxLoginPresenter({
    @required this.validation,
    @required this.authentication,
    @required this.saveCurrentAccount,
  });

  String _email;
  String _password;

  // creating observers for the streams using GetX
  var _emailError = Rx<UiError>(null);
  var _passwordError = Rx<UiError>(null);

  Stream<UiError> get emailErrorStream => _emailError.stream;
  Stream<UiError> get passwordErrorStream => _passwordError.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');

    _validateForm();
  }

  void _validateForm() {
    // setting a new value to the isFormValid observer of GetX
    isFormValid = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  UiError _validateField(String field) {
    final formData = {
      'email': _email,
      'password': _password,
    };

    final error = validation.validate(field: field, input: formData);

    switch (error) {
      case ValidationError.invalidField:
        return UiError.invalidadField;

      case ValidationError.requiredField:
        return UiError.requiredField;

      default:
        return null;
    }
  }

  Future<void> auth() async {
    isLoading = true;

    try {
      mainError = null;
      AccountEntity accountEntity =
          await authentication.auth(AuthenticationParams(
        email: _email,
        password: _password,
      ));

      await saveCurrentAccount.save(accountEntity);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UiError.invalidCredentials;
          break;

        default:
          mainError = UiError.unexpected;
          break;
      }
    }

    isLoading = false;
  }

  void goToSignUp() {
    navigateTo = '/signup';
  }
}
