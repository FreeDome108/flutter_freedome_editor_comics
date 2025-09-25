import 'package:flutter/foundation.dart';
import '../models/layer.dart';
import '../models/image.dart';
import '../models/cultures.dart';
import '../models/animation_types.dart';
import '../models/translate_animation.dart';
import '../models/rotate_animation.dart';
import '../models/scale_animation.dart';
import '../models/alpha_animation.dart';
import 'comics_view_model.dart';

/// ViewModel для управления слоем
class LayerViewModel extends ChangeNotifier {
  final ComicsViewModel _comicsViewModel;
  final Layer layer;
  Animation? _selectedAnim;

  LayerViewModel(this._comicsViewModel, this.layer);

  Animation? get selectedAnim => _selectedAnim;
  set selectedAnim(Animation? value) {
    if (_selectedAnim != value) {
      _selectedAnim = value;
      notifyListeners();
    }
  }

  /// Получение изображения для текущего языка
  Image? get currentImage => layer.getImage(_comicsViewModel.culture);

  /// Обновление культуры
  void updateCulture() {
    notifyListeners();
  }

  /// Обновление скролла
  void updateScroll() {
    notifyListeners();
  }

  /// Получение текущего состояния анимации
  AnimationState getAnimationState() {
    final scroll = _comicsViewModel.scroll;

    final translate = Animation.interpolateAnimations<TranslateAnimation>(
      layer.animations,
      _selectedAnim,
      scroll,
      () => TranslateAnimation.createDefault(),
    );

    final rotate = Animation.interpolateAnimations<RotateAnimation>(
      layer.animations,
      _selectedAnim,
      scroll,
      () => RotateAnimation.createDefault(),
    );

    final scale = Animation.interpolateAnimations<ScaleAnimation>(
      layer.animations,
      _selectedAnim,
      scroll,
      () => ScaleAnimation.createDefault(),
    );

    final alpha = Animation.interpolateAnimations<AlphaAnimation>(
      layer.animations,
      _selectedAnim,
      scroll,
      () => AlphaAnimation.createDefault(),
    );

    return AnimationState(
      translateX: translate.x.toDouble(),
      translateY: translate.y.toDouble(),
      rotation: rotate.angle,
      scaleX: scale.scaleX,
      scaleY: scale.scaleY,
      alpha: alpha.alpha,
    );
  }

  /// Добавление анимации
  void addAnimation(AnimationType type) {
    final scroll = _comicsViewModel.scroll;

    switch (type) {
      case AnimationType.translate:
        Animation.add<TranslateAnimation>(
          layer.animations,
          scroll,
          () => TranslateAnimation.createDefault(),
        );
        break;
      case AnimationType.rotate:
        Animation.add<RotateAnimation>(
          layer.animations,
          scroll,
          () => RotateAnimation.createDefault(),
        );
        break;
      case AnimationType.scale:
        Animation.add<ScaleAnimation>(
          layer.animations,
          scroll,
          () => ScaleAnimation.createDefault(),
        );
        break;
      case AnimationType.alpha:
        Animation.add<AlphaAnimation>(
          layer.animations,
          scroll,
          () => AlphaAnimation.createDefault(),
        );
        break;
      case AnimationType.sound:
        // Звуковые анимации не добавляются к слоям
        break;
    }

    notifyListeners();
  }

  /// Удаление анимации
  void removeAnimation(Animation animation) {
    layer.animations.remove(animation);
    if (_selectedAnim == animation) {
      _selectedAnim = null;
    }
    notifyListeners();
  }
}

/// Состояние анимации
class AnimationState {
  final double translateX;
  final double translateY;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final double alpha;

  AnimationState({
    required this.translateX,
    required this.translateY,
    required this.rotation,
    required this.scaleX,
    required this.scaleY,
    required this.alpha,
  });
}
