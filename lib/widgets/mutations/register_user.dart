import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/routes/login_page.dart';
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
  static const String _CREATE_USER_MUTATION = r'''
    mutation CreateUserWithDefaultCollection($mail: String!, $password: String!) {
      createUserWithDefaultCollection(mail: $mail, password: $password) {
        users {
          id
          mail
          ownedCollections {
            id
          }
          sharedCollections {
            id
          }
          defaultCollection {
            id
          }
          ownedImages {
            id
          }
        }
      }
    }
    ''';

  late final Future<QueryResult> _createUserFuture;

  @override
  void initState() {
    super.initState();
    _createUserFuture = GClientWrapper.getInstance().performMutation(
        _CREATE_USER_MUTATION,
        <String, dynamic>{'mail': widget.email, 'password': widget.password});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryResult>(
      future: _createUserFuture,
      initialData: QueryResult.unexecuted,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedButtonChild(CenteredCircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          Future.delayed(Duration(milliseconds: 200),
              () => _onRegistrationComplete(snapshot.data!));
          return SizedButtonChild(
            Icon(
              Icons.check,
              color: Colors.white,
            ),
          );
        }
        return const Text("Please try again later.");
      },
    );
  }

  void _onRegistrationComplete(QueryResult queryResult) async {
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
