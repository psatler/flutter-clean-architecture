<p align="center">
  <img alt="GitHub top language" src="https://img.shields.io/github/languages/top/psatler/flutter-clean-architecture.svg">

  <img alt="GitHub language count" src="https://img.shields.io/github/languages/count/psatler/flutter-clean-architecture.svg">

  <img alt="Repository size" src="https://img.shields.io/github/repo-size/psatler/flutter-clean-architecture.svg">

  <img alt="Repository Last Commit Date" src="https://img.shields.io/github/last-commit/psatler/flutter-clean-architecture?color=blue">

  <a href="https://www.linkedin.com/in/pablosatler/">
    <img alt="Made by Pablo Satler" src="https://img.shields.io/badge/made%20by-Pablo%20Satler-blue">
  </a>

  <img alt="License" src="https://img.shields.io/github/license/psatler/flutter-clean-architecture?color=blue">

</p>

# Flutter Clean Architecture

A survey app developed with clean architecture and SOLID principles in mind


## Version

This was originally built using Flutter 1.22.6


## Backend

The swagger documentation for the backend the app communicate with can be found [here](http://fordevs.herokuapp.com/api-docs/#/) 

## Third party packages

> #### Dependencies
- [Meta](https://pub.dev/packages/meta): Annotations for Static Analysis
- [Http](https://pub.dev/packages/http/install): A composable, Future-based library for making HTTP requests.
- [Provider](https://pub.dev/packages/provider): A wrapper around InheritedWidget to make them easier to use and more reusable.
- [Equatable](https://pub.dev/packages/equatable): An abstract class that helps to implement equality without needing to explicitly override == and hashCode.
- [Get](https://pub.dev/packages/get): Open screens/snackbars/dialogs without context, manage states and inject dependencies easily with GetX. 
  - Pay attention that I'm using version `3.4.2` exactly.
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage): provides API to store data in secure storage. Keychain is used in iOS, KeyStore based solution is used in Android.
  - We need to modify the minSdkVersion to 18 in the `build.gradle` file in the Android project

> #### Dev Dependencies
- [Test](https://pub.dev/packages/test): provides a standard way of writing and running tests in Dart.
- [Mockito](https://pub.dev/packages/mockito): Mock library for Dart inspired by the [Java's Mockito library](https://github.com/mockito/mockito).
- [Faker](https://pub.dev/packages/faker): A library for Dart that generates fake data.
- [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons): A command-line tool which simplifies the task of updating your Flutter app's launcher icon. More complex settings [with flavors can be found here](https://github.com/fluttercommunity/flutter_launcher_icons/tree/master/example/flavors).
  - the configuration done can be found at the end of the [pubspec.yaml](pubspec.yaml) file.
  - more pieces of information about _adaptive icons_ can be found [here](https://medium.com/google-design/designing-adaptive-icons-515af294c783).
  - you need to run the command specified in the [library's docs](https://pub.dev/packages/flutter_launcher_icons#book-guide): `flutter pub run flutter_launcher_icons:main`



## VSCode configurations

On the Run tab at the left side you can create a `launch.json` configuration to run the application as well as their tests. You can add default configuration too, such as
_Flutter run all tests_, so you can run all the tests by pressing **F5**.

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter: Run all Tests",
      "type": "dart",
      "request": "launch",
      "program": "./test/"
    },
    {
      "name": "flutter_clean_arch",
      "request": "launch",
      "type": "dart",
      "program": "./lib/main/main.dart"
    }
  ]
}
```

##### Snippets

Also, it was created a snippets to help initialize the boilerplate for tests.
To create a snippet, goes to `File -> Preferences -> User Snippets` and then
create a `dart.json` file. The snippet create use `darttest` as a shortcut.

```json
{
	"Flutter unit tests": {
		"prefix": "darttest",
		"body": [
			"import 'package:test/test.dart';",
			"",
			"void main() {",
			" test('', () {});",
			"}"
		],
		"description": "Initial boilerplate for test code"
	}
}
```

## Aknowledgements

- [This article](https://medium.com/flutter-community/flutter-design-patterns-0-introduction-5e88cfff6792) shows several design patterns applied to Flutter.

