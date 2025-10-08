import 'animation_types.dart';

/// Анимация звука
class SoundAnimation extends Animation {
  SoundAnimation({required super.start, required super.end})
    : super(type: AnimationType.sound);

  @override
  Animation interpolate(Animation current, double scroll) {
    return current;
  }

  /// Поиск текущей звуковой анимации
  static SoundAnimation? findCurrent(
    List<Animation> animations,
    double prevScroll,
    double scroll,
  ) {
    try {
      return animations.whereType<SoundAnimation>().firstWhere(
        (x) =>
            (x.start <= scroll && x.end >= scroll) ||
            (x.start == x.end &&
                prevScroll < scroll &&
                prevScroll <= x.start &&
                x.start <= scroll),
      );
    } catch (e) {
      return null;
    }
  }

  /// Создание звуковой анимации по умолчанию
  static SoundAnimation createDefault() {
    return SoundAnimation(start: 0, end: 0);
  }
}

