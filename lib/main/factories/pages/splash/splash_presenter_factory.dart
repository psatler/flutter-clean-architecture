import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';
import '../../usecases/usecases.dart';

SplashPresenter makeGetxSplashPresenter() {
  return GetxSplashPresenter(
    loadCurrentAccount: makeLocalLoadCurrentAccount(),
  );
}
