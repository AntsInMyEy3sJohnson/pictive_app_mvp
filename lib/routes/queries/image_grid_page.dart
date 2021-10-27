import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/collection/collection_bag.dart';
import 'package:pictive_app_mvp/data/image/image.dart' as appimg;
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/graphql/image_mutation_helper.dart';
import 'package:pictive_app_mvp/routes/queries/image_detail_page.dart';
import 'package:pictive_app_mvp/state/app/app_bloc.dart';
import 'package:pictive_app_mvp/state/app/app_state.dart';
import 'package:pictive_app_mvp/state/app/events/images_added_to_collection.dart';
import 'package:pictive_app_mvp/state/user/user_bloc.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';
import 'package:pictive_app_mvp/widgets/loading_overlay.dart';

class ImageGridPage extends StatefulWidget {
  static const String routeID = "/imagegrid";

  final String collectionID;
  final String collectionName;

  const ImageGridPage(this.collectionID, this.collectionName);

  @override
  _ImageGridPageState createState() => _ImageGridPageState();
}

class _ImageGridPageState extends State<ImageGridPage> {
  static const String _getCollectionByIdWithImageDataQuery = r'''
      query GetImagePayloadsInCollection($collectionID: ID!) {
        getCollectionByID(id: $collectionID) {
          collections {
            images {
              id
              thumbnail
              creationTimestamp
            }
          }
        }
     }
  ''';

  late final ImagePicker _imagePicker;
  late final UserBloc _userBloc;
  late final AppBloc _appBloc;

  late Future<QueryResult> _populateImagesFuture;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _userBloc = context.read<UserBloc>();
    _appBloc = context.read<AppBloc>();
    _populateImagesFuture = _performQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collectionName),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: BlocBuilder<AppBloc, AppState>(
        buildWhen: (previous, current) {
          final bool needsRebuild =
              current.activeCollectionsOverview[widget.collectionID]!;
          if (needsRebuild) {
            _populateImagesFuture = _performQuery();
          }
          return needsRebuild;
        },
        builder: (context, state) {
          return FutureBuilder<QueryResult>(
            future: _populateImagesFuture,
            builder:
                (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
              if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CenteredCircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final Collection collection =
                    _extractCollectionBag(snapshot.data!).collections![0];
                if (collection.images?.isEmpty ?? true) {
                  return Center(
                    child: Text(
                      "No images yet.",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                      ),
                    ),
                  );
                }
                final List<appimg.Image> images = collection.images!;
                images.sort(
                  (i1, i2) => int.parse(i1.creationTimestamp!).compareTo(
                    int.parse(i2.creationTimestamp!),
                  ),
                );
                return GridView.count(
                  mainAxisSpacing: MediaQuery.of(context).size.height * 0.01,
                  crossAxisCount: 3,
                  children: images
                      // TODO Image MemoryImage(Uint8List#e2a18) has a display size of 202×202 but a decode size of 960×1280, which uses an additional 6186KB.
                      // Consider resizing the asset ahead of time, supplying a cacheWidth parameter of 202, a cacheHeight parameter of 202, or using a ResizeImage.
                      .map(
                        (image) => GestureDetector(
                          onTap: () => _processImageTapped(image.id!),
                          child: Image.memory(
                            base64.decode(image.thumbnail!),
                          ),
                        ),
                      )
                      .toList(),
                );
              }
              return const Icon(Icons.error);
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: "Select images from your gallery",
            onPressed: _processSelectImagesButtonPressed,
            heroTag: "pickMultiImageFromGalleryFabImageGridPage",
            child: const Icon(Icons.photo),
          ),
          const Flexible(child: FractionallySizedBox(widthFactor: 0.02)),
          FloatingActionButton(
            tooltip: "Take a picture with your phone's camera",
            onPressed: _processTakePictureButtonPressed,
            heroTag: "takePicturesWithCameraFabImageGridPage",
            child: const Icon(Icons.camera_alt),
          ),
          const Flexible(child: FractionallySizedBox(widthFactor: 0.06)),
        ],
      ),
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
      final String userID = _userBloc.state.id!;
      final String collectionID = widget.collectionID;
      _handleImageUpload(userID, collectionID, xfiles);
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
      final String userID = _userBloc.state.id!;
      final String collectionID = widget.collectionID;
      _handleImageUpload(userID, collectionID, [xfile]);
    } catch (e) {
      debugPrint("An error occurred while attempting to take a picture: $e");
    }
  }

  Future<void> _handleImageUpload(
    String userID,
    String collectionID,
    List<XFile> xfiles,
  ) async {
    final String userID = _userBloc.state.id!;
    final Future<QueryResult> uploadResultFuture =
        ImageMutationHelper.getInstance().uploadImagesToCollection(
      userID,
      collectionID,
      xfiles,
    );
    final QueryResult uploadResult =
        await LoadingOverlay.of(context).during(uploadResultFuture);
    _processUploadResult(collectionID, uploadResult);
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

  void _processImageTapped(String id) {
    Navigator.pushNamed(context, ImageDetailPage.routeID, arguments: id);
  }

  Future<QueryResult> _performQuery() {
    return GClientWrapper.getInstance().performQuery(
      _getCollectionByIdWithImageDataQuery,
      <String, dynamic>{'collectionID': widget.collectionID},
    );
  }

  CollectionBag _extractCollectionBag(QueryResult queryResult) {
    return CollectionBag.fromJson(
      queryResult.data!["getCollectionByID"] as Map<String, dynamic>,
    );
  }
}
