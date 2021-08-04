import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pictive_app_mvp/state/user_bloc.dart';
import 'package:pictive_app_mvp/state/user_state.dart';
import 'package:pictive_app_mvp/widgets/collection_tile.dart';

class OverviewPage extends StatefulWidget {
  static const String ROUTE_ID = "/overview";

  const OverviewPage();

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pictive"),
        actions: [
          // Disable this button if no pictures are currently present
          IconButton(
              icon: Icon(Icons.filter_alt_outlined),
              onPressed: () => print("I was pressed"))
        ],
      ),
      body: Center(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (_images.isEmpty) {
              return const Text("No images yet.");
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.005),
                    child: CollectionTile());
              },
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: "Select images from your gallery",
            child: const Icon(Icons.photo),
            onPressed: _processSelectImagesButtonPressed,
            heroTag: "pickMultiImageFromGalleryFab",
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          FloatingActionButton(
            tooltip: "Take a picture with your phone's camera",
            child: const Icon(Icons.camera_alt),
            onPressed: _processTakePictureButtonPressed,
            heroTag: "takePicturesWithCameraFab",
          ),
        ],
      ),
    );
  }

  void _processSelectImagesButtonPressed() async {
    try {
      final selectedPictures = await _imagePicker.pickMultiImage();
      if (selectedPictures != null) {
        _addPicturesToList(selectedPictures);
      } else {
        print("Received null list from image picker");
      }
    } catch (e) {
      print("Error while attempting to pick images: $e");
    }
  }

  void _processTakePictureButtonPressed() async {
    try {
      final picture = await _imagePicker.pickImage(source: ImageSource.camera);
      if (picture != null) {
        _addPicturesToList([picture]);
      } else {
        print("Received null image from camera.");
      }
    } catch (e) {
      print("An error occurred while attempting to take a picture: $e");
    }
  }

  void _addPicturesToList(Iterable<XFile> pictures) {
    setState(() {
      _images.addAll(pictures.toList());
    });
  }

  Widget _generateImagePreview() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(_images.length, (index) {
        return Card(
          color: Theme.of(context).backgroundColor,
          child: Image.file(File(_images[index].path)),
        );
      }),
    );
  }
}
