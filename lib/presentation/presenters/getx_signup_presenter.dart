import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

class GetxSignUpPresenter extends GetxController
    with LoadingManager
    implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
    @required this.saveCurrentAccount,
  });

  String _name;
  String _email;
  String _password;
  String _passwordConfirmation;

  // creating observers for the streams using GetX
  var _emailError = Rx<UiError>(null);
  var _nameError = Rx<UiError>(null);
  var _passwordError = Rx<UiError>(null);
  var _passwordConfirmationError = Rx<UiError>(null);
  var _mainError = Rx<UiError>(null);
  var _isFormValid = false.obs;
  var _navigateTo = RxString(null);

  Stream<UiError> get emailErrorStream => _emailError.stream;
  Stream<UiError> get nameErrorStream => _nameError.stream;
  Stream<UiError> get passwordErrorStream => _passwordError.stream;
  Stream<UiError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;
  Stream<UiError> get mainErrorStream => _mainError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField('passwordConfirmation');
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

  UiError _validateField(String field) {
    final formData = {
      'name': _name,
      'email': _email,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation,
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

  Future<void> signUp() async {
    try {
      isLoading = true;
      _mainError.value = null;
      AccountEntity accountEntity = await addAccount.add(AddAccountParams(
        name: _name,
        email: _email,
        password: _password,
        passwordConfirmation: _passwordConfirmation,
      ));

      await saveCurrentAccount.save(accountEntity);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          _mainError.value = UiError.emailInUse;
          break;

        default:
          _mainError.value = UiError.unexpected;
          break;
      }
    } finally {
      isLoading = false;
    }
  }

  void goToLogin() {
    _navigateTo.value = '/login';
  }
}
