import 'package:json_annotation/json_annotation.dart';
import 'package:pictive_app_mvp/data/image/image.dart';

part 'image_bag.g.dart';

@JsonSerializable()
class ImageBag {

  List<Image>? images;

  ImageBag();

  factory ImageBag.fromJson(Map<String, dynamic> json) => _$ImageBagFromJson(json);

  Map<String, dynamic> toJson() => _$ImageBagToJson(this);

}
