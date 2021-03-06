import 'package:flutter/material.dart';

class CenteredCircularProgressIndicator extends StatelessWidget {

  const CenteredCircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(
          color: Colors.grey,
          backgroundColor: Colors.white,
        ),
      ],
    );
  }

}
