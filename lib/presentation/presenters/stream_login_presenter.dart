import 'dart:async';

import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

class LoginState {
  String emailError;

  // this is a computed value based on the others
  bool get isFormValid => false;
}

class StreamLoginPresenter {
  final Validation validation;
  // if we have one controller for each Stream, we don't need a broadcast. As we
  // are using only one StreamController, we are going to use broadcast. StreamControllers
  // are costly, that's why we are using only one instead of 5 (one for each stream).
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream => _controller.stream
      .map((state) => state.emailError)
      .distinct(); // Skips data events if they are equal to the previous data event.
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({@required this.validation});

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }

  void validatePassword(String password) {
    validation.validate(field: 'password', value: password);
  }
}
