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
    return value != null && value.length >= size
        ? null
        : ValidationError.invalidField;
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

  test('Should return error if value is smaller than min size', () {
    final lessThanStr = faker.randomGenerator.string(4, min: 1);
    final error = sut.validate(lessThanStr);

    expect(error, ValidationError.invalidField);
  });

  test('Should return null if value is equal to min size', () {
    final equalTo = faker.randomGenerator.string(5, min: 5);
    final error = sut.validate(equalTo);

    expect(error, null);
  });

  test('Should return null if value is greater than min size', () {
    final greaterThan = faker.randomGenerator.string(10, min: 6);
    final error = sut.validate(greaterThan);

    expect(error, null);
  });
}
