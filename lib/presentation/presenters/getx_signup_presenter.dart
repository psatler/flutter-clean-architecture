import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;
  final AddAccount addAccount;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
  });

  String _name;
  String _email;
  String _password;
  String _passwordConfirmation;

  // creating observers for the streams using GetX
  var _emailError = Rx<UiError>();
  var _nameError = Rx<UiError>();
  var _passwordError = Rx<UiError>();
  var _passwordConfirmationError = Rx<UiError>();
  var _isFormValid = false.obs;

  Stream<UiError> get emailErrorStream => _emailError.stream;
  Stream<UiError> get nameErrorStream => _nameError.stream;
  Stream<UiError> get passwordErrorStream => _passwordError.stream;
  Stream<UiError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField(
        field: 'passwordConfirmation', value: passwordConfirmation);
    _validateForm();
  }

  void _validateForm() {
    // setting a new value to the isFormValid observer of GetX
    _isFormValid.value = _emailError.value == null &&
        _nameError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null &&
        _name != null &&
        _email != null &&
        _password != null &&
        _passwordConfirmation != null;
  }

  UiError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);

    switch (error) {
      case ValidationError.invalidField:
        return UiError.invalidadField;

      case ValidationError.requiredField:
        return UiError.requiredField;

      default:
        return null;
    }
  }

  Future<void> signUp() async {
    await addAccount.add(AddAccountParams(
      name: _name,
      email: _email,
      password: _password,
      passwordConfirmation: _passwordConfirmation,
    ));
  }
}
