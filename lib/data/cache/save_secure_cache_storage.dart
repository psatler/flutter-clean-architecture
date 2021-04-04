import 'package:meta/meta.dart';

// used by the SecureStorageAdapter
abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({
    @required String key,
    @required String value,
  });
}
