// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_bag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionBag _$CollectionBagFromJson(Map<String, dynamic> json) {
  return CollectionBag()
    ..collections = (json['collections'] as List<dynamic>?)
        ?.map((e) => Collection.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$CollectionBagToJson(CollectionBag instance) =>
    <String, dynamic>{
      'collections': instance.collections,
    };
