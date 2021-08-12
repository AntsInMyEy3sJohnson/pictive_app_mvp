import 'package:flutter/material.dart';

class LoginRegisterBody extends StatelessWidget {

  final GlobalKey<FormState> formKey;
  final List<Widget> inputElements;
  final Widget submitWidget;

  const LoginRegisterBody(this.formKey, this.inputElements, this.submitWidget);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: inputElements,
            ),
          ),
          submitWidget,
        ],
      ),
    );
  }

}