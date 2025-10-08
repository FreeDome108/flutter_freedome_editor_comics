import 'animation_types.dart';

/// Анимация прозрачности
class AlphaAnimation extends Animation {
  double alpha;

  AlphaAnimation({
    required super.start,
    required super.end,
    required this.alpha,
  }) : super(type: AnimationType.alpha);

  @override
  Animation interpolate(Animation current, double scroll) {
    final alpha = current as AlphaAnimation;
    final factor = alpha.factor(scroll);

    return AlphaAnimation(
      start: start,
      end: end,
      alpha: this.alpha + (alpha.alpha - this.alpha) * factor,
    );
  }

  /// Создание анимации прозрачности по умолчанию
  static AlphaAnimation createDefault() {
    return AlphaAnimation(start: 0, end: 200, alpha: 1.0);
  }
}
