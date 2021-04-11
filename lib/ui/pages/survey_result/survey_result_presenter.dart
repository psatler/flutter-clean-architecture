import 'package:meta/meta.dart';

import 'survey_result_view_model.dart';

abstract class SurveyResultPresenter {
  Stream<bool> get isLoadingStream;
  Stream<bool> get isSessionExpiredStream;
  Stream<SurveyResultViewModel> get surveyResultStream;

  Future<void> loadData();
  Future<void> save({@required String answer});
}
