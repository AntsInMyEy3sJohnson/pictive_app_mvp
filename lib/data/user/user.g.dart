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
        ?.map((e) => e as String)
        .toList()
    ..sharedCollections = (json['sharedCollections'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..defaultCollection = json['defaultCollection'] as String?
    ..ownedImages = (json['ownedImages'] as List<dynamic>?)
        ?.map((e) => e as String)
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
