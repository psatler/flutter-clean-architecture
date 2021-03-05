import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/domain/usecases/usecases.dart';
import 'package:flutter_clean_arch/ui/pages/pages.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({
    @required this.loadCurrentAccount,
  });

  var _navigateTo = RxString();

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> checkAccount() async {
    await loadCurrentAccount.load();

    _navigateTo.value = "/surveys";
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  GetxSplashPresenter sut;
  LoadCurrentAccountSpy loadCurrentAccount;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  test('Should call loadCurrentAccount', () async {
    await sut.checkAccount();

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to the surveys page on success', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkAccount();
  });
}
