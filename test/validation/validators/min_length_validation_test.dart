import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:flutter_clean_arch/presentation/protocols/protocols.dart';
import 'package:flutter_clean_arch/validation/protocols/protocols.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({
    @required this.field,
    @required this.size,
  });

  @override
  ValidationError validate(String value) {
    return ValidationError.invalidField;
  }
}

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate('');

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    final error = sut.validate(null);

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is less than min size', () {
    final lessThanStr = faker.randomGenerator.string(4, min: 1);
    final error = sut.validate(lessThanStr);

    expect(error, ValidationError.invalidField);
  });
}
