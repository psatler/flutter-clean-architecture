import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/domain/helpers/helpers.dart';
import 'package:flutter_clean_arch/domain/usecases/usecases.dart';

import 'package:flutter_clean_arch/data/http/http.dart';
import 'package:flutter_clean_arch/data/usecases/usecases.dart';

import '../../../mocks/mocks.dart';

// mocks and spies
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  // sut = System Under Tests
  // AAA = arrange, act, assert

  RemoteAddAccount sut;
  HttpClientSpy httpClient;
  String url;
  AddAccountParams params;
  Map apiResult;

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpData(Map data) {
    apiResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = FakeParamsFactory.makeAddAccount();

    // by default, all tests are going to mock a success case
    mockHttpData(FakeAccountFactory.makeApiJson());
  });
  test('Should call HttpClient with correct URL', () async {
    await sut.add(params);

    // verifying we are calling the request method with the right URL and parameters
    verify(
      httpClient.request(
        url: url,
        method: 'post',
        body: {
          'name': params.name,
          'email': params.email,
          'password': params.password,
          'passwordConfirmation': params.passwordConfirmation,
        },
      ),
    );
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 403',
      () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    mockHttpData(apiResult);

    final account = await sut.add(params);

    expect(account.token, apiResult['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with Invalid data',
      () async {
    // mocking an invalid response from API
    mockHttpData({
      'invalid_key': 'invalid_value',
    });

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
