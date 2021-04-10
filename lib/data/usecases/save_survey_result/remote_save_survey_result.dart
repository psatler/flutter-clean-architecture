import 'package:meta/meta.dart';

import '../../models/models.dart';

import '../../../data/http/http.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({
    @required this.url,
    @required this.httpClient,
  });

  Future<SurveyResultEntity> save({String answer}) async {
    try {
      final jsonResponse = await httpClient.request(
        url: url,
        method: 'put',
        body: {
          'answer': answer,
        },
      );

      return RemoteSurveyResultModel.fromJson(jsonResponse).toEntity();
    } on HttpError catch (error) {
      HttpError.forbidden == error
          ? throw DomainError.accessDenied
          : throw DomainError.unexpected;
    }
  }
}
