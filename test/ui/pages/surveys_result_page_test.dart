import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:flutter_clean_arch/ui/helpers/helpers.dart';
import 'package:flutter_clean_arch/ui/pages/survey_result/survey_result.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  SurveyResultPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<dynamic> surveyResultController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveyResultController = StreamController<dynamic>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.surveyResultStream)
        .thenAnswer((_) => surveyResultController.stream);
  }

  void closeStream() {
    isLoadingController.close();
    surveyResultController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();

    initStreams();
    mockStreams();

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

    await mockNetworkImagesFor(
      () async => await tester.pumpWidget(surveysPage),
    );
  }

  tearDown(() {
    closeStream();
  });

  testWidgets('Should call LoadSurveyResult on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should handle loading indicator', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error if surveyResultStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);
    // expect(find.byType(CircularProgressIndicator), findsOneWidget);

    surveyResultController.addError(UiError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget); // reload button
    // expect(find.text('Question 1'), findsNothing); // a survey's question

    // expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call LoadSurveyResult on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UiError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(
        2); // called when first loading the page and also after pressing the reload button
  });
}
