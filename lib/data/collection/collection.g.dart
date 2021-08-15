// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Collection _$CollectionFromJson(Map<String, dynamic> json) {
  return Collection()
    ..id = json['id'] as String?
    ..defaultCollection = json['defaultCollection'] as bool?
    ..images = (json['images'] as List<dynamic>?)
        ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
        .toList()
    ..sharedWith = (json['sharedWith'] as List<dynamic>?)
        ?.map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList()
    ..owner = json['owner'] == null
        ? null
        : User.fromJson(json['owner'] as Map<String, dynamic>)
    ..displayName = json['displayName'] as String?
    ..pin = json['pin'] as int?
    ..nonOwnersCanShare = json['nonOwnersCanShare'] as bool?
    ..nonOwnersCanWrite = json['nonOwnersCanWrite'] as bool?;
}

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'defaultCollection': instance.defaultCollection,
      'images': instance.images,
      'sharedWith': instance.sharedWith,
      'owner': instance.owner,
      'displayName': instance.displayName,
      'pin': instance.pin,
      'nonOwnersCanShare': instance.nonOwnersCanShare,
      'nonOwnersCanWrite': instance.nonOwnersCanWrite,
    };
