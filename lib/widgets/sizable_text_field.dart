import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizableTextField extends StatelessWidget {

  final String text;
  final double widthModifier;
  final FontWeight fontWeight;

  const SizableTextField(this.text, this.widthModifier, {this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * widthModifier,
        fontWeight: fontWeight,
      ),
    );
  }



}