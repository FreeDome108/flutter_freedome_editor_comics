# Changelog

## [1.1.0] - 2025-01-08

### 🎯 MAJOR CHANGES - Boranko 1.1 Only

**This version ONLY supports Boranko 1.1 format. Legacy formats are no longer supported.**

### ✅ Added

- **Boranko 1.1 Support**: Full implementation of Boranko 1.1 format
  - `Comics.version` field (always "1.1.0")
  - `data.json` + `layers/` + `sounds/` structure
  - Validation of archive format
  - Version checking on load/save

- **ZipUtils Enhancements**:
  - `validateBorankoArchive()` - validates .boranko archives
  - Automatic data.json validation on unzip
  - Proper error messages for invalid archives

- **ComicsViewModel Improvements**:
  - Automatic archive validation before loading
  - Version checking after loading
  - .boranko extension enforcement on save
  - Better error handling

- **Documentation**:
  - Updated README.md with Boranko 1.1 structure
  - Added COMICA_VS_FREEDOME.md - comparison of legacy COMICA PRO and new FreeDome systems
  - Added BORANKO_1.1_MIGRATION.md - migration guide
  - Added BORANKO_1.1_IMPLEMENTATION_REPORT.md - implementation report
  - Added olddoc/ documentation - archive of COMICA PRO legacy system (2018)

### ❌ Removed

- **Legacy Format Support**:
  - Old .comics format without data.json
  - .puzzle format
  - `puzzleScales` constant (replaced with `borankoScales`)
  - Placeholder generation for puzzle mode

### ⚠️ Deprecated

The following parameters are deprecated but kept for backwards compatibility (they are ignored):
- `puzzle: bool` in `Layer.create()`
- `puzzle: bool` in `Layer.setImage()`
- `puzzle: bool` in `Image.update()`

### 🔧 Changed

- **FileManager**:
  - Temp folder path: `ComicsEditor/Temp` → `BorankoEditor/Temp`
  - Only single scale (1.0) is supported
  - Removed puzzle-specific logic

- **Comics Model**:
  - Added version validation in `save()` and `load()`
  - Throws exception if version is not "1.1.0"

- **Layer & Image Models**:
  - Puzzle parameter is now ignored
  - Added Boranko 1.1 documentation

### 📦 Migration Guide

**For existing projects:**

1. Use `freedome_sphere` to convert old .comics files:
```dart
import 'package:freedome_sphere_flutter/services/boranko_service.dart';

final service = BorankoService();
final project = await service.importComicsAsBoranko('old.comics');
await service.saveBorankoProject(project, 'new_boranko');
```

2. Update your code to use new API:
```dart
// Old
await comics.saveToFile('project.comics');

// New
final viewModel = ComicsViewModel();
await viewModel.save('project.boranko');
```

See [BORANKO_1.1_MIGRATION.md](BORANKO_1.1_MIGRATION.md) for detailed migration instructions.

### 🐛 Bug Fixes

- Fixed temporary folder cleanup
- Improved error messages
- Better validation of archive structure

### 📝 Notes

- **Breaking Change**: This version is NOT backwards compatible with legacy formats
- **Recommendation**: Migrate all existing projects to Boranko 1.1
- **Support**: Use older version (1.0.x) if you need legacy format support

---

## [1.0.0] - Previous version

Initial release with legacy .comics and .puzzle format support.