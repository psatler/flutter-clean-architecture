// PS: if using a third party library to implement the email validation, the following is a good approach:
// 1) create an interface (abs. class) called EmailValidator
// 2) make EmailValidation implements the EmailValidator
// 3) then, for the tests, we would mock the interface and test based on the results of the EmailValidator
// 4) we would make an implementation of the EmailValidator in the "infra" layer (in case we are using an 3rd party library)

import 'package:equatable/equatable.dart';

import '../../presentation/protocols/validation.dart';
import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  ValidationError validate(Map input) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    // if null or empty, then is valid. Or if hasMatch, it's also valid
    final isValid =
        input[field]?.isNotEmpty != true || regex.hasMatch(input[field]);
    return isValid ? null : ValidationError.invalidField;
  }

  @override
  List<Object> get props => [field];
}
