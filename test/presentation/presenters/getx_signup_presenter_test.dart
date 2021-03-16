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

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  GetxSignUpPresenter sut; // <----
  ValidationSpy validation;
  AddAccountSpy addAccount;
  SaveCurrentAccountSpy saveCurrentAccount;

  String email;
  String name;
  String password;
  String passwordConfirmation;
  String token;

  PostExpectation mockValidationCall(String field) => when(
        validation.validate(
          field: field != null ? field : anyNamed('field'),
          input: anyNamed('input'),
        ),
      );

  void mockValidation({String field, ValidationError returnValue}) {
    // when testing success, we don't need to pass value as we won't return any error
    mockValidationCall(field).thenReturn(returnValue);
  }

  PostExpectation mockAddAccountCall() => when(addAccount.add(any));

  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
      addAccount: addAccount,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    token = faker.guid.guid();

    // mocking successful validation
    mockValidation();
    mockAddAccount();
  });

  test('Should call validation with correct email', () {
    final formData = {
      'name': null,
      'email': email,
      'password': null,
      'passwordConfirmation': null,
    };

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', input: formData)).called(1);
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

  test('Should call Validation with correct name', () {
    final formData = {
      'name': name,
      'email': null,
      'password': null,
      'passwordConfirmation': null,
    };

    sut.validateName(name);

    verify(validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if name is invalid', () {
    mockValidation(returnValue: ValidationError.invalidField);

    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidadField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit requiredFieldError if name is empty', () {
    mockValidation(returnValue: ValidationError.requiredField);

    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct password', () {
    final formData = {
      'name': null,
      'email': null,
      'password': password,
      'passwordConfirmation': null,
    };

    sut.validatePassword(password);

    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if password is invalid', () {
    mockValidation(returnValue: ValidationError.invalidField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidadField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit requiredFieldError if password is empty', () {
    mockValidation(returnValue: ValidationError.requiredField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should call Validation with correct passwordConfirmation', () {
    final formData = {
      'name': null,
      'email': null,
      'password': null,
      'passwordConfirmation': passwordConfirmation,
    };

    sut.validatePasswordConfirmation(passwordConfirmation);

    verify(validation.validate(field: 'passwordConfirmation', input: formData))
        .called(1);
  });

  test('Should emit invalidFieldError if passwordConfirmation is invalid', () {
    mockValidation(returnValue: ValidationError.invalidField);

    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidadField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit requiredFieldError if passwordConfirmation is empty', () {
    mockValidation(returnValue: ValidationError.requiredField);

    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should enable form button if all form fields are valid', () async {
    // sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    // sut.passwordErrorStream
    //     .listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero); // hack to make emitsInOrder work
    sut.validateEmail(email);
    await Future.delayed(Duration.zero); // hack to make emitsInOrder work
    sut.validatePassword(password);
    await Future.delayed(Duration.zero); // hack to make emitsInOrder work
    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero); // hack to make emitsInOrder work
  });

  test('Should call AddAccount with correct value', () async {
    // fill out all the fields
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(addAccount.add(AddAccountParams(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    ))).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UiError.unexpected]));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.signUp();
  });

  test('Should emit correct events (isLoading stream) on AddAccount success',
      () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.signUp();
  });

  test('Should emit correct events on EmailInUseError', () async {
    mockAddAccountError(DomainError.emailInUse);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UiError.emailInUse]));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.signUp();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAddAccountError(DomainError.unexpected);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UiError.unexpected]));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.signUp();
  });

  test('Should change page after successfully creating an account', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    sut.navigateToStream.listen(expectAsync1((page) => expect(
          page,
          '/surveys',
        )));

    await sut.signUp();
  });

  test('Should go to Login page on link click', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(
          page,
          '/login',
        )));

    sut.goToLogin();
  });
}
