import '../../../../presentation/protocols/protocols.dart';
import '../../../../main/composites/composites.dart';
import '../../../../validation/protocols/protocols.dart';

import '../../../builders/builders.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
  ];
}
