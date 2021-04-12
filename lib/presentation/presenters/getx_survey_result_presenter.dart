import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

import '../mixins/mixins.dart';

class GetxSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager
    implements SurveyResultPresenter {
  final LoadSurveysResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  final _surveyResult = Rx<SurveyResultViewModel>(null);
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    @required this.loadSurveyResult,
    @required this.saveSurveyResult,
    @required this.surveyId,
  });

  Future<void> loadData() async {
    _showResultOnAction(
        () => loadSurveyResult.loadBySurvey(surveyId: surveyId));
  }

  Future<void> save({@required String answer}) async {
    _showResultOnAction(() => saveSurveyResult.save(answer: answer));
  }

  // passing a function action without parameters
  Future<void> _showResultOnAction(Future<SurveyResultEntity> action()) async {
    try {
      isLoading = true;
      SurveyResultEntity surveyResult = await action();

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
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        print(UiError.unexpected.description);
        // _surveys.addError(UiError.unexpected.description);
        _surveyResult.subject.addError(UiError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }
}
