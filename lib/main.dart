import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictive_app_mvp/data/user/user.dart';
import 'package:pictive_app_mvp/routes.dart';
import 'package:pictive_app_mvp/routes/login_page.dart';
import 'package:pictive_app_mvp/state/app/app_bloc.dart';
import 'package:pictive_app_mvp/state/app/app_state.dart';
import 'package:pictive_app_mvp/state/user/user_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(User()),
        ),
        BlocProvider<AppBloc>(create: (_) => AppBloc(AppState.dummyState())),
      ],
      child: MaterialApp(
        theme: Theme.of(context).copyWith(
          primaryColor: const Color(0xffe040fb),
          primaryColorLight: const Color(0xffff79ff),
          primaryColorDark: const Color(0xffaa00c7),
          accentColor: const Color(0xffbdbdbd),
          backgroundColor: const Color(0x00000000),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xffffc32c),
              shadowColor: const Color(0xffaa00c7),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            foregroundColor: Color(0xffff79ff),
            backgroundColor: Color(0xffaa00c7),
          ),
        ),
        onGenerateTitle: (context) => "Pictive",
        initialRoute: LoginPage.routeID,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
