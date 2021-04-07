import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveyResultPresenter implements SurveyResultPresenter {
  final LoadSurveysResult loadSurveyResult;
  final String surveyId;

  final _isLoading = true.obs;
  final _surveyResult = Rx<SurveyResultViewModel>(null);

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    @required this.loadSurveyResult,
    @required this.surveyId,
  });

  Future<void> loadData() async {
    try {
      _isLoading.value = true;

      SurveyResultEntity surveyResult =
          await loadSurveyResult.loadBySurvey(surveyId: surveyId);

      _surveyResult.value = SurveyResultViewModel(
        surveyId: surveyResult.surveyId,
        question: surveyResult.question,
        answers: surveyResult.answers
            .map((answer) => SurveyAnswerViewModel(
                  image: answer.image,
                  answer: answer.answer,
                  isCurrentAnswer: answer.isCurrentAnswer,
                  percent: '${answer.percent}%',
                ))
            .toList(),
      );
    } on DomainError {
      print(UiError.unexpected.description);
      // _surveys.addError(UiError.unexpected.description);
      _surveyResult.subject.addError(UiError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }
}
