import 'package:get/get.dart';

mixin FormManager on GetxController {
  // shortcut to create an RxBool with initial value as false
  final _isFormValid = false.obs;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  set isFormValid(bool value) => _isFormValid.value = value;
}
