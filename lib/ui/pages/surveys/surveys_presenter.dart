import 'survey_view_model.dart';

abstract class SurveysPresenter {
  Stream<List<SurveyViewModel>> get surveysStream;

  Future<void> loadData();
}
