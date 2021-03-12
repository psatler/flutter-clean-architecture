import 'package:test/test.dart';

import 'package:flutter_clean_arch/presentation/protocols/protocols.dart';
import 'package:flutter_clean_arch/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', fieldToCompare: 'other_field');
  });

  test(
      'Should return null on invalid cases (if at least one of the fields are null)',
      () {
    final onlyOneField = sut.validate({'any_field': 'any_value'});
    final onlyAnotherField = sut.validate({'other_field': 'any_value'});
    final noneOfTheFields = sut.validate({});

    expect(onlyOneField, null);
    expect(onlyAnotherField, null);
    expect(noneOfTheFields, null);
  });

  test('Should return error if values are not equal', () {
    final formData = {'any_field': 'any_value', 'other_field': 'other_value'};

    final error = sut.validate(formData);

    expect(error, ValidationError.invalidField);
  });

  test('Should return null if values are equal', () {
    final formData = {'any_field': 'any_value', 'other_field': 'any_value'};

    final error = sut.validate(formData);

    expect(error, null);
  });
}
