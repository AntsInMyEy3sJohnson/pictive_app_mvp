import 'package:json_annotation/json_annotation.dart';
import 'package:pictive_app_mvp/data/collection.dart';

part 'collection_bag.g.dart';

@JsonSerializable()
class CollectionBag {

  List<Collection>? collections;

  CollectionBag();

  factory CollectionBag.fromJson(Map<String, dynamic> json) => _$CollectionBagFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionBagToJson(this);

}
