import 'animation_types.dart';
import 'pivot_animation.dart';

/// Анимация масштабирования
class ScaleAnimation extends PivotAnimation {
  double scaleX;
  double scaleY;

  ScaleAnimation({
    required super.start,
    required super.end,
    required this.scaleX,
    required this.scaleY,
    super.pivotX = 0.5,
    super.pivotY = 0.5,
  }) : super(type: AnimationType.scale);

  @override
  Animation interpolate(Animation current, double scroll) {
    final scale = current as ScaleAnimation;
    final factor = scale.factor(scroll);

    return ScaleAnimation(
      start: start,
      end: end,
      scaleX: scaleX + (scale.scaleX - scaleX) * factor,
      scaleY: scaleY + (scale.scaleY - scaleY) * factor,
      pivotX: scale.pivotX,
      pivotY: scale.pivotY,
    );
  }

  /// Создание анимации масштабирования по умолчанию
  static ScaleAnimation createDefault() {
    return ScaleAnimation(
      start: 0,
      end: 200,
      scaleX: 1.0,
      scaleY: 1.0,
      pivotX: 0.5,
      pivotY: 0.5,
    );
  }
}
