import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

/// Процессор изображений - аналог ImageMagick для Flutter
class ImageProcessor {
  /// Получение размеров изображения
  static Future<Size> getImageSize(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Не удалось декодировать изображение: $filePath');
    }

    return Size(image.width, image.height);
  }

  /// Изменение размера изображения
  static Future<void> resizeImage(
    String inputPath,
    String outputPath,
    int width,
    int height,
  ) async {
    final file = File(inputPath);
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Не удалось декодировать изображение: $inputPath');
    }

    final resized = img.copyResize(
      image,
      width: width,
      height: height,
      interpolation: img.Interpolation.cubic,
    );

    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(img.encodePng(resized));
  }

  /// Создание тайлов из изображения
  static Future<void> createTiles(
    String inputPath,
    String outputTemplate,
    int tileSize,
  ) async {
    final file = File(inputPath);
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Не удалось декодировать изображение: $inputPath');
    }

    final width = image.width;
    final height = image.height;
    final tilesX = (width / tileSize).ceil();
    final tilesY = (height / tileSize).ceil();

    for (int y = 0; y < tilesY; y++) {
      for (int x = 0; x < tilesX; x++) {
        final tileX = x * tileSize;
        final tileY = y * tileSize;
        final tileWidth = (tileX + tileSize > width) ? width - tileX : tileSize;
        final tileHeight = (tileY + tileSize > height)
            ? height - tileY
            : tileSize;

        final tile = img.copyCrop(
          image,
          x: tileX,
          y: tileY,
          width: tileWidth,
          height: tileHeight,
        );

        final tilePath = outputTemplate
            .replaceAll('{0}', x.toString())
            .replaceAll('{1}', y.toString());
        final tileFile = File(tilePath);
        await tileFile.writeAsBytes(img.encodePng(tile));
      }
    }
  }

  /// Создание placeholder изображения
  static Future<void> createPlaceholder(
    String inputPath,
    String outputPath,
    int maxSize,
  ) async {
    final file = File(inputPath);
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Не удалось декодировать изображение: $inputPath');
    }

    // Если изображение уже меньше maxSize, просто копируем
    if (image.width <= maxSize && image.height <= maxSize) {
      await file.copy(outputPath);
      return;
    }

    // Вычисляем новые размеры с сохранением пропорций
    double scale;
    if (image.width > image.height) {
      scale = maxSize / image.width;
    } else {
      scale = maxSize / image.height;
    }

    final newWidth = (image.width * scale).round();
    final newHeight = (image.height * scale).round();

    final resized = img.copyResize(
      image,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.cubic,
    );

    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(img.encodePng(resized));
  }

  /// Конвертация изображения в PNG32
  static Future<void> convertToPng32(
    String inputPath,
    String outputPath,
  ) async {
    final file = File(inputPath);
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Не удалось декодировать изображение: $inputPath');
    }

    // Принудительно конвертируем в RGBA
    final rgbaImage = image.convert(format: img.Format.uint8, numChannels: 4);

    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(img.encodePng(rgbaImage));
  }
}

/// Класс для хранения размеров
class Size {
  final int width;
  final int height;

  Size(this.width, this.height);
}
