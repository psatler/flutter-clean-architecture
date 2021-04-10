import 'package:get/get.dart';

mixin NavigationManager {
  void handleNavigation(Stream<String> stream, {clear = false}) {
    stream.listen((page) {
      if (page?.isNotEmpty == true) {
        if (clear == true) {
          Get.offAllNamed(page);
        } else {
          Get.toNamed(page);
        }
      }
    });
  }
}
