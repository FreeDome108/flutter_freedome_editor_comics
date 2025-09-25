import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'freedome_editor_comics_platform_interface.dart';

/// An implementation of [FreedomeEditorComicsPlatform] that uses method channels.
class MethodChannelFreedomeEditorComics extends FreedomeEditorComicsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('freedome_editor_comics');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
