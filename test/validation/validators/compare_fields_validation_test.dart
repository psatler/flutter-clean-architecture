import 'package:test/test.dart';

import 'package:flutter_clean_arch/presentation/protocols/protocols.dart';
import 'package:flutter_clean_arch/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', valueToCompare: 'any_value');
  });

  test('Should return error if values are not equal', () {
    final error = sut.validate('wrong_value');

    expect(error, ValidationError.invalidField);
  });
}
