import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/data/http/http.dart';
import 'package:flutter_clean_arch/data/usecases/usecases.dart';

import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/domain/helpers/helpers.dart';

import '../../../mocks/fake_surveys_factory.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteLoadSurveys sut;
  HttpClientSpy httpClient;
  String url;
  List<Map> validDataList;

  PostExpectation mockRequest() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
        ),
      );

  void mockHttpData(List<Map> data) {
    validDataList = data; // storing to compare the list later in the tests
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);

    mockHttpData(FakeSurveysFactory.makeApiJson());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveys on 200', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
        id: validDataList[0]['id'],
        question: validDataList[0]['question'],
        dateTime: DateTime.parse(validDataList[0]['date']),
        didAnswer: validDataList[0]['didAnswer'],
      ),
      SurveyEntity(
        id: validDataList[1]['id'],
        question: validDataList[1]['question'],
        dateTime: DateTime.parse(validDataList[1]['date']),
        didAnswer: validDataList[1]['didAnswer'],
      ),
    ]);
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with Invalid data',
      () async {
    mockHttpData(FakeSurveysFactory.makeInvalidApiJson());

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
