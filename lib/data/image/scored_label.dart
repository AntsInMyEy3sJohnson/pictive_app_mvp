import 'package:json_annotation/json_annotation.dart';

part 'scored_label.g.dart';

@JsonSerializable()
class ScoredLabel {

  String? label;
  double? score;

  ScoredLabel();

  factory ScoredLabel.fromJson(Map<String, dynamic> json) => _$ScoredLabelFromJson(json);

  Map<String, dynamic> toJson() => _$ScoredLabelToJson(this);

}
