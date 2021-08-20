import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/collection/collection_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';

class PopulateImages extends StatefulWidget {
  final String collectionID;

  const PopulateImages(this.collectionID);

  @override
  _PopulateImagesState createState() => _PopulateImagesState();
}

class _PopulateImagesState extends State<PopulateImages> {
  static const String _GET_COLLECTION_BY_ID_WITH_IMAGE_PAYLOADS_QUERY = r'''
      query GetImagePayloadsInCollection($collectionID: ID!) {
        getCollectionByID(id: $collectionID) {
          collections {
            images {
              payload
            }
          }
        }
     }
  ''';

  late final Future<QueryResult> _populateImagesFuture;

  @override
  void initState() {
    super.initState();
    _populateImagesFuture = GClientWrapper.getInstance().performQuery(
        _GET_COLLECTION_BY_ID_WITH_IMAGE_PAYLOADS_QUERY,
        <String, dynamic>{'collectionID': widget.collectionID});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryResult>(
      future: _populateImagesFuture,
      builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const CenteredCircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final Collection collection =
              _extractCollectionBag(snapshot.data!).collections![0];
          if (collection.images?.isEmpty ?? true) {
            return const Text("No images yet.");
          }
          return GridView.count(
            crossAxisCount: 3,
            children: collection.images!
                .map((image) => Image.memory(base64.decode(image.payload!)))
                .toList(),
          );
        }
        return const Icon(Icons.error);
      },
    );
  }

  CollectionBag _extractCollectionBag(QueryResult queryResult) {
    return CollectionBag.fromJson(queryResult.data!["getCollectionByID"]);
  }
}
