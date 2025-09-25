import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

/// Модель изображения
@JsonSerializable()
class Image {
  String file;
  String popup;
  int width;
  int height;

  Image({this.file = '', this.popup = '', this.width = 0, this.height = 0});

  /// Проверка, является ли изображение тайлами
  bool get isTiles => file.isNotEmpty && file.contains('{0}');

  /// Обновление изображения
  Future<void> update(
    String folder,
    String newFile,
    bool puzzle,
    bool popup,
  ) async {
    // TODO: Implement file management
    if (popup) {
      this.popup = newFile;
    } else {
      file = newFile;
      // TODO: Get actual image dimensions
      width = 512;
      height = 512;
    }
  }

  /// Удаление изображения
  Future<void> delete(String folder) async {
    // TODO: Implement file deletion
    if (isTiles) {
      // TODO: Delete tiles
    } else {
      // TODO: Delete single file
    }
  }

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
