import '../../../domain/usecases/usecases.dart';
import '../../../data/usecases/usecases.dart';
import '../../composites/composites.dart';
import '../factories.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys'),
  );
}

LoadSurveys makeLocalLoadSurveys() =>
    LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());

LoadSurveys makeRemoteLoadSurveysWithLocalFallback() =>
    RemoteLoadSurveysWithLocalFallback(
      remote: makeRemoteLoadSurveys(),
      local: makeLocalLoadSurveys(),
    );
