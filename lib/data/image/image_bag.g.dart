// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_bag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageBag _$ImageBagFromJson(Map<String, dynamic> json) {
  return ImageBag()
    ..images = (json['images'] as List<dynamic>?)
        ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$ImageBagToJson(ImageBag instance) => <String, dynamic>{
      'images': instance.images,
    };
