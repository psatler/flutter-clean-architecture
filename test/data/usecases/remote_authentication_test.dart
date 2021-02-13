import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// sut = System Under Tests
// AAA = arrange, act, assert

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void> request({@required String url}) async {}
}

// mocks and spies
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('Should call HttpClient with correct URL', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    await sut.auth();

    // verifying we are calling the request method with the right URL
    verify(httpClient.request(url: url));
  });
}
