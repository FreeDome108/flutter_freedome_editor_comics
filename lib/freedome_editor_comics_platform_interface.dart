import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'freedome_editor_comics_method_channel.dart';

abstract class FreedomeEditorComicsPlatform extends PlatformInterface {
  /// Constructs a FreedomeEditorComicsPlatform.
  FreedomeEditorComicsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FreedomeEditorComicsPlatform _instance =
      MethodChannelFreedomeEditorComics();

  /// The default instance of [FreedomeEditorComicsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFreedomeEditorComics].
  static FreedomeEditorComicsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FreedomeEditorComicsPlatform] when
  /// they register themselves.
  static set instance(FreedomeEditorComicsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
