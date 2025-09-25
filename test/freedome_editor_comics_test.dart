import 'package:flutter_test/flutter_test.dart';
import 'package:freedome_editor_comics/freedome_editor_comics.dart';
import 'package:freedome_editor_comics/freedome_editor_comics_platform_interface.dart';
import 'package:freedome_editor_comics/freedome_editor_comics_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFreedomeEditorComicsPlatform
    with MockPlatformInterfaceMixin
    implements FreedomeEditorComicsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FreedomeEditorComicsPlatform initialPlatform = FreedomeEditorComicsPlatform.instance;

  test('$MethodChannelFreedomeEditorComics is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFreedomeEditorComics>());
  });

  test('getPlatformVersion', () async {
    FreedomeEditorComics freedomeEditorComicsPlugin = FreedomeEditorComics();
    MockFreedomeEditorComicsPlatform fakePlatform = MockFreedomeEditorComicsPlatform();
    FreedomeEditorComicsPlatform.instance = fakePlatform;

    expect(await freedomeEditorComicsPlugin.getPlatformVersion(), '42');
  });
}
