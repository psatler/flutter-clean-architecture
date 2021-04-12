import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:flutter_clean_arch/ui/helpers/helpers.dart';
import 'package:flutter_clean_arch/ui/pages/survey_result/survey_result.dart';
import 'package:flutter_clean_arch/ui/pages/survey_result/components/components.dart';

import '../../mocks/mocks.dart';
import '../helpers/helpers.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  SurveyResultPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<bool> isSessionExpiredController;
  StreamController<SurveyResultViewModel> surveyResultController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    isSessionExpiredController = StreamController<bool>();
    surveyResultController = StreamController<SurveyResultViewModel>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.surveyResultStream)
        .thenAnswer((_) => surveyResultController.stream);

    when(presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  void closeStream() {
    isLoadingController.close();
    surveyResultController.close();
    isSessionExpiredController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();

    initStreams();
    mockStreams();

    final surveysResultPage = makePage(
      path: '/survey_result/any_survey_id',
      pageBeingTested: () => SurveyResultPage(presenter: presenter),
    );

    await mockNetworkImagesFor(
      () async => await tester.pumpWidget(surveysResultPage),
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

  testWidgets('Should present error if surveyResultStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);
    // expect(find.byType(CircularProgressIndicator), findsOneWidget);

    surveyResultController.addError(UiError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget); // reload button
    expect(find.text('Question'), findsNothing); // a survey's question

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

  testWidgets('Should present valid data if surveyResultStream succeeds',
      (WidgetTester tester) async {
    await loadPage(tester);
    // expect(find.byType(CircularProgressIndicator), findsOneWidget);

    surveyResultController.add(FakeSurveyResultFactory.makeViewModel());
    await mockNetworkImagesFor(
      () async => await tester.pump(),
    );

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsNothing);
    expect(find.text('Recarregar'), findsNothing); // reload button
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);

    // find by color: https://stackoverflow.com/questions/59190126/check-for-color-during-widget-test

    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisabledIcon), findsOneWidget);

    final networkImage =
        tester.widget<Image>(find.byType(Image)).image as NetworkImage;

    expect(networkImage.url, 'Image 0');
  });

  testWidgets('Should logout', (WidgetTester tester) async {
    // Material App above was changed to GetMaterialApp and a fake login was created
    await loadPage(tester);

    isSessionExpiredController.add(true);
    await tester.pumpAndSettle();

    expect(currentRoute, '/login');
    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets("Should not logout", (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(false);
    await tester
        .pump(); // using only pump because the navigation will not occur and pumpAndSettle will timeout because of that
    expect(currentRoute, '/survey_result/any_survey_id');

    isSessionExpiredController.add(null);
    await tester
        .pump(); // using only pump because the navigation will not occur and pumpAndSettle will timeout because of that
    expect(currentRoute, '/survey_result/any_survey_id');
  });

  testWidgets('Should call save on list item click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(FakeSurveyResultFactory.makeViewModel());
    await mockNetworkImagesFor(
      () async => await tester.pump(),
    );

    await tester.tap(find.text('Answer 1'));

    verify(presenter.save(answer: 'Answer 1')).called(1);
  });

  testWidgets('Should not call save on current answer click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.add(FakeSurveyResultFactory.makeViewModel());
    await mockNetworkImagesFor(
      () async => await tester.pump(),
    );

    await tester.tap(find.text('Answer 0'));

    verifyNever(presenter.save(answer: 'Answer 0'));
  });
}
