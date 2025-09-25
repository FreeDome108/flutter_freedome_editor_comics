# Freedome Editor Comics

Flutter библиотека для создания и редактирования интерактивных комиксов с поддержкой анимации, звука и многоязычности.

## Описание

Freedome Editor Comics - это Flutter библиотека, портированная с C# legacy_comics_editor, которая предоставляет функциональность для создания интерактивных комиксов с поддержкой:

- **Многослойная структура** - создание слоев с изображениями
- **Анимация** - поддержка трансформаций (перемещение, поворот, масштабирование, прозрачность)
- **Звуковое сопровождение** - добавление аудио файлов с временными метками
- **Многоязычность** - поддержка нескольких языков (EN, RU, HI)
- **Экспорт/Импорт** - сохранение и загрузка проектов в формате .comics/.puzzle

## Формат данных

### Структура Comics

```dart
class Comics {
  int width;           // Ширина комикса
  int height;          // Высота комикса
  List<Layer> layers;  // Список слоев
  List<Sound> sounds; // Список звуков
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
- **Проекты**: .comics, .puzzle

### Выходные форматы
- **Проекты**: .comics (обычные комиксы), .puzzle (пазлы)

## Примеры использования

### Создание нового комикса

```dart
import 'package:freedome_editor_comics/freedome_editor_comics.dart';

// Создание нового комикса
final comics = Comics(
  width: 1080,
  height: 2160,
  layers: [],
  sounds: [],
);

// Добавление слоя
final layer = Layer.create(
  imagePath: '/path/to/image.jpg',
  scroll: 0.0,
  isPuzzle: false,
);

comics.layers.add(layer);

// Добавление звука
final sound = Sound.create(
  audioPath: '/path/to/audio.mp3',
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

### Сохранение и загрузка

```dart
// Сохранение комикса
await comics.save('/path/to/comics.comics');

// Загрузка комикса
final loadedComics = await Comics.load('/path/to/comics.comics');
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

Библиотека построена на основе MVVM паттерна:

- **Models** - Модели данных (Comics, Layer, Image, Sound, Animation)
- **ViewModels** - Логика представления (ComicsViewModel, LayerViewModel)
- **Utils** - Утилиты (FileManager, ZipUtils, ImageMagick)

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