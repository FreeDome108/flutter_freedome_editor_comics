/// Типы анимаций
enum AnimationType { translate, rotate, scale, alpha, sound }

/// Базовый класс для всех анимаций
abstract class Animation {
  int start;
  int end;
  AnimationType type;

  Animation({required this.start, required this.end, required this.type});

  /// Интерполяция между анимациями
  Animation interpolate(Animation current, double scroll);

  /// Фактор интерполяции (easing функция)
  double factor(double scroll) {
    final t = (scroll - start) / (end - start);
    return (-t) * t * t + 1; // easeOut cubic
  }

  /// Поиск ближайших анимаций для интерполяции
  static Tuple<T, T?> findNearest<T extends Animation>(
    List<Animation> animations,
    double scroll,
    T Function() createDefault,
  ) {
    T? prev;
    T? curr;

    final typedAnimations = animations.whereType<T>().toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    for (final anim in typedAnimations) {
      if (anim.end <= scroll) {
        prev = anim;
      } else {
        if (anim.start < scroll) {
          curr = anim;
        }
        break;
      }
    }

    prev ??= createDefault();

    return Tuple(prev, curr);
  }

  /// Интерполяция анимаций
  static T interpolateAnimations<T extends Animation>(
    List<Animation> animations,
    Animation? selected,
    double scroll,
    T Function() createDefault,
  ) {
    if (selected is T) {
      return selected;
    }

    final pair = findNearest<T>(animations, scroll, createDefault);
    return pair.item2 != null
        ? pair.item1.interpolate(pair.item2!, scroll) as T
        : pair.item1;
  }

  /// Добавление новой анимации
  static T add<T extends Animation>(
    List<Animation> animations,
    double scroll,
    T Function() createDefault,
  ) {
    final pair = findNearest<T>(animations, double.infinity, createDefault);
    final anim = pair.item1;

    final newAnim = createDefault();
    newAnim.start = scroll > anim.end ? scroll.round() : anim.end + 1;
    newAnim.end = newAnim.start + 200;

    animations.add(newAnim);
    return newAnim;
  }

  @override
  String toString() {
    return type.toString().split('.').last;
  }
}

/// Класс для хранения пары значений
class Tuple<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple(this.item1, this.item2);
}

