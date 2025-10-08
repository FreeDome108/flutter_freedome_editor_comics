import 'dart:convert';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'layer.dart';
import 'sound.dart';

part 'comics.g.dart';

/// Основная модель комикса
@JsonSerializable()
class Comics {
  int width;
  int height;
  List<Layer> layers;
  List<Sound> sounds;

  Comics({
    this.width = 1080,
    this.height = 2160,
    List<Layer>? layers,
    List<Sound>? sounds,
  }) : layers = layers ?? [],
       sounds = sounds ?? [];

  /// Сохранение комикса
  Future<void> save() async {
    final tempDir = await getTemporaryDirectory();
    final dataFile = File('${tempDir.path}/data.json');
    await dataFile.writeAsString(jsonEncode(toJson()));
  }

  /// Загрузка комикса
  static Future<Comics> load() async {
    final tempDir = await getTemporaryDirectory();
    final dataFile = File('${tempDir.path}/data.json');

    if (await dataFile.exists()) {
      final jsonString = await dataFile.readAsString();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return Comics.fromJson(json);
    }

    return Comics(width: 1080, height: 2160);
  }

  /// Сохранение в файл
  Future<void> saveToFile(String filePath) async {
    // TODO: Implement ZIP archive creation
    await save();
    // TODO: Create ZIP with all assets
  }

  /// Загрузка из файла
  static Future<Comics> loadFromFile(String filePath) async {
    // TODO: Implement ZIP archive extraction
    return await load();
  }

  factory Comics.fromJson(Map<String, dynamic> json) => _$ComicsFromJson(json);
  Map<String, dynamic> toJson() => _$ComicsToJson(this);
}

