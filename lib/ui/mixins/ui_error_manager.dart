import 'package:flutter/material.dart';

import '../components/components.dart';
import '../helpers/helpers.dart';

mixin UIErrorManager {
  void handleMainError(BuildContext context, Stream<UiError> stream) {
    stream.listen((error) {
      if (error != null) {
        showErrorMessage(
          context: context,
          message: error.description,
        );
      }
    });
  }
}
