// it will loop through all the validators, running the right one to apply the validation.
// if one or more validators return an error, we pass this to the screen that is using it.
// if all validators return null, there is no errors.

import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';

import '../../validation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError validate({@required String field, @required Map input}) {
    ValidationError error;
    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(input);
      if (error != null) {
        return error;
      }
    }
    return error;
  }
}
