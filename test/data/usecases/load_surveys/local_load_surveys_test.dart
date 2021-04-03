import 'package:faker/faker.dart';
import 'package:flutter_clean_arch/data/models/models.dart';
import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/domain/helpers/helpers.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({
    @required this.fetchCacheStorage,
  });

  Future<List<SurveyEntity>> load() async {
    final data = await fetchCacheStorage.fetch('surveys');

    if (data == null || data.isEmpty) {
      throw DomainError.unexpected;
    }

    return data
        .map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity())
        .toList();
  }
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

abstract class FetchCacheStorage {
  Future<dynamic> fetch(String key);
}

void main() {
  LocalLoadSurveys sut;
  FetchCacheStorageSpy fetchCacheStorage;
  List<Map> data;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2021-04-02T00:00:00Z',
          'didAnswer': 'false',
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2021-03-29T00:00:00Z',
          'didAnswer': 'true',
        }
      ];

  void mockFetch(List<Map> dataList) {
    data = dataList;
    when(fetchCacheStorage.fetch(any)).thenAnswer((_) async => data);
  }

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);

    mockFetch(mockValidData());
  });

  test('Should call fetchCacheStorage with correct key', () async {
    await sut.load();

    verify(fetchCacheStorage.fetch('surveys')).called(1);
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
}
