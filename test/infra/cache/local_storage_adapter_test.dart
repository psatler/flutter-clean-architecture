import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:flutter_clean_arch/data/cache/cache.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({
    @required this.secureStorage,
  });

  @override
  Future<void> saveSecure({
    @required String key,
    @required String value,
  }) async {
    await secureStorage.write(key: key, value: value);
  }
}

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  LocalStorageAdapter sut;
  FlutterSecureStorageSpy secureStorage;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  void mockSaveSecureError() {
    when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  test('Should call save secure with correct parameters', () async {
    await sut.saveSecure(key: key, value: value);

    verify(secureStorage.write(key: key, value: value));
  });

// we won't treat the exception here at the infra layer, letting it to be handled at the data layer
  test('Should throw if secure throws', () async {
    mockSaveSecureError();

    final future = sut.saveSecure(key: key, value: value);

    expect(future, throwsA(isA<Exception>()));
  });
}
