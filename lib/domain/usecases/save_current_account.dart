import '../entities/entities.dart';

abstract class SaveCurrentAccount {
  // it won't know if the save is secure or not. This will be CacheStorage's responsibility
  Future<void> save(AccountEntity account);
}
