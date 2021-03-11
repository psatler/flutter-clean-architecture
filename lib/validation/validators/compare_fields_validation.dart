import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldsValidation({
    @required this.field,
    @required this.valueToCompare,
  });

  @override
  ValidationError validate(String value) {
    return ValidationError.invalidField;
  }

  @override
  List<Object> get props => [field, valueToCompare];
}
