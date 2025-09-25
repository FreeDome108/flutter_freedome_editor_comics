import 'package:json_annotation/json_annotation.dart';
import 'animation_types.dart';
import 'sound_animation.dart';
import 'animation_serializer.dart';

part 'sound.g.dart';

/// Модель звука
@JsonSerializable()
class Sound {
  String file;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Animation> animations;

  Sound({this.file = '', List<Animation>? animations})
    : animations = animations ?? [];

  /// Удаление звука
  Future<void> delete() async {
    // TODO: Implement file deletion
  }

  /// Создание нового звука
  static Future<Sound> create(String file, double scroll) async {
    final sound = Sound(file: file);

    // Добавляем звуковую анимацию
    sound.animations.add(
      SoundAnimation(start: scroll.round(), end: scroll.round()),
    );

    return sound;
  }

  factory Sound.fromJson(Map<String, dynamic> json) {
    final sound = _$SoundFromJson(json);
    // Десериализация анимаций
    if (json['animations'] != null) {
      sound.animations = (json['animations'] as List)
          .map((e) => AnimationSerializer.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return sound;
  }

  Map<String, dynamic> toJson() {
    final json = _$SoundToJson(this);
    // Сериализация анимаций
    json['animations'] = animations
        .map((e) => AnimationSerializer.toJson(e))
        .toList();
    return json;
  }
}
