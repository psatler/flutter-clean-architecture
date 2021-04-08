import 'package:meta/meta.dart';

// used by the SecureStorageAdapter
abstract class SaveSecureCacheStorage {
  Future<void> save({
    @required String key,
    @required String value,
  });
}
