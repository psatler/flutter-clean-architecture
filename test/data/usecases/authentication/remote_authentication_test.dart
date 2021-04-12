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

  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;
  AuthenticationParams params;
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
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = FakeParamsFactory.makeAuthentication();

    // by default, all tests are going to mock a success case
    mockHttpData(FakeAccountFactory.makeApiJson());
  });
  test('Should call HttpClient with correct URL', () async {
    await sut.auth(params);

    // verifying we are calling the request method with the right URL
    verify(
      httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password},
      ),
    );
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final account = await sut.auth(params);

    expect(account.token, apiResult['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with Invalid data',
      () async {
    mockHttpData({
      'invalid_key': 'invalid_value',
    });

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
