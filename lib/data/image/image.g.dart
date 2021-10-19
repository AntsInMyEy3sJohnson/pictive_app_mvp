// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image()
    ..id = json['id'] as String?
    ..thumbnail = json['thumbnail'] as String?
    ..content = json['content'] as String?
    ..extractedText = json['extractedText'] as String?
    ..scoredLabels = (json['scoredLabels'] as List<dynamic>?)
        ?.map((e) => ScoredLabel.fromJson(e as Map<String, dynamic>))
        .toList()
    ..containedInCollections =
        (json['containedInCollections'] as List<dynamic>?)
            ?.map((e) => Collection.fromJson(e as Map<String, dynamic>))
            .toList()
    ..owner = json['owner'] == null
        ? null
        : User.fromJson(json['owner'] as Map<String, dynamic>)
    ..creationTimestamp = json['creationTimestamp'] as String?;
}

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'id': instance.id,
      'thumbnail': instance.thumbnail,
      'content': instance.content,
      'extractedText': instance.extractedText,
      'scoredLabels': instance.scoredLabels,
      'containedInCollections': instance.containedInCollections,
      'owner': instance.owner,
      'creationTimestamp': instance.creationTimestamp,
    };
