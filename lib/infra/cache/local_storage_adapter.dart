import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';

import '../../data/cache/cache_storage.dart';

class LocalStorageAdapter implements CacheStorage {
  final LocalStorage localStorage;

  LocalStorageAdapter({
    @required this.localStorage,
  });

  Future<void> save({
    @required String key,
    @required dynamic value,
  }) async {
    await localStorage.ready;
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }

  Future<void> delete(String key) async {
    await localStorage.ready;
    await localStorage.deleteItem(key);
  }

  Future<dynamic> fetch(String key) async {
    await localStorage.ready;
    return await localStorage.getItem(key);
  }
}
