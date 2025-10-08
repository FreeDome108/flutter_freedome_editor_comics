import 'animation_types.dart';

/// Базовый класс для анимаций с точкой поворота
abstract class PivotAnimation extends Animation {
  double pivotX;
  double pivotY;

  PivotAnimation({
    required super.start,
    required super.end,
    this.pivotX = 0.5,
    this.pivotY = 0.5,
    required super.type,
  });

  /// Точка поворота как координаты
  Point get pivot => Point(pivotX, pivotY);
}

/// Класс для представления точки
class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}

