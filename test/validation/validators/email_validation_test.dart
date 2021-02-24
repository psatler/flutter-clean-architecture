import 'package:flutter_clean_arch/validation/protocols/protocols.dart';
import 'package:test/test.dart';

// PS: if using a third party library to implement the email validation, the following is a good approach:
// 1) create an interface (abs. class) called EmailValidator
// 2) make EmailValidation implements the EmailValidator
// 3) then, for the tests, we would mock the interface and test based on the results of the EmailValidator
// 4) we would make an implementation of the EmailValidator in the "infra" layer (in case we are using an 3rd party library)

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  String validate(String value) {
    return null;
  }
}

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });
  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('email@email.com'), null);
  });
}
