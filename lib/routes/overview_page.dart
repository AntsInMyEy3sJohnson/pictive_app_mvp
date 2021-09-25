import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:image/image.dart' as imagelib;
import 'package:image_picker/image_picker.dart';
import 'package:pictive_app_mvp/data/collection/collection_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/state/app/app_bloc.dart';
import 'package:pictive_app_mvp/state/app/events/collection_created.dart';
import 'package:pictive_app_mvp/state/app/events/images_added_to_collection.dart';
import 'package:pictive_app_mvp/state/user/user_bloc.dart';
import 'package:pictive_app_mvp/widgets/dialogs/create_new_collection_dialog.dart';
import 'package:pictive_app_mvp/widgets/dialogs/dialog_helper.dart';
import 'package:pictive_app_mvp/widgets/loading_overlay.dart';
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
          // TODO Disable this button if no images are currently present
          IconButton(
              icon: Icon(Icons.filter_alt_outlined),
              onPressed: () => print("Filter button pressed"))
        ],
      ),
      body: Center(
        child: PopulateCollectionList(_userBloc.state.mail!),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: "Create a new collection",
            child: const Icon(Icons.collections),
            onPressed: _processCreateNewCollectionButtonPressed,
            heroTag: "createNewCollectionFab",
          ),
          Flexible(child: FractionallySizedBox(widthFactor: 0.02)),
          FloatingActionButton(
            tooltip: "Select images from your gallery",
            child: const Icon(Icons.photo),
            onPressed: _processSelectImagesButtonPressed,
            heroTag: "pickMultiImageFromGalleryFab",
          ),
          Flexible(child: FractionallySizedBox(widthFactor: 0.02)),
          FloatingActionButton(
            tooltip: "Take a picture with your phone's camera",
            child: const Icon(Icons.camera_alt),
            onPressed: _processTakePictureButtonPressed,
            heroTag: "takePicturesWithCameraFab",
          ),
          Flexible(child: FractionallySizedBox(widthFactor: 0.06)),
        ],
      ),
    );
  }

  void _processCreateNewCollectionButtonPressed() async {
    final String? collectionName = await DialogHelper<String>()
        .show(context, const CreateNewCollectionDialog());
    if (collectionName != null) {
      final QueryResult queryResult = await LoadingOverlay.of(context)
          .during(GClientWrapper.getInstance().performMutation(
        _createCollectionMutation(),
        <String, dynamic>{
          'ownerID': _userBloc.state.id,
          'displayName': collectionName,
          'pin': 0000,
          'nonOwnersCanShare': false,
          'nonOwnersCanWrite': false,
        },
      ));
      _processNewCollectionCreated(queryResult);
    }
  }

  void _processNewCollectionCreated(QueryResult queryResult) {
    if (queryResult.hasException) {
      print(
          "Encountered exception during collection creation: ${queryResult.exception.toString()}");
      return;
    }
    final CollectionBag collectionBag =
        _extractCollectionBag(queryResult, "createCollection");
    final String collectionName = collectionBag.collections![0].displayName!;
    _appBloc.add(
        CollectionCreated(collectionBag.collections![0].id!, collectionName));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Collection '$collectionName' successfully created."),
          ],
        ),
      ),
    );
  }

  CollectionBag _extractCollectionBag(
      QueryResult queryResult, String payloadEntryNode) {
    return CollectionBag.fromJson(queryResult.data![payloadEntryNode]);
  }

  void _processSelectImagesButtonPressed() async {
    try {
      final List<XFile>? xfiles = await _imagePicker.pickMultiImage();
      if (xfiles == null) {
        print("Received null list of images from image picker.");
        return;
      }
      await LoadingOverlay.of(context).during(
          _uploadImagesToCollection(evaluateTargetCollection(), xfiles));
    } catch (e) {
      print("Error while attempting to pick images: $e");
    }
  }

  void _processTakePictureButtonPressed() async {
    try {
      final XFile? xfile =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (xfile == null) {
        print("Received null image from image picker.");
        return;
      }
      await LoadingOverlay.of(context).during(
          _uploadImagesToCollection(evaluateTargetCollection(), [xfile]));
    } catch (e) {
      print("An error occurred while attempting to take a picture: $e");
    }
  }

  Future<void> _uploadImagesToCollection(
      String collectionID, List<XFile> xfiles) async {
    final List<String> base64Payloads = await _generateBase64Payloads(xfiles);
    _processUploadResult(
      collectionID,
      await GClientWrapper.getInstance()
          .performMutation(_uploadImagesMutation(), <String, dynamic>{
        'ownerID': _userBloc.state.id,
        'collectionID': collectionID,
        'base64Payloads': base64Payloads,
      }),
    );
  }

  String evaluateTargetCollection() {
    return _appBloc.state.getIdOfActiveCollection() ??
        _userBloc.state.defaultCollection!.id!;
  }

  Future<List<String>> _generateBase64Payloads(List<XFile> xfiles) async {
    final List<String> base64Payloads = List.empty(growable: true);
    for (XFile xfile in xfiles) {
      final imagelib.Image? image =
          imagelib.decodeImage(await xfile.readAsBytes());
      if (image == null) {
        // TODO Add logging
        print("Unknown error while processing image.");
        return base64Payloads;
      }
      final List<int> pngInts = imagelib.encodePng(image);
      base64Payloads.add(base64.encode(pngInts));
    }
    return base64Payloads;
  }

  void _processUploadResult(String collectionID, QueryResult queryResult) {
    if (queryResult.hasException) {
      print(
          "Encountered exception during image upload: ${queryResult.exception.toString()}");
      return;
    }
    _appBloc.add(ImagesAddedToCollection(collectionID));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Images successfully uploaded."),
          ],
        ),
      ),
    );
  }

  String _createCollectionMutation() {
    return r'''
    mutation CreateCollection($ownerID: ID!, $displayName: String!, $pin: Int!, $nonOwnersCanShare: Boolean!, $nonOwnersCanWrite: Boolean!){
      createCollection(ownerID: $ownerID, displayName: $displayName, pin: $pin, nonOwnersCanShare: $nonOwnersCanShare, nonOwnersCanWrite: $nonOwnersCanWrite) {
        collections {
          id
          displayName
        }
      }
    }  
    ''';
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
