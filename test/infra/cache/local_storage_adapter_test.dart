import 'package:test/test.dart';

import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';

import 'package:flutter_clean_arch/infra/cache/cache.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  group('[adapter method] saveSecure', () {
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
  });

  group('[adapter method] fetchSecure', () {
    void mockFetchSecure() {
      when(secureStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => value);
    }

    setUp(() {
      mockFetchSecure();
    });

    test('Should call fetch secure with correct key', () async {
      await sut.fetchSecure(key);

      verify(secureStorage.read(key: key));
    });

    test('Should return correct token on successful fetch performed', () async {
      final fetchedValue = await sut.fetchSecure(key);

      expect(fetchedValue, value);
    });
  });
}
