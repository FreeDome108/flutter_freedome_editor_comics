// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Layer _$LayerFromJson(Map<String, dynamic> json) => Layer(
  preview: json['preview'] as bool? ?? false,
  images: (json['images'] as List<dynamic>?)
      ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LayerToJson(Layer instance) => <String, dynamic>{
  'preview': instance.preview,
  'images': instance.images,
};
