import 'package:json_annotation/json_annotation.dart';
import 'package:pictive_app_mvp/data/image.dart';
import 'package:pictive_app_mvp/data/user.dart';

part 'collection.g.dart';

@JsonSerializable()
class Collection {

  String? id;
  bool? defaultCollection;
  List<Image>? images;
  List<User>? sharedWith;
  User? owner;
  String? displayName;
  int? pin;
  bool? nonOwnersCanShare;
  bool? nonOwnersCanWrite;

  Collection();

  factory Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionToJson(this);

}
