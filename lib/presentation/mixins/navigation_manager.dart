import 'package:get/get.dart';

mixin NavigationManager on GetxController {
  final _navigateTo = RxString(null);
  Stream<String> get navigateToStream => _navigateTo.stream;
  // set navigateTo(String value) => _navigateTo.value = value; // only send streams different than the previous one
  set navigateTo(String value) => _navigateTo.subject.add(value);
}
