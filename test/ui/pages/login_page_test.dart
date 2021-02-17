import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_clean_arch/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();

    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);

    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    // as LoginPage uses material components, we surround it with MaterialApp
    await loadPage(tester);

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );
    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means it has no errors, since at least one of the children is always the label text',
    ); // it will not find any errorText in the textFormField initially

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );
    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means it has no errors, since at least one of the children is always the label text',
    );

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null); // initially, the button should be disabled
  });

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    // we'll simulate an email is being typed and validate it
    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add('any error');
    // after emitting the event, we need to rerender the UI to reflect the changes
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should NOT present error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(null);
    // after emitting the event, we need to rerender the UI to reflect the changes
    await tester.pump();

    // getting the children of Email Text Field
    expect(
      find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means it has no errors, since at least one of the children is always the label text',
    );
  });

  testWidgets('Should NOT present error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add('');
    // after emitting the event, we need to rerender the UI to reflect the changes
    await tester.pump();

    // getting the children of Email Text Field
    expect(
      find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means it has no errors, since at least one of the children is always the label text',
    );
  });

  testWidgets('Should present error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add('any error');
    // after emitting the event, we need to rerender the UI to reflect the changes
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });
}
