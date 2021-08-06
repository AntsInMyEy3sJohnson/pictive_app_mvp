// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBag _$UserBagFromJson(Map<String, dynamic> json) {
  return UserBag()
    ..users = (json['users'] as List<dynamic>?)
        ?.map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$UserBagToJson(UserBag instance) => <String, dynamic>{
      'users': instance.users,
    };
