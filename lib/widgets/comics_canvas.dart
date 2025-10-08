import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../viewmodels/comics_view_model.dart';
import '../viewmodels/layer_view_model.dart';

/// Canvas для отображения и редактирования комиксов
class ComicsCanvas extends StatefulWidget {
  final ComicsViewModel viewModel;
  final double width;
  final double height;

  const ComicsCanvas({
    super.key,
    required this.viewModel,
    this.width = 400,
    this.height = 600,
  });

  @override
  State<ComicsCanvas> createState() => _ComicsCanvasState();
}

class _ComicsCanvasState extends State<ComicsCanvas> {
  late ComicsViewModel _viewModel;
  final List<ui.Image> _cachedImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.addListener(_onViewModelChanged);
    _loadImages();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {
      _loadImages();
    });
  }

  Future<void> _loadImages() async {
    setState(() {
      _isLoading = true;
    });

    _cachedImages.clear();

    for (final layerViewModel in _viewModel.layers) {
      final image = layerViewModel.currentImage;
      if (image != null && image.file.isNotEmpty) {
        try {
          final uiImage = await _loadImageFromFile(image.file);
          _cachedImages.add(uiImage);
        } catch (e) {
          // TODO: Add proper logging
          // print('Ошибка загрузки изображения: $e');
          _cachedImages.add(await _createPlaceholderImage());
        }
      } else {
        _cachedImages.add(await _createPlaceholderImage());
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<ui.Image> _loadImageFromFile(String filePath) async {
    // TODO: Реализовать загрузку изображений из файловой системы
    // Пока возвращаем placeholder
    return await _createPlaceholderImage();
  }

  Future<ui.Image> _createPlaceholderImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, 200, 200), paint);

    final picture = recorder.endRecording();
    return await picture.toImage(200, 200);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomPaint(
              painter: ComicsPainter(
                layers: _viewModel.layers,
                cachedImages: _cachedImages,
                scroll: _viewModel.scroll,
              ),
            ),
    );
  }
}

/// Painter для отрисовки комиксов
class ComicsPainter extends CustomPainter {
  final List<LayerViewModel> layers;
  final List<ui.Image> cachedImages;
  final double scroll;

  ComicsPainter({
    required this.layers,
    required this.cachedImages,
    required this.scroll,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Очищаем canvas
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // Рисуем слои
    for (int i = 0; i < layers.length && i < cachedImages.length; i++) {
      final layer = layers[i];
      final image = cachedImages[i];
      final animationState = layer.getAnimationState();

      canvas.save();

      // Применяем трансформации
      canvas.translate(animationState.translateX, animationState.translateY);
      canvas.rotate(animationState.rotation * 3.14159 / 180);
      canvas.scale(animationState.scaleX, animationState.scaleY);

      // Применяем прозрачность
      final paint = Paint()
        ..colorFilter = ColorFilter.mode(
          Colors.white.withValues(alpha: animationState.alpha),
          BlendMode.modulate,
        );

      // Рисуем изображение
      canvas.drawImage(image, Offset.zero, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ComicsPainter oldDelegate) {
    return oldDelegate.scroll != scroll ||
        oldDelegate.layers.length != layers.length ||
        oldDelegate.cachedImages.length != cachedImages.length;
  }
}

