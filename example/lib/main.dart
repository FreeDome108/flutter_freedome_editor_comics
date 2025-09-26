import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freedome_editor_comics/freedome_editor_comics.dart';

void main() {
  runApp(const ComicsEditorApp());
}

class ComicsEditorApp extends StatelessWidget {
  const ComicsEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ComicsViewModel(),
      child: MaterialApp(
        title: 'Comics Editor',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const ComicsEditorHome(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class ComicsEditorHome extends StatefulWidget {
  const ComicsEditorHome({super.key});

  @override
  State<ComicsEditorHome> createState() => _ComicsEditorHomeState();
}

class _ComicsEditorHomeState extends State<ComicsEditorHome>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comics Editor'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _isPlaying ? _stopAnimation : _playAnimation,
            icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
            tooltip: _isPlaying ? 'Stop Animation' : 'Play Animation',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'new',
                child: ListTile(
                  leading: Icon(Icons.create_new_folder),
                  title: Text('New Comics'),
                ),
              ),
              const PopupMenuItem(
                value: 'open',
                child: ListTile(
                  leading: Icon(Icons.folder_open),
                  title: Text('Open Comics'),
                ),
              ),
              const PopupMenuItem(
                value: 'save',
                child: ListTile(
                  leading: Icon(Icons.save),
                  title: Text('Save Comics'),
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Export Comics'),
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.auto_stories), text: 'Editor'),
            Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [const EditorTab(), const TimelineTab(), const SettingsTab()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddContentDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Content'),
      ),
    );
  }

  void _playAnimation() {
    setState(() {
      _isPlaying = true;
    });
    // TODO: Implement animation playback
  }

  void _stopAnimation() {
    setState(() {
      _isPlaying = false;
    });
    // TODO: Stop animation playback
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'new':
        _showNewComicsDialog();
        break;
      case 'open':
        _openComics();
        break;
      case 'save':
        _saveComics();
        break;
      case 'export':
        _exportComics();
        break;
    }
  }

  void _showNewComicsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Comics'),
        content: const Text('Create a new comics project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Create new comics
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _openComics() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.path != null) {
        // TODO: Load comics from file
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Opened: ${file.name}')));
        }
      }
    }
  }

  void _saveComics() {
    // TODO: Save comics
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Comics saved!')));
  }

  void _exportComics() {
    // TODO: Export comics
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Comics exported!')));
  }

  void _showAddContentDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Content',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAddButton(
                  icon: Icons.image,
                  label: 'Image',
                  onTap: () => _addImage(),
                ),
                _buildAddButton(
                  icon: Icons.audiotrack,
                  label: 'Audio',
                  onTap: () => _addAudio(),
                ),
                _buildAddButton(
                  icon: Icons.video_library,
                  label: 'Video',
                  onTap: () => _addVideo(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  void _addImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.path != null) {
        final viewModel = Provider.of<ComicsViewModel>(context, listen: false);
        final messenger = ScaffoldMessenger.of(context);
        final fileName = file.name;
        await viewModel.addLayer(file.path!);
        if (mounted) {
          messenger.showSnackBar(SnackBar(content: Text('Image added: $fileName')));
        }
      }
    }
  }

  void _addAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.path != null) {
        final viewModel = Provider.of<ComicsViewModel>(context, listen: false);
        final messenger = ScaffoldMessenger.of(context);
        final fileName = file.name;
        await viewModel.addSound(file.path!);
        if (mounted) {
          messenger.showSnackBar(SnackBar(content: Text('Audio added: $fileName')));
        }
      }
    }
  }

  void _addVideo() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Video support coming soon!')));
  }
}

class EditorTab extends StatelessWidget {
  const EditorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ComicsViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Comics Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Comics Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Width', '${viewModel.width}px'),
                      _buildInfoRow('Height', '${viewModel.height}px'),
                      _buildInfoRow('Layers', '${viewModel.layers.length}'),
                      _buildInfoRow('Sounds', '${viewModel.sounds.length}'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Comics Canvas
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_stories,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Comics Preview',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ComicsCanvas(
                          viewModel: viewModel,
                          width: 400,
                          height: 300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Layers List
              if (viewModel.layers.isNotEmpty) ...[
                Text('Layers', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ...viewModel.layers.asMap().entries.map(
                  (entry) => _buildLayerCard(context, entry.key, entry.value),
                ),
              ],

              const SizedBox(height: 16),

              // Sounds List
              if (viewModel.sounds.isNotEmpty) ...[
                Text('Sounds', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ...viewModel.sounds.asMap().entries.map(
                  (entry) => _buildSoundCard(context, entry.key, entry.value),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLayerCard(
    BuildContext context,
    int index,
    LayerViewModel layer,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text('${index + 1}'),
        ),
        title: Text('Layer ${index + 1}'),
        subtitle: Text('${layer.layer.animations.length} animations'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleLayerAction(context, value, layer),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'duplicate',
              child: ListTile(
                leading: Icon(Icons.copy),
                title: Text('Duplicate'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundCard(
    BuildContext context,
    int index,
    SoundViewModel sound,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.audiotrack, color: Colors.white),
        ),
        title: Text('Sound ${index + 1}'),
        subtitle: Text('${sound.sound.animations.length} animations'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleSoundAction(context, value, sound),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'play',
              child: ListTile(
                leading: Icon(Icons.play_arrow),
                title: Text('Play'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLayerAction(
    BuildContext context,
    String action,
    LayerViewModel layer,
  ) {
    final viewModel = Provider.of<ComicsViewModel>(context, listen: false);
    switch (action) {
      case 'edit':
        // TODO: Open layer editor
        break;
      case 'duplicate':
        // TODO: Duplicate layer
        break;
      case 'delete':
        viewModel.removeLayer(layer);
        break;
    }
  }

  void _handleSoundAction(
    BuildContext context,
    String action,
    SoundViewModel sound,
  ) {
    switch (action) {
      case 'play':
        // TODO: Play sound
        break;
      case 'delete':
        final viewModel = Provider.of<ComicsViewModel>(context, listen: false);
        viewModel.removeSound(sound);
        break;
    }
  }
}

class TimelineTab extends StatelessWidget {
  const TimelineTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ComicsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.layers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timeline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No layers to animate',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Add some layers to start creating animations',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Animation Timeline for first layer
              Card(
                child: AnimationTimeline(
                  layerViewModel: viewModel.layers.first,
                  scroll: viewModel.scroll,
                  onScrollChanged: (value) {
                    viewModel.scroll = value;
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Animation Controls
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Animation Controls',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                _addAnimation(context, AnimationType.translate),
                            icon: const Icon(Icons.open_with),
                            label: const Text('Move'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                _addAnimation(context, AnimationType.rotate),
                            icon: const Icon(Icons.rotate_right),
                            label: const Text('Rotate'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                _addAnimation(context, AnimationType.scale),
                            icon: const Icon(Icons.zoom_in),
                            label: const Text('Scale'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                _addAnimation(context, AnimationType.alpha),
                            icon: const Icon(Icons.opacity),
                            label: const Text('Fade'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addAnimation(BuildContext context, AnimationType type) {
    final viewModel = Provider.of<ComicsViewModel>(context, listen: false);
    if (viewModel.layers.isNotEmpty) {
      viewModel.layers.first.addAnimation(type);
    }
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comics Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildSettingTile(
                    context,
                    'Canvas Width',
                    '800px',
                    Icons.width_wide,
                    () {},
                  ),
                  _buildSettingTile(
                    context,
                    'Canvas Height',
                    '600px',
                    Icons.height,
                    () {},
                  ),
                  _buildSettingTile(
                    context,
                    'Frame Rate',
                    '60 FPS',
                    Icons.speed,
                    () {},
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Export Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildSettingTile(
                    context,
                    'Image Quality',
                    'High',
                    Icons.high_quality,
                    () {},
                  ),
                  _buildSettingTile(
                    context,
                    'Audio Quality',
                    '128 kbps',
                    Icons.audiotrack,
                    () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }
}
