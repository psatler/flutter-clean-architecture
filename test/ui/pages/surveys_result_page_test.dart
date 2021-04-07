import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/ui/pages/survey_result/survey_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:flutter_clean_arch/ui/helpers/helpers.dart';
import 'package:flutter_clean_arch/ui/pages/surveys/surveys.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  SurveyResultPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();

    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [
        GetPage(
            name: '/survey_result/:survey_id',
            page: () => SurveyResultPage(
                  presenter: presenter,
                ))
      ],
    );

    mockNetworkImagesFor(() async => await tester.pumpWidget(surveysPage));
  }

  testWidgets('Should call LoadSurveysResult on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });
}
