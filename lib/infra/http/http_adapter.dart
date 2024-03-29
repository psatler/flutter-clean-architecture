import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
      });
    final uriUrl = Uri.parse(url);

    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500); // defaulting to 500

    try {
      if (method == 'post') {
        response = await client
            .post(
              uriUrl,
              headers: defaultHeaders,
              body: jsonBody,
            )
            .timeout(Duration(seconds: 10));
      } else if (method == 'get') {
        response = await client
            .get(
              uriUrl,
              headers: defaultHeaders,
            )
            .timeout(Duration(seconds: 10));
      } else if (method == 'put') {
        response = await client
            .put(
              uriUrl,
              headers: defaultHeaders,
              body: jsonBody,
            )
            .timeout(Duration(seconds: 10));
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.isEmpty ? null : jsonDecode(response.body);

      case 204:
        return null;

      case 400:
        throw HttpError.badRequest;

      case 401:
        throw HttpError.unauthorized;

      case 403:
        throw HttpError.forbidden;

      case 404:
        throw HttpError.notFound;

      default:
        throw HttpError.serverError;
    }
  }
}
