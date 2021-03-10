import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_clean_arch/ui/helpers/errors/errors.dart';
import 'package:flutter_clean_arch/ui/pages/pages.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  SignUpPresenter presenter;
  StreamController<UiError> nameErrorController;
  StreamController<UiError> emailErrorController;
  StreamController<UiError> passwordErrorController;
  StreamController<UiError> passwordConfirmationErrorController;
  StreamController<bool> isFormValidController;

  void initStreams() {
    nameErrorController = StreamController<UiError>();
    emailErrorController = StreamController<UiError>();
    passwordErrorController = StreamController<UiError>();
    passwordConfirmationErrorController = StreamController<UiError>();
    isFormValidController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    isFormValidController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();

    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter)),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    // as LoginPage uses material components, we surround it with MaterialApp
    await loadPage(tester);

    final nameTextChildren = find.descendant(
      of: find.bySemanticsLabel('Nome'),
      matching: find.byType(Text),
    );
    expect(
      nameTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means it has no errors, since at least one of the children is always the label text',
    ); // it will not find any errorText in the textFormField initially

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

    final passwordConfirmationTextChildren = find.descendant(
      of: find.bySemanticsLabel('Confirmar senha'),
      matching: find.byType(Text),
    );
    expect(
      passwordConfirmationTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means it has no errors, since at least one of the children is always the label text',
    );

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null); // initially, the button should be disabled
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    // we'll simulate an email is being typed and validate it
    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), password);
    verify(presenter.validatePasswordConfirmation(password));
  });

  testWidgets('Should present email error', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UiError.invalidadField);
    // after emitting the event, we need to rerender the UI to reflect the changes
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    emailErrorController.add(UiError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);

    emailErrorController.add(null);
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

  testWidgets('Should present name error', (WidgetTester tester) async {
    await loadPage(tester);

    nameErrorController.add(UiError.invalidadField);
    // after emitting the event, we need to rerender the UI to reflect the changes
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    nameErrorController.add(UiError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);

    nameErrorController.add(null);
    await tester.pump();
    // getting the children of Email Text Field
    expect(
      find.descendant(
          of: find.bySemanticsLabel('Nome'), matching: find.byType(Text)),
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means it has no errors, since at least one of the children is always the label text',
    );
  });

  testWidgets('Should present password error', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(UiError.invalidadField);
    // after emitting the event, we need to rerender the UI to reflect the changes
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    passwordErrorController.add(UiError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);

    passwordErrorController.add(null);
    await tester.pump();
    // getting the children of Email Text Field
    expect(
      find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means it has no errors, since at least one of the children is always the label text',
    );
  });

  testWidgets('Should present password confirmation error',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordConfirmationErrorController.add(UiError.invalidadField);
    // after emitting the event, we need to rerender the UI to reflect the changes
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    passwordConfirmationErrorController.add(UiError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);

    passwordConfirmationErrorController.add(null);
    await tester.pump();
    // getting the children of Email Text Field
    expect(
      find.descendant(
          of: find.bySemanticsLabel('Confirmar senha'),
          matching: find.byType(Text)),
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means it has no errors, since at least one of the children is always the label text',
    );
  });

  testWidgets('Should enable button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    // after emitting the event, we need to rerender the UI to reflect the changes
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disable button if form is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    // after emitting the event, we need to rerender the UI to reflect the changes
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
  });
}
