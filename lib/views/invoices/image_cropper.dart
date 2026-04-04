import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:path_provider/path_provider.dart';

class ImageCropperScreen extends StatefulWidget {
  final File imageFile;
  final double? aspectRatio; // Optional fixed aspect ratio
  final String title;

  const ImageCropperScreen({
    Key? key,
    required this.imageFile,
    this.aspectRatio,
    this.title = 'Crop Image',
  }) : super(key: key);

  @override
  State<ImageCropperScreen> createState() => _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  final GlobalKey<ExtendedImageEditorState> _editorKey =
      GlobalKey<ExtendedImageEditorState>();
  double? _aspectRatio;
  Map<String, double> _aspectRatios = {};
  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _loadOriginalImageSize();
  }

  Future<void> _loadOriginalImageSize() async {
    final data = await widget.imageFile.readAsBytes();
    final decodedImage = await decodeImageFromList(data);
    final originalRatio =
        decodedImage.width.toDouble() / decodedImage.height.toDouble();

    if (!mounted) return;
    setState(() {
      _aspectRatios = {
        'Original': originalRatio,
        'Free': 0.0,
        '1:1': 1.0,
        '16:9': 16 / 9,
        '9:16': 9 / 16,
        '4:3': 4 / 3,
        '3:4': 3 / 4,
        'Square': 1.0,
      };
      _aspectRatio = widget.aspectRatio ?? originalRatio;
    });
  }

  Future<void> _cropAndReturn() async {
    final state = _editorKey.currentState;
    if (state == null) return;

    final Uint8List? croppedData = await _cropImageData(state);
    if (croppedData == null) return;

    final tempDir = await getTemporaryDirectory();
    final filePath =
        '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);
    await file.writeAsBytes(croppedData);

    if (mounted) Navigator.pop(context, file);
  }

  Future<Uint8List?> _cropImageData(ExtendedImageEditorState state) async {
    final Rect? cropRect = state.getCropRect();
    if (cropRect == null) return null;

    final Uint8List data = state.rawImageData!;
    final ui.Image image = await decodeImageFromList(data);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(
      image,
      cropRect,
      Rect.fromLTWH(0, 0, cropRect.width, cropRect.height),
      Paint(),
    );

    final picture = recorder.endRecording();
    final ui.Image croppedImage = await picture.toImage(
      cropRect.width.toInt(),
      cropRect.height.toInt(),
    );

    final byteData = await croppedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData?.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    if (_aspectRatios.isEmpty) {
      return Scaffold(
        backgroundColor: _isDarkMode ? const Color(0xFF0F172A) : Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: const Color(0xFFF5C518)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF0F172A) : Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5C518),
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context, null),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _cropAndReturn,
            icon: const Icon(Icons.check, color: Colors.black87),
            label: const Text(
              'Apply',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ExtendedImage.file(
                widget.imageFile,
                fit: BoxFit.contain,
                mode: ExtendedImageMode.editor,
                extendedImageEditorKey: _editorKey,
                initEditorConfigHandler: (_) => EditorConfig(
                  maxScale: 8.0,
                  cropRectPadding: const EdgeInsets.all(20.0),
                  hitTestSize: 20.0,
                  cropAspectRatio: _aspectRatio == 0.0 ? null : _aspectRatio,
                ),
                cacheRawData: true,
              ),
            ),
            _buildAspectRatioBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAspectRatioBar() {
    final isDarkMode = _isDarkMode;

    return Container(
      height: 80,
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: _aspectRatios.entries.map((entry) {
          final selected = _aspectRatio == entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(entry.key),
              selected: selected,
              onSelected: (_) => setState(() => _aspectRatio = entry.value),
              selectedColor: const Color(0xFFF5C518),
              backgroundColor: isDarkMode
                  ? const Color(0xFF0F172A)
                  : Colors.grey[800],
              labelStyle: TextStyle(
                color: selected
                    ? Colors.black87
                    : (isDarkMode ? Colors.grey[300] : Colors.grey[300]),
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
