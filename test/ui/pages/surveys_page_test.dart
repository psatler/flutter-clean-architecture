import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_clean_arch/ui/helpers/helpers.dart';
import 'package:flutter_clean_arch/ui/pages/surveys/surveys.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;
  StreamController<List<SurveyViewModel>> surveysController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    surveysController = StreamController<List<SurveyViewModel>>();
    when(presenter.surveysStream).thenAnswer((_) => surveysController.stream);

    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(
            name: '/surveys',
            page: () => SurveysPage(
                  presenter: presenter,
                ))
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(
          id: '1',
          question: 'Question 1',
          date: 'Date 1',
          didAnswer: true,
        ),
        SurveyViewModel(
          id: '2',
          question: 'Question 2',
          date: 'Date 2',
          didAnswer: false,
        ),
      ];

  tearDown(() {
    surveysController.close();
  });

  testWidgets('Should call LoadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  // testWidgets('Should handle loading indicator', (WidgetTester tester) async {
  //   await loadPage(tester);

  //   isLoadingController.add(true);
  //   await tester.pump();
  //   expect(find.byType(CircularProgressIndicator), findsOneWidget);

  //   isLoadingController.add(false);
  //   await tester.pump();
  //   expect(find.byType(CircularProgressIndicator), findsNothing);

  //   isLoadingController.add(true);
  //   await tester.pump();
  //   expect(find.byType(CircularProgressIndicator), findsOneWidget);

  //   isLoadingController.add(null);
  //   await tester.pump();
  //   expect(find.byType(CircularProgressIndicator), findsNothing);
  // });

  testWidgets('Should present error if surveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    surveysController.addError(UiError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget); // reload button
    expect(find.text('Question 1'), findsNothing); // a survey's question

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present list of questions if surveysStream succeeds',
      (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    surveysController.add(makeSurveys());
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsNothing);
    expect(find.text('Recarregar'), findsNothing); // reload button
    expect(find.text('Question 1'), findsWidgets); // a survey's question
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);

    expect(find.byType(CircularProgressIndicator), findsNothing);

    // to find only one widget of the last type, we can disable infinite scroll in the CarouselSlider
    // expect(find.text('Question 2'), findsOneWidget);
  });

  testWidgets('Should call LoadSurveys on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UiError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(
        2); // called when first loading the page and also after pressing the reload button
  });
}
