import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/presentation/protocols/protocols.dart';
import 'package:flutter_clean_arch/validation/validators/validators.dart';

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate({'any_field': ''});

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    final error = sut.validate({'any_field': null});

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is smaller than min size', () {
    final lessThanStr = {'any_field': faker.randomGenerator.string(4, min: 1)};
    final error = sut.validate(lessThanStr);

    expect(error, ValidationError.invalidField);
  });

  test('Should return null if value is equal to min size', () {
    final equalTo = {'any_field': faker.randomGenerator.string(5, min: 5)};
    final error = sut.validate(equalTo);

    expect(error, null);
  });

  test('Should return null if value is greater than min size', () {
    final greaterThan = {'any_field': faker.randomGenerator.string(10, min: 6)};
    final error = sut.validate(greaterThan);

    expect(error, null);
  });
}
