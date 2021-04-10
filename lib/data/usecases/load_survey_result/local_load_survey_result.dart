import 'package:meta/meta.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';

import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveyResult implements LoadSurveysResult {
  final CacheStorage cacheStorage;

  LocalLoadSurveyResult({
    @required this.cacheStorage,
  });

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');

      if (data == null || data.isEmpty) {
        throw Exception();
      }

      return LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
