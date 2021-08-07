import 'package:flutter/material.dart';
import 'package:pictive_app_mvp/routes/login_page.dart';
import 'package:pictive_app_mvp/routes/overview_page.dart';
import 'package:pictive_app_mvp/routes/registration_page.dart';

class RouteGenerator {

  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case LoginPage.ROUTE_ID:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RegistrationPage.ROUTE_ID:
        return MaterialPageRoute(builder: (_) => const RegistrationPage());
      case OverviewPage.ROUTE_ID:
        return MaterialPageRoute(builder: (_) => const OverviewPage());
      default:
        throw RouteException("No such route: ${routeSettings.name}");
    }

  }

}

class RouteException implements Exception {
  final String message;

  const RouteException(this.message);
}