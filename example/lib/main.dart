import 'package:flutter/material.dart';
import 'package:freedome_editor_comics/freedome_editor_comics.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freedome Editor Comics Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ComicsEditorPage(),
    );
  }
}

class ComicsEditorPage extends StatefulWidget {
  const ComicsEditorPage({super.key});

  @override
  State<ComicsEditorPage> createState() => _ComicsEditorPageState();
}

class _ComicsEditorPageState extends State<ComicsEditorPage> {
  late ComicsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ComicsViewModel();
    _initializeComics();
  }

  Future<void> _initializeComics() async {
    await _viewModel.initializeComics(null);
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Freedome Editor Comics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              await _viewModel.save();
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Comics saved!')));
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
          // Информация о комиксе
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comics Info',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('Width: ${_viewModel.width}px'),
                  Text('Height: ${_viewModel.height}px'),
                  Text('Layers: ${_viewModel.layers.length}'),
                  Text('Sounds: ${_viewModel.sounds.length}'),
                ],
              ),
            ),
          ),

          // Контролы
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            allowMultiple: false,
                          );
                          
                          if (result != null && result.files.isNotEmpty) {
                            final file = result.files.first;
                            if (file.path != null) {
                              await _viewModel.addLayer(file.path!);
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Layer added: ${file.name}'),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.image),
                        label: const Text('Add Layer'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.audio,
                            allowMultiple: false,
                          );
                          
                          if (result != null && result.files.isNotEmpty) {
                            final file = result.files.first;
                            if (file.path != null) {
                              await _viewModel.addSound(file.path!);
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Sound added: ${file.name}'),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.audiotrack),
                        label: const Text('Add Sound'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Скролл контрол
                  Row(
                    children: [
                      const Text('Scroll: '),
                      Expanded(
                        child: Slider(
                          value: _viewModel.scroll,
                          min: 0,
                          max: 1000,
                          divisions: 100,
                          onChanged: (value) {
                            setState(() {
                              _viewModel.scroll = value;
                            });
                          },
                        ),
                      ),
                      Text('${_viewModel.scroll.round()}'),
                    ],
                  ),

                  // Язык контрол
                  Row(
                    children: [
                      const Text('Language: '),
                      DropdownButton<Cultures>(
                        value: _viewModel.culture,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _viewModel.culture = value;
                            });
                          }
                        },
                        items: CulturesHelper.all.map((culture) {
                          return DropdownMenuItem(
                            value: culture,
                            child: Text(
                              culture.toString().split('.').last.toUpperCase(),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Canvas для отображения комикса
          Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Comics Preview',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ComicsCanvas(viewModel: _viewModel, width: 400, height: 300),
              ],
            ),
          ),

          // Временная шкала анимаций
          if (_viewModel.layers.isNotEmpty)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimationTimeline(
                layerViewModel: _viewModel.layers.first,
                scroll: _viewModel.scroll,
                onScrollChanged: (value) {
                  setState(() {
                    _viewModel.scroll = value;
                  });
                },
              ),
            ),

          // Список слоев
          ..._viewModel.layers.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final layer = entry.value;
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: ListTile(
                  leading: const Icon(Icons.layers),
                  title: Text('Layer ${index + 1}'),
                  subtitle: Text(
                    'Animations: ${layer.layer.animations.length}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await _viewModel.removeLayer(layer);
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ),

          // Добавляем отступ внизу
          const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
