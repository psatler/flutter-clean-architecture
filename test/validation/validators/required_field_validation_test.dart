import 'package:flutter_clean_arch/presentation/protocols/protocols.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/validation/validators/validators.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Should return null if value is not empty', () {
    final error = sut.validate('any_value');

    expect(error, equals(null));
  });

  test('Should return error if value is empty', () {
    final error = sut.validate('');

    expect(error, ValidationError.requiredField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.requiredField);
  });
}
