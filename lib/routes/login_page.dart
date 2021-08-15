import 'package:flutter/material.dart';
import 'package:pictive_app_mvp/input_validation/generic_input_validation.dart';
import 'package:pictive_app_mvp/routes/registration_page.dart';
import 'package:pictive_app_mvp/widgets/login_register_body.dart';
import 'package:pictive_app_mvp/widgets/queries/log_in_user.dart';
import 'package:pictive_app_mvp/widgets/relative_vertical_sized_box.dart';

class LoginPage extends StatefulWidget {
  static const String ROUTE_ID = "/";

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
                  decoration: InputDecoration(
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
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePassword,
                ),
              ],
              _loginTriggered
                  ? ElevatedButton(
                      onPressed: null, child: LogInUser(_emailController.text))
                  : ElevatedButton(
                      child: const Text("Login"),
                      onPressed: _performLogin,
                    ),
            ),
            const RelativeVerticalSizedBox(multiplier: 0.03),
            const Text("Don't have an account yet?"),
            ElevatedButton(
                onPressed: _navigateToRegistration,
                child: const Text("Register now!"))
          ],
        ),
      ),
    );
  }

  void _navigateToRegistration() {
    Navigator.pushNamed(context, RegistrationPage.ROUTE_ID);
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
