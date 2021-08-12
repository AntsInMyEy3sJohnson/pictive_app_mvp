import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {

  String? id;
  String? mail;
  List<String>? ownedCollections;
  List<String>? sharedCollections;
  String? defaultCollection;
  List<String>? ownedImages;

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}
