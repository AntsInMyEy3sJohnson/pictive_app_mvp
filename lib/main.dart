import 'package:flutter/material.dart';
import 'package:pictive_app_mvp/routes.dart';
import 'package:pictive_app_mvp/routes/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context).copyWith(
        primaryColor: const Color(0xffe040fb),
        primaryColorLight: const Color(0xffff79ff),
        primaryColorDark: const Color(0xffaa00c7),
        accentColor: const Color(0xffbdbdbd),
        backgroundColor: const Color(0xff757575),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          primary: const Color(0xffffb300),
          shadowColor: const Color(0xffc68400),
        )),
      ),
      onGenerateTitle: (context) => "Pictive",
      initialRoute: LoginPage.ROUTE_ID,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
