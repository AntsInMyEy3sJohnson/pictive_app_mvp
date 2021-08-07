import 'package:flutter/material.dart';
import 'package:pictive_app_mvp/input_validation/generic_input_validation.dart';
import 'package:pictive_app_mvp/routes/overview_page.dart';
import 'package:pictive_app_mvp/state/events/user_registered.dart';
import 'package:pictive_app_mvp/state/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictive_app_mvp/widgets/login_register_body.dart';
import 'package:pictive_app_mvp/widgets/relative_vertical_sized_box.dart';

class RegistrationPage extends StatefulWidget {

  static const String ROUTE_ID = "/register";

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepetitionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = context.read<UserBloc>();
  }


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
        child: LoginRegisterBody(
          _formKey,
          <Widget>[
            // TODO Put this into dedicated widget to avoid code duplication
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Mail",
                border: OutlineInputBorder()
              ),
              validator: _validateMail,
            ),
            const RelativeVerticalSizedBox(),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
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
              decoration: InputDecoration(
                hintText: "Repeat password",
                border: OutlineInputBorder(),
              ),
              validator: _validatePasswordRepetition,
            ),
          ],
          "Register",
          _performRegistration,
        ),
      ),
    );
  }

  void _performRegistration() {
    if (_formKey.currentState?.validate() ?? false) {
      _userBloc.add(UserRegistered(_emailController.text, _passwordController.text));
      Navigator.pushReplacementNamed(context, OverviewPage.ROUTE_ID);
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