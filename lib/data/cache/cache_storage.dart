import 'package:meta/meta.dart';

// used by the LocalStorageAdapter
abstract class CacheStorage {
  Future<dynamic> fetch(String key);
  Future<void> delete(String key);
  Future<void> save({
    @required String key,
    @required dynamic value,
  });
}
