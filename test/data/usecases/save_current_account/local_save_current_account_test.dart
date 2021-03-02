import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/data/cache/cache.dart';
import 'package:flutter_clean_arch/data/usecases/usecases.dart';

import 'package:flutter_clean_arch/domain/entities/entities.dart';
import 'package:flutter_clean_arch/domain/helpers/helpers.dart';

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
