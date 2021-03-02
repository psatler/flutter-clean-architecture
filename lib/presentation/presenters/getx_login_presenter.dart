import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

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
  var _emailError = RxString();
  var _passwordError = RxString();
  var _mainError = RxString();
  var _navigateTo = RxString();
  // shortcut to create an RxBool with initial value as false
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<String> get emailErrorStream => _emailError.stream;
  Stream<String> get passwordErrorStream => _passwordError.stream;
  Stream<String> get mainErrorStream => _mainError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    // setting a new value to the isFormValid observer of GetX
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  Future<void> auth() async {
    _isLoading.value = true;

    try {
      AccountEntity accountEntity =
          await authentication.auth(AuthenticationParams(
        email: _email,
        password: _password,
      ));

      await saveCurrentAccount.save(accountEntity);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      _mainError.value = error.description;
    }

    _isLoading.value = false;
  }

  void dispose() {}
}
