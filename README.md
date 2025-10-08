# Freedome Editor Comics - Boranko 1.1

Flutter библиотека для создания и редактирования интерактивных комиксов в формате **Boranko 1.1**.

## Описание

Freedome Editor Comics - это Flutter библиотека для работы с форматом **Boranko 1.1**, который представляет собой современный стандарт для интерактивных комиксов с поддержкой:

- **Многослойная структура** - создание слоев с изображениями и анимациями
- **Анимация** - поддержка трансформаций (перемещение, поворот, масштабирование, прозрачность)
- **Звуковое сопровождение** - добавление аудио файлов с привязкой к слоям
- **Многоязычность** - поддержка нескольких языков (EN, RU, HI)
- **Формат Boranko 1.1** - современный формат с data.json, layers/, sounds/

## ⚠️ Важно: Только Boranko 1.1

**Эта библиотека поддерживает ТОЛЬКО формат Boranko 1.1.**

Legacy форматы больше не поддерживаются:
- ❌ Старый формат .comics без data.json
- ❌ Формат .puzzle
- ✅ Только Boranko 1.1 (.boranko с data.json)

## Формат данных Boranko 1.1

### Структура .boranko архива

```
project.boranko (ZIP архив)
├── data.json          # Основной файл с метаданными
├── layers/            # Папка со слоями (изображения)
│   ├── layer_0.jpg
│   ├── layer_1.png
│   └── ...
└── sounds/            # Папка со звуками
    ├── sound_0.mp3
    ├── sound_1.mp3
    └── ...
```

### Структура data.json

```json
{
  "version": "1.1.0",
  "width": 1080,
  "height": 2160,
  "layers": [...],
  "sounds": [...]
}
```

### Структура Comics (Dart)

```dart
class Comics {
  String version;      // Версия формата (всегда "1.1.0")
  int width;           // Ширина комикса
  int height;          // Высота комикса
  List<Layer> layers;  // Список слоев
  List<Sound> sounds;  // Список звуков
}
```

### Структура Layer

```dart
class Layer {
  bool preview;                    // Превью режим
  List<Image> images;              // Изображения для разных языков
  List<Animation> animations;      // Анимации слоя
}
```

### Структура Image

```dart
class Image {
  String file;          // Путь к файлу изображения
  String popup;         // Путь к popup изображению
  int width;           // Ширина изображения
  int height;          // Высота изображения
  bool isTiles;        // Является ли изображение тайлами
}
```

### Типы анимаций

#### TranslateAnim (Перемещение)
```dart
class TranslateAnim extends Animation {
  int x;  // Смещение по X
  int y;  // Смещение по Y
}
```

#### RotateAnim (Поворот)
```dart
class RotateAnim extends PivotAnimation {
  double angle;   // Угол поворота в градусах
  double pivotX;  // Точка поворота X (0.0-1.0)
  double pivotY;  // Точка поворота Y (0.0-1.0)
}
```

#### ScaleAnim (Масштабирование)
```dart
class ScaleAnim extends PivotAnimation {
  double scaleX;  // Масштаб по X
  double scaleY;  // Масштаб по Y
  double pivotX;  // Точка масштабирования X (0.0-1.0)
  double pivotY;  // Точка масштабирования Y (0.0-1.0)
}
```

#### AlphaAnim (Прозрачность)
```dart
class AlphaAnim extends Animation {
  double alpha;  // Прозрачность (0.0-1.0)
}
```

#### SoundAnim (Звук)
```dart
class SoundAnim extends Animation {
  // Специальная анимация для воспроизведения звука
}
```

### Структура Sound

```dart
class Sound {
  String file;                    // Путь к аудио файлу
  List<Animation> animations;     // Анимации звука
}
```

### Базовый класс Animation

```dart
abstract class Animation {
  int start;        // Начальное время
  int end;          // Конечное время
  AnimationType type; // Тип анимации
  
  // Интерполяция между анимациями
  Animation interpolate(Animation current, double scroll);
  
  // Фактор интерполяции
  double factor(double scroll);
}
```

## Поддерживаемые языки

- **EN** - English
- **RU** - Русский  
- **HI** - Hindi

## Форматы файлов

### Входные форматы
- **Изображения**: JPG, PNG
- **Аудио**: MP3
- **Проекты**: .boranko (только Boranko 1.1)

### Выходные форматы
- **Проекты**: .boranko (Boranko 1.1 с data.json, layers/, sounds/)

## Примеры использования

### Создание нового комикса (Boranko 1.1)

```dart
import 'package:freedome_editor_comics/freedome_editor_comics.dart';

// Создание нового комикса в формате Boranko 1.1
final comics = Comics(
  version: '1.1.0',  // Обязательно указываем версию
  width: 1080,
  height: 2160,
  layers: [],
  sounds: [],
);

// Добавление слоя
final layer = await Layer.create(
  '/path/to/image.jpg',
  scroll: 0.0,
  puzzle: false,  // Deprecated, игнорируется
);

if (layer != null) {
  comics.layers.add(layer);
}

// Добавление звука
final sound = await Sound.create(
  '/path/to/audio.mp3',
  scroll: 0.0,
);

comics.sounds.add(sound);
```

### Работа с анимациями

```dart
// Добавление анимации перемещения
final translateAnim = TranslateAnim(
  start: 0,
  end: 1000,
  x: 100,
  y: 50,
);

layer.animations.add(translateAnim);

// Добавление анимации поворота
final rotateAnim = RotateAnim(
  start: 500,
  end: 1500,
  angle: 45.0,
  pivotX: 0.5,
  pivotY: 0.5,
);

layer.animations.add(rotateAnim);
```

### Сохранение и загрузка (Boranko 1.1)

```dart
// Сохранение в формат Boranko 1.1
final viewModel = ComicsViewModel();
await viewModel.save('/path/to/project.boranko');

// Загрузка из Boranko 1.1 архива
await viewModel.initializeComics('/path/to/project.boranko');

// Валидация Boranko 1.1 архива
final isValid = await ZipUtils.validateBorankoArchive('/path/to/project.boranko');
if (isValid) {
  print('Valid Boranko 1.1 archive!');
}
```

### Воспроизведение анимации

```dart
// Получение текущего состояния анимации
final currentState = layer.getAnimationState(scroll: 500.0);

// Применение трансформаций
canvas.translate(currentState.translateX, currentState.translateY);
canvas.rotate(currentState.rotation);
canvas.scale(currentState.scaleX, currentState.scaleY);
canvas.setAlpha(currentState.alpha);
```

## Архитектура

Библиотека построена на основе MVVM паттерна и поддерживает только формат Boranko 1.1:

- **Models** - Модели данных (Comics, Layer, Image, Sound, Animation)
  - Comics: версия 1.1.0, поддержка data.json
  - Layer: работа со слоями в папке layers/
  - Sound: работа со звуками в папке sounds/
- **ViewModels** - Логика представления (ComicsViewModel, LayerViewModel, SoundViewModel)
  - Валидация версии Boranko 1.1
  - Автоматическая проверка архивов
- **Utils** - Утилиты
  - FileManager: управление структурой Boranko 1.1
  - ZipUtils: работа с .boranko архивами
  - ImageProcessor: обработка изображений

## Зависимости

- `path_provider` - для работы с файловой системой
- `archive` - для работы с ZIP архивами
- `image` - для обработки изображений
- `audioplayers` - для воспроизведения звука

## Установка

```yaml
dependencies:
  freedome_editor_comics: ^1.0.0
```

## Лицензия

MIT License

## Поддержка

Для вопросов и предложений создавайте issues в репозитории проекта.