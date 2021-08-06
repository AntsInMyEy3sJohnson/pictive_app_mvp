import 'package:json_annotation/json_annotation.dart';
import 'package:pictive_app_mvp/data/user/user.dart';

part 'user_bag.g.dart';

@JsonSerializable()
class UserBag {

  List<User>? users;

  UserBag();

  factory UserBag.fromJson(Map<String, dynamic> json) => _$UserBagFromJson(json);

  Map<String, dynamic> toJson() => _$UserBagToJson(this);

}
