import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const PosterEditorApp());
}

class PosterEditorApp extends StatelessWidget {
  const PosterEditorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poster Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Canvaposters(),
    );
  }
}

class Canvaposters extends StatefulWidget {
  const Canvaposters({Key? key}) : super(key: key);

  @override
  State<Canvaposters> createState() => _PosterEditorScreenState();
}

class _PosterEditorScreenState extends State<Canvaposters> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  List<EditableTextElement> _textElements = [];
  List<EditableImageElement> _imageElements = [];
  final GlobalKey _canvasKey = GlobalKey();
  int? _selectedElementIndex;
  Offset? _dragOffset;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _textElements = [];
          _imageElements = [];
          _selectedElementIndex = null;
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _addOverlayImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageElements.add(EditableImageElement(
            imageFile: File(image.path),
            position: const Offset(50, 50),
            size: const Size(150, 150),
          ));
        });
      }
    } catch (e) {
      _showError('Failed to add image: $e');
    }
  }

  void _addTextElement() {
    final controller = TextEditingController(text: 'New Text');
    Color selectedColor = Colors.black;
    double selectedFontSize = 24.0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Text'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Text',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Color: '),
                    const SizedBox(width: 8),
                    ...Colors.primaries.take(6).map((color) => GestureDetector(
                      onTap: () {
                        setDialogState(() => selectedColor = color);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Size: '),
                    Expanded(
                      child: Slider(
                        value: selectedFontSize,
                        min: 12,
                        max: 72,
                        divisions: 60,
                        label: selectedFontSize.round().toString(),
                        onChanged: (value) {
                          setDialogState(() => selectedFontSize = value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _textElements.add(EditableTextElement(
                    text: controller.text,
                    position: const Offset(50, 100),
                    color: selectedColor,
                    fontSize: selectedFontSize,
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _editTextElement(int index) {
    final element = _textElements[index];
    final controller = TextEditingController(text: element.text);
    Color selectedColor = element.color;
    double selectedFontSize = element.fontSize;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Text'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Text',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Color: '),
                    const SizedBox(width: 8),
                    ...Colors.primaries.take(6).map((color) => GestureDetector(
                      onTap: () {
                        setDialogState(() => selectedColor = color);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Size: '),
                    Expanded(
                      child: Slider(
                        value: selectedFontSize,
                        min: 12,
                        max: 72,
                        divisions: 60,
                        label: selectedFontSize.round().toString(),
                        onChanged: (value) {
                          setDialogState(() => selectedFontSize = value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _textElements.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _textElements[index] = element.copyWith(
                    text: controller.text,
                    color: selectedColor,
                    fontSize: selectedFontSize,
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportImage() async {
    try {
      setState(() => _selectedElementIndex = null);
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary = _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/edited_poster_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to: $filePath'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      _showError('Failed to export: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poster Editor'),
        actions: [
          if (_imageFile != null) ...[
            IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: _addTextElement,
              tooltip: 'Add Text',
            ),
            IconButton(
              icon: const Icon(Icons.add_photo_alternate),
              onPressed: _addOverlayImage,
              tooltip: 'Add Image',
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _exportImage,
              tooltip: 'Export',
            ),
          ],
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickImage,
        icon: const Icon(Icons.image),
        label: const Text('Select Poster'),
      ),
    );
  }

  Widget _buildBody() {
    if (_imageFile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.image_outlined, size: 100, color: Colors.grey),
            SizedBox(height: 16),
            Text('Select a poster to start editing', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: RepaintBoundary(
          key: _canvasKey,
          child: Stack(
            children: [
              Image.file(_imageFile!, fit: BoxFit.contain),
              ..._imageElements.asMap().entries.map((entry) {
                final idx = entry.key;
                final elem = entry.value;
                return Positioned(
                  left: elem.position.dx,
                  top: elem.position.dy,
                  child: GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        _selectedElementIndex = -1 - idx;
                        _dragOffset = details.localPosition;
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        _imageElements[idx] = elem.copyWith(
                          position: details.globalPosition - _dragOffset!,
                        );
                      });
                    },
                    child: Container(
                      width: elem.size.width,
                      height: elem.size.height,
                      decoration: BoxDecoration(
                        border: _selectedElementIndex == -1 - idx
                            ? Border.all(color: Colors.blue, width: 2)
                            : null,
                      ),
                      child: Image.file(elem.imageFile, fit: BoxFit.cover),
                    ),
                  ),
                );
              }).toList(),
              ..._textElements.asMap().entries.map((entry) {
                final idx = entry.key;
                final elem = entry.value;
                return Positioned(
                  left: elem.position.dx,
                  top: elem.position.dy,
                  child: GestureDetector(
                    onTap: () => _editTextElement(idx),
                    onPanStart: (details) {
                      setState(() {
                        _selectedElementIndex = idx;
                        _dragOffset = details.localPosition;
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        _textElements[idx] = elem.copyWith(
                          position: details.globalPosition - _dragOffset!,
                        );
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        border: Border.all(
                          color: _selectedElementIndex == idx ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        elem.text,
                        style: TextStyle(
                          color: elem.color,
                          fontSize: elem.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class EditableTextElement {
  final String text;
  final Offset position;
  final Color color;
  final double fontSize;

  EditableTextElement({
    required this.text,
    required this.position,
    this.color = Colors.black,
    this.fontSize = 24.0,
  });

  EditableTextElement copyWith({
    String? text,
    Offset? position,
    Color? color,
    double? fontSize,
  }) {
    return EditableTextElement(
      text: text ?? this.text,
      position: position ?? this.position,
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

class EditableImageElement {
  final File imageFile;
  final Offset position;
  final Size size;

  EditableImageElement({
    required this.imageFile,
    required this.position,
    required this.size,
  });

  EditableImageElement copyWith({
    File? imageFile,
    Offset? position,
    Size? size,
  }) {
    return EditableImageElement(
      imageFile: imageFile ?? this.imageFile,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }
}















