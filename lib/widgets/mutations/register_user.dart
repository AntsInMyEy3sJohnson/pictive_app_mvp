import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/user/user_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/routes/login_page.dart';
import 'package:pictive_app_mvp/state/events/user_registered.dart';
import 'package:pictive_app_mvp/state/user_bloc.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';
import 'package:pictive_app_mvp/widgets/sized_button_child.dart';

class RegisterUser extends StatefulWidget {
  final String email;
  final String password;

  const RegisterUser(this.email, this.password);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  late final UserBloc _userBloc;

  late final Future<QueryResult> _resultFuture;

  @override
  void initState() {
    super.initState();
    _userBloc = context.read<UserBloc>();
    _resultFuture = GClientWrapper.getInstance()
        .performCreateUser(widget.email, widget.password);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryResult>(
      future: _resultFuture,
      initialData: QueryResult.unexecuted,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.data == QueryResult.unexecuted) {
          return const SizedButtonChild(Text("Register"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedButtonChild(CenteredCircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Future.delayed(Duration(milliseconds: 200),
                () => _onRegistrationComplete(snapshot.data!));
            return SizedButtonChild(
              Icon(
                Icons.check,
                color: Colors.white,
              ),
            );
          }
        }
        return const Text("Please try again later.");
      },
    );
  }

  void _onRegistrationComplete(QueryResult queryResult) async {
    final UserBag userBag =
        UserBag.fromJson(queryResult.data!["createUserWithDefaultCollection"]);
    _userBloc.add(UserRegistered(userBag.users![0]));
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success!"),
        content: const Text(
            "Registration successful. You can now log in with your email address and password."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Got it!")),
        ],
      ),
    );
    Navigator.pushReplacementNamed(context, LoginPage.ROUTE_ID);
  }
}
