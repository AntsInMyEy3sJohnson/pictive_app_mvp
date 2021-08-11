import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pictive_app_mvp/graphql/mutation_provider.dart';
import 'package:pictive_app_mvp/routes/overview_page.dart';
import 'package:pictive_app_mvp/state/events/user_registered.dart';
import 'package:pictive_app_mvp/state/user_bloc.dart';

class RegisterUser extends StatelessWidget {
  final UserBloc userBloc;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function inputValidCallback;

  const RegisterUser(this.userBloc, this.emailController,
      this.passwordController, this.inputValidCallback);

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
          document: gql(MutationProvider.getCreateUserMutation()),
          onCompleted: (dynamic resultData) {
            userBloc.add(
                UserRegistered(emailController.text, passwordController.text));
            Navigator.pushReplacementNamed(context, OverviewPage.ROUTE_ID);
          }),
      builder: (RunMutation runMutation, QueryResult? queryResult) {
        return ElevatedButton(
          child: const Text("Register"),
          onPressed: () => inputValidCallback()
              ? runMutation({
                  "mail": emailController.text,
                  "password": passwordController.text,
                })
              : null,
        );
      },
    );
  }
}
