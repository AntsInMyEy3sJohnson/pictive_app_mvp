// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scored_label.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoredLabel _$ScoredLabelFromJson(Map<String, dynamic> json) {
  return ScoredLabel()
    ..label = json['label'] as String?
    ..score = (json['score'] as num?)?.toDouble();
}

Map<String, dynamic> _$ScoredLabelToJson(ScoredLabel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'score': instance.score,
    };
