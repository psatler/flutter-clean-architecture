import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/surveys/surveys.dart';
import '../mixins/mixins.dart';

class GetxSurveysPresenter with SessionManager implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  final _surveys = Rx<List<SurveyViewModel>>(null);
  final _navigateTo = RxString(null);

  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;

  GetxSurveysPresenter({
    @required this.loadSurveys,
  });

  Future<void> loadData() async {
    try {
      List<SurveyEntity> surveys = await loadSurveys.load();

      _surveys.value = surveys
          .map((survey) => SurveyViewModel(
                id: survey.id,
                question: survey.question,
                date: DateFormat('dd MMM yyyy').format(survey.dateTime),
                didAnswer: survey.didAnswer,
              ))
          .toList();
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        print(UiError.unexpected.description);
        // _surveys.addError(UiError.unexpected.description);
        // _surveys.subject.addError(UiError.unexpected.description);
      }
    }
  }

  void goToSurveyResult(String surveyId) {
    _navigateTo.value = '/survey_result/$surveyId';
  }
}
