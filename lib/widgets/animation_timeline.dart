import 'package:flutter/material.dart';
import '../models/animation_types.dart' as comics;
import '../viewmodels/layer_view_model.dart';

/// Временная шкала анимаций
class AnimationTimeline extends StatefulWidget {
  final LayerViewModel layerViewModel;
  final double scroll;
  final Function(double) onScrollChanged;

  const AnimationTimeline({
    super.key,
    required this.layerViewModel,
    required this.scroll,
    required this.onScrollChanged,
  });

  @override
  State<AnimationTimeline> createState() => _AnimationTimelineState();
}

class _AnimationTimelineState extends State<AnimationTimeline> {
  late double _currentScroll;

  @override
  void initState() {
    super.initState();
    _currentScroll = widget.scroll;
  }

  @override
  void didUpdateWidget(AnimationTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scroll != widget.scroll) {
      _currentScroll = widget.scroll;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.grey[50],
      ),
      child: Column(
        children: [
          // Заголовок
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: const Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                const Text(
                  'Timeline',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                // Кнопки добавления анимаций
                ...comics.AnimationType.values.map(
                  (type) => Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: ElevatedButton(
                      onPressed: () => widget.layerViewModel.addAnimation(type),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(40, 30),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(
                        type
                            .toString()
                            .split('.')
                            .last
                            .substring(0, 1)
                            .toUpperCase(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Временная шкала
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 2000, // Максимальная ширина временной шкалы
                height: 150,
                child: Stack(
                  children: [
                    // Фон с делениями
                    _buildTimelineBackground(),

                    // Анимации
                    ...widget.layerViewModel.layer.animations
                        .asMap()
                        .entries
                        .map(
                          (entry) =>
                              _buildAnimationWidget(entry.key, entry.value),
                        ),

                    // Индикатор текущего времени
                    _buildCurrentTimeIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineBackground() {
    return CustomPaint(
      painter: TimelineBackgroundPainter(),
      size: const Size(2000, 150),
    );
  }

  Widget _buildAnimationWidget(int index, comics.Animation animation) {
    final left = animation.start * 2.0; // 2 пикселя на единицу времени
    final width = (animation.end - animation.start) * 2.0;

    return Positioned(
      left: left,
      top: 20 + (index * 25),
      child: GestureDetector(
        onTap: () {
          widget.layerViewModel.selectedAnim = animation;
        },
        child: Container(
          width: width,
          height: 20,
          decoration: BoxDecoration(
            color: _getAnimationColor(animation.type),
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              animation.type.toString().split('.').last,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTimeIndicator() {
    return Positioned(
      left: _currentScroll * 2.0,
      top: 0,
      child: Container(
        width: 2,
        height: 150,
        color: Colors.red,
        child: const Center(
          child: Icon(Icons.keyboard_arrow_down, color: Colors.red, size: 16),
        ),
      ),
    );
  }

  Color _getAnimationColor(comics.AnimationType type) {
    switch (type) {
      case comics.AnimationType.translate:
        return Colors.blue;
      case comics.AnimationType.rotate:
        return Colors.green;
      case comics.AnimationType.scale:
        return Colors.orange;
      case comics.AnimationType.alpha:
        return Colors.purple;
      case comics.AnimationType.sound:
        return Colors.red;
    }
  }
}

/// Painter для фона временной шкалы
class TimelineBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke;

    // Рисуем вертикальные линии каждые 100 единиц времени
    for (int i = 0; i <= 20; i++) {
      final x = i * 100.0;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Рисуем горизонтальные линии для каждого слоя
    for (int i = 0; i < 5; i++) {
      final y = 20.0 + (i * 25.0);
      canvas.drawLine(const Offset(0, 0), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(TimelineBackgroundPainter oldDelegate) => false;
}
