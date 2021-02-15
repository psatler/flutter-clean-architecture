// the app entry point, where we define global styles, etc
// it will can the login page

import 'package:flutter/material.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey app - Clean Architecture',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
