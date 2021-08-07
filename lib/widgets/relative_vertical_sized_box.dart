import 'package:flutter/material.dart';

class RelativeVerticalSizedBox extends StatelessWidget {

  final double multiplier;

  const RelativeVerticalSizedBox({this.multiplier = 0.01});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height * multiplier);
  }
}
