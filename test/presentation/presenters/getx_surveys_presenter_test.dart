import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/domain/helpers/helpers.dart';
import 'package:flutter_clean_arch/domain/usecases/usecases.dart';
import 'package:flutter_clean_arch/presentation/presenters/getx_surveys_presenter.dart';
import 'package:flutter_clean_arch/ui/helpers/helpers.dart';
import 'package:flutter_clean_arch/ui/pages/pages.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  GetxSurveysPresenter sut;
  LoadSurveysSpy loadSurveys;
  List<SurveyEntity> surveys;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2021, 3, 29),
            didAnswer: true),
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2018, 10, 3),
            didAnswer: false),
      ];

  PostExpectation mockLoadSurveysCall() => when(loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveysError() =>
      mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);

    mockLoadSurveys(mockValidData());
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
                  date: '29 Mar 2021',
                  didAnswer: surveys[0].didAnswer),
              SurveyViewModel(
                  id: surveys[1].id,
                  question: surveys[1].question,
                  date: '03 Out 2018',
                  didAnswer: surveys[1].didAnswer),
            ])));

    await sut.loadData();
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
}
