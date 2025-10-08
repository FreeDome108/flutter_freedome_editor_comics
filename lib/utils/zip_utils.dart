import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;

/// Утилиты для работы с ZIP архивами
///
/// Поддерживает только формат Boranko 1.1:
/// - Распаковка .boranko архивов с data.json, layers/, sounds/
/// - Создание .boranko архивов с правильной структурой
class ZipUtils {
  /// Создание .boranko архива (Boranko 1.1)
  ///
  /// Создает архив со структурой:
  /// - data.json (корень)
  /// - layers/ (папка со слоями)
  /// - sounds/ (папка со звуками)
  static Future<void> zip(
    String srcPath,
    String dstPath, {
    int compressionLevel = 5,
  }) async {
    final archive = Archive();
    final srcDir = Directory(srcPath);

    if (!await srcDir.exists()) {
      throw Exception('Source directory does not exist: $srcPath');
    }

    // Проверяем наличие data.json
    final dataJsonFile = File(path.join(srcPath, 'data.json'));
    if (!await dataJsonFile.exists()) {
      throw Exception(
        'Invalid Boranko 1.1 structure: data.json not found in $srcPath',
      );
    }

    await _addDirectoryToArchive(archive, srcDir, '');

    final zipData = ZipEncoder().encode(archive);
    if (zipData == null) {
      throw Exception('Failed to encode Boranko archive');
    }

    final dstFile = File(dstPath);
    await dstFile.writeAsBytes(zipData);
  }

  /// Валидация .boranko архива
  static Future<bool> validateBorankoArchive(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return false;
      }

      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // Проверяем наличие data.json
      final hasDataJson = archive.files.any(
        (file) => file.name == 'data.json' || file.name.endsWith('/data.json'),
      );

      return hasDataJson;
    } catch (e) {
      return false;
    }
  }

  /// Распаковка .boranko архива (Boranko 1.1)
  ///
  /// Ожидаемая структура архива:
  /// - data.json (обязательно)
  /// - layers/ (папка со слоями)
  /// - sounds/ (папка со звуками)
  static Future<void> unzip(String srcPath, String dstPath) async {
    final srcFile = File(srcPath);
    if (!await srcFile.exists()) {
      throw Exception('Boranko file does not exist: $srcPath');
    }

    final bytes = await srcFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // Проверяем наличие data.json
    final hasDataJson = archive.files.any(
      (file) => file.name == 'data.json' || file.name.endsWith('/data.json'),
    );

    if (!hasDataJson) {
      throw Exception('Invalid Boranko 1.1 archive: data.json not found');
    }

    final dstDir = Directory(dstPath);
    if (!await dstDir.exists()) {
      await dstDir.create(recursive: true);
    }

    // Извлекаем все файлы
    for (final file in archive) {
      final filePath = path.join(dstPath, file.name);
      final fileDir = Directory(path.dirname(filePath));

      if (!await fileDir.exists()) {
        await fileDir.create(recursive: true);
      }

      if (file.isFile) {
        final outputFile = File(filePath);
        await outputFile.writeAsBytes(file.content as List<int>);
      }
    }

    // Проверяем структуру Boranko 1.1
    final dataJsonFile = File(path.join(dstPath, 'data.json'));
    if (!await dataJsonFile.exists()) {
      throw Exception(
        'Invalid Boranko 1.1 structure: data.json not found after extraction',
      );
    }
  }

  /// Добавление директории в архив
  static Future<void> _addDirectoryToArchive(
    Archive archive,
    Directory dir,
    String prefix,
  ) async {
    await for (final entity in dir.list(recursive: false)) {
      final relativePath = path.join(prefix, path.basename(entity.path));

      if (entity is File) {
        final bytes = await entity.readAsBytes();
        final archiveFile = ArchiveFile(relativePath, bytes.length, bytes);
        archive.addFile(archiveFile);
      } else if (entity is Directory) {
        await _addDirectoryToArchive(archive, entity, relativePath);
      }
    }
  }
}
