import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final DeleteSecureCacheStorage deleteSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
    @required this.deleteSecureCacheStorage,
    @required this.decoratee,
  });

  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body, // optional
    Map headers,
  }) async {
    try {
      final String token = await fetchSecureCacheStorage.fetchSecure('token');
      final authorizedHeaders = headers ?? {}
        ..addAll({'x-access-token': token});

      final response = await decoratee.request(
        url: url,
        method: method,
        body: body,
        headers: authorizedHeaders,
      );

      return response;
    } catch (error) {
      if (error is HttpError && error != HttpError.forbidden) {
        rethrow;
      }

      await deleteSecureCacheStorage.deleteSecure('token');
      throw HttpError.forbidden;
    }
  }
}
