import 'package:flutter/material.dart';
import 'package:pictive_app_mvp/routes/queries/image_grid_page.dart';
import 'package:pictive_app_mvp/routes/login_page.dart';
import 'package:pictive_app_mvp/routes/overview_page.dart';
import 'package:pictive_app_mvp/routes/registration_page.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case LoginPage.routeID:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RegistrationPage.routeID:
        return MaterialPageRoute(builder: (_) => const RegistrationPage());
      case OverviewPage.routeID:
        return MaterialPageRoute(builder: (_) => const OverviewPage());
      case ImageGridPage.routeID:
        final List<String> args = routeSettings.arguments! as List<String>;
        return _withPageRouteBuilder(ImageGridPage(args[0], args[1]), routeSettings);
      default:
        throw RouteException("No such route: ${routeSettings.name}");
    }
  }

  static Route<dynamic> _withPageRouteBuilder(Widget child, RouteSettings routeSettings) {
    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

class RouteException implements Exception {
  final String message;

  const RouteException(this.message);
}
