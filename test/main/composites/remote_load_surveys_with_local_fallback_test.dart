import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_arch/data/usecases/load_surveys/load_surveys.dart';
import 'package:flutter_clean_arch/domain/entities/entities.dart';

class RemoteLoadSurveysWithLocalFallback {
  final RemoteLoadSurveys remote;

  RemoteLoadSurveysWithLocalFallback({
    @required this.remote,
  });

  Future<void> load() async {
    await remote.load();
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

void main() {
  RemoteLoadSurveysWithLocalFallback sut;
  RemoteLoadSurveysSpy remote;

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote);
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });
}
