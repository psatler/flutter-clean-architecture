import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/domain/helpers/helpers.dart';
import 'package:flutter_clean_arch/domain/usecases/usecases.dart';
import 'package:flutter_clean_arch/presentation/presenters/presenters.dart';
import 'package:flutter_clean_arch/ui/helpers/helpers.dart';
import 'package:flutter_clean_arch/ui/pages/pages.dart';

import '../../mocks/mocks.dart';

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

  PostExpectation mockLoadSurveyResultCall() =>
      when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveyResultError(DomainError error) =>
      mockLoadSurveyResultCall().thenThrow(error);

  PostExpectation mockSaveSurveyResultCall() =>
      when(saveSurveyResult.save(answer: anyNamed('answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => data);
  }

  void mockSaveSurveyResultError(DomainError error) =>
      mockSaveSurveyResultCall().thenThrow(error);

  SurveyResultViewModel mapToViewModel(SurveyResultEntity entity) =>
      SurveyResultViewModel(
          surveyId: entity.surveyId,
          question: entity.question,
          answers: [
            SurveyAnswerViewModel(
                image: entity.answers[0].image,
                answer: entity.answers[0].answer,
                isCurrentAnswer: entity.answers[0].isCurrentAnswer,
                percent: '${entity.answers[0].percent}%'),
            SurveyAnswerViewModel(
                answer: entity.answers[1].answer,
                isCurrentAnswer: entity.answers[1].isCurrentAnswer,
                percent: '${entity.answers[1].percent}%')
          ]);

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

    mockLoadSurveyResult(FakeSurveyResultFactory.mockSurveyResultEntity());
    mockSaveSurveyResult(FakeSurveyResultFactory.mockSurveyResultEntity());
  });

  group('load data', () {
    test('Should call LoadSurveyResult on loadData', () async {
      await sut.loadData();

      verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('Should emit correct events/streams on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(
          expectAsync1((result) => expect(result, mapToViewModel(loadResult))));

      await sut.loadData();
    });

    // test below is not working because I won't be able to add Error to stream
    // (stream.subject.addError complains about NoSuchMethodError)
    test('Should emit correct events/streams on failure', () async {
      mockLoadSurveyResultError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null,
          onError: expectAsync1(
              (error) => expect(error, UiError.unexpected.description)));

      await sut.loadData();
    });

    test('Should emit correct event on access denied', () async {
      mockLoadSurveyResultError(DomainError.accessDenied);

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
      expectLater(
          sut.surveyResultStream,
          emitsInOrder([
            mapToViewModel(loadResult),
            mapToViewModel(saveResult),
          ]));

      await sut.loadData();
      await sut.save(answer: answer);
    });

    test('Should emit correct events/streams on failure', () async {
      mockSaveSurveyResultError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null,
          onError: expectAsync1(
              (error) => expect(error, UiError.unexpected.description)));

      await sut.save(answer: answer);
    });

    test('Should emit correct event on access denied', () async {
      mockSaveSurveyResultError(DomainError.accessDenied);

      // expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.save(answer: answer);
    });
  });
}
