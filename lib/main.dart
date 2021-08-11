import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pictive_app_mvp/routes.dart';
import 'package:pictive_app_mvp/routes/login_page.dart';
import 'package:pictive_app_mvp/state/user_bloc.dart';
import 'package:pictive_app_mvp/state/user_state.dart';

void main() {
  runApp(MyApp(_initGraphQlClient()));
}

GraphQLClient _initGraphQlClient() {
  final HttpLink httpLink = HttpLink("http://34.69.124.174");
  return GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  );
}

class MyApp extends StatelessWidget {
  final GraphQLClient graphQLClient;

  const MyApp(this.graphQLClient);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (_) => UserBloc(UserState.dummyState()),
      child: GraphQLProvider(
        client: ValueNotifier<GraphQLClient>(graphQLClient),
        child: MaterialApp(
          theme: Theme.of(context).copyWith(
            primaryColor: const Color(0xffe040fb),
            primaryColorLight: const Color(0xffff79ff),
            primaryColorDark: const Color(0xffaa00c7),
            accentColor: const Color(0xffbdbdbd),
            backgroundColor: const Color(0x0),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
              primary: const Color(0xffffb300),
              shadowColor: const Color(0xffc68400),
            )),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              foregroundColor: const Color(0xffc68400),
              backgroundColor: const Color(0xffffb300),
            ),
          ),
          onGenerateTitle: (context) => "Pictive",
          initialRoute: LoginPage.ROUTE_ID,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
