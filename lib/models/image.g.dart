// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) => Image(
  file: json['file'] as String? ?? '',
  popup: json['popup'] as String? ?? '',
  width: (json['width'] as num?)?.toInt() ?? 0,
  height: (json['height'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
  'file': instance.file,
  'popup': instance.popup,
  'width': instance.width,
  'height': instance.height,
};
