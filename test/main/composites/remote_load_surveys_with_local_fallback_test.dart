import 'package:faker/faker.dart';
import 'package:flutter_clean_arch/domain/helpers/helpers.dart';

import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/data/usecases/usecases.dart';
import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/domain/usecases/usecases.dart';

class RemoteLocalSurveyResultWithLocalFallback implements LoadSurveysResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLocalSurveyResultWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  // Future<SurveyResultEntity> loadBySurvey({String surveyId});
  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      SurveyResultEntity surveyResult =
          await remote.loadBySurvey(surveyId: surveyId);

      await local.save(surveyResult);

      return surveyResult;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }
      await local.validate(surveyId);
      await local.loadBySurvey(surveyId: surveyId);
    }
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLocalSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  String surveyId;
  SurveyResultEntity surveyResult;

  SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
        surveyId: surveyId,
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: faker.randomGenerator.boolean(),
            percent: faker.randomGenerator.integer(100),
          ),
        ],
      );

  PostExpectation mockRemoteLoadCall() =>
      when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoad() {
    surveyResult = mockSurveyResult();
    mockRemoteLoadCall().thenAnswer((_) async => surveyResult);
  }

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLocalSurveyResultWithLocalFallback(
      remote: remote,
      local: local,
    );

    mockRemoteLoad();
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyResult)).called(1);
  });

  test('Should return remote data', () async {
    SurveyResultEntity response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, surveyResult);
  });

  test('Should rethrow if remote LoadBySurveys throws AccessDeniedError',
      () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local LoadBySurveys on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.validate(surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: surveyId)).called(1);
  });
}
