import 'package:flutter/material.dart';
import 'package:pictive_app_mvp/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pictive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
    );
  }
}
