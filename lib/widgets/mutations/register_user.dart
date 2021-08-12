import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/user/user_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/state/user_bloc.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';

class RegisterUser extends StatefulWidget {
  final UserBloc userBloc;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function inputValidCallback;

  const RegisterUser(this.userBloc, this.emailController,
      this.passwordController, this.inputValidCallback);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  Future<QueryResult>? _resultFuture;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onRegistrationTriggered,
      child: FutureBuilder<QueryResult>(
        future: _resultFuture,
        initialData: QueryResult.unexecuted,
        builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
          if(snapshot.connectionState == ConnectionState.none && snapshot.data == QueryResult.unexecuted) {
            return const Text("Register");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CenteredCircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              _onRegistrationComplete(snapshot.data!);
              return Icon(Icons.check, color: Colors.white);
            }
          }
          return const Text("Please try again later.");
        },
      ),
    );
  }

  void _onRegistrationTriggered() {
    if (widget.inputValidCallback()) {
      print("Performing mutation");
      setState(() {
        _resultFuture = GClientWrapper.getInstance().performCreateUser(
            widget.emailController.text, widget.passwordController.text);
      });
    }
  }

  void _onRegistrationComplete(QueryResult queryResult) {
    final UserBag userBag = UserBag.fromJson(queryResult.data!["createUserWithDefaultCollection"]["users"][0]);
    // TODO Do something useful with the result
  }
}
