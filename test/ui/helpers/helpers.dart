import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget makePage({
  @required String path,
  @required Widget Function() pageBeingTested,
}) {
  final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

  final getPages = [
    GetPage(name: path, page: pageBeingTested),
    GetPage(
        name: '/any_route',
        page: () => Scaffold(
              appBar: AppBar(title: Text('any title')),
              body: Text('fake page'),
            )),
  ];

  if (path != '/login') {
    getPages.add(GetPage(
        name: '/login', page: () => Scaffold(body: Text('fake login'))));
  }

  return GetMaterialApp(
    initialRoute: path,
    navigatorObservers: [routeObserver],
    getPages: getPages,
  );
}

String get currentRoute => Get.currentRoute;
