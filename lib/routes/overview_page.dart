import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:image/image.dart' as imagelib;
import 'package:image_picker/image_picker.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/state/app/app_bloc.dart';
import 'package:pictive_app_mvp/state/app/events/images_added_to_collection.dart';
import 'package:pictive_app_mvp/state/user/user_bloc.dart';
import 'package:pictive_app_mvp/widgets/queries/populate_collection_list.dart';

class OverviewPage extends StatefulWidget {
  static const String ROUTE_ID = "/overview";

  const OverviewPage();

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  final ImagePicker _imagePicker = ImagePicker();

  late final UserBloc _userBloc;
  late final AppBloc _appBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = context.read<UserBloc>();
    _appBloc = context.read<AppBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pictive"),
        actions: [
          // Disable this button if no pictures are currently present
          IconButton(
              icon: Icon(Icons.filter_alt_outlined),
              onPressed: () => print("Filter button pressed"))
        ],
      ),
      body: Center(
        child: PopulateCollectionList(_userBloc.state.mail!),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: "Select images from your gallery",
            child: const Icon(Icons.photo),
            onPressed: _processSelectImagesButtonPressed,
            heroTag: "pickMultiImageFromGalleryFab",
          ),
          Flexible(child: FractionallySizedBox(heightFactor: 0.01)),
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
      final List<XFile>? selectedImages = await _imagePicker.pickMultiImage();
      if (selectedImages != null) {
      } else {
        print("Received null list from image picker");
      }
    } catch (e) {
      print("Error while attempting to pick images: $e");
    }
  }

  void _processTakePictureButtonPressed() async {
    try {
      final XFile? xfile =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (xfile != null) {
        final imagelib.Image? image =
            imagelib.decodeImage(await xfile.readAsBytes());
        if (image != null) {
          final List<int> pngInts = imagelib.encodePng(image);
          final String base64Payload = base64.encode(pngInts);
          final String collectionID = _userBloc.state.defaultCollection!.id!;
          final QueryResult uploadResult = await GClientWrapper.getInstance()
              .performMutation(_uploadImagesMutation(), <String, dynamic>{
            'ownerID': _userBloc.state.id,
            // TODO Implement dynamic activation and deactivation of collections
            'collectionID': collectionID,
            'base64Payloads': [base64Payload],
          });
          if (!uploadResult.hasException) {
            _appBloc.add(ImagesAddedToCollection(collectionID));
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Image upload successful"),
                    ],
                  ),
                ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${uploadResult.exception.toString()}"),
                  ],
                ),
              ),
            );
          }
        }
      } else {
        print("Received null image from camera.");
      }
    } catch (e) {
      print("An error occurred while attempting to take a picture: $e");
    }
  }

  String _uploadImagesMutation() {
    return r'''
    mutation UploadImages($ownerID: ID!, $collectionID: ID!, $base64Payloads: [String!]!) {
      uploadImages(ownerID: $ownerID, collectionID: $collectionID, base64Payloads: $base64Payloads) {
        images {
          id
          payload
        }
      }
    }
    ''';
  }
}
