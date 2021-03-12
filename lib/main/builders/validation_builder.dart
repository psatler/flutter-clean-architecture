import '../../validation/protocols/protocols.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  static ValidationBuilder _instance;

  // letting the constructor as private in dart
  ValidationBuilder._();

  String fieldName;
  List<FieldValidation> validations = [];

  // the only access to the builder is this static method which returns an instance of the class
  // so then we can chain the methods
  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._();
    _instance.fieldName = fieldName;
    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(fieldName));
    return this; // so that we can chain the methods
  }

  ValidationBuilder email() {
    validations.add(EmailValidation(fieldName));
    return this;
  }

  ValidationBuilder min(int size) {
    validations.add(MinLengthValidation(field: fieldName, size: size));
    return this;
  }

  ValidationBuilder sameAs(String fieldToCompare) {
    validations.add(CompareFieldsValidation(
      field: fieldName,
      fieldToCompare: fieldToCompare,
    ));
    return this;
  }

  List<FieldValidation> build() => validations;
}
