import 'package:json_annotation/json_annotation.dart';
import 'package:pictive_app_mvp/data/collection.dart';
import 'package:pictive_app_mvp/data/image.dart';

part 'user.g.dart';

@JsonSerializable()
class User {

  String? id;
  String? mail;
  List<Collection>? ownedCollections;
  List<Collection>? sharedCollections;
  Collection? defaultCollection;
  List<Image>? ownedImages;

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}
