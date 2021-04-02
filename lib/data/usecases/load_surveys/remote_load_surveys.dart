import 'package:flutter_clean_arch/data/http/http.dart';
import 'package:meta/meta.dart';

import '../../../data/models/models.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveys({
    @required this.url,
    @required this.httpClient,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final httpResponse = await httpClient.request(url: url, method: 'get');

      return httpResponse
          .map<SurveyEntity>(
              (json) => RemoteSurveyModal.fromJson(json).toEntity())
          .toList();
    } on HttpError catch (error) {
      HttpError.forbidden == error
          ? throw DomainError.accessDenied
          : throw DomainError.unexpected;
    }
  }
}
