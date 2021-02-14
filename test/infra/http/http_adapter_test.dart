import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:meta/meta.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;

    await client.post(
      url,
      headers: headers,
      body: jsonBody,
    );
  }
}

class ClientSpy extends Mock implements Client {
} // Client from the Http library

void main() {
  // making group of tests to leverage similar setups for the different groups under tests

  HttpAdapter sut;
  ClientSpy client;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('POST', () {
    test('Should call post with correct values', () async {
      final body = {'any_key': 'any_value'};
      await sut.request(
        url: url,
        method: 'post',
        body: body,
      );

      // verifying that we call client.post internally (inside the HttpAdater class)
      verify(client.post(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode(body),
      ));
    });

    test('Should call post without body', () async {
      await sut.request(url: url, method: 'post');

      // verifying that we call client.post internally (inside the HttpAdater class)
      verify(client.post(
        any,
        headers: anyNamed('headers'),
      ));
    });
  });
}
