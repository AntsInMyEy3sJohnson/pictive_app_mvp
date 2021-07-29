import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {

  static const String ROUTE_ID = "/overview";

  const OverviewPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pictive"),
        actions: [
          IconButton(icon: Icon(Icons.filter_alt_outlined), onPressed: () => print("I was pressed"))
        ],
      ),
      body: const Center(
        child: Text("Stuff will go here"),
      ),
    );
  }

}