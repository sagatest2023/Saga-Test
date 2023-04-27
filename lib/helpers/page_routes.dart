import 'package:get/route_manager.dart';
import 'package:saga_test/convocacao/convocacao_page.dart';

import '../login/login_page.dart';

abstract class Pages {
  static final routes = <GetPage>[
    GetPage(name: PagesRoutes.login, page: () => LoginPage()),
    GetPage(name: PagesRoutes.convocacao, page: () => const ConvocacaoPage()),
  ];
}

abstract class PagesRoutes {
  static const String login = '/login';
  static const String convocacao = '/convocacao';
}
