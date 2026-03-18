import 'dart:math';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

// ─────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────

enum BottomTab { text, frames, audio, animation, brandInfo, sticker }

enum AnimationType {
  none,
  fade,
  slideLeft,
  slideRight,
  slideUp,
  slideDown,
  zoom,
  rotate,
  flipIn,
  wobble,
  rollin,
}

enum EffectType { none, blur, grayscale, sepia, brightness, contrast }

enum BrandElementType { logo, name, phone, address }

class BrandElement {
  final String id;
  final BrandElementType type;
  Offset position;
  double fontSize;
  Color color;
  bool isVisible;

  BrandElement({
    required this.id,
    required this.type,
    required this.position,
    this.fontSize = 14,
    this.color = Colors.white,
    this.isVisible = true,
  });

  BrandElement copyWith({
    Offset? position,
    double? fontSize,
    Color? color,
    bool? isVisible,
  }) {
    return BrandElement(
      id: id,
      type: type,
      position: position ?? this.position,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class OverlayTextItem {
  String id, text;
  Offset position;
  double fontSize;
  Color color, backgroundColor;
  bool hasBorder, hasShadow, isBold, isItalic, isUnderline;
  TextAlign align;
  double rotation;

  OverlayTextItem({
    required this.id,
    required this.text,
    this.position = const Offset(50, 200),
    this.fontSize = 24,
    this.color = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.hasBorder = false,
    this.hasShadow = false,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.align = TextAlign.left,
    this.rotation = 0,
  });

  OverlayTextItem copyWith({
    String? text,
    Offset? position,
    double? fontSize,
    Color? color,
    Color? backgroundColor,
    bool? hasBorder,
    bool? hasShadow,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    TextAlign? align,
    double? rotation,
  }) {
    return OverlayTextItem(
      id: id,
      text: text ?? this.text,
      position: position ?? this.position,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      hasBorder: hasBorder ?? this.hasBorder,
      hasShadow: hasShadow ?? this.hasShadow,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      align: align ?? this.align,
      rotation: rotation ?? this.rotation,
    );
  }
}

class BrandInfo {
  String name, phone, address, logoAsset;
  BrandInfo({
    this.name = 'VISHNU P',
    this.phone = '6282714883',
    this.address = 'NBRRA-3, Maradu, Kochi, Kerala',
    this.logoAsset = '',
  });
}

// ── 20 FRAME LAYOUTS ────────────────────────
enum FrameLayout {
  classic,
  modern,
  elegant,
  minimal,
  banner,
  card,
  neon,
  ribbon,
  diagonal,
  curved,
  sideStrip,
  split,
  badge,
  gradient,
  zigzag,
  shadow,
  stripe,
  arch,
  filmstrip,
  luxury,
}

class FrameStyle {
  final String name;
  final Color borderColor;
  final Color? headerBg, footerBg;
  final FrameLayout layout;
  final Color accentColor;

  const FrameStyle({
    required this.name,
    required this.borderColor,
    this.headerBg,
    this.footerBg,
    required this.layout,
    this.accentColor = Colors.white,
  });
}

// ─────────────────────────────────────────────
//  MAIN SCREEN
// ─────────────────────────────────────────────

class PosterEditorScreen extends StatefulWidget {
  final String posterAsset;
  const PosterEditorScreen({Key? key, required this.posterAsset})
    : super(key: key);

  @override
  State<PosterEditorScreen> createState() => _PosterEditorScreenState();
}

class _PosterEditorScreenState extends State<PosterEditorScreen>
    with TickerProviderStateMixin {
  BottomTab _activeTab = BottomTab.text;
  Color _bgColor = const Color(0xFFF5F0E8);

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAudioPlaying = false;

  final List<OverlayTextItem> _texts = [];
  String? _selectedTextId;

  final BrandInfo _brandInfo = BrandInfo();
  late List<BrandElement> _brandElements;

  int _selectedFrame = -1;
  String? _uploadedImagePath;
  String? _uploadedLogoPath;

  final List<FrameStyle> _frames = const [
    FrameStyle(
      name: 'Classic',
      borderColor: Color(0xFF8B6914),
      headerBg: Color(0xFF8B6914),
      footerBg: Color(0xFF8B6914),
      layout: FrameLayout.classic,
      accentColor: Color(0xFFFFD700),
    ),
    FrameStyle(
      name: 'Golden',
      borderColor: Color(0xFFD4AF37),
      headerBg: Color(0xFFD4AF37),
      footerBg: Color(0xFFD4AF37),
      layout: FrameLayout.banner,
      accentColor: Colors.black,
    ),
    FrameStyle(
      name: 'Modern',
      borderColor: Color(0xFF37474F),
      headerBg: Color(0xFF263238),
      footerBg: Color(0xFF37474F),
      layout: FrameLayout.modern,
      accentColor: Color(0xFF00BCD4),
    ),
    FrameStyle(
      name: 'Elegant',
      borderColor: Color(0xFFB71C1C),
      headerBg: Color(0xFFB71C1C),
      footerBg: Color(0xFF7F0000),
      layout: FrameLayout.elegant,
      accentColor: Color(0xFFFFCDD2),
    ),
    FrameStyle(
      name: 'Neon',
      borderColor: Color(0xFF00E676),
      footerBg: Color(0xFF1B5E20),
      layout: FrameLayout.neon,
      accentColor: Color(0xFF69F0AE),
    ),
    FrameStyle(
      name: 'Minimal',
      borderColor: Color(0xFF212121),
      layout: FrameLayout.minimal,
      accentColor: Color(0xFF757575),
    ),
    FrameStyle(
      name: 'Card',
      borderColor: Color(0xFF1565C0),
      footerBg: Color(0xFF0D47A1),
      layout: FrameLayout.card,
      accentColor: Color(0xFF82B1FF),
    ),
    FrameStyle(
      name: 'Ribbon',
      borderColor: Color(0xFFAD1457),
      headerBg: Color(0xFFAD1457),
      layout: FrameLayout.ribbon,
      accentColor: Color(0xFFF48FB1),
    ),
    FrameStyle(
      name: 'Diagonal',
      borderColor: Color(0xFFE65100),
      footerBg: Color(0xFFBF360C),
      layout: FrameLayout.diagonal,
      accentColor: Color(0xFFFFAB40),
    ),
    FrameStyle(
      name: 'Wave',
      borderColor: Color(0xFF006064),
      footerBg: Color(0xFF00838F),
      layout: FrameLayout.curved,
      accentColor: Color(0xFF80DEEA),
    ),
    FrameStyle(
      name: 'Side Strip',
      borderColor: Color(0xFF4A148C),
      footerBg: Color(0xFF6A1B9A),
      layout: FrameLayout.sideStrip,
      accentColor: Color(0xFFCE93D8),
    ),
    FrameStyle(
      name: 'Split',
      borderColor: Color(0xFF1B5E20),
      footerBg: Color(0xFF388E3C),
      layout: FrameLayout.split,
      accentColor: Color(0xFFA5D6A7),
    ),
    FrameStyle(
      name: 'Badge',
      borderColor: Color(0xFF880E4F),
      headerBg: Color(0xFFC2185B),
      footerBg: Color(0xFF880E4F),
      layout: FrameLayout.badge,
      accentColor: Color(0xFFF8BBD0),
    ),
    FrameStyle(
      name: 'Gradient',
      borderColor: Color(0xFF311B92),
      footerBg: Color(0xFF4527A0),
      layout: FrameLayout.gradient,
      accentColor: Color(0xFFB39DDB),
    ),
    FrameStyle(
      name: 'Zigzag',
      borderColor: Color(0xFFF57F17),
      footerBg: Color(0xFFFF8F00),
      layout: FrameLayout.zigzag,
      accentColor: Color(0xFFFFE082),
    ),
    FrameStyle(
      name: 'Shadow',
      borderColor: Color(0xFF37474F),
      footerBg: Color(0xFF263238),
      layout: FrameLayout.shadow,
      accentColor: Color(0xFF90A4AE),
    ),
    FrameStyle(
      name: 'Stripe',
      borderColor: Color(0xFFB71C1C),
      footerBg: Color(0xFFD32F2F),
      layout: FrameLayout.stripe,
      accentColor: Color(0xFFFFCDD2),
    ),
    FrameStyle(
      name: 'Arch',
      borderColor: Color(0xFF01579B),
      headerBg: Color(0xFF0288D1),
      footerBg: Color(0xFF01579B),
      layout: FrameLayout.arch,
      accentColor: Color(0xFFB3E5FC),
    ),
    FrameStyle(
      name: 'Filmstrip',
      borderColor: Color(0xFF212121),
      footerBg: Color(0xFF424242),
      layout: FrameLayout.filmstrip,
      accentColor: Color(0xFFFFEB3B),
    ),
    FrameStyle(
      name: 'Luxury',
      borderColor: Color(0xFFD4AF37),
      headerBg: Color(0xFF1A1200),
      footerBg: Color(0xFF1A1200),
      layout: FrameLayout.luxury,
      accentColor: Color(0xFFFFD700),
    ),
  ];

  AnimationType _selectedAnimation = AnimationType.none;
  late AnimationController _animController;
  late Animation<double> _animValue;
  late AnimationController _brandAnimController;
  final Map<String, Animation<double>> _brandAnimations = {};

  EffectType _selectedEffect = EffectType.none;
  double _effectStrength = 0.5;

  String? _selectedAudio;
  final List<AudioTrack> _audioTracks = [
    AudioTrack(
      'Upbeat Pop',
      'assets/audio/Aaja Mahiya - Lofi _ Slowed Reverb.mp3',
    ),
    AudioTrack(
      'Calm Acoustic',
      'assets/audio/Bharosa Karlo Tum Sath Nibhaunga - Lofi _ Slowed Reverb.mp3',
    ),
    AudioTrack(
      'Corporate',
      'assets/audio/Jana Mere Sawalo Ka Manzar Tu - Lofi _ Slowed Reverb.mp3',
    ),
    AudioTrack(
      'Cinematic',
      'assets/audio/Mere Ganpati Deva - Lofi _ Slowed Reverb.mp3',
    ),
    AudioTrack(
      'Electronic',
      'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
    ),
    AudioTrack(
      'Jazz Lounge',
      'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
    ),
  ];

  bool _isDownloading = false;
  double _downloadProgress = 0;

  final GlobalKey _posterKey = GlobalKey();

  String? _resizingTextId;
  Offset _resizeStartOffset = Offset.zero;
  double _resizeStartFontSize = 24;

  @override
  void initState() {
    super.initState();
    _brandElements = [
      BrandElement(
        id: 'logo',
        type: BrandElementType.logo,
        position: const Offset(12, 12),
        isVisible: true,
      ),
      BrandElement(
        id: 'name',
        type: BrandElementType.name,
        position: const Offset(12, 290),
        fontSize: 16,
        color: Colors.white,
        isVisible: true,
      ),
      BrandElement(
        id: 'phone',
        type: BrandElementType.phone,
        position: const Offset(12, 312),
        fontSize: 12,
        color: Colors.white70,
        isVisible: true,
      ),
      BrandElement(
        id: 'address',
        type: BrandElementType.address,
        position: const Offset(12, 330),
        fontSize: 10,
        color: Colors.white60,
        isVisible: true,
      ),
    ];

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animValue = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );

    _brandAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _setupBrandAnimations();
  }

  void _setupBrandAnimations() {
    _brandAnimations.clear();
    final ids = _brandElements.map((e) => e.id).toList();
    for (int i = 0; i < ids.length; i++) {
      final start = (i * 0.2).clamp(0.0, 1.0);
      final end = (start + 0.4).clamp(0.0, 1.0);
      _brandAnimations[ids[i]] = CurvedAnimation(
        parent: _brandAnimController,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animController.dispose();
    _brandAnimController.dispose();
    super.dispose();
  }

  bool get _isAnimated =>
      _selectedAnimation != AnimationType.none ||
      _selectedEffect != EffectType.none ||
      _selectedAudio != null;

  OverlayTextItem? get _selectedText {
    if (_selectedTextId == null || _texts.isEmpty) return null;
    try {
      return _texts.firstWhere((t) => t.id == _selectedTextId);
    } catch (_) {
      return null;
    }
  }

  void _addText() {
    final item = OverlayTextItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Tap to edit',
      position: Offset(60, 200 + _texts.length * 40.0),
      fontSize: 22,
      color: Colors.white,
    );
    setState(() {
      _texts.add(item);
      _selectedTextId = item.id;
    });
    _openTextEditor(item);
  }

  Future<void> _playAudio(String? trackName) async {
    try {
      // Stop current audio if playing
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);

      if (trackName == null || trackName == 'No Audio') {
        setState(() {
          _isAudioPlaying = false;
          _selectedAudio = null;
        });
        return;
      }

      // Find the selected track
      final selectedTrack = _audioTracks.firstWhere(
        (track) => track.name == trackName,
      );

      print('Attempting to play: ${selectedTrack.assetPath}');

      // Check if asset exists (you can't actually check, but we'll try to play)
      try {
        // Play the audio from assets
        final result = await _audioPlayer.play(
          AssetSource(selectedTrack.assetPath),
          volume: 1.0,
        );

        setState(() {
          _isAudioPlaying = true;
          _selectedAudio = trackName;
        });

        // Listen for when audio completes
        _audioPlayer.onPlayerComplete.listen((event) {
          print('Audio playback completed');
          if (mounted) {
            setState(() {
              _isAudioPlaying = false;
            });
          }
        });

        // Listen for errors
      } catch (e) {
        print('Error playing audio file: $e');
        setState(() {
          _isAudioPlaying = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not play audio file. Make sure assets are properly configured.',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('General error in _playAudio: $e');
      setState(() {
        _isAudioPlaying = false;
      });
    }
  }

  void _openTextEditor(OverlayTextItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TextEditorSheet(
        item: item,
        onChanged: (updated) {
          setState(() {
            final idx = _texts.indexWhere((t) => t.id == updated.id);
            if (idx != -1) _texts[idx] = updated;
          });
        },
      ),
    );
  }

  // ── IMAGE UPLOAD ─────────────────────────

  Future<void> _pickImage({bool forLogo = false}) async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (picked != null) {
        setState(() {
          if (forLogo)
            _uploadedLogoPath = picked.path;
          else
            _uploadedImagePath = picked.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                forLogo ? 'Logo updated!' : 'Background image updated!',
              ),
              backgroundColor: const Color(0xFF2E7D32),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ── DOWNLOAD (FIXED) ─────────────────────

  // void _startDownload() async {
  //   setState(() {
  //     _isDownloading = true;
  //     _downloadProgress = 0;
  //   });

  //   try {
  //     if (_isAnimated) {
  //       // ── REAL MP4 EXPORT WITH CORRECT TIMING ──────────────────────

  //       setState(() => _downloadProgress = 0.05);

  //       // 1. Create temp directory for frames
  //       final tempDir = await getTemporaryDirectory();
  //       final framesDir = Directory(
  //         '${tempDir.path}/poster_frames_${DateTime.now().millisecondsSinceEpoch}',
  //       );
  //       await framesDir.create(recursive: true);

  //       // 2. Animation settings
  //       const totalFrames = 90; // 3 seconds at 30fps for smoother animation
  //       const fps = 30;
  //       const animationDurationMs = 3000; // 3 seconds

  //       // Store original animation states
  //       final wasAnimating = _animController.isAnimating;

  //       // Stop automatic animation
  //       if (wasAnimating) {
  //         _animController.stop();
  //         _brandAnimController.stop();
  //       }

  //       // Calculate frame delay for 3-second duration
  //       const frameDelayMs =
  //           animationDurationMs ~/ totalFrames; // ~33ms per frame

  //       // Capture frames with proper timing
  //       for (int i = 0; i < totalFrames; i++) {
  //         // Calculate progress based on time (0.0 to 1.0)
  //         final progress = i / (totalFrames - 1);

  //         // For ping-pong animation (like repeat(reverse: true))
  //         // This creates a smooth back-and-forth motion over 3 seconds
  //         final animValue;
  //         if (progress <= 0.5) {
  //           // First half (0-1.5s): 0.0 → 1.0
  //           animValue = progress * 2;
  //         } else {
  //           // Second half (1.5-3s): 1.0 → 0.0
  //           animValue = 2.0 - (progress * 2);
  //         }

  //         // Set main animation controller value
  //         _animController.value = animValue;

  //         // Set brand animation controller value
  //         _brandAnimController.value = animValue;

  //         // IMPORTANT: Force a rebuild of all widgets
  //         setState(() {});

  //         // Wait for the frame to render completely
  //         await WidgetsBinding.instance.endOfFrame;

  //         // Wait for the calculated frame delay to maintain 3-second duration
  //         await Future.delayed(Duration(milliseconds: frameDelayMs));

  //         // Capture the frame
  //         final ctx = _posterKey.currentContext;
  //         if (ctx == null) throw Exception('Poster context not found');

  //         final boundary = ctx.findRenderObject() as RenderRepaintBoundary;
  //         final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
  //         final ByteData? byteData = await image.toByteData(
  //           format: ui.ImageByteFormat.png,
  //         );

  //         if (byteData == null) throw Exception('Frame $i encoding failed');

  //         final frameFile = File(
  //           '${framesDir.path}/frame_${i.toString().padLeft(4, '0')}.png',
  //         );
  //         await frameFile.writeAsBytes(byteData.buffer.asUint8List());

  //         // Update progress
  //         setState(() => _downloadProgress = 0.05 + (i / totalFrames) * 0.55);
  //       }

  //       setState(() => _downloadProgress = 0.62);

  //       // 3. Build ffmpeg command
  //       final outputPath =
  //           '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.mp4';

  //       String ffmpegCommand =
  //           '-y -framerate $fps -i ${framesDir.path}/frame_%04d.png '
  //           '-c:v libx264 -pix_fmt yuv420p -crf 23 -preset fast '
  //           '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
  //           '$outputPath';

  //       setState(() => _downloadProgress = 0.65);

  //       // 4. Execute ffmpeg
  //       final session = await FFmpegKit.execute(ffmpegCommand);
  //       final returnCode = await session.getReturnCode();

  //       setState(() => _downloadProgress = 0.88);

  //       if (!ReturnCode.isSuccess(returnCode)) {
  //         final logs = await session.getAllLogsAsString();
  //         throw Exception('FFmpeg failed: $logs');
  //       }

  //       // 5. Save to gallery
  //       final hasAccess = await Gal.hasAccess();
  //       if (!hasAccess) await Gal.requestAccess();
  //       await Gal.putVideo(outputPath, album: 'Poster Editor');

  //       setState(() => _downloadProgress = 1.0);

  //       // 6. Cleanup frames
  //       await framesDir.delete(recursive: true);

  //       // 7. Restore animation state
  //       if (wasAnimating && mounted) {
  //         _animController.repeat(reverse: true);
  //         _brandAnimController.repeat();
  //       }

  //       await Future.delayed(const Duration(milliseconds: 400));
  //       if (mounted) {
  //         setState(() => _isDownloading = false);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('✅ Video saved to gallery!'),
  //             backgroundColor: Color(0xFF2E7D32),
  //           ),
  //         );
  //       }
  //     } else {
  //       // ── IMAGE DOWNLOAD (unchanged) ───────────
  //       setState(() => _downloadProgress = 0.2);
  //       await Future.delayed(const Duration(milliseconds: 300));

  //       final ctx = _posterKey.currentContext;
  //       if (ctx == null) throw Exception('Poster not found. Please try again.');

  //       final boundary = ctx.findRenderObject() as RenderRepaintBoundary;

  //       setState(() => _downloadProgress = 0.4);
  //       await Future.delayed(const Duration(milliseconds: 100));

  //       final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //       setState(() => _downloadProgress = 0.65);

  //       final ByteData? byteData = await image.toByteData(
  //         format: ui.ImageByteFormat.png,
  //       );
  //       if (byteData == null) throw Exception('Failed to encode image');
  //       setState(() => _downloadProgress = 0.8);

  //       final Uint8List pngBytes = byteData.buffer.asUint8List();
  //       final tempDir = await getTemporaryDirectory();
  //       final file = File(
  //         '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png',
  //       );
  //       await file.writeAsBytes(pngBytes);
  //       setState(() => _downloadProgress = 0.92);

  //       final hasAccess = await Gal.hasAccess();
  //       if (!hasAccess) await Gal.requestAccess();
  //       await Gal.putImage(file.path, album: 'Poster Editor');
  //       setState(() => _downloadProgress = 1.0);

  //       await Future.delayed(const Duration(milliseconds: 400));
  //       if (mounted) {
  //         setState(() => _isDownloading = false);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('✅ Image saved to gallery!'),
  //             backgroundColor: Color(0xFF2E7D32),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() => _isDownloading = false);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Download failed: $e'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

  void _startDownload() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      if (_isAnimated) {
        // ── REAL MP4 EXPORT WITH CORRECT TIMING ──────────────────────

        setState(() => _downloadProgress = 0.05);

        // 1. Create temp directory for frames
        final tempDir = await getTemporaryDirectory();
        final framesDir = Directory(
          '${tempDir.path}/poster_frames_${DateTime.now().millisecondsSinceEpoch}',
        );
        await framesDir.create(recursive: true);

        // 2. Animation settings
        const int totalFrames = 90; // 3 seconds at 30fps
        const int fps = 30;
        const int animationDurationMs = 3000; // 3 seconds

        // Store original animation state
        final bool wasAnimating = _animController.isAnimating;

        // Stop automatic animation
        if (wasAnimating) {
          _animController.stop();
          _brandAnimController.stop();
        }

        // Calculate delay between frames to match 3-second duration
        const int frameDelayMs =
            animationDurationMs ~/ totalFrames; // ~33ms per frame

        print(
          'Starting frame capture: $totalFrames frames at ${frameDelayMs}ms intervals',
        );

        // Capture frames with proper timing
        for (int i = 0; i < totalFrames; i++) {
          final DateTime frameStartTime = DateTime.now();

          // Calculate progress based on frame index (0.0 to 1.0)
          final double progress = i / (totalFrames - 1);

          // Calculate animation value based on animation type
          double animValue;

          switch (_selectedAnimation) {
            case AnimationType.none:
              animValue = 1.0;
              break;
            case AnimationType.fade:
            case AnimationType.zoom:
            case AnimationType.slideLeft:
            case AnimationType.slideRight:
            case AnimationType.slideUp:
            case AnimationType.slideDown:
              // For smooth back-and-forth motion
              animValue = (sin(progress * pi) * 0.5) + 0.5;
              break;
            case AnimationType.rotate:
            case AnimationType.flipIn:
            case AnimationType.wobble:
            case AnimationType.rollin:
              // For rotation-based animations
              animValue = progress;
              break;
          }

          // Set main animation controller value
          _animController.value = animValue;

          // Set brand animation controller value for staggered animations
          _brandAnimController.value = progress;

          // Force a rebuild of all widgets to update animations
          setState(() {});

          // Wait for the frame to render completely
          await WidgetsBinding.instance.endOfFrame;

          // Small delay to ensure rendering is complete
          await Future.delayed(const Duration(milliseconds: 5));

          // Capture the frame
          final RenderRepaintBoundary? boundary =
              _posterKey.currentContext?.findRenderObject()
                  as RenderRepaintBoundary?;
          if (boundary == null) throw Exception('Poster context not found');

          final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
          final ByteData? byteData = await image.toByteData(
            format: ui.ImageByteFormat.png,
          );

          if (byteData == null) throw Exception('Frame $i encoding failed');

          // Save frame as PNG
          final String frameNumber = i.toString().padLeft(4, '0');
          final File frameFile = File(
            '${framesDir.path}/frame_$frameNumber.png',
          );
          await frameFile.writeAsBytes(byteData.buffer.asUint8List());

          // Calculate actual elapsed time and adjust delay if needed
          final int elapsedMs = DateTime.now()
              .difference(frameStartTime)
              .inMilliseconds;
          final int remainingDelay = frameDelayMs - elapsedMs;

          if (remainingDelay > 0) {
            await Future.delayed(Duration(milliseconds: remainingDelay));
          }

          // Update progress
          setState(() {
            _downloadProgress = 0.05 + (i / totalFrames) * 0.55;
          });
        }

        setState(() => _downloadProgress = 0.62);

        // 3. Check if audio is selected and prepare audio file
        String? audioFilePath;
        if (_selectedAudio != null && _selectedAudio != 'No Audio') {
          try {
            // Map audio names to asset paths
            const Map<String, String> audioAssets = {
              'Upbeat Pop':
                  'assets/audio/Aaja Mahiya - Lofi _ Slowed Reverb.mp3',
              'Calm Acoustic':
                  'assets/audio/Bharosa Karlo Tum Sath Nibhaunga - Lofi _ Slowed Reverb.mp3',
              'Corporate':
                  'assets/audio/Jana Mere Sawalo Ka Manzar Tu - Lofi _ Slowed Reverb.mp3',
              'Cinematic':
                  'assets/audio/Mere Ganpati Deva - Lofi _ Slowed Reverb.mp3',
              'Electronic':
                  'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
              'Jazz Lounge':
                  'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
            };

            final String? assetPath = audioAssets[_selectedAudio];
            if (assetPath != null) {
              // Copy audio asset to temp file
              final ByteData audioData = await rootBundle.load(assetPath);
              final File tempAudioFile = File('${tempDir.path}/temp_audio.mp3');
              await tempAudioFile.writeAsBytes(audioData.buffer.asUint8List());
              audioFilePath = tempAudioFile.path;
            }
          } catch (e) {
            print('Error loading audio: $e');
            // Continue without audio if there's an error
          }
        }

        // 4. Build ffmpeg command with or without audio
        final String outputPath =
            '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.mp4';

        String ffmpegCommand;
        if (audioFilePath != null && File(audioFilePath).existsSync()) {
          // Command with audio
          ffmpegCommand =
              '-y -framerate $fps -i ${framesDir.path}/frame_%04d.png '
              '-i "$audioFilePath" '
              '-c:v libx264 -pix_fmt yuv420p -c:a aac -shortest '
              '-crf 23 -preset fast '
              '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
              '"$outputPath"';
        } else {
          // Command without audio
          ffmpegCommand =
              '-y -framerate $fps -i ${framesDir.path}/frame_%04d.png '
              '-c:v libx264 -pix_fmt yuv420p '
              '-crf 23 -preset fast '
              '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
              '"$outputPath"';
        }

        setState(() => _downloadProgress = 0.65);

        // 5. Execute ffmpeg
        print('Executing FFmpeg command: $ffmpegCommand');
        final ffmpegSession = await FFmpegKit.execute(ffmpegCommand);
        final ReturnCode? returnCode = await ffmpegSession.getReturnCode();

        setState(() => _downloadProgress = 0.88);

        if (!ReturnCode.isSuccess(returnCode)) {
          final String? logs = await ffmpegSession.getAllLogsAsString();
          final String? failStackTrace = await ffmpegSession
              .getFailStackTrace();
          print('FFmpeg failed: $logs');
          print('Stack trace: $failStackTrace');
          throw Exception('FFmpeg failed to create video');
        }

        // 6. Verify video file exists
        final File videoFile = File(outputPath);
        if (!await videoFile.exists()) {
          throw Exception('Video file was not created');
        }

        // 7. Save to gallery
        final bool hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          await Gal.requestAccess();
        }
        await Gal.putVideo(outputPath, album: 'Poster Editor');

        setState(() => _downloadProgress = 1.0);

        // 8. Cleanup frames
        try {
          await framesDir.delete(recursive: true);
          if (audioFilePath != null) {
            File(audioFilePath).deleteSync();
          }
        } catch (e) {
          print('Cleanup error: $e');
        }

        // 9. Restore animation state
        if (wasAnimating && mounted) {
          _animController.repeat(reverse: true);
          _brandAnimController.repeat();
        }

        await Future.delayed(const Duration(milliseconds: 400));

        if (mounted) {
          setState(() {
            _isDownloading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                audioFilePath != null
                    ? '✅ Video with audio saved to gallery!'
                    : '✅ Video saved to gallery!',
              ),
              backgroundColor: const Color(0xFF2E7D32),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // ── IMAGE DOWNLOAD ───────────────────────────

        setState(() => _downloadProgress = 0.2);
        await Future.delayed(const Duration(milliseconds: 300));

        final RenderRepaintBoundary? boundary =
            _posterKey.currentContext?.findRenderObject()
                as RenderRepaintBoundary?;
        if (boundary == null) {
          throw Exception('Poster not found. Please try again.');
        }

        setState(() => _downloadProgress = 0.4);
        await Future.delayed(const Duration(milliseconds: 100));

        final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        setState(() => _downloadProgress = 0.65);

        final ByteData? byteData = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );

        if (byteData == null) {
          throw Exception('Failed to encode image');
        }

        setState(() => _downloadProgress = 0.8);

        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final Directory tempDir = await getTemporaryDirectory();
        final String fileName =
            'poster_${DateTime.now().millisecondsSinceEpoch}.png';
        final File file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(pngBytes);

        setState(() => _downloadProgress = 0.92);

        // Save to gallery
        final bool hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          await Gal.requestAccess();
        }
        await Gal.putImage(file.path, album: 'Poster Editor');

        setState(() => _downloadProgress = 1.0);

        await Future.delayed(const Duration(milliseconds: 400));

        if (mounted) {
          setState(() {
            _isDownloading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Image saved to gallery!'),
              backgroundColor: Color(0xFF2E7D32),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('Download error: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          _isDownloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  // ──────────────────────────────────────────
  //  BUILD
  // ──────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Stack(
        children: [
          Column(
            children: [
              _buildTopBar(),
              Expanded(child: _buildPosterArea()),
              _buildColorRow(),
              _buildBottomPanel(),
              _buildBottomTabBar(),
            ],
          ),
          if (_isDownloading) _buildDownloadDialog(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: const Color(0xFFF5C518),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        left: 8,
        right: 8,
        bottom: 8,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 22),
            onPressed: () => Navigator.maybePop(context),
          ),
          IconButton(
            icon: const Icon(Icons.layers, color: Colors.black87, size: 22),
            onPressed: _showLayersSheet,
          ),
          IconButton(
            icon: const Icon(
              Icons.add_photo_alternate,
              color: Colors.black87,
              size: 22,
            ),
            tooltip: 'Upload Background',
            onPressed: () => _pickImage(forLogo: false),
          ),
          if (_isAnimated)
            IconButton(
              icon: Icon(
                _animController.isAnimating
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                color: Colors.black87,
                size: 22,
              ),
              onPressed: () {
                setState(() {
                  if (_animController.isAnimating) {
                    _animController.stop();
                    _brandAnimController.stop();
                  } else {
                    _animController.repeat(reverse: true);
                    _brandAnimController.repeat();
                  }
                });
              },
            ),
          const Spacer(),
          GestureDetector(
            onTap: _startDownload,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    _isAnimated ? Icons.videocam : Icons.download,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isAnimated ? 'Export MP4' : 'Download',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterArea() {
    return GestureDetector(
      onTap: () => setState(() => _selectedTextId = null),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: RepaintBoundary(
              key: _posterKey,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    _buildPosterBackground(),
                    if (_selectedFrame >= 0)
                      _buildFrameOverlay(_frames[_selectedFrame]),
                    if (_selectedFrame < 0) ..._buildFreeBrandElements(),
                    ..._texts.map((t) => _buildTextWidget(t)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPosterBackground() {
    Widget img;
    if (_uploadedImagePath != null) {
      img = Image.file(
        File(_uploadedImagePath!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      img = Image.asset(
        widget.posterAsset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    Widget base = Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: _bgColor,
        ),
        img,
      ],
    );

    if (_selectedEffect == EffectType.blur) {
      base = ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: 3 * _effectStrength,
          sigmaY: 3 * _effectStrength,
        ),
        child: base,
      );
    } else if (_selectedEffect == EffectType.grayscale) {
      base = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: base,
      );
    } else if (_selectedEffect == EffectType.sepia) {
      base = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.393,
          0.769,
          0.189,
          0,
          0,
          0.349,
          0.686,
          0.168,
          0,
          0,
          0.272,
          0.534,
          0.131,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: base,
      );
    }

    if (_selectedAnimation != AnimationType.none) {
      return AnimatedBuilder(
        animation: _animValue,
        builder: (_, __) => _applyAnimation(base),
      );
    }
    return base;
  }

  Widget _applyAnimation(Widget child) {
    switch (_selectedAnimation) {
      case AnimationType.fade:
        return Opacity(opacity: 0.4 + 0.6 * _animValue.value, child: child);
      case AnimationType.zoom:
        return Transform.scale(
          scale: 0.95 + 0.05 * _animValue.value,
          child: child,
        );
      case AnimationType.rotate:
        return Transform.rotate(
          angle: 0.03 * sin(_animValue.value * pi),
          child: child,
        );
      case AnimationType.slideLeft:
        return Transform.translate(
          offset: Offset(-10 * _animValue.value, 0),
          child: child,
        );
      case AnimationType.slideRight:
        return Transform.translate(
          offset: Offset(10 * _animValue.value, 0),
          child: child,
        );
      case AnimationType.slideUp:
        return Transform.translate(
          offset: Offset(0, -10 * _animValue.value),
          child: child,
        );
      case AnimationType.slideDown:
        return Transform.translate(
          offset: Offset(0, 10 * _animValue.value),
          child: child,
        );
      case AnimationType.flipIn:
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(0.2 * sin(_animValue.value * pi)),
          child: child,
        );
      case AnimationType.wobble:
        return Transform.rotate(
          angle: 0.05 * sin(_animValue.value * pi * 2),
          child: child,
        );
      case AnimationType.rollin:
        return Transform.rotate(angle: _animValue.value * 0.1, child: child);
      default:
        return child;
    }
  }

  // ── FREE BRAND ELEMENTS ──────────────────

  List<Widget> _buildFreeBrandElements() {
    return _brandElements
        .where((e) => e.isVisible)
        .map((e) => _buildDraggableBrandElement(e))
        .toList();
  }

  Widget _buildDraggableBrandElement(BrandElement elem) {
    final anim = _selectedAnimation != AnimationType.none
        ? (_brandAnimations[elem.id] ?? const AlwaysStoppedAnimation(1.0))
        : const AlwaysStoppedAnimation(1.0);
    return Positioned(
      left: elem.position.dx,
      top: elem.position.dy,
      child: GestureDetector(
        onPanUpdate: (d) {
          setState(() {
            final idx = _brandElements.indexWhere((e) => e.id == elem.id);
            if (idx != -1)
              _brandElements[idx] = _brandElements[idx].copyWith(
                position: elem.position + d.delta,
              );
          });
        },
        onLongPress: () => _showBrandElementOptions(elem),
        child: AnimatedBuilder(
          animation: anim,
          builder: (_, child) => _wrapBrandAnim(child!, anim),
          child: _buildBrandContent(elem),
        ),
      ),
    );
  }

  Widget _wrapBrandAnim(Widget child, Animation<double> anim) {
    switch (_selectedAnimation) {
      case AnimationType.fade:
        return Opacity(opacity: anim.value, child: child);
      case AnimationType.slideLeft:
        return Transform.translate(
          offset: Offset(-80 * (1 - anim.value), 0),
          child: Opacity(opacity: anim.value, child: child),
        );
      case AnimationType.slideRight:
        return Transform.translate(
          offset: Offset(80 * (1 - anim.value), 0),
          child: Opacity(opacity: anim.value, child: child),
        );
      case AnimationType.slideUp:
        return Transform.translate(
          offset: Offset(0, 40 * (1 - anim.value)),
          child: Opacity(opacity: anim.value, child: child),
        );
      case AnimationType.slideDown:
        return Transform.translate(
          offset: Offset(0, -40 * (1 - anim.value)),
          child: Opacity(opacity: anim.value, child: child),
        );
      case AnimationType.zoom:
        return Transform.scale(
          scale: anim.value,
          child: Opacity(opacity: anim.value, child: child),
        );
      case AnimationType.rotate:
        return Transform.rotate(
          angle: (1 - anim.value) * pi,
          child: Opacity(opacity: anim.value, child: child),
        );
      case AnimationType.flipIn:
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY((1 - anim.value) * pi / 2),
          child: Opacity(opacity: anim.value, child: child),
        );
      case AnimationType.wobble:
        return Transform.translate(
          offset: Offset(10 * sin(anim.value * pi * 4) * (1 - anim.value), 0),
          child: child,
        );
      case AnimationType.rollin:
        return Transform.rotate(
          angle: (1 - anim.value) * pi * 2,
          child: Transform.scale(scale: anim.value, child: child),
        );
      default:
        return child;
    }
  }

  Widget _buildBrandContent(BrandElement elem) {
    switch (elem.type) {
      case BrandElementType.logo:
        return _logoWidget(const Color(0xFFD4AF37), size: 56);
      case BrandElementType.name:
        return Text(
          _brandInfo.name,
          style: TextStyle(
            fontSize: elem.fontSize,
            color: elem.color,
            fontWeight: FontWeight.bold,
            shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
          ),
        );
      case BrandElementType.phone:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone, size: elem.fontSize - 2, color: elem.color),
            const SizedBox(width: 4),
            Text(
              _brandInfo.phone,
              style: TextStyle(fontSize: elem.fontSize, color: elem.color),
            ),
          ],
        );
      case BrandElementType.address:
        return SizedBox(
          width: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                size: elem.fontSize - 2,
                color: elem.color,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _brandInfo.address,
                  style: TextStyle(fontSize: elem.fontSize, color: elem.color),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        );
    }
  }

  void _showBrandElementOptions(BrandElement elem) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              elem.type.name.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.visibility_off, color: Colors.orange),
              title: const Text('Hide element'),
              onTap: () {
                setState(() {
                  final idx = _brandElements.indexWhere((e) => e.id == elem.id);
                  if (idx != -1)
                    _brandElements[idx] = _brandElements[idx].copyWith(
                      isVisible: false,
                    );
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── FRAME RENDERING ───────────────────────

  Widget _buildFrameOverlay(FrameStyle frame) {
    return Positioned.fill(
      child: IgnorePointer(child: _buildFrameLayout(frame)),
    );
  }

  Widget _buildFrameLayout(FrameStyle f) {
    switch (f.layout) {
      case FrameLayout.classic:
        return _frameClassic(f);
      case FrameLayout.banner:
        return _frameBanner(f);
      case FrameLayout.modern:
        return _frameModern(f);
      case FrameLayout.elegant:
        return _frameElegant(f);
      case FrameLayout.neon:
        return _frameNeon(f);
      case FrameLayout.minimal:
        return _frameMinimal(f);
      case FrameLayout.card:
        return _frameCard(f);
      case FrameLayout.ribbon:
        return _frameRibbon(f);
      case FrameLayout.diagonal:
        return _frameDiagonal(f);
      case FrameLayout.curved:
        return _frameCurved(f);
      case FrameLayout.sideStrip:
        return _frameSideStrip(f);
      case FrameLayout.split:
        return _frameSplit(f);
      case FrameLayout.badge:
        return _frameBadge(f);
      case FrameLayout.gradient:
        return _frameGradient(f);
      case FrameLayout.zigzag:
        return _frameZigzag(f);
      case FrameLayout.shadow:
        return _frameShadow(f);
      case FrameLayout.stripe:
        return _frameStripe(f);
      case FrameLayout.arch:
        return _frameArch(f);
      case FrameLayout.filmstrip:
        return _frameFilmstrip(f);
      case FrameLayout.luxury:
        return _frameLuxury(f);
    }
  }

  // 1. Classic
  Widget _frameClassic(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 8),
        ),
      ),
      Positioned(
        top: 14,
        left: 14,
        child: _logoWidget(f.borderColor, size: 52),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: f.footerBg ?? f.borderColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bt(_brandInfo.name, 14, Colors.white, FontWeight.bold, 0),
              const SizedBox(height: 2),
              _br(Icons.phone, _brandInfo.phone, 11, Colors.white70, 1),
              _br(Icons.location_on, _brandInfo.address, 10, Colors.white60, 2),
            ],
          ),
        ),
      ),
    ],
  );

  // 2. Golden Banner
  Widget _frameBanner(FrameStyle f) => Stack(
    children: [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          color: f.headerBg ?? f.borderColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _logoWidget(Colors.white.withOpacity(0.2), size: 40),
              const SizedBox(width: 10),
              _bt(_brandInfo.name, 15, Colors.white, FontWeight.bold, 0),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: (f.footerBg ?? f.borderColor).withOpacity(0.9),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: _br(Icons.phone, _brandInfo.phone, 11, Colors.white, 1),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _br(
                  Icons.location_on,
                  _brandInfo.address,
                  10,
                  Colors.white70,
                  2,
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            vertical: BorderSide(color: f.borderColor, width: 4),
          ),
        ),
      ),
    ],
  );

  // 3. Modern
  Widget _frameModern(FrameStyle f) => Stack(
    children: [
      Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        child: Container(width: 8, color: f.borderColor),
      ),
      Positioned(
        bottom: 16,
        left: 16,
        right: 16,
        child: Container(
          decoration: BoxDecoration(
            color: (f.headerBg ?? f.borderColor).withOpacity(0.85),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _logoWidget(Colors.white.withOpacity(0.2), size: 44),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bt(_brandInfo.name, 14, Colors.white, FontWeight.bold, 0),
                    _br(Icons.phone, _brandInfo.phone, 11, Colors.white70, 1),
                    _br(
                      Icons.location_on,
                      _brandInfo.address,
                      10,
                      Colors.white60,
                      2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 14,
        right: 14,
        child: _logoWidget(f.borderColor, size: 50),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: f.borderColor, width: 4),
          ),
        ),
      ),
    ],
  );

  // 4. Elegant
  Widget _frameElegant(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 6),
        ),
      ),
      Positioned.fill(
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: f.borderColor.withOpacity(0.5), width: 1),
          ),
        ),
      ),
      Positioned(
        top: 16,
        left: 0,
        right: 0,
        child: Center(child: _logoWidget(f.borderColor, size: 56)),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: f.footerBg ?? f.borderColor,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              _bt(_brandInfo.name, 14, Colors.white, FontWeight.bold, 0),
              const SizedBox(height: 2),
              _bt(_brandInfo.phone, 11, Colors.white70, FontWeight.normal, 1),
              _bt(
                _brandInfo.address.length > 30
                    ? '${_brandInfo.address.substring(0, 30)}…'
                    : _brandInfo.address,
                10,
                Colors.white60,
                FontWeight.normal,
                2,
              ),
            ],
          ),
        ),
      ),
    ],
  );

  // 5. Neon
  Widget _frameNeon(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: f.borderColor.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
      Positioned(
        top: 12,
        left: 12,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: f.borderColor.withOpacity(0.8), blurRadius: 12),
            ],
          ),
          child: _logoWidget(f.borderColor, size: 50),
        ),
      ),
      Positioned(
        bottom: 12,
        left: 12,
        right: 12,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            border: Border.all(color: f.borderColor, width: 1),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bt(_brandInfo.name, 14, f.borderColor, FontWeight.bold, 0),
              _br(Icons.phone, _brandInfo.phone, 11, Colors.white70, 1),
              _br(Icons.location_on, _brandInfo.address, 10, Colors.white54, 2),
            ],
          ),
        ),
      ),
    ],
  );

  // 6. Minimal
  Widget _frameMinimal(FrameStyle f) {
    const sz = 24.0, th = 3.0;
    final c = f.borderColor;
    return Stack(
      children: [
        Positioned(top: 8, left: 8, child: _corner(c, sz, th, true, true)),
        Positioned(top: 8, right: 8, child: _corner(c, sz, th, true, false)),
        Positioned(bottom: 8, left: 8, child: _corner(c, sz, th, false, true)),
        Positioned(
          bottom: 8,
          right: 8,
          child: _corner(c, sz, th, false, false),
        ),
        Positioned(top: 20, right: 20, child: _logoWidget(c, size: 46)),
        Positioned(
          bottom: 20,
          left: 20,
          right: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bt(_brandInfo.name, 15, Colors.white, FontWeight.bold, 0),
              _br(Icons.phone, _brandInfo.phone, 11, Colors.white70, 1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _corner(Color c, double sz, double th, bool top, bool left) {
    return SizedBox(
      width: sz,
      height: sz,
      child: CustomPaint(
        painter: _CornerPainter(
          color: c,
          thickness: th,
          topLeft: top && left,
          topRight: top && !left,
          bottomLeft: !top && left,
          bottomRight: !top && !left,
        ),
      ),
    );
  }

  // 7. Card
  Widget _frameCard(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 5),
        ),
      ),
      Positioned(
        bottom: 14,
        left: 14,
        right: 14,
        child: Container(
          decoration: BoxDecoration(
            color: (f.footerBg ?? f.borderColor).withOpacity(0.92),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _logoWidget(Colors.white.withOpacity(0.15), size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bt(_brandInfo.name, 14, Colors.white, FontWeight.bold, 0),
                    const SizedBox(height: 2),
                    _br(Icons.phone, _brandInfo.phone, 11, Colors.white60, 1),
                    _br(
                      Icons.location_on,
                      _brandInfo.address,
                      10,
                      Colors.white60,
                      2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  // 8. Ribbon
  Widget _frameRibbon(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 4),
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 52,
          color: f.headerBg ?? f.borderColor,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              _logoWidget(Colors.white.withOpacity(0.2), size: 38),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bt(_brandInfo.name, 14, Colors.white, FontWeight.bold, 0),
                  _bt(
                    _brandInfo.phone,
                    11,
                    Colors.white70,
                    FontWeight.normal,
                    1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: (f.headerBg ?? f.borderColor).withOpacity(0.8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: _br(
            Icons.location_on,
            _brandInfo.address,
            10,
            Colors.white70,
            2,
          ),
        ),
      ),
    ],
  );

  // 9. Diagonal
  Widget _frameDiagonal(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 4),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: ClipPath(
          clipper: _DiagonalClipper(),
          child: Container(
            height: 80,
            color: f.footerBg ?? f.borderColor,
            padding: const EdgeInsets.fromLTRB(14, 20, 14, 8),
            child: Row(
              children: [
                _logoWidget(Colors.white.withOpacity(0.2), size: 36),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _bt(
                        _brandInfo.name,
                        13,
                        Colors.white,
                        FontWeight.bold,
                        0,
                      ),
                      _br(Icons.phone, _brandInfo.phone, 10, Colors.white70, 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 14,
        right: 14,
        child: _logoWidget(f.borderColor, size: 46),
      ),
    ],
  );

  // 10. Wave/Curved
  Widget _frameCurved(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 3),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            height: 90,
            color: f.footerBg ?? f.borderColor,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.fromLTRB(14, 28, 14, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _logoWidget(Colors.white.withOpacity(0.2), size: 36),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _bt(_brandInfo.name, 13, Colors.white, FontWeight.bold, 0),
                    _bt(
                      _brandInfo.phone,
                      10,
                      Colors.white70,
                      FontWeight.normal,
                      1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  // 11. Side Strip
  Widget _frameSideStrip(FrameStyle f) => Stack(
    children: [
      Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        child: Container(
          width: 52,
          color: f.footerBg ?? f.borderColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _logoWidget(Colors.white.withOpacity(0.2), size: 38),
              const SizedBox(height: 8),
              RotatedBox(
                quarterTurns: 1,
                child: _bt(
                  _brandInfo.name,
                  11,
                  Colors.white,
                  FontWeight.bold,
                  0,
                ),
              ),
              const SizedBox(height: 6),
              RotatedBox(
                quarterTurns: 1,
                child: _bt(
                  _brandInfo.phone,
                  9,
                  Colors.white70,
                  FontWeight.normal,
                  1,
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: f.borderColor, width: 4),
            bottom: BorderSide(color: f.borderColor, width: 4),
            left: BorderSide(color: f.borderColor, width: 4),
          ),
        ),
      ),
    ],
  );

  // 12. Split
  Widget _frameSplit(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 4),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: f.borderColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _logoWidget(Colors.white.withOpacity(0.25), size: 36),
                    const SizedBox(height: 4),
                    _bt(_brandInfo.name, 12, Colors.white, FontWeight.bold, 0),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: (f.footerBg ?? f.borderColor).withOpacity(0.8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _br(Icons.phone, _brandInfo.phone, 10, Colors.white, 1),
                    const SizedBox(height: 4),
                    _br(
                      Icons.location_on,
                      _brandInfo.address,
                      9,
                      Colors.white70,
                      2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  // 13. Badge
  Widget _frameBadge(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 5),
        ),
      ),
      Positioned(
        top: 10,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: f.headerBg ?? f.borderColor,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8),
              ],
            ),
            child: const Center(
              child: Text(
                'LOGO',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: f.footerBg ?? f.borderColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bt(_brandInfo.name, 13, Colors.white, FontWeight.bold, 0),
                    _br(Icons.phone, _brandInfo.phone, 10, Colors.white70, 1),
                  ],
                ),
              ),
              Flexible(
                child: _br(
                  Icons.location_on,
                  _brandInfo.address,
                  9,
                  Colors.white60,
                  2,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  // 14. Gradient
  Widget _frameGradient(FrameStyle f) => Stack(
    children: [
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                (f.footerBg ?? f.borderColor).withOpacity(0.95),
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(14, 30, 14, 10),
          child: Row(
            children: [
              _logoWidget(f.borderColor, size: 44),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _bt(_brandInfo.name, 14, Colors.white, FontWeight.bold, 0),
                    _br(Icons.phone, _brandInfo.phone, 11, Colors.white70, 1),
                    _br(
                      Icons.location_on,
                      _brandInfo.address,
                      10,
                      Colors.white60,
                      2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 3),
        ),
      ),
    ],
  );

  // 15. Zigzag
  Widget _frameZigzag(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 4),
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 14,
          child: CustomPaint(painter: _ZigzagPainter(color: f.borderColor)),
        ),
      ),
      Positioned(
        top: 16,
        left: 12,
        child: _logoWidget(f.borderColor, size: 48),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: f.footerBg ?? f.borderColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            children: [
              Expanded(
                child: _bt(
                  _brandInfo.name,
                  13,
                  Colors.white,
                  FontWeight.bold,
                  0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _bt(
                    _brandInfo.phone,
                    10,
                    Colors.white70,
                    FontWeight.normal,
                    1,
                  ),
                  _bt(
                    _brandInfo.address.length > 20
                        ? '${_brandInfo.address.substring(0, 20)}…'
                        : _brandInfo.address,
                    9,
                    Colors.white60,
                    FontWeight.normal,
                    2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );

  // 16. Shadow
  Widget _frameShadow(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 4),
        ),
      ),
      Positioned(
        bottom: 14,
        left: 14,
        right: 14,
        child: Container(
          decoration: BoxDecoration(
            color: f.footerBg ?? f.borderColor,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(4, 4),
              ),
              BoxShadow(
                color: f.borderColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _logoWidget(Colors.white.withOpacity(0.15), size: 44),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bt(_brandInfo.name, 13, Colors.white, FontWeight.bold, 0),
                    _br(Icons.phone, _brandInfo.phone, 10, Colors.white70, 1),
                    _br(
                      Icons.location_on,
                      _brandInfo.address,
                      9,
                      Colors.white60,
                      2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  // 17. Stripe
  Widget _frameStripe(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 4),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 8, color: f.accentColor.withOpacity(0.7)),
            Container(
              color: f.footerBg ?? f.borderColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  _logoWidget(Colors.white.withOpacity(0.2), size: 38),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _bt(
                      _brandInfo.name,
                      13,
                      Colors.white,
                      FontWeight.bold,
                      0,
                    ),
                  ),
                  _bt(
                    _brandInfo.phone,
                    10,
                    Colors.white70,
                    FontWeight.normal,
                    1,
                  ),
                ],
              ),
            ),
            Container(height: 6, color: f.accentColor.withOpacity(0.5)),
          ],
        ),
      ),
    ],
  );

  // 18. Arch
  Widget _frameArch(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 4),
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: ClipPath(
          clipper: _ArchClipper(),
          child: Container(
            height: 70,
            color: f.headerBg ?? f.borderColor,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
            child: Row(
              children: [
                _logoWidget(Colors.white.withOpacity(0.2), size: 36),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bt(_brandInfo.name, 13, Colors.white, FontWeight.bold, 0),
                    _bt(
                      _brandInfo.phone,
                      10,
                      Colors.white70,
                      FontWeight.normal,
                      1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: (f.footerBg ?? f.borderColor).withOpacity(0.85),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: _br(
            Icons.location_on,
            _brandInfo.address,
            10,
            Colors.white70,
            2,
          ),
        ),
      ),
    ],
  );

  // 19. Filmstrip
  Widget _frameFilmstrip(FrameStyle f) {
    Widget holes() => Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        10,
        (i) => Container(
          width: 12,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(width: 22, color: f.borderColor, child: holes()),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(width: 22, color: f.borderColor, child: holes()),
        ),
        Positioned(
          bottom: 0,
          left: 22,
          right: 22,
          child: Container(
            color: f.footerBg ?? f.borderColor,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Row(
              children: [
                _logoWidget(f.accentColor.withOpacity(0.3), size: 36),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bt(
                        _brandInfo.name,
                        12,
                        f.accentColor,
                        FontWeight.bold,
                        0,
                      ),
                      _bt(
                        _brandInfo.phone,
                        9,
                        Colors.white70,
                        FontWeight.normal,
                        1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 20. Luxury
  Widget _frameLuxury(FrameStyle f) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.accentColor, width: 6),
        ),
      ),
      Positioned.fill(
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: f.accentColor.withOpacity(0.5),
              width: 1.5,
            ),
          ),
        ),
      ),
      Positioned(top: 14, left: 14, child: _luxuryCorner(f.accentColor)),
      Positioned(
        top: 14,
        right: 14,
        child: Transform.flip(flipX: true, child: _luxuryCorner(f.accentColor)),
      ),
      Positioned(
        bottom: 88,
        left: 14,
        child: Transform.flip(flipY: true, child: _luxuryCorner(f.accentColor)),
      ),
      Positioned(
        bottom: 88,
        right: 14,
        child: Transform.flip(
          flipX: true,
          flipY: true,
          child: _luxuryCorner(f.accentColor),
        ),
      ),
      Positioned(
        top: 14,
        left: 0,
        right: 0,
        child: Center(child: _logoWidget(f.accentColor, size: 54)),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
            color: f.footerBg ?? f.borderColor,
            border: Border(top: BorderSide(color: f.accentColor, width: 2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            children: [
              _bt(_brandInfo.name, 14, f.accentColor, FontWeight.bold, 0),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone,
                    size: 10,
                    color: f.accentColor.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  _bt(
                    _brandInfo.phone,
                    11,
                    Colors.white70,
                    FontWeight.normal,
                    1,
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.location_on,
                    size: 10,
                    color: f.accentColor.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: _bt(
                      _brandInfo.address.length > 22
                          ? '${_brandInfo.address.substring(0, 22)}…'
                          : _brandInfo.address,
                      10,
                      Colors.white60,
                      FontWeight.normal,
                      2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _luxuryCorner(Color c) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: _LuxuryCornerPainter(color: c)),
    );
  }

  // ── BRAND ANIMATION HELPERS ───────────────

  Widget _bt(
    String text,
    double size,
    Color color,
    FontWeight weight,
    int index,
  ) {
    if (_selectedAnimation == AnimationType.none) {
      return Text(
        text,
        style: TextStyle(fontSize: size, color: color, fontWeight: weight),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    final anim = _brandAnimations.values.length > index
        ? _brandAnimations.values.elementAt(index)
        : const AlwaysStoppedAnimation(1.0);
    return AnimatedBuilder(
      animation: anim,
      builder: (_, child) => _wrapBrandAnim(child!, anim),
      child: Text(
        text,
        style: TextStyle(fontSize: size, color: color, fontWeight: weight),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _br(IconData icon, String text, double size, Color color, int index) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: size - 1, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontSize: size, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
    if (_selectedAnimation == AnimationType.none) return content;
    final anim = _brandAnimations.values.length > index
        ? _brandAnimations.values.elementAt(index)
        : const AlwaysStoppedAnimation(1.0);
    return AnimatedBuilder(
      animation: anim,
      builder: (_, child) => _wrapBrandAnim(child!, anim),
      child: content,
    );
  }

  Widget _logoWidget(Color bgColor, {double size = 52}) {
    if (_uploadedLogoPath != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.file(
            File(_uploadedLogoPath!),
            fit: BoxFit.cover,
            width: size,
            height: size,
          ),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'LOGO',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ── TEXT WIDGET ───────────────────────────

  Widget _buildTextWidget(OverlayTextItem item) {
    final isSelected = _selectedTextId == item.id;
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTextId = item.id);
          _openTextEditor(item);
        },
        onPanUpdate: (d) {
          setState(() {
            final idx = _texts.indexWhere((t) => t.id == item.id);
            if (idx != -1)
              _texts[idx] = _texts[idx].copyWith(
                position: item.position + Offset(d.delta.dx, d.delta.dy),
              );
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (isSelected)
              Positioned(
                top: -14,
                left: -4,
                child: GestureDetector(
                  onTap: () => setState(() {
                    _texts.removeWhere((t) => t.id == item.id);
                    _selectedTextId = null;
                  }),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Container(
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 1.5),
                      color: Colors.blue.withOpacity(0.05),
                    )
                  : null,
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: item.hasBorder
                    ? BoxDecoration(
                        border: Border.all(color: item.color, width: 1),
                      )
                    : null,
                color: item.backgroundColor == Colors.transparent
                    ? null
                    : item.backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Transform.rotate(
                  angle: item.rotation,
                  child: Text(
                    item.text,
                    textAlign: item.align,
                    style: TextStyle(
                      fontSize: item.fontSize,
                      color: item.color,
                      fontWeight: item.isBold
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontStyle: item.isItalic
                          ? FontStyle.italic
                          : FontStyle.normal,
                      decoration: item.isUnderline
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      shadows: item.hasShadow
                          ? [
                              const Shadow(
                                color: Colors.black38,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                right: -6,
                bottom: -6,
                child: GestureDetector(
                  onPanStart: (d) {
                    _resizingTextId = item.id;
                    _resizeStartOffset = d.globalPosition;
                    _resizeStartFontSize = item.fontSize;
                  },
                  onPanUpdate: (d) {
                    if (_resizingTextId != item.id) return;
                    final delta =
                        (d.globalPosition.dx -
                            _resizeStartOffset.dx +
                            d.globalPosition.dy -
                            _resizeStartOffset.dy) /
                        2;
                    final newSize = (_resizeStartFontSize + delta).clamp(
                      8.0,
                      96.0,
                    );
                    setState(() {
                      final idx = _texts.indexWhere((t) => t.id == item.id);
                      if (idx != -1)
                        _texts[idx] = _texts[idx].copyWith(fontSize: newSize);
                    });
                  },
                  onPanEnd: (_) => _resizingTextId = null,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.open_in_full,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── COLOR ROW ─────────────────────────────

  Widget _buildColorRow() {
    final colors = [
      Colors.teal,
      Colors.brown.shade300,
      Colors.cyan,
      Colors.red.shade700,
      Colors.red.shade900,
      const Color(0xFFD4AF37),
      Colors.lightGreen,
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.grey,
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Background colour',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 28,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = colors[i];
                return GestureDetector(
                  onTap: () => setState(() => _bgColor = c),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _bgColor == c
                            ? Colors.black87
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM PANEL ──────────────────────────

  Widget _buildBottomPanel() {
    switch (_activeTab) {
      case BottomTab.text:
        return _buildTextPanel();
      case BottomTab.frames:
        return _buildFramesPanel();
      case BottomTab.audio:
        return _buildAudioPanel();
      case BottomTab.animation:
        return _buildAnimationPanel();
      case BottomTab.brandInfo:
        return _buildBrandInfoPanel();
      case BottomTab.sticker:
        return _buildEffectPanel();
    }
  }

  Widget _buildTextPanel() {
    final sel = _selectedText;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ta(
                  Icons.palette_outlined,
                  'Text Theme',
                  sel == null ? null : () => _showTextThemePicker(sel),
                ),
                _ta(
                  Icons.edit,
                  'Edit',
                  sel == null ? null : () => _openTextEditor(sel),
                ),
                _ta(
                  Icons.font_download_outlined,
                  'Font',
                  sel == null ? null : () => _showFontPicker(sel),
                ),
                _ta(
                  Icons.format_color_text,
                  'Color',
                  sel == null ? null : () => _showColorPicker(sel),
                ),
                _ta(
                  Icons.arrow_upward,
                  null,
                  sel == null ? null : () => _moveText(sel, dy: -10),
                ),
                _ta(
                  Icons.arrow_downward,
                  null,
                  sel == null ? null : () => _moveText(sel, dy: 10),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ta(
                  Icons.wb_sunny_outlined,
                  'Shadow',
                  sel == null
                      ? null
                      : () => setState(() {
                          final i = _texts.indexWhere((t) => t.id == sel.id);
                          _texts[i] = _texts[i].copyWith(
                            hasShadow: !sel.hasShadow,
                          );
                        }),
                ),
                _ta(
                  Icons.border_outer,
                  'Border',
                  sel == null
                      ? null
                      : () => setState(() {
                          final i = _texts.indexWhere((t) => t.id == sel.id);
                          _texts[i] = _texts[i].copyWith(
                            hasBorder: !sel.hasBorder,
                          );
                        }),
                ),
                _ta(
                  Icons.format_color_fill,
                  'BG',
                  sel == null ? null : () => _showBgColorPicker(sel),
                ),
                _ta(
                  Icons.arrow_back,
                  null,
                  sel == null ? null : () => _moveText(sel, dx: -10),
                ),
                _ta(
                  Icons.arrow_forward,
                  null,
                  sel == null ? null : () => _moveText(sel, dx: 10),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _fb(
                'U',
                sel?.isUnderline ?? false,
                TextDecoration.underline,
                sel == null
                    ? null
                    : () => setState(() {
                        final i = _texts.indexWhere((t) => t.id == sel.id);
                        _texts[i] = _texts[i].copyWith(
                          isUnderline: !sel.isUnderline,
                        );
                      }),
              ),
              _fb(
                'I',
                sel?.isItalic ?? false,
                TextDecoration.none,
                sel == null
                    ? null
                    : () => setState(() {
                        final i = _texts.indexWhere((t) => t.id == sel.id);
                        _texts[i] = _texts[i].copyWith(isItalic: !sel.isItalic);
                      }),
                italic: true,
              ),
              _fb(
                'B',
                sel?.isBold ?? false,
                TextDecoration.none,
                sel == null
                    ? null
                    : () => setState(() {
                        final i = _texts.indexWhere((t) => t.id == sel.id);
                        _texts[i] = _texts[i].copyWith(isBold: !sel.isBold);
                      }),
                bold: true,
              ),
              _sb('T', 18, sel),
              _sb('T', 24, sel),
              IconButton(
                icon: const Icon(Icons.format_align_left, size: 20),
                onPressed: sel == null
                    ? null
                    : () => setState(() {
                        final i = _texts.indexWhere((t) => t.id == sel.id);
                        _texts[i] = _texts[i].copyWith(align: TextAlign.left);
                      }),
              ),
              _ta(Icons.add_circle_outline, 'Add Text', _addText),
            ],
          ),
        ],
      ),
    );
  }

  void _moveText(OverlayTextItem sel, {double dx = 0, double dy = 0}) {
    setState(() {
      final i = _texts.indexWhere((t) => t.id == sel.id);
      if (i != -1)
        _texts[i] = _texts[i].copyWith(position: sel.position + Offset(dx, dy));
    });
  }

  Widget _ta(IconData icon, String? label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.35 : 1,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: Colors.black87),
              if (label != null)
                Text(
                  label,
                  style: const TextStyle(fontSize: 9, color: Colors.black54),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fb(
    String label,
    bool active,
    TextDecoration deco,
    VoidCallback? onTap, {
    bool italic = false,
    bool bold = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active ? Colors.black87 : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: active ? Colors.white : Colors.black87,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              decoration: deco,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sb(String label, double size, OverlayTextItem? sel) {
    final isActive = sel?.fontSize == size;
    return GestureDetector(
      onTap: sel == null
          ? null
          : () => setState(() {
              final i = _texts.indexWhere((t) => t.id == sel.id);
              _texts[i] = _texts[i].copyWith(fontSize: size);
            }),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? Colors.black87 : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: size / 2,
              color: isActive ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showTextThemePicker(OverlayTextItem sel) {
    final themes = [
      {
        'name': 'Default',
        'color': Colors.white,
        'bg': Colors.transparent,
        'bold': false,
        'shadow': false,
      },
      {
        'name': 'Bold White',
        'color': Colors.white,
        'bg': Colors.transparent,
        'bold': true,
        'shadow': true,
      },
      {
        'name': 'Dark',
        'color': Colors.black,
        'bg': Colors.white.withOpacity(0.8),
        'bold': false,
        'shadow': false,
      },
      {
        'name': 'Gold',
        'color': const Color(0xFFD4AF37),
        'bg': Colors.transparent,
        'bold': true,
        'shadow': true,
      },
      {
        'name': 'Neon',
        'color': Colors.greenAccent,
        'bg': Colors.black.withOpacity(0.5),
        'bold': true,
        'shadow': false,
      },
      {
        'name': 'Red Alert',
        'color': Colors.white,
        'bg': Colors.red.shade700,
        'bold': true,
        'shadow': false,
      },
    ];
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Text Theme',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: themes
                  .map(
                    (t) => GestureDetector(
                      onTap: () {
                        setState(() {
                          final i = _texts.indexWhere((x) => x.id == sel.id);
                          if (i != -1)
                            _texts[i] = _texts[i].copyWith(
                              color: t['color'] as Color,
                              backgroundColor: t['bg'] as Color,
                              isBold: t['bold'] as bool,
                              hasShadow: t['shadow'] as bool,
                            );
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: (t['bg'] as Color) == Colors.transparent
                              ? Colors.grey.shade100
                              : t['bg'] as Color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          t['name'] as String,
                          style: TextStyle(
                            color: t['color'] as Color,
                            fontWeight: (t['bold'] as bool)
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showFontPicker(OverlayTextItem sel) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Font Size',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Slider(
              value: sel.fontSize,
              min: 10,
              max: 72,
              divisions: 62,
              activeColor: const Color(0xFFF5C518),
              label: sel.fontSize.toStringAsFixed(0),
              onChanged: (v) {
                setState(() {
                  final i = _texts.indexWhere((t) => t.id == sel.id);
                  if (i != -1) _texts[i] = _texts[i].copyWith(fontSize: v);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(OverlayTextItem sel) {
    final colors = [
      Colors.black,
      Colors.white,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow.shade700,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.brown,
      Colors.grey,
      const Color(0xFFD4AF37),
      Colors.cyan,
      Colors.lime,
      Colors.indigo,
    ];
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Text Colour',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors
                  .map(
                    (c) => GestureDetector(
                      onTap: () {
                        setState(() {
                          final i = _texts.indexWhere((t) => t.id == sel.id);
                          _texts[i] = _texts[i].copyWith(color: c);
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showBgColorPicker(OverlayTextItem sel) {
    final colors = [
      Colors.transparent,
      Colors.black87,
      Colors.white,
      Colors.red.shade700,
      Colors.blue.shade700,
      Colors.green.shade700,
      const Color(0xFFD4AF37),
      Colors.purple.shade700,
    ];
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Background Colour',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors
                  .map(
                    (c) => GestureDetector(
                      onTap: () {
                        setState(() {
                          final i = _texts.indexWhere((t) => t.id == sel.id);
                          _texts[i] = _texts[i].copyWith(backgroundColor: c);
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c == Colors.transparent ? Colors.white : c,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: c == Colors.transparent
                            ? const Center(
                                child: Text(
                                  '∅',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : null,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ── FRAMES PANEL ──────────────────────────

  Widget _buildFramesPanel() {
    return Container(
      height: 140,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                const Text(
                  'Frames — 20 Styles',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _pickImage(forLogo: false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5C518),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 14,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Upload Image',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _frames.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                if (i == 0)
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFrame = -1),
                    child: _frameThumb(
                      'None',
                      Colors.grey.shade400,
                      _selectedFrame == -1,
                      null,
                    ),
                  );
                final f = _frames[i - 1];
                return GestureDetector(
                  onTap: () => setState(() => _selectedFrame = i - 1),
                  child: _frameThumb(
                    f.name,
                    f.borderColor,
                    _selectedFrame == i - 1,
                    f,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _frameThumb(
    String name,
    Color color,
    bool selected,
    FrameStyle? frame,
  ) {
    return Container(
      width: 68,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: selected ? Colors.blueAccent : Colors.grey.shade300,
          width: selected ? 2.5 : 1,
        ),
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey.shade100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: [
            Container(color: Colors.grey.shade200),
            if (frame != null)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: color, width: 3),
                ),
              ),
            if (frame != null)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              ),
            if (frame != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: color.withOpacity(0.85),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 3,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 3, width: 40, color: Colors.white70),
                      const SizedBox(height: 2),
                      Container(height: 2, width: 28, color: Colors.white38),
                    ],
                  ),
                ),
              ),
            Positioned(
              bottom: frame == null ? 4 : null,
              top: frame == null ? null : 66,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.blueAccent : Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── AUDIO PANEL ───────────────────────────

  // Widget _buildAudioPanel() {
  //   return Container(
  //     height: 150,
  //     color: Colors.white,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Padding(
  //           padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
  //           child: Text(
  //             'Audio',
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
  //           ),
  //         ),
  //         Expanded(
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             padding: const EdgeInsets.symmetric(horizontal: 12),
  //             itemCount: _audioTracks.length + 1,
  //             itemBuilder: (_, i) {
  //               if (i == 0)
  //                 return GestureDetector(
  //                   onTap: () => setState(() => _selectedAudio = null),
  //                   child: _audioChip('No Audio', _selectedAudio == null),
  //                 );
  //               final t = _audioTracks[i - 1];
  //               return GestureDetector(
  //                 onTap: () => setState(() => _selectedAudio = t),
  //                 child: _audioChip(t, _selectedAudio == t),
  //               );
  //             },
  //           ),
  //         ),
  //         if (_selectedAudio != null)
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
  //             child: Row(
  //               children: [
  //                 const Icon(Icons.music_note, size: 16, color: Colors.amber),
  //                 const SizedBox(width: 4),
  //                 Text(
  //                   'Playing: $_selectedAudio',
  //                   style: const TextStyle(fontSize: 11, color: Colors.black54),
  //                 ),
  //                 const Spacer(),
  //                 const Icon(Icons.equalizer, size: 18, color: Colors.green),
  //               ],
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAudioPanel() {
    return Container(
      height: 180, // Increased height to accommodate controls
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text(
              'Audio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _audioTracks.length + 1,
              itemBuilder: (_, i) {
                if (i == 0)
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedAudio = null);
                      _playAudio(null);
                    },
                    child: _audioChip('No Audio', _selectedAudio == null),
                  );
                final track = _audioTracks[i - 1];
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedAudio = track.name);
                    _playAudio(track.name);
                  },
                  child: _audioChip(track.name, _selectedAudio == track.name),
                );
              },
            ),
          ),
          if (_selectedAudio != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Icon(
                    _isAudioPlaying ? Icons.volume_up : Icons.volume_off,
                    size: 16,
                    color: _isAudioPlaying ? Colors.green : Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isAudioPlaying
                          ? 'Playing: $_selectedAudio'
                          : 'Selected: $_selectedAudio',
                      style: TextStyle(
                        fontSize: 11,
                        color: _isAudioPlaying ? Colors.green : Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_isAudioPlaying)
                    IconButton(
                      icon: const Icon(Icons.stop, size: 18),
                      onPressed: () async {
                        await _audioPlayer.stop();
                        setState(() {
                          _isAudioPlaying = false;
                        });
                      },
                    ),
                  const Icon(Icons.audiotrack, size: 18, color: Colors.green),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Widget _audioChip(String label, bool selected) {
  //   return Container(
  //     margin: const EdgeInsets.only(right: 10),
  //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: selected ? const Color(0xFFF5C518) : Colors.grey.shade100,
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(
  //         color: selected ? const Color(0xFFF5C518) : Colors.grey.shade300,
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         Icon(
  //           Icons.headphones,
  //           size: 14,
  //           color: selected ? Colors.black87 : Colors.black45,
  //         ),
  //         const SizedBox(width: 4),
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 11,
  //             fontWeight: selected ? FontWeight.bold : FontWeight.normal,
  //             color: selected ? Colors.black87 : Colors.black54,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _audioChip(String label, bool selected) {
    final isPlaying = _isAudioPlaying && _selectedAudio == label;

    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFF5C518) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPlaying
              ? Colors.green
              : (selected ? const Color(0xFFF5C518) : Colors.grey.shade300),
          width: isPlaying ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPlaying ? Icons.play_arrow : Icons.headphones,
            size: 14,
            color: isPlaying
                ? Colors.green
                : (selected ? Colors.black87 : Colors.black45),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: isPlaying
                  ? Colors.green
                  : (selected ? Colors.black87 : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  // ── ANIMATION PANEL ───────────────────────

  Widget _buildAnimationPanel() {
    final animations = [
      _AnimData(AnimationType.none, Icons.block, 'None'),
      _AnimData(AnimationType.fade, Icons.opacity, 'Fade'),
      _AnimData(AnimationType.zoom, Icons.zoom_in, 'Zoom'),
      _AnimData(AnimationType.rotate, Icons.rotate_right, 'Rotate'),
      _AnimData(AnimationType.flipIn, Icons.flip, 'FlipIn'),
      _AnimData(AnimationType.wobble, Icons.vibration, 'Wobble'),
      _AnimData(AnimationType.rollin, Icons.motion_photos_on, 'Roll In'),
      _AnimData(AnimationType.slideLeft, Icons.arrow_back, 'Slide ←'),
      _AnimData(AnimationType.slideRight, Icons.arrow_forward, 'Slide →'),
      _AnimData(AnimationType.slideUp, Icons.arrow_upward, 'Slide ↑'),
      _AnimData(AnimationType.slideDown, Icons.arrow_downward, 'Slide ↓'),
    ];
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text(
              'Animation',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: animations.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final a = animations[i];
                final sel = _selectedAnimation == a.type;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedAnimation = a.type);
                    if (a.type != AnimationType.none) {
                      _animController.repeat(reverse: true);
                      _brandAnimController.repeat();
                    } else {
                      _animController.stop();
                      _animController.reset();
                      _brandAnimController.stop();
                      _brandAnimController.reset();
                    }
                  },
                  child: Container(
                    width: 72,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: sel
                            ? const Color(0xFFF5C518)
                            : Colors.grey.shade200,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: sel
                          ? const Color(0xFFFFFDE7)
                          : Colors.grey.shade50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          a.icon,
                          size: 28,
                          color: sel ? Colors.amber.shade800 : Colors.black54,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          a.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            color: sel ? Colors.amber.shade900 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── BRAND INFO PANEL ──────────────────────

  Widget _buildBrandInfoPanel() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Brand Info',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _pickImage(forLogo: true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5C518),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add_a_photo, size: 14, color: Colors.black87),
                      SizedBox(width: 4),
                      Text(
                        'Upload Logo',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _bInfoRow(
            Icons.account_circle,
            'Name',
            _brandInfo.name,
            () => _editBrandField(
              'Name',
              _brandInfo.name,
              (v) => setState(() => _brandInfo.name = v),
            ),
          ),
          const Divider(height: 12),
          _bInfoRow(
            Icons.phone,
            'Phone',
            _brandInfo.phone,
            () => _editBrandField(
              'Phone',
              _brandInfo.phone,
              (v) => setState(() => _brandInfo.phone = v),
            ),
          ),
          const Divider(height: 12),
          _bInfoRow(
            Icons.location_on,
            'Address',
            _brandInfo.address,
            () => _editBrandField(
              'Address',
              _brandInfo.address,
              (v) => setState(() => _brandInfo.address = v),
            ),
          ),
          const Divider(height: 12),
          Row(
            children: [
              const Icon(Icons.image, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Show Logo', style: TextStyle(fontSize: 13)),
              ),
              Switch(
                value: _brandElements
                    .firstWhere((e) => e.id == 'logo')
                    .isVisible,
                onChanged: (v) {
                  setState(() {
                    final i = _brandElements.indexWhere((e) => e.id == 'logo');
                    if (i != -1)
                      _brandElements[i] = _brandElements[i].copyWith(
                        isVisible: v,
                      );
                  });
                },
                activeColor: const Color(0xFFF5C518),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bInfoRow(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.black45),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.edit, size: 15, color: Colors.black38),
        ],
      ),
    );
  }

  void _editBrandField(
    String label,
    String current,
    ValueChanged<String> onSave,
  ) {
    final ctrl = TextEditingController(text: current);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit $label',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: label,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5C518),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    onSave(ctrl.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── EFFECT PANEL ──────────────────────────

  Widget _buildEffectPanel() {
    final effects = [
      _EffectData(EffectType.none, Icons.block, 'Remove'),
      _EffectData(EffectType.blur, Icons.blur_on, 'Blur'),
      _EffectData(EffectType.grayscale, Icons.filter_b_and_w, 'Grayscale'),
      _EffectData(EffectType.sepia, Icons.filter_vintage, 'Sepia'),
      _EffectData(EffectType.brightness, Icons.brightness_5, 'Bright'),
      _EffectData(EffectType.contrast, Icons.contrast, 'Contrast'),
    ];
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text(
              'Effect',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: effects.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final e = effects[i];
                final sel = _selectedEffect == e.type;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEffect = e.type),
                  child: Container(
                    width: 72,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: sel ? Colors.amber : Colors.grey.shade200,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: sel
                          ? const Color(0xFFFFF8E1)
                          : Colors.grey.shade50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          e.icon,
                          size: 28,
                          color: sel ? Colors.amber.shade700 : Colors.black45,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            color: sel ? Colors.amber.shade800 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedEffect == EffectType.blur)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Text('Strength', style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: Slider(
                      value: _effectStrength,
                      min: 0,
                      max: 1,
                      activeColor: Colors.amber,
                      onChanged: (v) => setState(() => _effectStrength = v),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── BOTTOM TAB BAR ────────────────────────

  Widget _buildBottomTabBar() {
    final tabs = [
      _TabData(BottomTab.text, Icons.text_fields, 'Text'),
      _TabData(BottomTab.frames, Icons.crop_square, 'Frames'),
      _TabData(BottomTab.audio, Icons.volume_up_outlined, 'Audio'),
      _TabData(BottomTab.animation, Icons.animation, 'Animation'),
      _TabData(
        BottomTab.brandInfo,
        Icons.business_center_outlined,
        'Brand Info',
      ),
      _TabData(BottomTab.sticker, Icons.auto_fix_high, 'Effect'),
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: tabs
              .map(
                (t) => GestureDetector(
                  onTap: () => setState(() => _activeTab = t.tab),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _activeTab == t.tab
                              ? const Color(0xFFF5C518)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          t.icon,
                          size: 22,
                          color: _activeTab == t.tab
                              ? const Color(0xFFF5C518)
                              : Colors.black54,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.label,
                          style: TextStyle(
                            fontSize: 9,
                            color: _activeTab == t.tab
                                ? const Color(0xFFF5C518)
                                : Colors.black54,
                            fontWeight: _activeTab == t.tab
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // ── DOWNLOAD DIALOG ───────────────────────

  Widget _buildDownloadDialog() {
    return Positioned.fill(
      child: Container(
        color: Colors.black45,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isAnimated ? 'Exporting Video…' : 'Saving to Gallery…',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _downloadProgress,
                    backgroundColor: Colors.grey.shade200,
                    color: const Color(0xFFF5C518),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(_downloadProgress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      '${(_downloadProgress * 100).toInt()}/100',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── LAYERS SHEET ─────────────────────────

  void _showLayersSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => Container(
          color: Colors.white,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Layers',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.image_outlined,
                  color: Colors.blueGrey,
                ),
                title: const Text('Poster Background'),
                trailing: GestureDetector(
                  onTap: () => _pickImage(forLogo: false),
                  child: const Icon(
                    Icons.swap_horiz,
                    color: Colors.blueAccent,
                    size: 20,
                  ),
                ),
              ),
              ..._brandElements.map(
                (e) => ListTile(
                  leading: Icon(
                    e.type == BrandElementType.logo
                        ? Icons.circle
                        : e.type == BrandElementType.name
                        ? Icons.account_circle
                        : e.type == BrandElementType.phone
                        ? Icons.phone
                        : Icons.location_on,
                    color: Colors.amber,
                  ),
                  title: Text(
                    e.type.name[0].toUpperCase() + e.type.name.substring(1),
                  ),
                  subtitle: Text(
                    e.isVisible ? 'Visible' : 'Hidden',
                    style: TextStyle(
                      fontSize: 11,
                      color: e.isVisible ? Colors.green : Colors.red,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      e.isVisible ? Icons.visibility : Icons.visibility_off,
                      size: 18,
                      color: e.isVisible ? Colors.teal : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        final i = _brandElements.indexWhere(
                          (x) => x.id == e.id,
                        );
                        if (i != -1)
                          _brandElements[i] = _brandElements[i].copyWith(
                            isVisible: !e.isVisible,
                          );
                      });
                      setSheet(() {});
                    },
                  ),
                ),
              ),
              ..._texts.map(
                (t) => ListTile(
                  leading: const Icon(Icons.text_fields, color: Colors.teal),
                  title: Text(
                    t.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() => _texts.removeWhere((x) => x.id == t.id));
                      setSheet(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CUSTOM PAINTERS
// ─────────────────────────────────────────────

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool topLeft, topRight, bottomLeft, bottomRight;
  _CornerPainter({
    required this.color,
    required this.thickness,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    if (topLeft) {
      canvas.drawLine(Offset.zero, Offset(size.width, 0), p);
      canvas.drawLine(Offset.zero, Offset(0, size.height), p);
    }
    if (topRight) {
      canvas.drawLine(Offset(size.width, 0), Offset(0, 0), p);
      canvas.drawLine(
        Offset(size.width, 0),
        Offset(size.width, size.height),
        p,
      );
    }
    if (bottomLeft) {
      canvas.drawLine(
        Offset(0, size.height),
        Offset(size.width, size.height),
        p,
      );
      canvas.drawLine(Offset(0, size.height), Offset.zero, p);
    }
    if (bottomRight) {
      canvas.drawLine(
        Offset(size.width, size.height),
        Offset(0, size.height),
        p,
      );
      canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width, 0),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}

class AudioTrack {
  final String name;
  final String assetPath;

  AudioTrack(this.name, this.assetPath);
}

class _LuxuryCornerPainter extends CustomPainter {
  final Color color;
  _LuxuryCornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(size.width, 0), p);
    canvas.drawLine(Offset.zero, Offset(0, size.height), p);
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.4),
      2.5,
      p..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_LuxuryCornerPainter old) => false;
}

class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_DiagonalClipper old) => false;
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.35);
    final cp1 = Offset(size.width * 0.25, size.height * 0.1);
    final ep1 = Offset(size.width * 0.5, size.height * 0.35);
    final cp2 = Offset(size.width * 0.75, size.height * 0.6);
    final ep2 = Offset(size.width, size.height * 0.35);
    path.cubicTo(cp1.dx, cp1.dy, ep1.dx, ep1.dy, ep1.dx, ep1.dy);
    path.cubicTo(ep1.dx, ep1.dy, cp2.dx, cp2.dy, ep2.dx, ep2.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper old) => false;
}

class _ArchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 1.1,
      size.width,
      size.height * 0.7,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_ArchClipper old) => false;
}

class _ZigzagPainter extends CustomPainter {
  final Color color;
  _ZigzagPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    const step = 14.0;
    final fillPath = Path();
    fillPath.moveTo(0, size.height);
    var x = 0.0;
    var up = true;
    while (x < size.width) {
      x += step;
      fillPath.lineTo(x.clamp(0, size.width), up ? 0 : size.height);
      up = !up;
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(_ZigzagPainter old) => false;
}

// ─────────────────────────────────────────────
//  TEXT EDITOR BOTTOM SHEET
// ─────────────────────────────────────────────

class _TextEditorSheet extends StatefulWidget {
  final OverlayTextItem item;
  final ValueChanged<OverlayTextItem> onChanged;

  const _TextEditorSheet({
    Key? key,
    required this.item,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<_TextEditorSheet> createState() => _TextEditorSheetState();
}

class _TextEditorSheetState extends State<_TextEditorSheet> {
  late TextEditingController _ctrl;
  late OverlayTextItem _current;

  @override
  void initState() {
    super.initState();
    _current = widget.item;
    _ctrl = TextEditingController(text: widget.item.text);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _update(OverlayTextItem updated) {
    setState(() => _current = updated);
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              autofocus: true,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Enter text…',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (v) => _update(_current.copyWith(text: v)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Size', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: _current.fontSize,
                    min: 10,
                    max: 72,
                    divisions: 62,
                    activeColor: const Color(0xFFF5C518),
                    label: _current.fontSize.toStringAsFixed(0),
                    onChanged: (v) => _update(_current.copyWith(fontSize: v)),
                  ),
                ),
                Text(
                  _current.fontSize.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _chip(
                  'B',
                  _current.isBold,
                  () => _update(_current.copyWith(isBold: !_current.isBold)),
                  bold: true,
                ),
                _chip(
                  'I',
                  _current.isItalic,
                  () =>
                      _update(_current.copyWith(isItalic: !_current.isItalic)),
                  italic: true,
                ),
                _chip(
                  'U',
                  _current.isUnderline,
                  () => _update(
                    _current.copyWith(isUnderline: !_current.isUnderline),
                  ),
                  underline: true,
                ),
                _chip(
                  'Shadow',
                  _current.hasShadow,
                  () => _update(
                    _current.copyWith(hasShadow: !_current.hasShadow),
                  ),
                ),
                _chip(
                  'Border',
                  _current.hasBorder,
                  () => _update(
                    _current.copyWith(hasBorder: !_current.hasBorder),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5C518),
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(
    String label,
    bool active,
    VoidCallback onTap, {
    bool bold = false,
    bool italic = false,
    bool underline = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.black87 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: active ? Colors.white : Colors.black87,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            decoration: underline
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HELPER DATA CLASSES
// ─────────────────────────────────────────────

class _TabData {
  final BottomTab tab;
  final IconData icon;
  final String label;
  _TabData(this.tab, this.icon, this.label);
}

class _AnimData {
  final AnimationType type;
  final IconData icon;
  final String label;
  _AnimData(this.type, this.icon, this.label);
}

class _EffectData {
  final EffectType type;
  final IconData icon;
  final String label;
  _EffectData(this.type, this.icon, this.label);
}
