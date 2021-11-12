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
    ..sourcedBy = (json['sourcedBy'] as List<dynamic>?)
        ?.map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList()
    ..owner = json['owner'] == null
        ? null
        : User.fromJson(json['owner'] as Map<String, dynamic>)
    ..displayName = json['displayName'] as String?
    ..pin = json['pin'] as int?
    ..sourcingAllowed = json['sourcingAllowed'] as bool?
    ..nonOwnersCanWrite = json['nonOwnersCanWrite'] as bool?
    ..creationTimestamp = json['creationTimestamp'] as String?;
}

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'defaultCollection': instance.defaultCollection,
      'images': instance.images,
      'sourcedBy': instance.sourcedBy,
      'owner': instance.owner,
      'displayName': instance.displayName,
      'pin': instance.pin,
      'sourcingAllowed': instance.sourcingAllowed,
      'nonOwnersCanWrite': instance.nonOwnersCanWrite,
      'creationTimestamp': instance.creationTimestamp,
    };
