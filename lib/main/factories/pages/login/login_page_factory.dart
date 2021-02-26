import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

Widget makeLoginPage() {
  final streamLoginPresenter = makeLoginPresenter();
  return LoginPage(streamLoginPresenter);
}
