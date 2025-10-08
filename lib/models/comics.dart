import 'dart:convert';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'layer.dart';
import 'sound.dart';

part 'comics.g.dart';

/// Основная модель комикса (BORANKO V1.1)
///
/// Поддерживает только формат Boranko 1.1:
/// - data.json с версией
/// - layers/ папка со слоями
/// - sounds/ папка со звуками
@JsonSerializable()
class Comics {
  String version; // Версия формата (должна быть "1.1.0")
  int width;
  int height;
  List<Layer> layers;
  List<Sound> sounds;

  Comics({
    this.version = '1.1.0',
    this.width = 1080,
    this.height = 2160,
    List<Layer>? layers,
    List<Sound>? sounds,
  }) : layers = layers ?? [],
       sounds = sounds ?? [];

  /// Сохранение комикса в формате Boranko 1.1
  /// Создает data.json в корне временной папки
  Future<void> save() async {
    // Проверяем версию
    if (version != '1.1.0') {
      throw Exception(
        'Unsupported version: $version. Only Boranko 1.1.0 is supported.',
      );
    }

    final tempDir = await getTemporaryDirectory();
    final dataFile = File('${tempDir.path}/data.json');
    await dataFile.writeAsString(jsonEncode(toJson()));
  }

  /// Загрузка комикса из data.json (Boranko 1.1)
  static Future<Comics> load() async {
    final tempDir = await getTemporaryDirectory();
    final dataFile = File('${tempDir.path}/data.json');

    if (await dataFile.exists()) {
      final jsonString = await dataFile.readAsString();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final comics = Comics.fromJson(json);

      // Проверяем версию
      if (comics.version != '1.1.0') {
        throw Exception(
          'Unsupported version: ${comics.version}. Only Boranko 1.1.0 is supported.',
        );
      }

      return comics;
    }

    return Comics(version: '1.1.0', width: 1080, height: 2160);
  }

  /// Валидация формата Boranko 1.1
  bool validate() {
    if (version != '1.1.0') {
      return false;
    }
    // Boranko 1.1 требует наличия data.json с версией
    return true;
  }

  factory Comics.fromJson(Map<String, dynamic> json) => _$ComicsFromJson(json);
  Map<String, dynamic> toJson() => _$ComicsToJson(this);
}
