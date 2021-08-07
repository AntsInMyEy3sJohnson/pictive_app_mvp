import 'package:flutter/material.dart';

class RelativeVerticalSizedBox extends StatelessWidget {

  const RelativeVerticalSizedBox();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.01);
  }
}
