import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/ui/helpers/errors/errors.dart';

import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/domain/helpers/helpers.dart';
import 'package:flutter_clean_arch/domain/usecases/usecases.dart';

import 'package:flutter_clean_arch/presentation/presenters/presenters.dart';
import 'package:flutter_clean_arch/presentation/protocols/validation.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  GetxSignUpPresenter sut; // <----
  ValidationSpy validation;

  String email;

  PostExpectation mockValidationCall(String field) => when(
        validation.validate(
          field: field != null ? field : anyNamed('field'),
          value: anyNamed('value'),
        ),
      );

  void mockValidation({String field, ValidationError returnValue}) {
    // when testing success, we don't need to pass value as we won't return any error
    mockValidationCall(field).thenReturn(returnValue);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
    );
    email = faker.internet.email();

    // mocking successful validation
    mockValidation();
  });

  test('Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(returnValue: ValidationError.invalidField);

    expectLater(sut.emailErrorStream, emits(UiError.invalidadField));

    sut.validateEmail(email);
  });

  test('Should ONLY emit error if error is different than the previous one',
      () {
    mockValidation(returnValue: ValidationError.invalidField);

    // expecting the callback to be called only one time
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidadField)));
    // expectLater(sut.emailErrorStream, emitsInOrder(['error']));

    // user typed two times, so validateEmail is called two times as well
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit the event stating if the form is valid or not', () {
    mockValidation(returnValue: ValidationError.invalidField);

    // expecting the callback to be called only one time
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidadField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // user typed two times, so validateEmail is called two times as well
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit the invalidFieldError if email is invalid', () {
    mockValidation(returnValue: ValidationError.invalidField);

    // expecting the callback to be called only one time
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidadField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // user typed two times, so validateEmail is called two times as well
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit the requiredFieldError if email is empty', () {
    mockValidation(returnValue: ValidationError.requiredField);

    // expecting the callback to be called only one time
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // user typed two times, so validateEmail is called two times as well
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if email validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // user typed two times, so validateEmail is called two times as well
    sut.validateEmail(email);
    sut.validateEmail(email);
  });
}
