import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'image_processor.dart';

/// Менеджер файлов для работы с ресурсами Boranko 1.1
///
/// Управляет структурой:
/// - layers/ (слои)
/// - sounds/ (звуки)
///
/// Legacy форматы (puzzle, старый .comics) не поддерживаются
class FileManager {
  static const String folderLayers = 'layers';
  static const String folderSounds = 'sounds';
  static const int tileSize = 512;
  // Убрана поддержка puzzle формата
  static const List<double> borankoScales = [1.0]; // Только Boranko 1.1

  /// Получение временной папки для Boranko 1.1
  static Future<String> get tempFolder async {
    final tempDir = await getTemporaryDirectory();
    return '${tempDir.path}/BorankoEditor/Temp';
  }

  /// Получение расширения файла
  static String getFileExt(String name) {
    final ext = name.split('.').last;
    return ext.isNotEmpty ? '.$ext' : '.jpg';
  }

  /// Проверка существования файла
  static Future<bool> checkFile(
    String folder,
    String oldFile,
    String newFile,
  ) async {
    final tempDir = await tempFolder;
    final name = newFile.split('/').last.split('.').first;
    final ext = getFileExt(newFile);
    final singleName = '$name$ext';
    final tileName = '${name}_{0}_{1}_{2}$ext';

    final singlePath = '$tempDir/$folder/$singleName';
    final singleExists = await File(singlePath).exists();

    if (oldFile == singleName || oldFile == tileName || !singleExists) {
      return true;
    }

    // Проверяем тайлы
    final tilePattern = tileName
        .replaceAll('{0}', '*')
        .replaceAll('{1}', '*')
        .replaceAll('{2}', '*');
    final tileDir = Directory('$tempDir/$folder');
    if (await tileDir.exists()) {
      final files = await tileDir.list().toList();
      return !files.any((file) => file.path.contains(tilePattern));
    }

    return true;
  }

  /// Обновление файла
  static Future<String> update(
    String folder,
    String oldFile,
    String newFile,
  ) async {
    await delete(folder, oldFile);
    final tempDir = await tempFolder;
    final name = newFile.split('/').last.split('.').first;
    final ext = getFileExt(newFile);
    final fileName = '$name$ext';
    final destPath = '$tempDir/$folder/$fileName';

    await File(newFile).copy(destPath);
    return fileName;
  }

  /// Удаление файла
  static Future<void> delete(String folder, String oldFile) async {
    if (oldFile.isEmpty) return;

    final tempDir = await tempFolder;
    final filePath = '$tempDir/$folder/$oldFile';
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Обновление тайлов (Boranko 1.1)
  /// Параметр puzzle больше не используется
  static Future<String> updateTiles(
    String folder,
    String oldFile,
    String newFile,
    bool puzzle, // Deprecated: оставлен для обратной совместимости
  ) async {
    await deleteTiles(folder, oldFile);

    final tempDir = await tempFolder;
    final name = newFile.split('/').last.split('.').first;
    final ext = getFileExt(newFile);
    final scales =
        borankoScales; // Только Boranko 1.1, puzzle не поддерживается

    // Получаем размеры исходного изображения
    final size = await ImageProcessor.getImageSize(newFile);

    // Создаем тайлы для каждого масштаба
    for (final scale in scales) {
      final scaleInt = (scale * 1000).round();
      final scaledWidth = (size.width * scale).round();
      final scaledHeight = (size.height * scale).round();

      final scaledPath = '$tempDir/$folder/${name}_$scaleInt$ext';
      final tileTemplate =
          '$tempDir/$folder/${name}_${scaleInt}_{0}_{1}_{2}$ext';

      // Изменяем размер изображения
      await ImageProcessor.resizeImage(
        newFile,
        scaledPath,
        scaledWidth,
        scaledHeight,
      );

      // Создаем тайлы
      await ImageProcessor.createTiles(scaledPath, tileTemplate, tileSize);

      // Удаляем промежуточный файл
      await File(scaledPath).delete();
    }

    // Puzzle режим больше не поддерживается (только Boranko 1.1)

    final fullName = '${name}_{0}_{1}_{2}$ext';
    return fullName;
  }

  /// Удаление тайлов
  static Future<void> deleteTiles(String folder, String oldFile) async {
    if (oldFile.isEmpty) return;

    final tempDir = await tempFolder;
    final folderDir = Directory('$tempDir/$folder');

    if (await folderDir.exists()) {
      final files = await folderDir.list().toList();
      final pattern = oldFile
          .replaceAll('{0}', '*')
          .replaceAll('{1}', '*')
          .replaceAll('{2}', '*');

      for (final file in files) {
        if (file.path.contains(pattern)) {
          await file.delete();
        }
      }
    }
  }

  /// Удаление папки
  static Future<void> deleteFolder({int errorCount = 0}) async {
    try {
      final tempDir = await tempFolder;
      final dir = Directory(tempDir);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      if (errorCount > 10) {
        rethrow;
      }

      await Future.delayed(const Duration(milliseconds: 100));
      await deleteFolder(errorCount: errorCount + 1);
    }
  }

  /// Создание папок
  static Future<void> createFolders() async {
    final tempDir = await tempFolder;
    final folders = [folderLayers, folderSounds];

    for (final folder in folders) {
      final dir = Directory('$tempDir/$folder');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    }
  }
}
