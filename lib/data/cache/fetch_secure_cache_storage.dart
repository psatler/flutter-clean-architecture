// used by the SecureStorageAdapter
abstract class FetchSecureCacheStorage {
  Future<String> fetch(String key);
}
