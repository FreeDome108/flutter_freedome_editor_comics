import 'animation_types.dart';

/// Анимация перемещения
class TranslateAnimation extends Animation {
  int x;
  int y;

  TranslateAnimation({
    required super.start,
    required super.end,
    required this.x,
    required this.y,
  }) : super(type: AnimationType.translate);

  @override
  Animation interpolate(Animation current, double scroll) {
    final translate = current as TranslateAnimation;
    final factor = translate.factor(scroll);

    return TranslateAnimation(
      start: start,
      end: end,
      x: (x + (translate.x - x) * factor).round(),
      y: (y + (translate.y - y) * factor).round(),
    );
  }

  /// Создание анимации перемещения по умолчанию
  static TranslateAnimation createDefault() {
    return TranslateAnimation(start: 0, end: 200, x: 0, y: 0);
  }
}

