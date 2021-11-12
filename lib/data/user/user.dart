import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/image/image.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  String? id;
  String? mail;
  List<Collection>? ownedCollections;
  List<Collection>? sourcedCollections;
  Collection? defaultCollection;
  List<Image>? ownedImages;

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id];
}
