import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:extended_image/extended_image.dart';

class CropperScreen extends StatefulWidget {
  final File imageFile;
  const CropperScreen({super.key, required this.imageFile});

  @override
  State<CropperScreen> createState() => _CropperScreenState();
}

class _CropperScreenState extends State<CropperScreen> {
  final GlobalKey<ExtendedImageEditorState> _editorKey =
      GlobalKey<ExtendedImageEditorState>();

  double? _aspectRatio;
  Size? _originalImageSize;
  Map<String, double> _aspectRatios = {};

  // Rotation state
  int _rotationAngle = 0; // 0, 90, 180, 270
  bool _isRotating = false;

  @override
  void initState() {
    super.initState();
    _loadOriginalImageSize();
  }

  void _loadOriginalImageSize() async {
    final data = await widget.imageFile.readAsBytes();
    final decodedImage = await decodeImageFromList(data);
    final originalWidth = decodedImage.width.toDouble();
    final originalHeight = decodedImage.height.toDouble();
    final originalRatio = originalWidth / originalHeight;

    setState(() {
      _originalImageSize = Size(originalWidth, originalHeight);
      _aspectRatios = {
        'Original': originalRatio,
        '1:1': 1.0,
        '16:9': 16 / 9,
        '9:16': 9 / 16,
        '7:5': 7 / 5,
        '5:7': 5 / 7,
      };
      _aspectRatio = originalRatio;
    });
  }

  // Rotate the image
  void _rotateImage() {
    setState(() {
      _isRotating = true;
    });

    // Rotate 90 degrees clockwise
    _rotationAngle = (_rotationAngle + 90) % 360;

    // Get the current editor state
    final state = _editorKey.currentState;
    if (state != null) {
      // Reset the crop area after rotation
      state.reset();
    }

    setState(() {
      _isRotating = false;
    });
  }

  // Reset rotation
  void _resetRotation() {
    setState(() {
      _rotationAngle = 0;
    });
    _editorKey.currentState?.reset();
  }

  // Returns the cropped file
  Future<void> _cropAndReturn() async {
    final state = _editorKey.currentState;
    if (state == null) return;

    final Uint8List? croppedData = await _cropImageDataWithDartLibrary(state);

    if (croppedData == null) {
      print("Cropping failed");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to crop image'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final filePath =
        '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);
    await file.writeAsBytes(croppedData);

    // Return the cropped file to the previous screen
    if (mounted) Navigator.pop(context, file);
  }

  @override
  Widget build(BuildContext context) {
    if (_aspectRatios.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final aspectRatio = _aspectRatio == 0.0 ? null : _aspectRatio;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5C518),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.pop(context, null),
          ),
          title: const Text(
            "Crop Image",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // Rotate button
            IconButton(
              icon: const Icon(Icons.rotate_right, color: Colors.black87),
              onPressed: _isRotating ? null : _rotateImage,
              tooltip: 'Rotate 90°',
            ),
            // Reset rotation button
            if (_rotationAngle != 0)
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black87),
                onPressed: _resetRotation,
                tooltip: 'Reset rotation',
              ),
            TextButton.icon(
              onPressed: _cropAndReturn,
              icon: const Icon(Icons.check, color: Colors.black87),
              label: const Text(
                "Use Photo",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _isRotating
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF5C518),
                      ),
                    )
                  : Transform.rotate(
                      angle:
                          _rotationAngle *
                          (3.14159 / 180), // Convert to radians
                      child: ExtendedImage.file(
                        widget.imageFile,
                        fit: BoxFit.contain,
                        mode: ExtendedImageMode.editor,
                        extendedImageEditorKey: _editorKey,
                        initEditorConfigHandler: (state) {
                          return EditorConfig(
                            maxScale: 8.0,
                            cropRectPadding: const EdgeInsets.all(20.0),
                            hitTestSize: 20.0,
                            cropAspectRatio: aspectRatio,
                          );
                        },
                        cacheRawData: true,
                      ),
                    ),
            ),
            _buildAspectRatioSelector(),
            _buildBottomToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAspectRatioSelector() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.black,
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

  Widget _buildBottomToolbar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.black,
        border: Border(
          top: BorderSide(
            color: isDarkMode ? Colors.grey[800]! : Colors.grey[900]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Rotate button
          _buildToolbarButton(
            icon: Icons.rotate_right,
            label: 'Rotate',
            onTap: _rotateImage,
          ),
          // Reset button
          _buildToolbarButton(
            icon: Icons.refresh,
            label: 'Reset',
            onTap: _resetRotation,
            isEnabled: _rotationAngle != 0,
          ),
          // Zoom hint
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFF5C518), size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDarkMode ? Colors.white70 : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> _cropImageDataWithDartLibrary(
    ExtendedImageEditorState state,
  ) async {
    final Rect cropRect = state.getCropRect()!;
    final Uint8List data = state.rawImageData!;
    ui.Image image = await decodeImageFromList(data);

    // Apply rotation if needed
    if (_rotationAngle != 0) {
      image = await _rotateUIImage(image, _rotationAngle);
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    final srcRect = cropRect;
    final dstRect = Rect.fromLTWH(0, 0, cropRect.width, cropRect.height);

    canvas.drawImageRect(image, srcRect, dstRect, paint);

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

  // Helper function to rotate UIImage
  Future<ui.Image> _rotateUIImage(ui.Image image, int degrees) async {
    final radians = degrees * (3.14159 / 180);
    final width = image.width;
    final height = image.height;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Translate and rotate
    canvas.translate(width / 2, height / 2);
    canvas.rotate(radians);
    canvas.translate(-width / 2, -height / 2);

    // Draw the image
    canvas.drawImage(image, Offset.zero, Paint());

    final picture = recorder.endRecording();

    // For 90 or 270 degree rotation, swap width and height
    final rotatedWidth = (degrees % 180 == 0) ? width : height;
    final rotatedHeight = (degrees % 180 == 0) ? height : width;

    final rotatedImage = await picture.toImage(rotatedWidth, rotatedHeight);
    return rotatedImage;
  }
}
