import 'package:flutter/material.dart';
import 'package:pictive_app_mvp/input_validation/generic_input_validation.dart';
import 'package:pictive_app_mvp/widgets/login_register_body.dart';
import 'package:pictive_app_mvp/widgets/mutations/register_user.dart';
import 'package:pictive_app_mvp/widgets/relative_vertical_sized_box.dart';

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
                      child: RegisterUser(
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
