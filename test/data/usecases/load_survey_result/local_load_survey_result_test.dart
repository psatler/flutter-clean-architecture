import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/data/cache/cache.dart';
import 'package:flutter_clean_arch/data/usecases/usecases.dart';
import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/domain/helpers/helpers.dart';

import '../../../mocks/mocks.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('LoadBySurvey', () {
    LocalLoadSurveyResult sut;
    CacheStorageSpy cacheStorage;
    Map data;
    String surveyId;

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      surveyId = faker.guid.guid();
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);

      mockFetch(FakeSurveyResultFactory.makeCacheJson());
    });

    test('Should call cacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return a survey result on success', () async {
      final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

      expect(
        surveyResult,
        SurveyResultEntity(
          surveyId: data['surveyId'],
          question: data['question'],
          answers: [
            SurveyAnswerEntity(
              image: data['answers'][0]['image'],
              answer: data['answers'][0]['answer'],
              isCurrentAnswer: true,
              percent: 40,
            ),
            SurveyAnswerEntity(
              answer: data['answers'][1]['answer'],
              isCurrentAnswer: false,
              percent: 60,
            ),
          ],
        ),
      );
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch({});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is null', () async {
      mockFetch(null);

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch(FakeSurveyResultFactory.makeInvalidCacheJson());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(FakeSurveyResultFactory.makeIncompleteCacheJson());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache library throws', () async {
      mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('Validate', () {
    LocalLoadSurveyResult sut;
    CacheStorageSpy cacheStorage;
    Map data;
    String surveyId;

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      surveyId = faker.guid.guid();
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);

      mockFetch(FakeSurveyResultFactory.makeCacheJson());
    });

    test('Should call cache with correct key', () async {
      await sut.validate(surveyId);

      verify(cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it invalid', () async {
      mockFetch(FakeSurveyResultFactory.makeInvalidCacheJson());

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch(FakeSurveyResultFactory.makeIncompleteCacheJson());

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if cache lib throws', () async {
      mockFetchError();

      await sut.validate(surveyId);

      verify(cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('Save', () {
    LocalLoadSurveyResult sut;
    CacheStorageSpy cacheStorage;
    SurveyResultEntity surveyResult;

    PostExpectation mockSaveCall() =>
        when(cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);

      surveyResult = FakeSurveyResultFactory.mockSurveyResultEntity();
    });

    test('Should call cacheStorage with correct values (key and value)',
        () async {
      Map json = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'percent': '40',
            'isCurrentAnswer': 'true',
          },
          {
            'image': null,
            'answer': surveyResult.answers[1].answer,
            'percent': '60',
            'isCurrentAnswer': 'false',
          }
        ],
      };

      await sut.save(surveyResult);

      verify(cacheStorage.save(
              key: 'survey_result/${surveyResult.surveyId}', value: json))
          .called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      mockSaveError();

      final future = sut.save(surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
