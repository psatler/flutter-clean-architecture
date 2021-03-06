// protocols (dependencies) related to the presentation layer
import 'package:meta/meta.dart';

abstract class Validation {
  ValidationError validate({
    @required String field,
    @required String value,
  });
}

enum ValidationError {
  requiredField,
  invalidField,
}
