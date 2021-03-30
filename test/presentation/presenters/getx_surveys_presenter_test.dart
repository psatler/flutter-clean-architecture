import 'package:flutter_clean_arch/domain/helpers/helpers.dart';
import 'package:flutter_clean_arch/ui/helpers/helpers.dart';
import 'package:get/get.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:intl/intl.dart';

import 'package:flutter_clean_arch/domain/usecases/usecases.dart';
import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/ui/pages/pages.dart';

class GetxSurveysPresenter implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  final _isLoading = true.obs;
  final _surveys = Rx<List<SurveyViewModel>>();

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GetxSurveysPresenter({
    @required this.loadSurveys,
  });

  Future<void> loadData() async {
    try {
      _isLoading.value = true; // dispatching an event to start loading
      List<SurveyEntity> surveys = await loadSurveys.load();

      _surveys.value = surveys
          .map((survey) => SurveyViewModel(
                id: survey.id,
                question: survey.question,
                date: DateFormat('dd MMM yyyy').format(survey.dateTime),
                didAnswer: survey.didAnswer,
              ))
          .toList();
    } on DomainError {
      _surveys.subject.addError(UiError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }
}

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  GetxSurveysPresenter sut;
  LoadSurveysSpy loadSurveys;
  List<SurveyEntity> surveys;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2021, 3, 29),
            didAnswer: true),
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2018, 10, 3),
            didAnswer: false),
      ];

  PostExpectation mockLoadSurveysCall() => when(loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveysError() =>
      mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);

    mockLoadSurveys(mockValidData());
  });
  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Should emit correct events/streams on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream
        .listen(expectAsync1((surveysExpect) => expect(surveysExpect, [
              SurveyViewModel(
                  id: surveys[0].id,
                  question: surveys[0].question,
                  date: '29 Mar 2021',
                  didAnswer: surveys[0].didAnswer),
              SurveyViewModel(
                  id: surveys[1].id,
                  question: surveys[1].question,
                  date: '03 Out 2018',
                  didAnswer: surveys[1].didAnswer),
            ])));

    await sut.loadData();
  });

  test('Should emit correct events/streams on failure', () async {
    mockLoadSurveysError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(null,
        onError: expectAsync1(
            (error) => expect(error, UiError.unexpected.description)));

    await sut.loadData();
  });
}
