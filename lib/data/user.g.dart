// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as String?
    ..mail = json['mail'] as String?
    ..ownedCollections = (json['ownedCollections'] as List<dynamic>?)
        ?.map((e) => Collection.fromJson(e as Map<String, dynamic>))
        .toList()
    ..sharedCollections = (json['sharedCollections'] as List<dynamic>?)
        ?.map((e) => Collection.fromJson(e as Map<String, dynamic>))
        .toList()
    ..defaultCollection = json['defaultCollection'] == null
        ? null
        : Collection.fromJson(json['defaultCollection'] as Map<String, dynamic>)
    ..ownedImages = (json['ownedImages'] as List<dynamic>?)
        ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'mail': instance.mail,
      'ownedCollections': instance.ownedCollections,
      'sharedCollections': instance.sharedCollections,
      'defaultCollection': instance.defaultCollection,
      'ownedImages': instance.ownedImages,
    };
