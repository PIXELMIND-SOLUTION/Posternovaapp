import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:posternova/models/create_poster_model.dart';

class PosterCropperScreen extends StatefulWidget {
  final File imageFile;
  final PosterSize posterSize;

  const PosterCropperScreen({
    super.key,
    required this.imageFile,
    required this.posterSize,
  });

  @override
  State<PosterCropperScreen> createState() => _PosterCropperScreenState();
}

class _PosterCropperScreenState extends State<PosterCropperScreen> {
  final GlobalKey<ExtendedImageEditorState> _editorKey =
      GlobalKey<ExtendedImageEditorState>();

  bool _isCropping = false;

  // Poster's exact aspect ratio — locked, no other options
  double get _posterAspectRatio =>
      widget.posterSize.width / widget.posterSize.height;

  String get _posterSizeLabel =>
      '${widget.posterSize.width.toInt()}×${widget.posterSize.height.toInt()}';

  Future<void> _cropAndReturn() async {
    final state = _editorKey.currentState;
    if (state == null) return;

    setState(() => _isCropping = true);

    try {
      final Uint8List? croppedData = await _cropImage(state);

      if (croppedData == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cropping failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/poster_bg_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(croppedData);

      if (mounted) Navigator.pop(context, file);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isCropping = false);
    }
  }

  Future<Uint8List?> _cropImage(ExtendedImageEditorState state) async {
    final Rect? cropRect = state.getCropRect();
    if (cropRect == null) return null;

    final Uint8List? rawData = state.rawImageData;
    if (rawData == null) return null;

    final ui.Image image = await decodeImageFromList(rawData);

    final targetW = widget.posterSize.width.toInt();
    final targetH = widget.posterSize.height.toInt();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, targetW.toDouble(), targetH.toDouble()),
    );

    // src = the crop region on the original image
    // dst = the full target poster size — this is what scales it correctly
    canvas.drawImageRect(
      image,
      cropRect, // source rect (cropped area)
      Rect.fromLTWH(
        0,
        0,
        targetW.toDouble(),
        targetH.toDouble(),
      ), // destination = full poster size
      Paint()..filterQuality = FilterQuality.high,
    );

    final picture = recorder.endRecording();
    final ui.Image finalImage = await picture.toImage(targetW, targetH);

    final byteData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData?.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5C518),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context, null),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crop Image',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _posterSizeLabel,
              style: const TextStyle(color: Colors.black54, fontSize: 11),
            ),
          ],
        ),
        actions: [
          if (_isCropping)
            const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black87,
                ),
              ),
            )
          else
            TextButton.icon(
              onPressed: _cropAndReturn,
              icon: const Icon(Icons.check, color: Colors.black87, size: 20),
              label: const Text(
                'Done',
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
          // Info banner
          Container(
            width: double.infinity,
            color: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.crop, color: Colors.white54, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Crop to fit poster: $_posterSizeLabel px',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),

          // Cropper
          Expanded(
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
                  // Lock to poster's exact aspect ratio
                  cropAspectRatio: _posterAspectRatio,
                  initCropRectType: InitCropRectType.imageRect,
                );
              },
              cacheRawData: true,
            ),
          ),

          // Bottom bar — shows only the poster size, no other options
          Container(
            height: 80,
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Locked ratio chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5C518),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock, size: 13, color: Colors.black87),
                      const SizedBox(width: 6),
                      Text(
                        _posterSizeLabel,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Ratio fraction display
                Text(
                  _aspectRatioLabel,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const Spacer(),
                // Reset button
                TextButton(
                  onPressed: () {
                    _editorKey.currentState?.reset();
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Converts aspect ratio to a readable fraction label e.g. 16:9, 3:4
  String get _aspectRatioLabel {
    final w = widget.posterSize.width;
    final h = widget.posterSize.height;
    final gcd = _gcd(w.toInt(), h.toInt());
    final rw = (w / gcd).toInt();
    final rh = (h / gcd).toInt();
    return '$rw : $rh';
  }

  int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);
}
