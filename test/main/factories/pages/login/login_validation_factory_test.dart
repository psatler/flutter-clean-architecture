import 'package:test/test.dart';

import 'package:flutter_clean_arch/validation/validators/validators.dart';
import 'package:flutter_clean_arch/main/factories/factories.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeLoginValidations();

    // comparing objects so we need to use Equatable and extends from it
    expect(
      validations,
      [
        RequiredFieldValidation('email'),
        EmailValidation('email'),
        // validations for password are below
        RequiredFieldValidation('password'),
        MinLengthValidation(field: 'password', size: 3),
      ],
    );
  });
}
