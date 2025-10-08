# Миграция на Boranko 1.1

## Изменения в freedome_editor_comics

С версии 1.1.0 библиотека **freedome_editor_comics** поддерживает только формат **Boranko 1.1**.

## Что изменилось?

### ✅ Поддерживается

- **Формат Boranko 1.1** - современный формат с:
  - `data.json` - основной файл метаданных с версией
  - `layers/` - папка со слоями
  - `sounds/` - папка со звуками
  - Версия: `1.1.0`

### ❌ Больше не поддерживается

- **Legacy .comics** - старый формат без `data.json`
- **Формат .puzzle** - старый формат для пазлов
- **Множественные масштабы** - теперь только `1.0`

## Основные изменения в API

### Comics Model

```dart
// До (Legacy)
final comics = Comics(
  width: 1080,
  height: 2160,
);

// После (Boranko 1.1)
final comics = Comics(
  version: '1.1.0',  // ⭐ Новое поле
  width: 1080,
  height: 2160,
);
```

### Сохранение и загрузка

```dart
// До (Legacy)
await comics.saveToFile('/path/to/project.comics');
final loaded = await Comics.loadFromFile('/path/to/project.comics');

// После (Boranko 1.1)
final viewModel = ComicsViewModel();
await viewModel.save('/path/to/project.boranko');
await viewModel.initializeComics('/path/to/project.boranko');
```

### Валидация архива

```dart
// Новая функция - валидация Boranko 1.1 архива
final isValid = await ZipUtils.validateBorankoArchive('/path/to/project.boranko');
if (!isValid) {
  throw Exception('Invalid Boranko 1.1 archive');
}
```

### FileManager

```dart
// До
static const List<double> comicsScales = [1.0];
static const List<double> puzzleScales = [1.0, 0.5, 0.25, 0.125];

// После
static const List<double> borankoScales = [1.0]; // Только Boranko 1.1
```

### Временная папка

```dart
// До
ComicsEditor/Temp

// После
BorankoEditor/Temp  // ⭐ Новое имя
```

## Структура архива

### Legacy (.comics)

```
project.comics
├── metadata.json (опционально)
└── page_*.jpg
```

### Boranko 1.1 (.boranko)

```
project.boranko
├── data.json          ⭐ Обязательно, с версией
├── layers/            ⭐ Структурированные слои
│   ├── layer_0.jpg
│   └── ...
└── sounds/            ⭐ Структурированные звуки
    ├── sound_0.mp3
    └── ...
```

## Миграция существующих проектов

### Автоматическая миграция

Если у вас есть старые .comics файлы, используйте `freedome_sphere` для конвертации:

```dart
import 'package:freedome_sphere_flutter/services/boranko_service.dart';

final borankoService = BorankoService();

// Конвертация .comics -> .boranko 1.1
final project = await borankoService.importComicsAsBoranko(
  'old_project.comics',
  enableTranslation: false,
);

// Сохранение в новом формате
await borankoService.saveBorankoProject(
  project,
  'new_project_boranko',
);
```

### Ручная миграция

1. Создайте структуру папок:
```bash
mkdir project_boranko
mkdir project_boranko/layers
mkdir project_boranko/sounds
```

2. Создайте `data.json`:
```json
{
  "version": "1.1.0",
  "width": 1080,
  "height": 2160,
  "layers": [],
  "sounds": []
}
```

3. Переместите файлы:
- Изображения → `layers/`
- Аудио → `sounds/`

4. Создайте .boranko архив:
```bash
cd project_boranko
zip -r ../project.boranko *
```

## Проверка совместимости

```dart
try {
  final viewModel = ComicsViewModel();
  await viewModel.initializeComics('/path/to/project.boranko');
  print('✅ Совместимо с Boranko 1.1');
} catch (e) {
  print('❌ Ошибка: $e');
  // Возможные ошибки:
  // - Invalid Boranko 1.1 archive: data.json not found
  // - Unsupported version: 1.0.0. Only Boranko 1.1.0 is supported.
}
```

## Часто задаваемые вопросы

### Q: Могу ли я использовать старые .comics файлы?

**A:** Нет, только Boranko 1.1. Используйте `freedome_sphere` для конвертации.

### Q: Что случилось с puzzle форматом?

**A:** Puzzle формат устарел и больше не поддерживается. Boranko 1.1 - универсальный формат.

### Q: Можно ли вернуться к старому формату?

**A:** Нет, библиотека полностью переведена на Boranko 1.1. Используйте старую версию библиотеки для работы с legacy форматами.

### Q: Где найти примеры Boranko 1.1 проектов?

**A:** Смотрите тесты в `freedome_sphere/test/boranko_v11_import_test.dart`.

## Дополнительная информация

- [BORANKO_V1.1_SUMMARY.md](../freedome_sphere/BORANKO_V1.1_SUMMARY.md) - полная спецификация
- [BORANKO_V1.1_IMPLEMENTATION.md](../freedome_sphere/BORANKO_V1.1_IMPLEMENTATION.md) - детали реализации
- [README.md](README.md) - основная документация библиотеки

---

**NativeMindNONC** - FreeDome Project  
Boranko 1.1 Migration Guide  
2025-01-08
