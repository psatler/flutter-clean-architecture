import 'package:test/test.dart';

import 'package:flutter_clean_arch/presentation/protocols/protocols.dart';

import 'package:flutter_clean_arch/validation/validators/validators.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });
  test('Should return null on invalid cases (if the email field is missing)',
      () {
    final formData = {};

    expect(sut.validate(formData), null);
  });

  test('Should return null if email is empty', () {
    final formData = {'any_field': ''};

    expect(sut.validate(formData), null);
  });

  test('Should return null if email is null', () {
    final formData = {'any_field': null};

    expect(sut.validate(formData), null);
  });

  test('Should return null if email is valid', () {
    final formData = {'any_field': 'email@email.com'};

    expect(sut.validate(formData), null);
  });

  test('Should return error if email is invalid', () {
    expect(
      sut.validate({'any_field': 'email.com'}),
      ValidationError.invalidField,
    );
    expect(
      sut.validate({'any_field': 'email@.com'}),
      ValidationError.invalidField,
    );
    expect(
      sut.validate({'any_field': '@.com'}),
      ValidationError.invalidField,
    );
    // expect(sut.validate('email@a.com'), 'Campo inválido');
  });
}
