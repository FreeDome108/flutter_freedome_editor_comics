import 'freedome_editor_comics_platform_interface.dart';

/// The main plugin class for FreedomeEditorComics
class FreedomeEditorComics {
  /// Get the platform version
  Future<String?> getPlatformVersion() {
    return FreedomeEditorComicsPlatform.instance.getPlatformVersion();
  }
}
