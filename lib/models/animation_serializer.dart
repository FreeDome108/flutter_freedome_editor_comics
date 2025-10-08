import 'animation_types.dart';
import 'translate_animation.dart';
import 'rotate_animation.dart';
import 'scale_animation.dart';
import 'alpha_animation.dart';
import 'sound_animation.dart';

/// Сериализатор для анимаций
class AnimationSerializer {
  static Map<String, dynamic> toJson(Animation animation) {
    final json = <String, dynamic>{
      'type': animation.type.toString().split('.').last,
      'start': animation.start,
      'end': animation.end,
    };

    switch (animation.type) {
      case AnimationType.translate:
        final translate = animation as TranslateAnimation;
        json['x'] = translate.x;
        json['y'] = translate.y;
        break;
      case AnimationType.rotate:
        final rotate = animation as RotateAnimation;
        json['angle'] = rotate.angle;
        json['pivotX'] = rotate.pivotX;
        json['pivotY'] = rotate.pivotY;
        break;
      case AnimationType.scale:
        final scale = animation as ScaleAnimation;
        json['scaleX'] = scale.scaleX;
        json['scaleY'] = scale.scaleY;
        json['pivotX'] = scale.pivotX;
        json['pivotY'] = scale.pivotY;
        break;
      case AnimationType.alpha:
        final alpha = animation as AlphaAnimation;
        json['alpha'] = alpha.alpha;
        break;
      case AnimationType.sound:
        // SoundAnimation не имеет дополнительных полей
        break;
    }

    return json;
  }

  static Animation fromJson(Map<String, dynamic> json) {
    final type = AnimationType.values.firstWhere(
      (e) => e.toString().split('.').last == json['type'],
    );
    final start = json['start'] as int;
    final end = json['end'] as int;

    switch (type) {
      case AnimationType.translate:
        return TranslateAnimation(
          start: start,
          end: end,
          x: json['x'] as int,
          y: json['y'] as int,
        );
      case AnimationType.rotate:
        return RotateAnimation(
          start: start,
          end: end,
          angle: (json['angle'] as num).toDouble(),
          pivotX: (json['pivotX'] as num).toDouble(),
          pivotY: (json['pivotY'] as num).toDouble(),
        );
      case AnimationType.scale:
        return ScaleAnimation(
          start: start,
          end: end,
          scaleX: (json['scaleX'] as num).toDouble(),
          scaleY: (json['scaleY'] as num).toDouble(),
          pivotX: (json['pivotX'] as num).toDouble(),
          pivotY: (json['pivotY'] as num).toDouble(),
        );
      case AnimationType.alpha:
        return AlphaAnimation(
          start: start,
          end: end,
          alpha: (json['alpha'] as num).toDouble(),
        );
      case AnimationType.sound:
        return SoundAnimation(start: start, end: end);
    }
  }
}
