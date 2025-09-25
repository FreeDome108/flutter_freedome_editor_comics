import 'package:json_annotation/json_annotation.dart';
import '../utils/file_manager.dart';
import '../utils/image_processor.dart';

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
    if (popup) {
      this.popup = await FileManager.update(folder, this.popup, newFile);
    } else {
      file = await FileManager.updateTiles(folder, file, newFile, puzzle);
      // Получаем реальные размеры изображения
      final size = await ImageProcessor.getImageSize(newFile);
      width = size.width;
      height = size.height;
    }
  }

  /// Удаление изображения
  Future<void> delete(String folder) async {
    if (isTiles) {
      await FileManager.deleteTiles(folder, file);
    } else {
      await FileManager.delete(folder, file);
    }
  }

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
