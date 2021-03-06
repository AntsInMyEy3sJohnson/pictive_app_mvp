import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pictive_app_mvp/data/image/image.dart';
import 'package:pictive_app_mvp/data/user/user.dart';

part 'collection.g.dart';

@JsonSerializable()
class Collection extends Equatable {
  String? id;
  bool? defaultCollection;
  List<Image>? images;
  List<User>? sourcedBy;
  User? owner;
  String? displayName;
  int? pin;
  bool? sourcingAllowed;
  bool? nonOwnersCanWrite;
  String? creationTimestamp;

  Collection();

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionToJson(this);

  @override
  List<Object?> get props => [id];
}
