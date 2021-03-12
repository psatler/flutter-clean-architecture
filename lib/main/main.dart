// it is the composition root: the main layer will know all the other layers and will
// control which page are called, etc

// so the main layer will be coupled to all other layers, so that the others ones
// can stay decouples from one another

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

// import '../utils/i18n/resources.dart';
import '../ui/components/components.dart';
import 'factories/factories.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  // R.load(Locale('en', 'US')); // we can load the language here before running the app

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light); // to keep status bar white on iOS

    return GetMaterialApp(
      title: 'Survey app - Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: makeTheme(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: makeSplashPage, transition: Transition.fade),
        GetPage(
            name: '/login', page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(name: '/signup', page: makeSignUpPage),
        GetPage(
            name: '/surveys',
            page: () => Scaffold(body: Text('Surveys')),
            transition: Transition.fadeIn),
      ],
    );
  }
}
