import '../../../../presentation/protocols/protocols.dart';
import '../../../../main/composites/composites.dart';
import '../../../../validation/protocols/protocols.dart';

import '../../../builders/builders.dart';

Validation makeSignUpValidation() {
  return ValidationComposite(makeSignUpValidations());
}

List<FieldValidation> makeSignUpValidations() {
  return [
    ...ValidationBuilder.field('name').required().min(3).build(),
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
    ...ValidationBuilder.field('passwordConfirmation')
        .required()
        .sameAs('password')
        .build(),
  ];
}
