import 'dart:async';

import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/presentation/protocols/validation.dart';

class LoginState {
  String emailError;
}

class StreamLoginPresenter {
  final Validation validation;
  // if we have one controller for each Stream, we don't need a broadcast. As we
  // are using only one StreamController, we are going to use broadcast. StreamControllers
  // are costly, that's why we are using only one instead of 5 (one for each stream).
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError);

  StreamLoginPresenter({@required this.validation});

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'Email', value: email);
    _controller.add(_state);
  }
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  StreamLoginPresenter sut;
  ValidationSpy validation;
  String email;

  PostExpectation mockValidationCall(String field) => when(
        validation.validate(
          field: field != null ? field : anyNamed('field'),
          value: anyNamed('value'),
        ),
      );

  void mockValidation({String field, String returnValue}) {
    // when testing success, we don't need to pass value as we won't return any error
    mockValidationCall(field).thenReturn(returnValue);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();

    // mocking successful validation
    mockValidation();
  });

  test('Should call validation with email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'Email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(returnValue: 'error');

    expectLater(sut.emailErrorStream, emits('error'));

    sut.validateEmail(email);
  });
}
