import '../../../domain/usecases/usecases.dart';
import '../../../data/usecases/usecases.dart';
import '../../composites/composites.dart';
import '../factories.dart';

LoadSurveysResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys/$surveyId/results'),
  );
}

LoadSurveysResult makeLocalLoadSurveyResult(String surveyId) {
  return LocalLoadSurveyResult(
    cacheStorage: makeLocalStorageAdapter(),
  );
}

LoadSurveysResult makeRemoteLoadSurveyWithLocalFallback(String surveyId) {
  return RemoteLocalSurveyResultWithLocalFallback(
    remote: makeRemoteLoadSurveyResult(surveyId),
    local: makeLocalLoadSurveyResult(surveyId),
  );
}
