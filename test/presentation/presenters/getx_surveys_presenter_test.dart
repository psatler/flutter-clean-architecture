import 'dart:math';

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/domain/helpers/helpers.dart';
import 'package:flutter_clean_arch/domain/usecases/usecases.dart';
import 'package:flutter_clean_arch/presentation/presenters/presenters.dart';
import 'package:flutter_clean_arch/ui/pages/pages.dart';

import '../../mocks/mocks.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  GetxSurveysPresenter sut;
  LoadSurveysSpy loadSurveys;
  List<SurveyEntity> surveys;

  PostExpectation mockLoadSurveysCall() => when(loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveysError() =>
      mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  void mockAccessDeniedError() =>
      mockLoadSurveysCall().thenThrow(DomainError.accessDenied);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);

    mockLoadSurveys(FakeSurveysFactory.makeEntities());
  });
  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Should emit correct events/streams on success', () async {
    sut.surveysStream
        .listen(expectAsync1((surveysExpect) => expect(surveysExpect, [
              SurveyViewModel(
                  id: surveys[0].id,
                  question: surveys[0].question,
                  date: '02 Feb 2020',
                  didAnswer: surveys[0].didAnswer),
              SurveyViewModel(
                  id: surveys[1].id,
                  question: surveys[1].question,
                  date: '03 Mar 2021',
                  didAnswer: surveys[1].didAnswer),
            ])));

    await sut.loadData();
  });

  test('Should go to SurveyResult page on survey click', () async {
    // when clicking two times, we should see two events being emitted
    expectLater(
        sut.navigateToStream,
        emitsInOrder([
          '/survey_result/any_route',
          '/survey_result/any_route',
        ]));

    sut.goToSurveyResult('any_route');
    sut.goToSurveyResult('any_route');
  });

  // test below is not working because I won't be able to add Error to stream
  // (stream.subject.addError complains about NoSuchMethodError)
  // test('Should emit correct events/streams on failure', () async {
  //   mockLoadSurveysError();

  //   sut.surveysStream.listen(null,
  //       onError: expectAsync1(
  //           (error) => expect(error, UiError.unexpected.description)));

  //   await sut.loadData();
  // });

  test('Should emit correct event on access denied', () async {
    mockAccessDeniedError();

    // expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });
}
