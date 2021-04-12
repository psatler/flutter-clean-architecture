import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_clean_arch/ui/pages/pages.dart';

import '../helpers/helpers.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  SplashPresenterSpy presenter;
  StreamController<String> navigateToController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    navigateToController = StreamController<String>();

    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);

    final splashPage = makePage(
      path: '/',
      pageBeingTested: () => SplashPage(presenter: presenter),
    );
    await tester.pumpWidget(splashPage);
  }

  tearDown(() {
    navigateToController.close();
  });

  testWidgets("Should display spinner on page load",
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Should call loadCurrentAccount on page load",
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.checkAccount()).called(1);
  });

  testWidgets("Should navigate to other page", (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets("Should not navigate to other page", (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester
        .pump(); // using only pump because the navigation will not occur and pumpAndSettle will timeout because of that
    expect(currentRoute, '/');

    navigateToController.add(null);
    await tester.pump();
    expect(currentRoute, '/');
  });
}
