import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:image/image.dart' as image_lib;
import 'package:image_picker/image_picker.dart';

import 'g_client_wrapper.dart';

class ImageMutationHelper {

  static const String _imageThumbnailStartMarker = "THUMBNAIL_START";
  static const String _imageThumbnailEndMarker = "THUMBNAIL_END";
  static const String _imageContentStartMarker = "CONTENT_START";
  static const String _imageContentEndMarker = "CONTENT_END";
  static const String _uploadImagesMutation = r'''
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

  static final ImageMutationHelper _theInstance = ImageMutationHelper._();

  ImageMutationHelper._();

  static ImageMutationHelper getInstance() {
    return _theInstance;
  }

  Future<QueryResult> uploadImagesToCollection(
      String ownerID,
      String collectionID,
      List<XFile> xfiles,
      ) async {
    final List<String> base64Payloads = await _generateBase64Payloads(xfiles);
    return GClientWrapper.getInstance()
        .performMutation(_uploadImagesMutation, <String, dynamic>{
      'ownerID': ownerID,
      'collectionID': collectionID,
      'base64Payloads': base64Payloads,
    });
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

}
