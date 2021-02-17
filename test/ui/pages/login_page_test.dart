import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_clean_arch/ui/pages/pages.dart';

void main() {
  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    // as LoginPage uses material components, we surround it with MaterialApp
    final loginPage = MaterialApp(home: LoginPage());
    await tester.pumpWidget(loginPage);

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
}
