import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:meta/meta.dart';

import 'package:flutter_clean_arch/data/http/http_client.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(
      url,
      headers: headers,
      body: jsonBody,
    );

    return jsonDecode(response.body);
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
      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

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
      when(client.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      await sut.request(url: url, method: 'post');

      // verifying that we call client.post internally (inside the HttpAdater class)
      verify(client.post(
        any,
        headers: anyNamed('headers'),
      ));
    });

    test('Should return data if post returns 200', () async {
      when(client.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });
  });
}
