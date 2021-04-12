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

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  GetxSurveyResultPresenter sut;
  LoadSurveyResultSpy loadSurveyResult;
  SaveSurveyResultSpy saveSurveyResult;
  SurveyResultEntity loadResult;
  SurveyResultEntity saveResult;
  String surveyId;
  String answer;

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
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveyResultError() =>
      mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);

  void mockAccessDeniedError() =>
      mockLoadSurveyResultCall().thenThrow(DomainError.accessDenied);

  PostExpectation mockSaveSurveyResultCall() =>
      when(saveSurveyResult.save(answer: anyNamed('answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => data);
  }

  setUp(() {
    surveyId = faker.guid.guid();
    answer = faker.lorem.sentence();
    loadSurveyResult = LoadSurveyResultSpy();
    saveSurveyResult = SaveSurveyResultSpy();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      saveSurveyResult: saveSurveyResult,
      surveyId: surveyId,
    );

    mockLoadSurveyResult(mockValidData());
    mockSaveSurveyResult(mockValidData());
  });

  group('load data', () {
    test('Should call LoadSurveyResult on loadData', () async {
      await sut.loadData();

      verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('Should emit correct events/streams on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(expectAsync1((result) => expect(
          result,
          SurveyResultViewModel(
              surveyId: loadResult.surveyId,
              question: loadResult.question,
              answers: [
                SurveyAnswerViewModel(
                    image: loadResult.answers[0].image,
                    answer: loadResult.answers[0].answer,
                    isCurrentAnswer: loadResult.answers[0].isCurrentAnswer,
                    percent: '${loadResult.answers[0].percent}%'),
                SurveyAnswerViewModel(
                    answer: loadResult.answers[1].answer,
                    isCurrentAnswer: loadResult.answers[1].isCurrentAnswer,
                    percent: '${loadResult.answers[1].percent}%')
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

    test('Should emit correct event on access denied', () async {
      mockAccessDeniedError();

      // expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.loadData();
    });
  });

  group('save', () {
    test('Should call SaveSurveyResult on save', () async {
      await sut.save(answer: answer);

      verify(saveSurveyResult.save(answer: answer)).called(1);
    });

    test('Should emit correct events/streams on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(expectAsync1((result) => expect(
          result,
          SurveyResultViewModel(
              surveyId: saveResult.surveyId,
              question: saveResult.question,
              answers: [
                SurveyAnswerViewModel(
                    image: saveResult.answers[0].image,
                    answer: saveResult.answers[0].answer,
                    isCurrentAnswer: saveResult.answers[0].isCurrentAnswer,
                    percent: '${saveResult.answers[0].percent}%'),
                SurveyAnswerViewModel(
                    answer: saveResult.answers[1].answer,
                    isCurrentAnswer: saveResult.answers[1].isCurrentAnswer,
                    percent: '${saveResult.answers[1].percent}%')
              ]))));

      await sut.save(answer: answer);
    });
  });
}
