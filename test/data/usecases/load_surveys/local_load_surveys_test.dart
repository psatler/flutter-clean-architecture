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
  group('Load', () {
    LocalLoadSurveys sut;
    CacheStorageSpy cacheStorage;
    List<Map> data;

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> dataList) {
      data = dataList;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);

      mockFetch(FakeSurveysFactory.makeCacheJson());
    });

    test('Should call fetchCacheStorage with correct key', () async {
      await sut.load();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
            id: data[0]['id'],
            question: data[0]['question'],
            dateTime: DateTime.utc(2021, 4, 2),
            didAnswer: false),
        SurveyEntity(
            id: data[1]['id'],
            question: data[1]['question'],
            dateTime: DateTime.utc(2021, 3, 29),
            didAnswer: true),
      ]);
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is null', () async {
      mockFetch(null);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch(FakeSurveysFactory.makeInvalidCacheJson());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(FakeSurveysFactory.makeIncompleteCacheJson());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache library throws', () async {
      mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('Validate', () {
    LocalLoadSurveys sut;
    CacheStorageSpy cacheStorage;
    List<Map> data;

    PostExpectation mockFetchCall() => when(cacheStorage.fetch(any));

    void mockFetch(List<Map> dataList) {
      data = dataList;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);

      mockFetch(FakeSurveysFactory.makeCacheJson());
    });

    test('Should call cache with correct key', () async {
      await sut.validate();

      verify(cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it invalid', () async {
      mockFetch(FakeSurveysFactory.makeInvalidCacheJson());

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch(FakeSurveysFactory.makeIncompleteCacheJson());

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if cache lib throws', () async {
      mockFetchError();

      await sut.validate();

      verify(cacheStorage.delete('surveys')).called(1);
    });
  });

  group('Save', () {
    LocalLoadSurveys sut;
    CacheStorageSpy cacheStorage;
    List<SurveyEntity> surveys;

    PostExpectation mockSaveCall() =>
        when(cacheStorage.save(key: anyNamed('key'), value: anyNamed('value')));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);

      surveys = FakeSurveysFactory.makeEntities();
    });

    test('Should call cacheStorage with correct values (key and value)',
        () async {
      final surveysList = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': '2020-02-02T00:00:00.000Z',
          'didAnswer': 'true',
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': '2021-03-03T00:00:00.000Z',
          'didAnswer': 'false',
        }
      ];

      await sut.save(surveys);

      verify(cacheStorage.save(key: 'surveys', value: surveysList)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      mockSaveError();

      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
