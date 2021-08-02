import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pictive_app_mvp/state/user_bloc.dart';
import 'package:pictive_app_mvp/state/user_state.dart';

class OverviewPage extends StatefulWidget {

  static const String ROUTE_ID = "/overview";

  const OverviewPage();

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {

  final List<XFile> _images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pictive"),
        actions: [
          // Disable this button if no pictures are currently present
          IconButton(icon: Icon(Icons.filter_alt_outlined), onPressed: () => print("I was pressed"))
        ],
      ),
      body: Center(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if(_images.isEmpty) {
              return const Text("No images yet.");
            }
            return GridView.builder(
                gridDelegate: gridDelegate,
                itemBuilder: itemBuilder);
          },
        ),
      ),
      floatingActionButton: Column(

      ),
    );
  }

  Widget _generateImagePreview() {

  }

}