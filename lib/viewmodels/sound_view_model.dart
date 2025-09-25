import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/sound.dart';
import '../models/sound_animation.dart';
import '../models/animation_types.dart';
import 'comics_view_model.dart';

/// ViewModel для управления звуком
class SoundViewModel extends ChangeNotifier {
  final ComicsViewModel _comicsViewModel;
  final Sound sound;
  Animation? _selectedAnim;
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;

  SoundViewModel(this._comicsViewModel, this.sound);

  Animation? get selectedAnim => _selectedAnim;
  set selectedAnim(Animation? value) {
    if (_selectedAnim != value) {
      _selectedAnim = value;
      notifyListeners();
    }
  }

  bool get isPlaying => _isPlaying;

  /// Обновление скролла
  void updateScroll() {
    if (_comicsViewModel.disableSound) {
      stop();
      return;
    }

    final scroll = _comicsViewModel.scroll;
    final soundAnim = SoundAnimation.findCurrent(
      sound.animations,
      scroll - 1,
      scroll,
    );

    if (soundAnim != null && !_isPlaying) {
      play();
    } else if (soundAnim == null && _isPlaying) {
      stop();
    }
  }

  /// Воспроизведение звука
  Future<void> play() async {
    if (sound.file.isEmpty || _isPlaying) return;

    _audioPlayer ??= AudioPlayer();
    await _audioPlayer!.play(DeviceFileSource(sound.file));
    _isPlaying = true;
    notifyListeners();
  }

  /// Остановка звука
  Future<void> stop() async {
    if (!_isPlaying) return;

    await _audioPlayer?.stop();
    _isPlaying = false;
    notifyListeners();
  }

  /// Пауза звука
  Future<void> pause() async {
    if (!_isPlaying) return;

    await _audioPlayer?.pause();
    _isPlaying = false;
    notifyListeners();
  }

  /// Добавление звуковой анимации
  void addSoundAnimation() {
    final scroll = _comicsViewModel.scroll;
    sound.animations.add(
      SoundAnimation(start: scroll.round(), end: scroll.round()),
    );
    notifyListeners();
  }

  /// Удаление звуковой анимации
  void removeSoundAnimation(Animation animation) {
    sound.animations.remove(animation);
    if (_selectedAnim == animation) {
      _selectedAnim = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }
}
