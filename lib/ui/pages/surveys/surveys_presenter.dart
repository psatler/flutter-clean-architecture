import 'survey_view_model.dart';

abstract class SurveysPresenter {
  Stream<List<SurveyViewModel>> get surveysStream;
  Stream<String> get navigateToStream;
  Stream<bool> get isSessionExpiredStream;

  Future<void> loadData();
  void goToSurveyResult(String surveyId);
}
