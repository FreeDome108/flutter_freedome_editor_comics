import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/comics.dart';
import '../models/layer.dart';
import '../models/sound.dart';
import '../models/cultures.dart';
import '../utils/file_manager.dart';
import '../utils/zip_utils.dart';
import 'layer_view_model.dart';
import 'sound_view_model.dart';

/// ViewModel для управления комиксом
class ComicsViewModel extends ChangeNotifier {
  Comics? _comics;
  List<LayerViewModel> _layers = [];
  List<SoundViewModel> _sounds = [];
  Cultures _culture = Cultures.en;
  double _scroll = 0.0;
  bool _disableSound = false;

  Comics? get comics => _comics;

  List<LayerViewModel> get layers => _layers;

  List<SoundViewModel> get sounds => _sounds;

  Cultures get culture => _culture;
  set culture(Cultures value) {
    if (_culture != value) {
      _culture = value;
      notifyListeners();
      for (final layer in _layers) {
        layer.updateCulture();
      }
    }
  }

  double get scroll => _scroll;
  set scroll(double value) {
    if (_scroll != value) {
      _scroll = value;
      notifyListeners();
      for (final layer in _layers) {
        layer.updateScroll();
      }
      for (final sound in _sounds) {
        sound.updateScroll();
      }
    }
  }

  bool get disableSound => _disableSound;
  set disableSound(bool value) {
    if (_disableSound != value) {
      _disableSound = value;
      notifyListeners();
      for (final sound in _sounds) {
        sound.updateScroll();
      }
    }
  }

  int get width => _comics?.width ?? 0;
  set width(int value) {
    if (_comics != null && _comics!.width != value) {
      _comics!.width = value;
      notifyListeners();
    }
  }

  int get height => _comics?.height ?? 0;
  set height(int value) {
    if (_comics != null && _comics!.height != value) {
      _comics!.height = value;
      notifyListeners();
    }
  }

  /// Инициализация комикса
  Future<void> initializeComics(String? filePath) async {
    await FileManager.deleteFolder();
    await FileManager.createFolders();

    if (filePath != null && !filePath.startsWith('<')) {
      await ZipUtils.unzip(filePath, await FileManager.tempFolder);
    }

    _comics = await Comics.load();
    _updateViewModels();
    notifyListeners();
  }

  /// Обновление ViewModels
  void _updateViewModels() {
    if (_comics == null) return;

    _layers = _comics!.layers
        .map((layer) => LayerViewModel(this, layer))
        .toList();

    _sounds = _comics!.sounds
        .map((sound) => SoundViewModel(this, sound))
        .toList();
  }

  /// Сохранение комикса
  Future<void> save([String? filePath]) async {
    if (_comics == null) return;

    await _comics!.save();

    if (filePath != null) {
      if (await File(filePath).exists()) {
        await File(filePath).delete();
      }
      await ZipUtils.zip(
        '${await FileManager.tempFolder}/*',
        filePath,
        compressionLevel: 0,
      );
    }
  }

  /// Добавление слоя
  Future<void> addLayer(String imagePath) async {
    if (_comics == null) return;

    final layer = await Layer.create(imagePath, _scroll, false);
    if (layer != null) {
      _comics!.layers.add(layer);
      _layers.add(LayerViewModel(this, layer));
      notifyListeners();
    }
  }

  /// Добавление звука
  Future<void> addSound(String audioPath) async {
    if (_comics == null) return;

    final sound = await Sound.create(audioPath, _scroll);
    _comics!.sounds.add(sound);
    _sounds.add(SoundViewModel(this, sound));
    notifyListeners();
  }

  /// Удаление слоя
  Future<void> removeLayer(LayerViewModel layerViewModel) async {
    if (_comics == null) return;

    await layerViewModel.layer.delete();
    _comics!.layers.remove(layerViewModel.layer);
    _layers.remove(layerViewModel);
    notifyListeners();
  }

  /// Удаление звука
  Future<void> removeSound(SoundViewModel soundViewModel) async {
    if (_comics == null) return;

    await soundViewModel.sound.delete();
    _comics!.sounds.remove(soundViewModel.sound);
    _sounds.remove(soundViewModel);
    notifyListeners();
  }

  @override
  void dispose() {
    for (final sound in _sounds) {
      sound.dispose();
    }
    super.dispose();
  }
}

