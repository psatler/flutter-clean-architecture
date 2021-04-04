// used by the SecureStorageAdapter
abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}
