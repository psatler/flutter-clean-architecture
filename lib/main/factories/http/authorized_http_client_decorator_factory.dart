import '../../factories/factories.dart';
import '../../decorators/decorators.dart';

import '../../../data/http/http.dart';

HttpClient makeAuthorizeHttpClientDecorator() {
  return AuthorizeHttpClientDecorator(
    fetchSecureCacheStorage: makeLocalStorageAdapter(),
    decoratee: makeHttpAdapter(),
  );
}
