import 'package:test/test.dart';

import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';

import 'package:flutter_clean_arch/infra/cache/cache.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  SecureStorageAdapter sut;
  FlutterSecureStorageSpy secureStorage;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('[adapter method] save', () {
    void mockSaveSecureError() {
      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenThrow(Exception());
    }

    test('Should call save secure with correct parameters', () async {
      await sut.save(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });

    // we won't treat the exception here at the infra layer, letting it to be handled at the data layer
    test('Should throw if secure throws', () async {
      mockSaveSecureError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(isA<Exception>()));
    });
  });

  group('[adapter method] fetch', () {
    PostExpectation mockFetchSecureCall() =>
        when(secureStorage.read(key: anyNamed('key')));

    void mockFetchSecure() {
      mockFetchSecureCall().thenAnswer((_) async => value);
    }

    void mockFetchSecureError() {
      mockFetchSecureCall().thenThrow(Exception());
    }

    setUp(() {
      mockFetchSecure();
    });

    test('Should call fetch secure with correct key', () async {
      await sut.fetch(key);

      verify(secureStorage.read(key: key));
    });

    test('Should return correct token on successful fetch performed', () async {
      final fetchedValue = await sut.fetch(key);

      expect(fetchedValue, value);
    });

    test('Should throw if fetch throws', () async {
      mockFetchSecureError();

      final future = sut.fetch(key);

      expect(future, throwsA(isA<Exception>()));
    });
  });

  group('Delete', () {
    void mockDeleteSecureError() {
      when(secureStorage.delete(key: anyNamed('key'))).thenThrow(Exception());
    }

    test('Should call delete with correct key', () async {
      await sut.delete(key);

      verify(secureStorage.delete(key: key)).called(1);
    });

    test('Should throw if delete throws', () async {
      mockDeleteSecureError();

      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
