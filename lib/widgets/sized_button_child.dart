import 'package:flutter/material.dart';

class SizedButtonChild extends StatelessWidget {

  final Widget child;

  const SizedButtonChild(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Center(child: child),
    );
  }

}