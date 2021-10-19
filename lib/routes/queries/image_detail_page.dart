import 'package:flutter/material.dart';

class ImageDetailPage extends StatefulWidget{

  static const String routeID = "/imagedetail";

  final String imageID;

  const ImageDetailPage(this.imageID);

  @override
  State<ImageDetailPage> createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(child: const Placeholder());
  }
}