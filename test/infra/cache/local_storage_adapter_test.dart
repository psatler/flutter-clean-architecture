import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/infra/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  LocalStorageAdapter sut;
  LocalStorageSpy localStorage;
  String key;
  dynamic value;

  void mockDeleteError() =>
      when(localStorage.deleteItem(any)).thenThrow(Exception());

  void mockSetError() =>
      when(localStorage.setItem(any, any)).thenThrow(Exception());

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);

    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });

  group('Save', () {
    test('Should call localStorage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(localStorage.deleteItem(key)).called(1);
      verify(localStorage.setItem(key, value)).called(1);
    });

    test('Should throw if delete item throws', () async {
      mockDeleteError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });

    test('Should throw if set item throws', () async {
      mockSetError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('Delete', () {
    test('Should delete localStorage cache with correct key', () async {
      await sut.delete(key);

      verify(localStorage.deleteItem(key)).called(1);
    });

    test('Should throw if delete item throws', () async {
      mockDeleteError();

      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('Fetch', () {
    test('Should call localStorage with correct value', () async {
      await sut.fetch(key);

      verify(localStorage.getItem(key)).called(1);
    });
  });
}
