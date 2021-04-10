import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/data/usecases/usecases.dart';

class RemoteLocalSurveyResultWithLocalFallback {
  final RemoteLoadSurveyResult remote;

  RemoteLocalSurveyResultWithLocalFallback({
    @required this.remote,
  });

  // Future<SurveyResultEntity> loadBySurvey({String surveyId});
  Future<void> loadBySurvey({String surveyId}) async {
    remote.loadBySurvey(surveyId: surveyId);
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

void main() {
  test('Should call remote LoadBySurvey', () async {
    final surveyId = faker.guid.guid();
    final remote = RemoteLoadSurveyResultSpy();
    final sut = RemoteLocalSurveyResultWithLocalFallback(remote: remote);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });
}
