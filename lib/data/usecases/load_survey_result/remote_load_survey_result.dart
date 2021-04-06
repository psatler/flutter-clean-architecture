import 'package:flutter_clean_arch/data/http/http.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteLoadSurveyResult implements LoadSurveysResult {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveyResult({
    @required this.url,
    @required this.httpClient,
  });

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final jsonResponse = await httpClient.request(url: url, method: 'get');

      return RemoteSurveyResultModel.fromJson(jsonResponse).toEntity();
    } on HttpError catch (error) {
      HttpError.forbidden == error
          ? throw DomainError.accessDenied
          : throw DomainError.unexpected;
    }
  }
}
