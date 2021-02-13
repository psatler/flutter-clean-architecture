import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/domain/usecases/usecases.dart';
import 'package:flutter_clean_arch/data/http/http.dart';
import 'package:flutter_clean_arch/data/usecases/usecases.dart';

// mocks and spies
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  // sut = System Under Tests
  // AAA = arrange, act, assert

  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test('Should call HttpClient with correct URL', () async {
    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
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
}
