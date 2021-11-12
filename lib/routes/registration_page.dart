import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/input_validation/generic_input_validation.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';
import 'package:pictive_app_mvp/widgets/login_register_body.dart';
import 'package:pictive_app_mvp/widgets/relative_vertical_sized_box.dart';
import 'package:pictive_app_mvp/widgets/sized_button_child.dart';

import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeID = "/register";

  const RegistrationPage();

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepetitionController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _registrationTriggered = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepetitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginRegisterBody(
              _formKey,
              <Widget>[
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Mail",
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateMail,
                ),
                const RelativeVerticalSizedBox(),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePassword,
                ),
                const RelativeVerticalSizedBox(),
                TextFormField(
                  controller: _passwordRepetitionController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Repeat password",
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePasswordRepetition,
                ),
              ],
              _registrationTriggered
                  ? ElevatedButton(
                      onPressed: null,
                      child: _RegisterUser(
                        _emailController.text,
                        _passwordController.text,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _onRegistrationTriggered,
                      child: const Text("Register"),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRegistrationTriggered() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _registrationTriggered = true;
      });
    }
  }

  String? _validateMail(String? mail) {
    // Use generic validation for now
    return GenericInputValidation.stringValidation(mail);
  }

  String? _validatePassword(String? password) {
    // Use generic validation for now
    return GenericInputValidation.stringValidation(password);
  }

  String? _validatePasswordRepetition(String? passwordRepetition) {
    // Use generic validation for now
    return GenericInputValidation.stringValidation(passwordRepetition);
  }
}

class _RegisterUser extends StatefulWidget {
  final String email;
  final String password;

  const _RegisterUser(this.email, this.password);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<_RegisterUser> {
  static const String _createUserMutation = r'''
    mutation CreateUserWithDefaultCollection($mail: String!, $password: String!) {
      createUserWithDefaultCollection(mail: $mail, password: $password) {
        users {
          id
          mail
          ownedCollections {
            id
          }
          sourcedCollections {
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
      _createUserMutation,
      <String, dynamic>{'mail': widget.email, 'password': widget.password},
    );
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
          Future.delayed(
            const Duration(milliseconds: 200),
            () => _onRegistrationComplete(snapshot.data!),
          );
          return const SizedButtonChild(
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

  Future<void> _onRegistrationComplete(QueryResult queryResult) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success!"),
        content: const Text(
          "Registration successful. You can now log in with your email address and password.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it!"),
          ),
        ],
      ),
    );
    if (!mounted) {
      debugPrint("Unmounted -- returning.");
      return;
    }
    Navigator.pushReplacementNamed(context, LoginPage.routeID);
  }
}
