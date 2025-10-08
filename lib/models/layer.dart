import 'package:json_annotation/json_annotation.dart';
import 'cultures.dart';
import 'image.dart';
import 'animation_types.dart';
import 'translate_animation.dart';
import 'animation_serializer.dart';

part 'layer.g.dart';

/// Модель слоя комикса (Boranko 1.1)
/// Legacy puzzle формат не поддерживается
@JsonSerializable()
class Layer {
  bool preview;
  List<Image> images;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Animation> animations;

  Layer({
    this.preview = false,
    List<Image>? images,
    List<Animation>? animations,
  }) : images = images ?? [],
       animations = animations ?? [];

  /// Получение изображения для определенного языка
  Image? getImage(Cultures culture, {bool returnDefault = true}) {
    final index = CulturesHelper.indexOf(culture);
    final image = index >= 0 && index < images.length ? images[index] : null;

    if (image != null && image.file.isNotEmpty) {
      return image;
    }

    return returnDefault
        ? images.firstWhere(
            (img) => img.file.isNotEmpty,
            orElse: () => images.isNotEmpty ? images.first : Image(),
          )
        : null;
  }

  /// Установка изображения для определенного языка
  /// Параметр puzzle игнорируется (только Boranko 1.1)
  Future<void> setImage(
    Cultures culture,
    String file,
    bool puzzle, // Deprecated: оставлен для обратной совместимости
    bool popup,
  ) async {
    final index = CulturesHelper.indexOf(culture);
    if (index >= 0 && index < images.length) {
      await images[index].update(
        'layers',
        file,
        false,
        popup,
      ); // puzzle всегда false
    }
  }

  /// Удаление слоя
  Future<void> delete() async {
    for (final image in images) {
      await image.delete('layers');
    }
  }

  /// Создание нового слоя (Boranko 1.1)
  /// Параметр puzzle игнорируется
  static Future<Layer?> create(String file, double scroll, bool puzzle) async {
    final layer = Layer();

    // Создаем изображения для всех языков
    for (int i = 0; i < CulturesHelper.all.length; i++) {
      final image = Image();
      layer.images.add(image);

      if (i == 0) {
        await image.update(
          'layers',
          file,
          false,
          false,
        ); // puzzle всегда false (Boranko 1.1)
      }
    }

    // Проверяем, что хотя бы одно изображение было добавлено
    if (layer.images.every((img) => img.file.isEmpty)) {
      return null;
    }

    // Добавляем анимацию перемещения
    layer.animations.add(
      TranslateAnimation(
        start: scroll.round(),
        end: scroll.round() + 200,
        x: 0,
        y: 0,
      ),
    );

    return layer;
  }

  factory Layer.fromJson(Map<String, dynamic> json) {
    final layer = _$LayerFromJson(json);
    // Десериализация анимаций
    if (json['animations'] != null) {
      layer.animations = (json['animations'] as List)
          .map((e) => AnimationSerializer.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return layer;
  }

  Map<String, dynamic> toJson() {
    final json = _$LayerToJson(this);
    // Сериализация анимаций
    json['animations'] = animations
        .map((e) => AnimationSerializer.toJson(e))
        .toList();
    return json;
  }
}
