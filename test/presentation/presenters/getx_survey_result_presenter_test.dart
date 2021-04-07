import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/domain/helpers/helpers.dart';
import 'package:flutter_clean_arch/domain/usecases/usecases.dart';
import 'package:flutter_clean_arch/presentation/presenters/presenters.dart';
import 'package:flutter_clean_arch/ui/helpers/helpers.dart';
import 'package:flutter_clean_arch/ui/pages/pages.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveysResult {}

void main() {
  GetxSurveyResultPresenter sut;
  LoadSurveyResultSpy loadSurveyResult;
  SurveyResultEntity surveyResult;
  String surveyId;

  SurveyResultEntity mockValidData() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
              image: faker.internet.httpUrl(),
              answer: faker.lorem.sentence(),
              percent: faker.randomGenerator.integer(100),
              isCurrentAnswer: faker.randomGenerator.boolean(),
            ),
            SurveyAnswerEntity(
              answer: faker.lorem.sentence(),
              percent: faker.randomGenerator.integer(100),
              isCurrentAnswer: faker.randomGenerator.boolean(),
            ),
          ]);

  PostExpectation mockLoadSurveyResultCall() =>
      when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    surveyResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveyResultError() =>
      mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);

  setUp(() {
    surveyId = faker.guid.guid();
    loadSurveyResult = LoadSurveyResultSpy();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      surveyId: surveyId,
    );

    mockLoadSurveyResult(mockValidData());
  });
  test('Should call LoadSurveyResult on loadData', () async {
    await sut.loadData();

    verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should emit correct events/streams on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(expectAsync1((result) => expect(
        result,
        SurveyResultViewModel(
            surveyId: surveyResult.surveyId,
            question: surveyResult.question,
            answers: [
              SurveyAnswerViewModel(
                  image: surveyResult.answers[0].image,
                  answer: surveyResult.answers[0].answer,
                  isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
                  percent: '${surveyResult.answers[0].percent}%'),
              SurveyAnswerViewModel(
                  answer: surveyResult.answers[1].answer,
                  isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
                  percent: '${surveyResult.answers[1].percent}%')
            ]))));

    await sut.loadData();
  });

  // test below is not working because I won't be able to add Error to stream
  // (stream.subject.addError complains about NoSuchMethodError)
  test('Should emit correct events/streams on failure', () async {
    mockLoadSurveyResultError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(null,
        onError: expectAsync1(
            (error) => expect(error, UiError.unexpected.description)));

    await sut.loadData();
  });
}
