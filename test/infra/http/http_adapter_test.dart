import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/data/http/http.dart';

import 'package:flutter_clean_arch/infra/http/http.dart';

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
    PostExpectation mockRequest() => when(
        client.post(any, headers: anyNamed('headers'), body: anyNamed('body')));

    // success cases don't need a body as argument as we already set one as default
    void mockResponse(int statusCode,
        {String body = '{"any_key": "any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    // group setup
    setUp(() {
      mockResponse(200);
    });

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

    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockResponse(200, body: ''); // overriding mock

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockResponse(400);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });
  });
}
