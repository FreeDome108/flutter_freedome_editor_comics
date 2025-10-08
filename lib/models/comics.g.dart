// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comics _$ComicsFromJson(Map<String, dynamic> json) => Comics(
  version: json['version'] as String? ?? '1.1.0',
  width: (json['width'] as num?)?.toInt() ?? 1080,
  height: (json['height'] as num?)?.toInt() ?? 2160,
  layers: (json['layers'] as List<dynamic>?)
      ?.map((e) => Layer.fromJson(e as Map<String, dynamic>))
      .toList(),
  sounds: (json['sounds'] as List<dynamic>?)
      ?.map((e) => Sound.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ComicsToJson(Comics instance) => <String, dynamic>{
  'version': instance.version,
  'width': instance.width,
  'height': instance.height,
  'layers': instance.layers,
  'sounds': instance.sounds,
};
