// protocols (dependencies) related to the presentation layer
import 'package:meta/meta.dart';

abstract class Validation {
  String validate({
    @required String field,
    @required String value,
  });
}
