import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;

/// Утилиты для работы с ZIP архивами
class ZipUtils {
  /// Создание ZIP архива
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

    await _addDirectoryToArchive(archive, srcDir, '');

    final zipData = ZipEncoder().encode(archive);
    if (zipData == null) {
      throw Exception('Failed to encode ZIP archive');
    }

    final dstFile = File(dstPath);
    await dstFile.writeAsBytes(zipData);
  }

  /// Распаковка ZIP архива
  static Future<void> unzip(String srcPath, String dstPath) async {
    final srcFile = File(srcPath);
    if (!await srcFile.exists()) {
      throw Exception('Source file does not exist: $srcPath');
    }

    final bytes = await srcFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final dstDir = Directory(dstPath);
    if (!await dstDir.exists()) {
      await dstDir.create(recursive: true);
    }

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

