import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/image/image.dart' as appimg;
import 'package:pictive_app_mvp/data/image/image_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailPage extends StatefulWidget {
  static const String routeID = "/imagedetail";

  final String imageID;

  const ImageDetailPage(this.imageID);

  @override
  State<ImageDetailPage> createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  static const String _getImageByIdQuery = r'''
    query GetImageByID($id: ID!){
      getImageByID(id: $id) {
        images {
          content
        }
      }
    }
  ''';

  late Future<QueryResult> _populateImageFuture;

  @override
  void initState() {
    super.initState();
    _populateImageFuture = _performQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _populateImageFuture,
          builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              // TODO Make this more beautiful -- looks very ugly without a surrounding Scaffold
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Icon(Icons.error);
            }
            final appimg.Image image =
                _extractImageBag(snapshot.data!).images![0];
            return PhotoView(
              imageProvider: MemoryImage(base64.decode(image.content!)),
            );
          },
        ),
      ),
    );
  }

  ImageBag _extractImageBag(QueryResult queryResult) {
    return ImageBag.fromJson(
        queryResult.data!['getImageByID'] as Map<String, dynamic>);
  }

  Future<QueryResult> _performQuery() {
    return GClientWrapper.getInstance().performQuery(
      // Image won't change after it has been initially uploaded to server,
      // so queries for its content can always run against the local cache after
      // the image was queried once
      _getImageByIdQuery,
      <String, dynamic>{'id': widget.imageID},
      // TODO Which other widgets could make do with a cache-local strategy?
      fetchPolicy: FetchPolicy.cacheFirst,
    );
  }
}
