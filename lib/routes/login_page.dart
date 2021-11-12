import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/user/user.dart';
import 'package:pictive_app_mvp/data/user/user_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/input_validation/generic_input_validation.dart';
import 'package:pictive_app_mvp/routes/registration_page.dart';
import 'package:pictive_app_mvp/state/app/app_bloc.dart';
import 'package:pictive_app_mvp/state/app/events/default_collection_retrieved.dart';
import 'package:pictive_app_mvp/state/user/events/user_logged_in.dart';
import 'package:pictive_app_mvp/state/user/user_bloc.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';
import 'package:pictive_app_mvp/widgets/login_register_body.dart';
import 'package:pictive_app_mvp/widgets/relative_vertical_sized_box.dart';
import 'package:pictive_app_mvp/widgets/sized_button_child.dart';

import 'overview_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeID = "/";

  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _loginTriggered = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              ],
              _loginTriggered
                  ? ElevatedButton(
                      onPressed: null,
                      child: _LogInUser(_emailController.text),
                    )
                  : ElevatedButton(
                      onPressed: _performLogin,
                      child: const Text("Login"),
                    ),
            ),
            const RelativeVerticalSizedBox(multiplier: 0.03),
            const Text("Don't have an account yet?"),
            ElevatedButton(
              onPressed: _navigateToRegistration,
              child: const Text("Register now!"),
            )
          ],
        ),
      ),
    );
  }

  void _navigateToRegistration() {
    Navigator.pushNamed(context, RegistrationPage.routeID);
  }

  void _performLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _loginTriggered = true;
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
}

class _LogInUser extends StatefulWidget {
  final String email;

  const _LogInUser(this.email);

  @override
  _LogInUserState createState() => _LogInUserState();
}

class _LogInUserState extends State<_LogInUser> {
  static const String _getUserByMailQuery = r'''
      query GetUserByMail($mail: String!){
      getUserByMail(mail: $mail){
        users {
          id
          mail
          ownedCollections {
            id
          }
          sourcedCollections {
            id
            defaultCollection
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

  late final Future<QueryResult> _getUserByMailFuture;
  late final UserBloc _userBloc;
  late final AppBloc _appBloc;

  @override
  void initState() {
    super.initState();
    _getUserByMailFuture = GClientWrapper.getInstance().performQuery(
      _getUserByMailQuery,
      <String, dynamic>{'mail': widget.email},
    );
    _userBloc = context.read<UserBloc>();
    _appBloc = context.read<AppBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryResult>(
      future: _getUserByMailFuture,
      initialData: QueryResult.unexecuted,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedButtonChild(CenteredCircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          Future.delayed(
            const Duration(milliseconds: 200),
            () => _onLoginComplete(snapshot.data!),
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

  Future<void> _onLoginComplete(QueryResult queryResult) async {
    final UserBag userBag = UserBag.fromJson(
      queryResult.data!["getUserByMail"] as Map<String, dynamic>,
    );
    final User user = userBag.users![0];
    _userBloc.add(UserLoggedIn(user));
    _appBloc.add(
      CollectionsRetrieved(
        user.sourcedCollections!.map((e) => e.id!).toList(),
        user.defaultCollection!.id!,
      ),
    );
    // TODO Pass this as callback into widget -- currently, there
    //  is still a back arrow displayed on the Overview page
    Navigator.pushReplacementNamed(context, OverviewPage.routeID);
  }
}
