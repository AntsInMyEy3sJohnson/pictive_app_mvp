import 'package:json_annotation/json_annotation.dart';

part 'collection.g.dart';

@JsonSerializable()
class Collection {

  String? id;
  bool? defaultCollection;
  List<String>? images;
  List<String>? sharedWith;
  String? owner;
  String? displayName;
  int? pin;
  bool? nonOwnersCanShare;
  bool? nonOwnersCanWrite;

  Collection();

  factory Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionToJson(this);

}
