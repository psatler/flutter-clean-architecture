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

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  GetxLoginPresenter sut; // <----
  ValidationSpy validation;
  AuthenticationSpy authentication;
  SaveCurrentAccountSpy saveCurrentAccount;
  String email;
  String password;
  String token;

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

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
      // ^^^^
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();

    // mocking successful validation
    mockValidation();

    // mocking successful authentication
    mockAuthentication();
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

  test('Should call validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {
    // simulating an error
    mockValidation(returnValue: ValidationError.requiredField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // user typed two times, so validateEmail is called two times as well
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if password validation succeeds', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // user typed two times, so validateEmail is called two times as well
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit the requiredFieldError if password is empty', () {
    mockValidation(returnValue: ValidationError.requiredField);

    // expecting the callback to be called only one time
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    // user typed two times, so validateEmail is called two times as well
    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit valid form if all form fields are valid', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero); // hack to make emitsInOrder work
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(authentication
            .auth(AuthenticationParams(email: email, password: password)))
        .called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false])); // <----
    sut.mainErrorStream.listen(expectAsync1((error) => expect(
          error,
          UiError.unexpected,
        )));

    await sut.auth();
  });

  test(
      'Should emit correct events (isLoading stream) on successful Authentication',
      () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should change page on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream.listen(expectAsync1((page) => expect(
          page,
          '/surveys',
        )));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false])); // <----
    sut.mainErrorStream.listen(expectAsync1((error) => expect(
          error,
          UiError.invalidCredentials,
        )));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false])); // <----
    sut.mainErrorStream.listen(expectAsync1((error) => expect(
          error,
          UiError.unexpected,
        )));

    await sut.auth();
  });
}
