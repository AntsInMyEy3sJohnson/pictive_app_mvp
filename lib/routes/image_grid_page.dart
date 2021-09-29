import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/collection/collection_bag.dart';
import 'package:pictive_app_mvp/data/image/image.dart' as appimg;
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/state/app/app_bloc.dart';
import 'package:pictive_app_mvp/state/app/app_state.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';

class ImageGridPage extends StatefulWidget {

  static const String routeID = "/imagegrid";

  final String collectionID;
  final String collectionName;

  const ImageGridPage(this.collectionID, this.collectionName);

  @override
  _ImageGridPageState createState() => _ImageGridPageState();
}

class _ImageGridPageState extends State<ImageGridPage> {

  static const String _GET_COLLECTION_BY_ID_WITH_IMAGE_PAYLOADS_QUERY = r'''
      query GetImagePayloadsInCollection($collectionID: ID!) {
        getCollectionByID(id: $collectionID) {
          collections {
            images {
              payload
              creationTimestamp
            }
          }
        }
     }
  ''';

  late Future<QueryResult> _populateImagesFuture;

  @override
  void initState() {
    super.initState();
    _populateImagesFuture = _performQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO Display collection name here
        title: Text(widget.collectionName),
        actions: [
          IconButton(onPressed: () => print("Search button was pressed"), icon: Icon(Icons.search))
        ],
      ),
      body: BlocBuilder<AppBloc, AppState>(
        buildWhen: (previous, current) {
          final bool needsRebuild =
          current.activeCollectionsOverview[widget.collectionID]!;
          if (needsRebuild) {
            this._populateImagesFuture = _performQuery();
          }
          return needsRebuild;
        },
        builder: (context, state) {
          return FutureBuilder<QueryResult>(
            future: _populateImagesFuture,
            builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
              if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CenteredCircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final Collection collection =
                _extractCollectionBag(snapshot.data!).collections![0];
                if (collection.images?.isEmpty ?? true) {
                  return const Text("No images yet.");
                }
                final List<appimg.Image> images = collection.images!;
                images.sort((i1, i2) =>
                    int.parse(i1.creationTimestamp!).compareTo(
                        int.parse(i2.creationTimestamp!)));
                return GridView.count(
                  crossAxisCount: 3,
                  children: images
                  // TODO Image MemoryImage(Uint8List#e2a18) has a display size of 202×202 but a decode size of 960×1280, which uses an additional 6186KB.
                  // Consider resizing the asset ahead of time, supplying a cacheWidth parameter of 202, a cacheHeight parameter of 202, or using a ResizeImage.
                      .map((image) =>
                      Image.memory(base64.decode(image.payload!)))
                      .toList(),
                );
              }
              return const Icon(Icons.error);
            },
          );
        },
      ),
    );
  }

  Future<QueryResult> _performQuery() {
    return GClientWrapper.getInstance().performQuery(
        _GET_COLLECTION_BY_ID_WITH_IMAGE_PAYLOADS_QUERY,
        <String, dynamic>{'collectionID': widget.collectionID});
  }

  CollectionBag _extractCollectionBag(QueryResult queryResult) {
    return CollectionBag.fromJson(queryResult.data!["getCollectionByID"] as Map<String, dynamic>);
  }

}