import 'package:flutter/material.dart';

class LoginRegisterBody extends StatelessWidget {

  final GlobalKey<FormState> formKey;
  final List<Widget> inputElements;
  final String submitText;
  final Function submitCallback;

  const LoginRegisterBody(this.formKey, this.inputElements, this.submitText, this.submitCallback);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FractionallySizedBox(
          widthFactor: 0.8,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: inputElements,
            ),
          ),
        ),
        ElevatedButton(onPressed: () => submitCallback(), child: Text(submitText))
      ],
    );
  }

}