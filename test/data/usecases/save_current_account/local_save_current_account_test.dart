import 'package:faker/faker.dart';
import 'package:flutter_clean_arch/domain/helpers/helpers.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/domain/usecases/usecases.dart';

// implementing an usecase
class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({
    @required this.saveSecureCacheStorage,
  });

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(
        key: 'token',
        value: account.token,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({
    @required String key,
    @required String value,
  });
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorageSpy saveSecureCacheStorage;
  AccountEntity accountEntity;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    final token = faker.guid.guid();
    accountEntity = AccountEntity(token);
  });

  void mockError() {
    when(saveSecureCacheStorage.saveSecure(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(accountEntity);

    verify(
      saveSecureCacheStorage.saveSecure(
          key: 'token', value: accountEntity.token),
    );
  });

  test(
      'Should throw UnexpectedError if SaveSecureCacheStorage throws any error',
      () async {
    mockError();

    final future = sut.save(accountEntity);

    expect(future, throwsA(DomainError.unexpected));
  });
}
