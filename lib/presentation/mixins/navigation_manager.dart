import 'package:get/get.dart';

mixin NavigationManager {
  final _navigateTo = RxString(null);
  Stream<String> get navigateToStream => _navigateTo.stream;
  set navigateTo(String value) => _navigateTo.value = value;
}
