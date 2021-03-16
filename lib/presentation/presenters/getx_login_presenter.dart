import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
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
  var _emailError = Rx<UiError>();
  var _passwordError = Rx<UiError>();
  var _mainError = Rx<UiError>();
  var _navigateTo = RxString();
  // shortcut to create an RxBool with initial value as false
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<UiError> get emailErrorStream => _emailError.stream;
  Stream<UiError> get passwordErrorStream => _passwordError.stream;
  Stream<UiError> get mainErrorStream => _mainError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

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
    _isFormValid.value = _emailError.value == null &&
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
    _isLoading.value = true;

    try {
      _mainError.value = null;
      AccountEntity accountEntity =
          await authentication.auth(AuthenticationParams(
        email: _email,
        password: _password,
      ));

      await saveCurrentAccount.save(accountEntity);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UiError.invalidCredentials;
          break;

        default:
          _mainError.value = UiError.unexpected;
          break;
      }
    }

    _isLoading.value = false;
  }

  void goToSignUp() {
    _navigateTo.value = '/signup';
  }
}
