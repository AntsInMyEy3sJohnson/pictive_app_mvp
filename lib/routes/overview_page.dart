import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:image/image.dart' as image_lib;
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
  static const String routeID = "/overview";

  const OverviewPage();

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  static const String _imageThumbnailStartMarker = "THUMBNAIL_START";
  static const String _imageThumbnailEndMarker = "THUMBNAIL_END";
  static const String _imageContentStartMarker = "CONTENT_START";
  static const String _imageContentEndMarker = "CONTENT_END";

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
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
          child: PopulateCollectionList(_userBloc.state.mail!),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: "Create a new collection",
            onPressed: _processCreateNewCollectionButtonPressed,
            heroTag: "createNewCollectionFab",
            child: const Icon(Icons.collections),
          ),
          const Flexible(
            child: FractionallySizedBox(widthFactor: 0.02),
          ),
          FloatingActionButton(
            tooltip: "Select images from your gallery",
            onPressed: _processSelectImagesButtonPressed,
            heroTag: "pickMultiImageFromGalleryFab",
            child: const Icon(Icons.photo),
          ),
          const Flexible(child: FractionallySizedBox(widthFactor: 0.02)),
          FloatingActionButton(
            tooltip: "Take a picture with your phone's camera",
            onPressed: _processTakePictureButtonPressed,
            heroTag: "takePicturesWithCameraFab",
            child: const Icon(Icons.camera_alt),
          ),
          const Flexible(
            child: FractionallySizedBox(widthFactor: 0.06),
          ),
        ],
      ),
    );
  }

  Future<void> _processCreateNewCollectionButtonPressed() async {
    final String? collectionName = await const DialogHelper<String>()
        .show(context, const CreateNewCollectionDialog());
    if (collectionName != null) {
      if (!mounted) {
        debugPrint("Unmounted -- returning.");
        return;
      }
      final QueryResult queryResult = await LoadingOverlay.of(context).during(
        GClientWrapper.getInstance().performMutation(
          _createCollectionMutation(),
          <String, dynamic>{
            'ownerID': _userBloc.state.id,
            'displayName': collectionName,
            'pin': 0000,
            'nonOwnersCanShare': false,
            'nonOwnersCanWrite': false,
          },
        ),
      );
      _processNewCollectionCreated(queryResult);
    }
  }

  void _processNewCollectionCreated(QueryResult queryResult) {
    if (queryResult.hasException) {
      return;
    }
    final CollectionBag collectionBag =
        _extractCollectionBag(queryResult, "createCollection");
    final String collectionName = collectionBag.collections![0].displayName!;
    _appBloc.add(
      CollectionCreated(collectionBag.collections![0].id!, collectionName),
    );
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
    QueryResult queryResult,
    String payloadEntryNode,
  ) {
    return CollectionBag.fromJson(
      queryResult.data![payloadEntryNode] as Map<String, dynamic>,
    );
  }

  Future<void> _processSelectImagesButtonPressed() async {
    try {
      final List<XFile>? xfiles = await _imagePicker.pickMultiImage();
      if (xfiles == null) {
        debugPrint("Received null list of images from image picker.");
        return;
      }
      if (!mounted) {
        debugPrint("Unmounted -- returning.");
        return;
      }
      await LoadingOverlay.of(context).during(
        _uploadImagesToCollection(evaluateTargetCollection(), xfiles),
      );
    } catch (e) {
      debugPrint("Error while attempting to pick images: $e");
    }
  }

  Future<void> _processTakePictureButtonPressed() async {
    try {
      final XFile? xfile =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (xfile == null) {
        debugPrint("Received null image from image picker.");
        return;
      }
      if (!mounted) {
        debugPrint("Unmounted -- returning.");
        return;
      }
      await LoadingOverlay.of(context).during(
        _uploadImagesToCollection(evaluateTargetCollection(), [xfile]),
      );
    } catch (e) {
      debugPrint("An error occurred while attempting to take a picture: $e");
    }
  }

  Future<void> _uploadImagesToCollection(
    String collectionID,
    List<XFile> xfiles,
  ) async {
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
    for (final XFile xfile in xfiles) {
      final image_lib.Image? image =
          image_lib.decodeImage(await xfile.readAsBytes());
      if (image == null) {
        // TODO Add logging
        debugPrint("Unknown error while processing image.");
        return base64Payloads;
      }
      final String imageThumbnailBase64 =
          _imageToBase64EncodedPng(image_lib.copyResize(image, width: 120));
      final String imageContentBase64 = _imageToBase64EncodedPng(image);
      final String payload =
          "$_imageThumbnailStartMarker:$imageThumbnailBase64:$_imageThumbnailEndMarker"
          "$_imageContentStartMarker:$imageContentBase64:$_imageContentEndMarker";
      base64Payloads.add(payload);
    }
    return base64Payloads;
  }

  String _imageToBase64EncodedPng(image_lib.Image image) {
    final List<int> ints = image_lib.encodePng(image);
    return base64.encode(ints);
  }

  void _processUploadResult(String collectionID, QueryResult queryResult) {
    if (queryResult.hasException) {
      debugPrint(
        "Encountered exception during image upload: ${queryResult.exception.toString()}",
      );
      return;
    }
    _appBloc.add(ImagesAddedToCollection(collectionID));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Images successfully uploaded."),
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
          thumbnail
          content
        }
      }
    }
    ''';
  }
}
