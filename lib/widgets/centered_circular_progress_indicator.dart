import 'package:flutter/material.dart';

class CenteredCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
          child: CircularProgressIndicator(
            color: Colors.grey,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

}