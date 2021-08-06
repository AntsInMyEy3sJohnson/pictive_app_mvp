import 'package:json_annotation/json_annotation.dart';
import 'package:pictive_app_mvp/data/collection.dart';
import 'package:pictive_app_mvp/data/scored_label.dart';
import 'package:pictive_app_mvp/data/user.dart';

part 'image.g.dart';

@JsonSerializable()
class Image {
  String? id;
  String? payload;
  String? extractedText;
  List<ScoredLabel>? scoredLabels;
  List<Collection>? containedInCollections;
  User? owner;

  Image();

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);

}
