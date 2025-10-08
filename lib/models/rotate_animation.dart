import 'animation_types.dart';
import 'pivot_animation.dart';

/// Анимация поворота
class RotateAnimation extends PivotAnimation {
  double angle;

  RotateAnimation({
    required super.start,
    required super.end,
    required this.angle,
    super.pivotX = 0.5,
    super.pivotY = 0.5,
  }) : super(type: AnimationType.rotate);

  @override
  Animation interpolate(Animation current, double scroll) {
    final rotate = current as RotateAnimation;
    final factor = rotate.factor(scroll);

    return RotateAnimation(
      start: start,
      end: end,
      angle: angle + (rotate.angle - angle) * factor,
      pivotX: rotate.pivotX,
      pivotY: rotate.pivotY,
    );
  }

  /// Создание анимации поворота по умолчанию
  static RotateAnimation createDefault() {
    return RotateAnimation(
      start: 0,
      end: 200,
      angle: 0.0,
      pivotX: 0.5,
      pivotY: 0.5,
    );
  }
}

