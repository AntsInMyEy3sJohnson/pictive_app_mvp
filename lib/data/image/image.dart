import 'package:json_annotation/json_annotation.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/image/scored_label.dart';
import 'package:pictive_app_mvp/data/user/user.dart';

part 'image.g.dart';

@JsonSerializable()
class Image {
  String? id;
  String? payload;
  String? preview;
  String? extractedText;
  List<ScoredLabel>? scoredLabels;
  List<Collection>? containedInCollections;
  User? owner;

  Image();

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
