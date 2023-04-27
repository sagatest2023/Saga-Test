import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'helpers/page_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      title: 'Saga Test',
      initialRoute: PagesRoutes.login,
      defaultTransition: Transition.noTransition,
      getPages: Pages.routes,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
    );
  }
}
