# flutter_clean_arch

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Backend

The swagger documentation to communicate with the backend can be found [here](http://fordevs.herokuapp.com/api-docs/#/) 

## Third party packages

> #### Dependencies
- [Meta](https://pub.dev/packages/meta): Annotations for Static Analysis
- [Http](https://pub.dev/packages/http/install): A composable, Future-based library for making HTTP requests.

> #### Dev Dependencies
- [Test](https://pub.dev/packages/test): provides a standard way of writing and running tests in Dart.
- [Mockito](https://pub.dev/packages/mockito): Mock library for Dart inspired by the [Java's Mockito library](https://github.com/mockito/mockito).
- [Faker](https://pub.dev/packages/faker): A library for Dart that generates fake data.


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
      "type": "dart"
    }
  ]
}
```
