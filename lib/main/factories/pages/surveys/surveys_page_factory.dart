import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import '../../../../main/factories/factories.dart';

Widget makeSurveysPage() => SurveysPage(
      presenter: makeGetxSurveysPresenter(),
    );
