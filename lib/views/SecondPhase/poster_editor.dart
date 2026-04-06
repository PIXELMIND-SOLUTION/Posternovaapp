import 'dart:convert' show json;
import 'dart:math';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/providers/adminamount/admin_amount_provider.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/views/SecondPhase/payment_service.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:file_picker/file_picker.dart';

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

// In your widget state
enum ItemType { poster, video }

ItemType _selectedItemType = ItemType.poster;

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
    this.name = 'NAME',
    this.phone = 'Mobile',
    this.address = '',
    this.logoAsset = '',
  });
}

class UserAudioTrack {
  final String name;
  final String filePath;
  final int durationInSeconds;

  UserAudioTrack({
    required this.name,
    required this.filePath,
    required this.durationInSeconds,
  });
}

// ── OVERLAY BRAND ELEMENT (movable/deletable on canvas) ──
class OverlayBrandItem {
  final String id;
  final BrandElementType type;
  Offset position;
  double fontSize;
  Color color;
  Color backgroundColor;
  bool isVisible;
  bool hasShadow;
  bool hasBorder;
  bool isBold;

  OverlayBrandItem({
    required this.id,
    required this.type,
    required this.position,
    this.fontSize = 14,
    this.color = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.isVisible = true,
    this.hasShadow = true,
    this.hasBorder = false,
    this.isBold = false,
  });

  OverlayBrandItem copyWith({
    Offset? position,
    double? fontSize,
    Color? color,
    Color? backgroundColor,
    bool? isVisible,
    bool? hasShadow,
    bool? hasBorder,
    bool? isBold,
  }) {
    return OverlayBrandItem(
      id: id,
      type: type,
      position: position ?? this.position,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isVisible: isVisible ?? this.isVisible,
      hasShadow: hasShadow ?? this.hasShadow,
      hasBorder: hasBorder ?? this.hasBorder,
      isBold: isBold ?? this.isBold,
    );
  }
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
  final Color? backgroundColor;

  const FrameStyle({
    required this.name,
    required this.borderColor,
    this.headerBg,
    this.footerBg,
    required this.layout,
    this.accentColor = Colors.white,
    this.backgroundColor,
  });
}

// ─────────────────────────────────────────────
//  MAIN SCREEN
// ─────────────────────────────────────────────

class PosterEditorScreen extends StatefulWidget {
  final String posterAsset;
  final String itemid;
  const PosterEditorScreen({
    Key? key,
    required this.posterAsset,
    required this.itemid,
  }) : super(key: key);

  @override
  State<PosterEditorScreen> createState() => _PosterEditorScreenState();
}

class _PosterEditorScreenState extends State<PosterEditorScreen>
    with TickerProviderStateMixin {
  BottomTab _activeTab = BottomTab.text;
  Color _bgColor = const Color(0xFFF5F0E8);
  MyPlanProvider? _planProvider;
  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  List<UserAudioTrack> _userAudioTracks = [];
  String? _selectedUserAudioPath;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAudioPlaying = false;

  final List<OverlayTextItem> _texts = [];
  String? _selectedTextId;

  Offset _frameLogoPosition = const Offset(14, 14);

  // Overlay brand items (movable/deletable on canvas)
  late List<OverlayBrandItem> _overlayBrandItems;
  String? _selectedBrandItemId;

  late BrandInfo _brandInfo;
  late List<BrandElement> _brandElements;

  int _selectedFrame = -1;
  String? _uploadedImagePath;
  String? _uploadedLogoPath;

  EdgeInsets _getFrameInsets() {
    if (_selectedFrame < 0) return EdgeInsets.zero;
    final frame = _frames[_selectedFrame];
    switch (frame.layout) {
      case FrameLayout.classic:
        return const EdgeInsets.fromLTRB(8, 8, 8, 50); // border + footer height
      case FrameLayout.banner:
        return const EdgeInsets.fromLTRB(4, 70, 4, 50); // header + footer
      case FrameLayout.modern:
        return const EdgeInsets.fromLTRB(8, 4, 4, 90); // left strip + card
      case FrameLayout.elegant:
        return const EdgeInsets.fromLTRB(6, 6, 6, 55);
      case FrameLayout.neon:
        return const EdgeInsets.fromLTRB(3, 3, 3, 80);
      case FrameLayout.minimal:
        return const EdgeInsets.fromLTRB(12, 12, 12, 90);
      case FrameLayout.card:
        return const EdgeInsets.fromLTRB(5, 5, 5, 90);
      case FrameLayout.ribbon:
        return const EdgeInsets.fromLTRB(4, 52, 4, 4);
      case FrameLayout.diagonal:
        return const EdgeInsets.fromLTRB(4, 4, 4, 80);
      case FrameLayout.curved:
        return const EdgeInsets.fromLTRB(3, 3, 3, 80);
      case FrameLayout.sideStrip:
        return const EdgeInsets.fromLTRB(4, 4, 52, 4);
      case FrameLayout.split:
        return const EdgeInsets.fromLTRB(4, 4, 4, 30);
      case FrameLayout.badge:
        return const EdgeInsets.fromLTRB(5, 5, 5, 45);
      case FrameLayout.gradient:
        return const EdgeInsets.fromLTRB(3, 3, 3, 60);
      case FrameLayout.zigzag:
        return const EdgeInsets.fromLTRB(4, 14, 4, 35);
      case FrameLayout.shadow:
        return const EdgeInsets.fromLTRB(4, 4, 4, 85);
      case FrameLayout.stripe:
        return const EdgeInsets.fromLTRB(4, 4, 4, 45);
      case FrameLayout.arch:
        return const EdgeInsets.fromLTRB(4, 70, 4, 4);
      case FrameLayout.filmstrip:
        return const EdgeInsets.fromLTRB(22, 4, 22, 60);
      case FrameLayout.luxury:
        return const EdgeInsets.fromLTRB(6, 6, 6, 60);
    }
  }

  // Add this method to process payment
  Future<void> _processPayment() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final userData = await AuthPreferences.getUserData();
      if (userData == null) throw Exception('User not logged in');

      final tempDir = await getTemporaryDirectory();
      String mediaPath;

      // ================= 🎥 VIDEO CASE =================
      if (_isAnimated) {
        final framesDir = Directory(
          '${tempDir.path}/frames_${DateTime.now().millisecondsSinceEpoch}',
        );
        await framesDir.create(recursive: true);

        const int fps = 30;
        const int durationSec = 3;
        final int totalFrames = fps * durationSec;

        print("🎥 Generating $totalFrames frames...");

        final bool wasAnimating = _animController.isAnimating;
        if (wasAnimating) {
          _animController.stop();
          _brandAnimController.stop();
        }

        for (int i = 0; i < totalFrames; i++) {
          // ✅ Proper animation progress
          final double progress = i / totalFrames;

          double animValue;
          switch (_selectedAnimation) {
            case AnimationType.none:
              animValue = 1.0;
              break;
            case AnimationType.rotate:
            case AnimationType.flipIn:
            case AnimationType.wobble:
            case AnimationType.rollin:
              animValue = progress;
              break;
            default:
              animValue = (sin(progress * pi) * 0.5) + 0.5;
          }

          _animController.value = animValue;
          _brandAnimController.value = progress;

          setState(() {});

          // ✅ CRITICAL FIX (UI sync)
          await WidgetsBinding.instance.endOfFrame;
          await Future.delayed(const Duration(milliseconds: 5));

          final boundary =
              _posterKey.currentContext?.findRenderObject()
                  as RenderRepaintBoundary?;

          if (boundary == null) throw Exception("Poster not found");

          final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
          final byteData = await image.toByteData(
            format: ui.ImageByteFormat.png,
          );

          final frameFile = File(
            '${framesDir.path}/frame_${i.toString().padLeft(4, '0')}.png',
          );

          await frameFile.writeAsBytes(byteData!.buffer.asUint8List());
        }

        // ✅ Check frames
        final frames = framesDir.listSync();
        print("📂 Frames generated: ${frames.length}");
        if (frames.isEmpty) throw Exception("No frames generated");

        final outputPath =
            '${tempDir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';

        print("🎬 Running FFmpeg...");

        final command =
            '-y -framerate $fps '
            '-i "${framesDir.path}/frame_%04d.png" '
            '-c:v libx264 -pix_fmt yuv420p '
            '-crf 23 -preset ultrafast '
            '"$outputPath"';

        final session = await FFmpegKit.execute(command);
        final returnCode = await session.getReturnCode();

        if (!ReturnCode.isSuccess(returnCode)) {
          final logs = await session.getAllLogsAsString();
          print("❌ FFmpeg failed");
          print(logs);
          throw Exception("Video generation failed");
        }

        final file = File(outputPath);

        if (!await file.exists() || await file.length() == 0) {
          throw Exception("Generated video is empty");
        }

        mediaPath = outputPath;

        print("✅ VIDEO CREATED: $mediaPath");
        print("VIDEO SIZE: ${await file.length()} bytes");

        if (wasAnimating && mounted) {
          _animController.repeat(reverse: true);
          _brandAnimController.repeat();
        }
      }
      // ================= 🖼️ IMAGE CASE =================
      else {
        final boundary =
            _posterKey.currentContext?.findRenderObject()
                as RenderRepaintBoundary?;

        if (boundary == null) throw Exception("Poster not found");

        final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData == null) throw Exception("Failed to capture image");

        final file = File(
          '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png',
        );

        await file.writeAsBytes(byteData.buffer.asUint8List());

        if (!await file.exists() || await file.length() == 0) {
          throw Exception("Generated image is empty");
        }

        mediaPath = file.path;

        print("🖼️ IMAGE CREATED: $mediaPath");
        print("IMAGE SIZE: ${await file.length()} bytes");
      }

      final mediaFile = File(mediaPath);

      print("========== FINAL FILE ==========");
      print("PATH: $mediaPath");
      print("SIZE: ${await mediaFile.length()} bytes");
      print("================================");

      String itemName = _isAnimated ? 'video' : 'poster';

      final paymentService = PaymentService(
        onSuccess: () {
          Navigator.pop(context);
          _showPaymentSuccess();
        },
        onFailure: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );

      await paymentService.initiatePayment(
        userId: userData.user.id,
        itemName: itemName,
        itemId: widget.itemid,
        amount: _posterPrice.toDouble(),
        mediaFile: mediaFile,
      );

      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);

      print("❌ PROCESS PAYMENT ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You now have full access to download your posters and videos.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Update purchase status
                    _planProvider!.setPurchaseStatus(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
    AudioTrack('Upbeat Pop', 'audio/Aaja Mahiya - Lofi _ Slowed Reverb.mp3'),
    AudioTrack(
      'Calm Acoustic',
      'audio/Bharosa Karlo Tum Sath Nibhaunga - Lofi _ Slowed Reverb.mp3',
    ),
    AudioTrack(
      'Corporate',
      'audio/Jana Mere Sawalo Ka Manzar Tu - Lofi _ Slowed Reverb.mp3',
    ),
    AudioTrack(
      'Cinematic',
      'audio/Mere Ganpati Deva - Lofi _ Slowed Reverb.mp3',
    ),
    AudioTrack(
      'Electronic',
      'audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
    ),
    AudioTrack(
      'Jazz Lounge',
      'audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
    ),
  ];

  bool _isDownloading = false;
  double _downloadProgress = 0;

  Map<String, dynamic>? _profileData;

  final String _baseUrl = 'http://31.97.206.144:4061/api/users';

  final GlobalKey _posterKey = GlobalKey();

  String? _resizingTextId;
  Offset _resizeStartOffset = Offset.zero;
  double _resizeStartFontSize = 24;
  bool _isLoadingProfile = false;
  int _posterPrice = 0; // Default fallback price
  String _posterName = 'Poster';
  String? userId;

  @override
  void initState() {
    super.initState();
    if (_planProvider == null || !_planProvider!.isPurchase) {
      _preventScreenshots();
    }
    _planProvider = Provider.of<MyPlanProvider>(context, listen: false);
    _checkPurchaseStatus();
    _fetchProfileData();
    _fetchPosterPriceFromProvider();

    _brandElements = [
      BrandElement(
        id: 'logo',
        type: BrandElementType.logo,
        position: const Offset(12, 12),
        isVisible: false,
      ),
      BrandElement(
        id: 'name',
        type: BrandElementType.name,
        position: const Offset(12, 290),
        fontSize: 16,
        color: Colors.white,
        isVisible: false,
      ),
      BrandElement(
        id: 'phone',
        type: BrandElementType.phone,
        position: const Offset(12, 312),
        fontSize: 12,
        color: Colors.white70,
        isVisible: false,
      ),
      BrandElement(
        id: 'address',
        type: BrandElementType.address,
        position: const Offset(12, 330),
        fontSize: 10,
        color: Colors.white60,
        isVisible: false,
      ),
    ];

    // Initialize overlay brand items (free-floating, movable/deletable)
    _overlayBrandItems = [
      OverlayBrandItem(
        id: 'ob_logo',
        type: BrandElementType.logo,
        position: const Offset(12, 12),
        isVisible: false,
      ),
      OverlayBrandItem(
        id: 'ob_name',
        type: BrandElementType.name,
        position: const Offset(12, 280),
        fontSize: 16,
        color: Colors.white,
        isBold: true,
        hasShadow: true,
        isVisible: false,
      ),
      OverlayBrandItem(
        id: 'ob_phone',
        type: BrandElementType.phone,
        position: const Offset(12, 305),
        fontSize: 12,
        color: Colors.white70,
        isVisible: false,
      ),
      OverlayBrandItem(
        id: 'ob_address',
        type: BrandElementType.address,
        position: const Offset(12, 325),
        fontSize: 10,
        color: Colors.white60,
        isVisible: false,
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

    _brandInfo = BrandInfo();
    // _loadBrandInfoFromUser();
  }

  void _fetchPosterPriceFromProvider() async {
    final adminProvider = Provider.of<AdminAmountProvider>(
      context,
      listen: false,
    );
    await adminProvider.fetchAdminAmounts();
    // Try to get poster price
    final posterAmount = adminProvider.getAmountByName('Poster');
    if (posterAmount != null) {
      _posterPrice = posterAmount.amount;
      _posterName = posterAmount.name;
    } else {
      // Try to get Business Card or any other as fallback
      final businessCard = adminProvider.getAmountByName('Business Card');
      if (businessCard != null) {
        _posterPrice = businessCard.amount;
        _posterName = businessCard.name;
      }
    }
  }

  Future<void> _pickUserAudio() async {
    try {
      // Pick audio file
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result == null) return;

      String filePath = result.files.single.path!;
      String fileName = result.files.single.name;

      // Get audio duration
      final tempPlayer = AudioPlayer();
      await tempPlayer.setSourceDeviceFile(filePath);
      final duration = await tempPlayer.getDuration();
      await tempPlayer.dispose();

      if (duration == null) {
        _showErrorSnackBar('Could not read audio duration');
        return;
      }

      // Check if duration exceeds 30 seconds
      if (duration.inSeconds > 30) {
        _showErrorSnackBar(
          'Audio too long! Maximum 30 seconds allowed.\n'
          'Selected: ${duration.inSeconds} seconds',
        );
        return;
      }

      // Copy to app directory for persistence
      final tempDir = await getTemporaryDirectory();
      final savedPath =
          '${tempDir.path}/user_audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
      final File sourceFile = File(filePath);
      await sourceFile.copy(savedPath);

      // Add to user audio tracks list
      final userTrack = UserAudioTrack(
        name: fileName,
        filePath: savedPath,
        durationInSeconds: duration.inSeconds,
      );

      setState(() {
        _userAudioTracks.add(userTrack);
        _selectedUserAudioPath = savedPath;
        _selectedAudio = fileName;
      });

      // Play the selected audio
      await _playUserAudio(savedPath, fileName);

      _showSuccessSnackBar(
        'Audio added! Duration: ${duration.inSeconds} seconds',
      );
    } catch (e) {
      print('Error picking audio: $e');
      _showErrorSnackBar('Failed to pick audio: $e');
    }
  }

  Future<void> _playUserAudio(String filePath, String fileName) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);

      await _audioPlayer.play(DeviceFileSource(filePath), volume: 1.0);

      setState(() {
        _isAudioPlaying = true;
        _selectedAudio = fileName;
      });

      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) setState(() => _isAudioPlaying = false);
      });
    } catch (e) {
      setState(() => _isAudioPlaying = false);
      _showErrorSnackBar('Could not play audio: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _preventScreenshots() {
    // For Android and iOS
    if (_planProvider != null && !_planProvider!.isPurchase) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      // This prevents screenshots by setting secure flag
      // Note: This only works on Android and iOS
    }
  }

  // When purchase is successful, you can allow screenshots
  void _allowScreenshots() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _checkPurchaseStatus() async {
    final userData = await AuthPreferences.getUserData();
    if (!mounted) return;
    if (userData != null) {
      setState(() {
        userId = userData.user.id;
      });
    }
    // Fetch user plan if not already loaded
    if (_planProvider != null &&
        _planProvider!.subscribedPlan == null &&
        userId != null) {
      await _planProvider!.fetchMyPlan(userId.toString());
    }
  }

  Future<void> _fetchProfileData() async {
    setState(() => _isLoadingProfile = true);

    try {
      // Try AuthProvider first, fall back to local storage
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String? userId = authProvider.user?.user.id;

      // Fallback to stored data if provider hasn't rehydrated yet
      if (userId == null) {
        final userData = await AuthPreferences.getUserData();
        userId = userData?.user.id;
      }

      if (userId == null) {
        setState(() => _isLoadingProfile = false);
        return;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/get-profile/$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // setState(() {
        //   _profileData = data;
        //   _isLoadingProfile = false;
        // });
        print("llllllllllllllllllllllllllll${data['name']}");
        print("llllllllllllllllllllllllllll${data['mobile']}");

        print("llllllllllllllllllllllllllll${data['profileImage']}");

        setState(() {
          _brandInfo = BrandInfo(
            name: data['name'] ?? _brandInfo.name,
            phone: data['mobile'],
            logoAsset: data['profileImage'] ?? '',
            address:
                _brandInfo.address ??
                _brandInfo.phone, // address not in user data, keep default
          );
        });
      } else {
        // Fallback: use locally stored name
        final userData = await AuthPreferences.getUserData();
        setState(() {
          _profileData = {
            'name': userData?.user.name,
            'mobile': userData?.user.mobile,
          };
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
      // Fallback to stored data on error
      try {
        final userData = await AuthPreferences.getUserData();
        setState(() {
          _profileData = {
            'name': userData?.user.name,
            'mobile': userData?.user.mobile,
          };
          _isLoadingProfile = false;
        });
      } catch (_) {
        setState(() => _isLoadingProfile = false);
      }
    }
  }

  Future<void> _loadBrandInfoFromUser() async {
    try {
      final userData = await AuthPreferences.getUserData();
      if (userData != null && mounted) {
        print("llllllllllllllllllllllll${userData.user.name}");
        print("llllllllllllllllllllllll${userData.user.mobile}");

        print("llllllllllllllllllllllll${userData.user.profileImage}");

        setState(() {
          _brandInfo = BrandInfo(
            name: userData.user.name ?? _brandInfo.name,
            phone: userData.user.mobile ?? _brandInfo.phone,
            logoAsset: userData.user.profileImage ?? '',
            address:
                _brandInfo.address ??
                _brandInfo.phone, // address not in user data, keep default
          );
        });
      }
    } catch (e) {
      print('Could not load user data: $e');
    }
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

    // Clean up user audio files
    for (var track in _userAudioTracks) {
      try {
        File(track.filePath).deleteSync();
      } catch (e) {
        print('Error deleting audio file: $e');
      }
    }
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

  // Future<void> _playAudio(String? trackName) async {
  //   try {
  //     await _audioPlayer.stop();
  //     await _audioPlayer.setReleaseMode(ReleaseMode.stop);
  //     if (trackName == null || trackName == 'No Audio') {
  //       setState(() {
  //         _isAudioPlaying = false;
  //         _selectedAudio = null;
  //       });
  //       return;
  //     }
  //     final selectedTrack = _audioTracks.firstWhere(
  //       (track) => track.name == trackName,
  //     );
  //     try {
  //       await _audioPlayer.play(
  //         AssetSource(selectedTrack.assetPath),
  //         volume: 1.0,
  //       );
  //       setState(() {
  //         _isAudioPlaying = true;
  //         _selectedAudio = trackName;
  //       });
  //       _audioPlayer.onPlayerComplete.listen((event) {
  //         if (mounted) setState(() => _isAudioPlaying = false);
  //       });
  //     } catch (e) {
  //       setState(() => _isAudioPlaying = false);
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Could not play audio file.'),
  //             backgroundColor: Colors.orange,
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     setState(() => _isAudioPlaying = false);
  //   }
  // }

  Future<void> _playAudio(String? trackName) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);

      if (trackName == null || trackName == 'No Audio') {
        setState(() {
          _isAudioPlaying = false;
          _selectedAudio = null;
          _selectedUserAudioPath = null;
        });
        return;
      }

      // Check if it's a user uploaded audio
      final userTrack = _userAudioTracks.firstWhere(
        (track) => track.name == trackName,
        orElse: () =>
            UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
      );

      if (userTrack.filePath.isNotEmpty &&
          await File(userTrack.filePath).exists()) {
        // Play user uploaded audio
        await _audioPlayer.play(
          DeviceFileSource(userTrack.filePath),
          volume: 1.0,
        );
        setState(() {
          _isAudioPlaying = true;
          _selectedAudio = trackName;
          _selectedUserAudioPath = userTrack.filePath;
        });
      } else {
        // Play static asset audio
        final selectedTrack = _audioTracks.firstWhere(
          (track) => track.name == trackName,
        );
        await _audioPlayer.play(
          AssetSource(selectedTrack.assetPath),
          volume: 1.0,
        );
        setState(() {
          _isAudioPlaying = true;
          _selectedAudio = trackName;
          _selectedUserAudioPath = null;
        });
      }

      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) setState(() => _isAudioPlaying = false);
      });
    } catch (e) {
      setState(() => _isAudioPlaying = false);
      _showErrorSnackBar('Could not play audio: $e');
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

  // ── DOWNLOAD ─────────────────────────────

  // void _startDownload() async {
  //   setState(() {
  //     _isDownloading = true;
  //     _downloadProgress = 0;
  //   });

  //   try {
  //     if (_isAnimated) {
  //       setState(() => _downloadProgress = 0.05);
  //       final tempDir = await getTemporaryDirectory();
  //       final framesDir = Directory(
  //         '${tempDir.path}/poster_frames_${DateTime.now().millisecondsSinceEpoch}',
  //       );
  //       await framesDir.create(recursive: true);

  //       const int totalFrames = 90;
  //       const int fps = 30;
  //       const int animationDurationMs = 3000;
  //       final bool wasAnimating = _animController.isAnimating;
  //       if (wasAnimating) {
  //         _animController.stop();
  //         _brandAnimController.stop();
  //       }
  //       const int frameDelayMs = animationDurationMs ~/ totalFrames;

  //       for (int i = 0; i < totalFrames; i++) {
  //         final DateTime frameStartTime = DateTime.now();
  //         final double progress = i / (totalFrames - 1);
  //         double animValue;
  //         switch (_selectedAnimation) {
  //           case AnimationType.none:
  //             animValue = 1.0;
  //             break;
  //           case AnimationType.rotate:
  //           case AnimationType.flipIn:
  //           case AnimationType.wobble:
  //           case AnimationType.rollin:
  //             animValue = progress;
  //             break;
  //           default:
  //             animValue = (sin(progress * pi) * 0.5) + 0.5;
  //         }
  //         _animController.value = animValue;
  //         _brandAnimController.value = progress;
  //         setState(() {});
  //         await WidgetsBinding.instance.endOfFrame;
  //         await Future.delayed(const Duration(milliseconds: 5));

  //         final RenderRepaintBoundary? boundary =
  //             _posterKey.currentContext?.findRenderObject()
  //                 as RenderRepaintBoundary?;
  //         if (boundary == null) throw Exception('Poster context not found');
  //         final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
  //         final ByteData? byteData = await image.toByteData(
  //           format: ui.ImageByteFormat.png,
  //         );
  //         if (byteData == null) throw Exception('Frame $i encoding failed');
  //         final File frameFile = File(
  //           '${framesDir.path}/frame_${i.toString().padLeft(4, '0')}.png',
  //         );
  //         await frameFile.writeAsBytes(byteData.buffer.asUint8List());

  //         final int elapsedMs = DateTime.now()
  //             .difference(frameStartTime)
  //             .inMilliseconds;
  //         final int remainingDelay = frameDelayMs - elapsedMs;
  //         if (remainingDelay > 0) {
  //           await Future.delayed(Duration(milliseconds: remainingDelay));
  //         }
  //         setState(() => _downloadProgress = 0.05 + (i / totalFrames) * 0.55);
  //       }

  //       setState(() => _downloadProgress = 0.62);
  //       String? audioFilePath;
  //       if (_selectedAudio != null && _selectedAudio != 'No Audio') {
  //         try {
  //           const Map<String, String> audioAssets = {
  //             'Upbeat Pop':
  //                 'assets/audio/Aaja Mahiya - Lofi _ Slowed Reverb.mp3',
  //             'Calm Acoustic':
  //                 'assets/audio/Bharosa Karlo Tum Sath Nibhaunga - Lofi _ Slowed Reverb.mp3',
  //             'Corporate':
  //                 'assets/audio/Jana Mere Sawalo Ka Manzar Tu - Lofi _ Slowed Reverb.mp3',
  //             'Cinematic':
  //                 'assets/audio/Mere Ganpati Deva - Lofi _ Slowed Reverb.mp3',
  //             'Electronic':
  //                 'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //             'Jazz Lounge':
  //                 'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //           };
  //           final String? assetPath = audioAssets[_selectedAudio];
  //           if (assetPath != null) {
  //             final ByteData audioData = await rootBundle.load(assetPath);
  //             final File tempAudioFile = File('${tempDir.path}/temp_audio.mp3');
  //             await tempAudioFile.writeAsBytes(audioData.buffer.asUint8List());
  //             audioFilePath = tempAudioFile.path;
  //           }
  //         } catch (e) {
  //           print('Error loading audio: $e');
  //         }
  //       }

  //       final String outputPath =
  //           '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.mp4';
  //       String ffmpegCommand;
  //       if (audioFilePath != null && File(audioFilePath).existsSync()) {
  //         ffmpegCommand =
  //             '-y -framerate $fps -i ${framesDir.path}/frame_%04d.png '
  //             '-i "$audioFilePath" '
  //             '-c:v libx264 -pix_fmt yuv420p -c:a aac -shortest '
  //             '-crf 23 -preset fast '
  //             '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
  //             '"$outputPath"';
  //       } else {
  //         ffmpegCommand =
  //             '-y -framerate $fps -i ${framesDir.path}/frame_%04d.png '
  //             '-c:v libx264 -pix_fmt yuv420p '
  //             '-crf 23 -preset fast '
  //             '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
  //             '"$outputPath"';
  //       }

  //       setState(() => _downloadProgress = 0.65);
  //       final ffmpegSession = await FFmpegKit.execute(ffmpegCommand);
  //       final ReturnCode? returnCode = await ffmpegSession.getReturnCode();
  //       setState(() => _downloadProgress = 0.88);
  //       if (!ReturnCode.isSuccess(returnCode)) {
  //         throw Exception('FFmpeg failed to create video');
  //       }

  //       final bool hasAccess = await Gal.hasAccess();
  //       if (!hasAccess) await Gal.requestAccess();
  //       await Gal.putVideo(outputPath, album: 'Poster Editor');
  //       setState(() => _downloadProgress = 1.0);

  //       try {
  //         await framesDir.delete(recursive: true);
  //         if (audioFilePath != null) File(audioFilePath).deleteSync();
  //       } catch (e) {}

  //       if (wasAnimating && mounted) {
  //         _animController.repeat(reverse: true);
  //         _brandAnimController.repeat();
  //       }

  //       await Future.delayed(const Duration(milliseconds: 400));
  //       if (mounted) {
  //         setState(() => _isDownloading = false);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(
  //               audioFilePath != null
  //                   ? '✅ Video with audio saved to gallery!'
  //                   : '✅ Video saved to gallery!',
  //             ),
  //             backgroundColor: const Color(0xFF2E7D32),
  //             duration: const Duration(seconds: 3),
  //           ),
  //         );
  //       }
  //     } else {
  //       setState(() => _downloadProgress = 0.2);
  //       await Future.delayed(const Duration(milliseconds: 300));
  //       final RenderRepaintBoundary? boundary =
  //           _posterKey.currentContext?.findRenderObject()
  //               as RenderRepaintBoundary?;
  //       if (boundary == null)
  //         throw Exception('Poster not found. Please try again.');

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
  //       final Directory tempDir = await getTemporaryDirectory();
  //       final String fileName =
  //           'poster_${DateTime.now().millisecondsSinceEpoch}.png';
  //       final File file = File('${tempDir.path}/$fileName');
  //       await file.writeAsBytes(pngBytes);
  //       setState(() => _downloadProgress = 0.92);

  //       final bool hasAccess = await Gal.hasAccess();
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
  //             duration: Duration(seconds: 3),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e, stackTrace) {
  //     print('Download error: $e\n$stackTrace');
  //     if (mounted) {
  //       setState(() => _isDownloading = false);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Download failed: ${e.toString()}'),
  //           backgroundColor: Colors.red,
  //           duration: const Duration(seconds: 4),
  //         ),
  //       );
  //     }
  //   }
  // }

  void _showPremiumModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFAF5FF), Color(0xFFEEF2FF)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Unlock Download',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Premium Access',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '₹$_posterPrice',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Maybe Later',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showPaymentDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Pay ₹$_posterPrice',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.payment_rounded,
                  color: Color(0xFF10B981),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Complete Payment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pay ₹$_posterPrice to download',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context); // Close dialog
                    await _processPayment();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _startDownload() async {
  //   print("gggggggggggggggggggggggg${_planProvider?.isPurchase}");
  //   if (!_planProvider!.isPurchase) {
  //     _showPremiumModal();
  //     return;
  //   }
  //   setState(() {
  //     _isDownloading = true;
  //     _downloadProgress = 0;
  //   });

  //   try {
  //     if (_isAnimated) {
  //       setState(() => _downloadProgress = 0.05);

  //       // ── tempDir at top ──
  //       final tempDir = await getTemporaryDirectory();

  //       final framesDir = Directory(
  //         '${tempDir.path}/poster_frames_${DateTime.now().millisecondsSinceEpoch}',
  //       );
  //       await framesDir.create(recursive: true);

  //       // ── Get audio duration first ──
  //       int videoDurationSec = 3;

  //       if (_selectedAudio != null && _selectedAudio != 'No Audio') {
  //         try {
  //           const Map<String, String> audioAssets = {
  //             'Upbeat Pop':
  //                 'assets/audio/Aaja Mahiya - Lofi _ Slowed Reverb.mp3',
  //             'Calm Acoustic':
  //                 'assets/audio/Bharosa Karlo Tum Sath Nibhaunga - Lofi _ Slowed Reverb.mp3',
  //             'Corporate':
  //                 'assets/audio/Jana Mere Sawalo Ka Manzar Tu - Lofi _ Slowed Reverb.mp3',
  //             'Cinematic':
  //                 'assets/audio/Mere Ganpati Deva - Lofi _ Slowed Reverb.mp3',
  //             'Electronic':
  //                 'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //             'Jazz Lounge':
  //                 'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //           };
  //           final String? assetPath = audioAssets[_selectedAudio];
  //           if (assetPath != null) {
  //             final ByteData audioData = await rootBundle.load(assetPath);
  //             final File tempAudioProbe = File(
  //               '${tempDir.path}/temp_audio_probe.mp3',
  //             );
  //             await tempAudioProbe.writeAsBytes(audioData.buffer.asUint8List());

  //             final probe = AudioPlayer();
  //             await probe.setSourceDeviceFile(tempAudioProbe.path);
  //             final duration = await probe.getDuration();
  //             await probe.dispose();

  //             if (duration != null && duration.inSeconds > 0) {
  //               videoDurationSec = duration.inSeconds;
  //             }
  //           }
  //         } catch (e) {
  //           print('Could not get audio duration: $e');
  //         }
  //       }

  //       const int fps = 30;
  //       final int totalFrames = videoDurationSec * fps;
  //       final int animationDurationMs = videoDurationSec * 1000;

  //       final bool wasAnimating = _animController.isAnimating;
  //       if (wasAnimating) {
  //         _animController.stop();
  //         _brandAnimController.stop();
  //       }

  //       final int frameDelayMs = animationDurationMs ~/ totalFrames;

  //       for (int i = 0; i < totalFrames; i++) {
  //         final DateTime frameStartTime = DateTime.now();
  //         final double progress =
  //             (i % fps) / fps; // loops animation every second

  //         double animValue;
  //         switch (_selectedAnimation) {
  //           case AnimationType.none:
  //             animValue = 1.0;
  //             break;
  //           case AnimationType.rotate:
  //           case AnimationType.flipIn:
  //           case AnimationType.wobble:
  //           case AnimationType.rollin:
  //             animValue = progress;
  //             break;
  //           default:
  //             animValue = (sin(progress * pi) * 0.5) + 0.5;
  //         }
  //         _animController.value = animValue;
  //         _brandAnimController.value = progress;
  //         setState(() {});
  //         await WidgetsBinding.instance.endOfFrame;
  //         await Future.delayed(const Duration(milliseconds: 5));

  //         final RenderRepaintBoundary? boundary =
  //             _posterKey.currentContext?.findRenderObject()
  //                 as RenderRepaintBoundary?;
  //         if (boundary == null) throw Exception('Poster context not found');
  //         final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
  //         final ByteData? byteData = await image.toByteData(
  //           format: ui.ImageByteFormat.png,
  //         );
  //         if (byteData == null) throw Exception('Frame $i encoding failed');
  //         final File frameFile = File(
  //           '${framesDir.path}/frame_${i.toString().padLeft(4, '0')}.png',
  //         );
  //         await frameFile.writeAsBytes(byteData.buffer.asUint8List());

  //         final int elapsedMs = DateTime.now()
  //             .difference(frameStartTime)
  //             .inMilliseconds;
  //         final int remainingDelay = frameDelayMs - elapsedMs;
  //         if (remainingDelay > 0) {
  //           await Future.delayed(Duration(milliseconds: remainingDelay));
  //         }
  //         setState(() => _downloadProgress = 0.05 + (i / totalFrames) * 0.55);
  //       }

  //       setState(() => _downloadProgress = 0.62);
  //       String? audioFilePath;
  //       if (_selectedAudio != null && _selectedAudio != 'No Audio') {
  //         try {
  //           const Map<String, String> audioAssets = {
  //             'Upbeat Pop':
  //                 'assets/audio/Aaja Mahiya - Lofi _ Slowed Reverb.mp3',
  //             'Calm Acoustic':
  //                 'assets/audio/Bharosa Karlo Tum Sath Nibhaunga - Lofi _ Slowed Reverb.mp3',
  //             'Corporate':
  //                 'assets/audio/Jana Mere Sawalo Ka Manzar Tu - Lofi _ Slowed Reverb.mp3',
  //             'Cinematic':
  //                 'assets/audio/Mere Ganpati Deva - Lofi _ Slowed Reverb.mp3',
  //             'Electronic':
  //                 'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //             'Jazz Lounge':
  //                 'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //           };
  //           final String? assetPath = audioAssets[_selectedAudio];
  //           if (assetPath != null) {
  //             final ByteData audioData = await rootBundle.load(assetPath);
  //             final File tempAudioFile = File('${tempDir.path}/temp_audio.mp3');
  //             await tempAudioFile.writeAsBytes(audioData.buffer.asUint8List());
  //             audioFilePath = tempAudioFile.path;
  //           }
  //         } catch (e) {
  //           print('Error loading audio: $e');
  //         }
  //       }

  //       final String outputPath =
  //           '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.mp4';
  //       String ffmpegCommand;
  //       if (audioFilePath != null && File(audioFilePath).existsSync()) {
  //         ffmpegCommand =
  //             '-y -framerate $fps -i ${framesDir.path}/frame_%04d.png '
  //             '-i "$audioFilePath" '
  //             '-c:v libx264 -pix_fmt yuv420p -c:a aac -shortest '
  //             '-crf 23 -preset fast '
  //             '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
  //             '"$outputPath"';
  //       } else {
  //         ffmpegCommand =
  //             '-y -framerate $fps -i ${framesDir.path}/frame_%04d.png '
  //             '-c:v libx264 -pix_fmt yuv420p '
  //             '-crf 23 -preset fast '
  //             '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
  //             '"$outputPath"';
  //       }

  //       setState(() => _downloadProgress = 0.65);
  //       final ffmpegSession = await FFmpegKit.execute(ffmpegCommand);
  //       final ReturnCode? returnCode = await ffmpegSession.getReturnCode();
  //       setState(() => _downloadProgress = 0.88);
  //       if (!ReturnCode.isSuccess(returnCode)) {
  //         throw Exception('FFmpeg failed to create video');
  //       }

  //       final bool hasAccess = await Gal.hasAccess();
  //       if (!hasAccess) await Gal.requestAccess();
  //       await Gal.putVideo(outputPath, album: 'Poster Editor');
  //       setState(() => _downloadProgress = 1.0);

  //       try {
  //         await framesDir.delete(recursive: true);
  //         if (audioFilePath != null) File(audioFilePath).deleteSync();
  //       } catch (e) {}

  //       if (wasAnimating && mounted) {
  //         _animController.repeat(reverse: true);
  //         _brandAnimController.repeat();
  //       }

  //       await Future.delayed(const Duration(milliseconds: 400));
  //       if (mounted) {
  //         setState(() => _isDownloading = false);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(
  //               audioFilePath != null
  //                   ? '✅ Video with audio saved to gallery!'
  //                   : '✅ Video saved to gallery!',
  //             ),
  //             backgroundColor: const Color(0xFF2E7D32),
  //             duration: const Duration(seconds: 3),
  //           ),
  //         );
  //       }
  //     } else {
  //       // ── Static image download ──
  //       setState(() => _downloadProgress = 0.2);
  //       await Future.delayed(const Duration(milliseconds: 300));
  //       final RenderRepaintBoundary? boundary =
  //           _posterKey.currentContext?.findRenderObject()
  //               as RenderRepaintBoundary?;
  //       if (boundary == null)
  //         throw Exception('Poster not found. Please try again.');

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
  //       final Directory tempDir = await getTemporaryDirectory();
  //       final String fileName =
  //           'poster_${DateTime.now().millisecondsSinceEpoch}.png';
  //       final File file = File('${tempDir.path}/$fileName');
  //       await file.writeAsBytes(pngBytes);
  //       setState(() => _downloadProgress = 0.92);

  //       final bool hasAccess = await Gal.hasAccess();
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
  //             duration: Duration(seconds: 3),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e, stackTrace) {
  //     print('Download error: $e\n$stackTrace');
  //     if (mounted) {
  //       setState(() => _isDownloading = false);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Download failed: ${e.toString()}'),
  //           backgroundColor: Colors.red,
  //           duration: const Duration(seconds: 4),
  //         ),
  //       );
  //     }
  //   }
  // }

  void _startDownload() async {
    print("gggggggggggggggggggggggg${_planProvider?.isPurchase}");
    if (!_planProvider!.isPurchase) {
      _showPremiumModal();
      return;
    }
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      if (_isAnimated) {
        setState(() => _downloadProgress = 0.05);

        // ── tempDir at top ──
        final tempDir = await getTemporaryDirectory();

        final framesDir = Directory(
          '${tempDir.path}/poster_frames_${DateTime.now().millisecondsSinceEpoch}',
        );
        await framesDir.create(recursive: true);

        // ── Get audio duration first ──
        int videoDurationSec = 3;

        if (_selectedAudio != null && _selectedAudio != 'No Audio') {
          try {
            // Check for user audio first
            final userTrack = _userAudioTracks.firstWhere(
              (track) => track.name == _selectedAudio,
              orElse: () =>
                  UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
            );

            Duration? duration;

            if (userTrack.filePath.isNotEmpty &&
                await File(userTrack.filePath).exists()) {
              // User audio file
              final probe = AudioPlayer();
              await probe.setSourceDeviceFile(userTrack.filePath);
              duration = await probe.getDuration();
              await probe.dispose();
              print('User audio duration: ${duration?.inSeconds} seconds');
            } else {
              // Static audio asset
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
                final ByteData audioData = await rootBundle.load(assetPath);
                final File tempAudioProbe = File(
                  '${tempDir.path}/temp_audio_probe_${DateTime.now().millisecondsSinceEpoch}.mp3',
                );
                await tempAudioProbe.writeAsBytes(
                  audioData.buffer.asUint8List(),
                );

                final probe = AudioPlayer();
                await probe.setSourceDeviceFile(tempAudioProbe.path);
                duration = await probe.getDuration();
                await probe.dispose();

                // Clean up temp file
                try {
                  await tempAudioProbe.delete();
                } catch (e) {}
              }
            }

            if (duration != null && duration.inSeconds > 0) {
              videoDurationSec = duration.inSeconds;
              print('Using audio duration: $videoDurationSec seconds');
            }
          } catch (e) {
            print('Could not get audio duration: $e');
          }
        }

        const int fps = 30;
        final int totalFrames = videoDurationSec * fps;
        final int animationDurationMs = videoDurationSec * 1000;

        final bool wasAnimating = _animController.isAnimating;
        if (wasAnimating) {
          _animController.stop();
          _brandAnimController.stop();
        }

        final int frameDelayMs = animationDurationMs ~/ totalFrames;

        for (int i = 0; i < totalFrames; i++) {
          final DateTime frameStartTime = DateTime.now();
          final double progress =
              (i % fps) / fps; // loops animation every second

          double animValue;
          switch (_selectedAnimation) {
            case AnimationType.none:
              animValue = 1.0;
              break;
            case AnimationType.rotate:
            case AnimationType.flipIn:
            case AnimationType.wobble:
            case AnimationType.rollin:
              animValue = progress;
              break;
            default:
              animValue = (sin(progress * pi) * 0.5) + 0.5;
          }
          _animController.value = animValue;
          _brandAnimController.value = progress;
          setState(() {});
          await WidgetsBinding.instance.endOfFrame;
          await Future.delayed(const Duration(milliseconds: 5));

          final RenderRepaintBoundary? boundary =
              _posterKey.currentContext?.findRenderObject()
                  as RenderRepaintBoundary?;
          if (boundary == null) throw Exception('Poster context not found');
          final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
          final ByteData? byteData = await image.toByteData(
            format: ui.ImageByteFormat.png,
          );
          if (byteData == null) throw Exception('Frame $i encoding failed');
          final File frameFile = File(
            '${framesDir.path}/frame_${i.toString().padLeft(4, '0')}.png',
          );
          await frameFile.writeAsBytes(byteData.buffer.asUint8List());

          final int elapsedMs = DateTime.now()
              .difference(frameStartTime)
              .inMilliseconds;
          final int remainingDelay = frameDelayMs - elapsedMs;
          if (remainingDelay > 0) {
            await Future.delayed(Duration(milliseconds: remainingDelay));
          }
          setState(() => _downloadProgress = 0.05 + (i / totalFrames) * 0.55);
        }

        setState(() => _downloadProgress = 0.62);
        String? audioFilePath;

        if (_selectedAudio != null && _selectedAudio != 'No Audio') {
          try {
            // First, check if it's a user-uploaded audio
            final userTrack = _userAudioTracks.firstWhere(
              (track) => track.name == _selectedAudio,
              orElse: () =>
                  UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
            );

            if (userTrack.filePath.isNotEmpty &&
                await File(userTrack.filePath).exists()) {
              // This is a user-uploaded audio file - copy it to temp directory
              final File sourceFile = File(userTrack.filePath);
              final File tempAudioFile = File(
                '${tempDir.path}/temp_user_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
              );
              await sourceFile.copy(tempAudioFile.path);
              audioFilePath = tempAudioFile.path;
              print('Using user audio file: ${userTrack.name}');
            } else {
              // Check static audio assets
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
                final ByteData audioData = await rootBundle.load(assetPath);
                final File tempAudioFile = File(
                  '${tempDir.path}/temp_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
                );
                await tempAudioFile.writeAsBytes(
                  audioData.buffer.asUint8List(),
                );
                audioFilePath = tempAudioFile.path;
                print('Using static audio file: $_selectedAudio');
              }
            }
          } catch (e) {
            print('Error loading audio for video: $e');
          }
        }

        final String outputPath =
            '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.mp4';
        String ffmpegCommand;

        if (audioFilePath != null && await File(audioFilePath).exists()) {
          ffmpegCommand =
              '-y -framerate $fps -i ${framesDir.path}/frame_%04d.png '
              '-i "$audioFilePath" '
              '-c:v libx264 -pix_fmt yuv420p -c:a aac -shortest '
              '-crf 23 -preset fast '
              '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
              '"$outputPath"';
        } else {
          ffmpegCommand =
              '-y -framerate $fps -i ${framesDir.path}/frame_%04d.png '
              '-c:v libx264 -pix_fmt yuv420p '
              '-crf 23 -preset fast '
              '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
              '"$outputPath"';
        }

        setState(() => _downloadProgress = 0.65);
        final ffmpegSession = await FFmpegKit.execute(ffmpegCommand);
        final ReturnCode? returnCode = await ffmpegSession.getReturnCode();
        setState(() => _downloadProgress = 0.88);

        if (!ReturnCode.isSuccess(returnCode)) {
          throw Exception('FFmpeg failed to create video');
        }

        final bool hasAccess = await Gal.hasAccess();
        if (!hasAccess) await Gal.requestAccess();
        await Gal.putVideo(outputPath, album: 'Poster Editor');
        setState(() => _downloadProgress = 1.0);

        try {
          await framesDir.delete(recursive: true);
          if (audioFilePath != null) {
            final audioFile = File(audioFilePath);
            if (await audioFile.exists()) {
              await audioFile.delete();
            }
          }
        } catch (e) {}

        if (wasAnimating && mounted) {
          _animController.repeat(reverse: true);
          _brandAnimController.repeat();
        }

        await Future.delayed(const Duration(milliseconds: 400));
        if (mounted) {
          setState(() => _isDownloading = false);
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
        // ── Static image download ──
        setState(() => _downloadProgress = 0.2);
        await Future.delayed(const Duration(milliseconds: 300));

        final RenderRepaintBoundary? boundary =
            _posterKey.currentContext?.findRenderObject()
                as RenderRepaintBoundary?;
        if (boundary == null)
          throw Exception('Poster not found. Please try again.');

        setState(() => _downloadProgress = 0.4);
        await Future.delayed(const Duration(milliseconds: 100));

        final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        setState(() => _downloadProgress = 0.65);
        final ByteData? byteData = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );
        if (byteData == null) throw Exception('Failed to encode image');
        setState(() => _downloadProgress = 0.8);

        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final Directory tempDir = await getTemporaryDirectory();
        final String fileName =
            'poster_${DateTime.now().millisecondsSinceEpoch}.png';
        final File file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(pngBytes);
        setState(() => _downloadProgress = 0.92);

        final bool hasAccess = await Gal.hasAccess();
        if (!hasAccess) await Gal.requestAccess();
        await Gal.putImage(file.path, album: 'Poster Editor');
        setState(() => _downloadProgress = 1.0);

        await Future.delayed(const Duration(milliseconds: 400));
        if (mounted) {
          setState(() => _isDownloading = false);
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
      print('Download error: $e\n$stackTrace');
      if (mounted) {
        setState(() => _isDownloading = false);
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
    final isDarkMode = _isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0F172A)
          : const Color(0xFFF0F0F0),
      body: Stack(
        children: [
          Column(
            children: [
              _buildTopBar(),
              Expanded(child: _buildPosterArea()),
              // _buildColorRow(),
              _buildBottomPanel(),
              _buildBottomTabBar(),
            ],
          ),
          if (_isDownloading) _buildDownloadDialog(),
        ],
      ),
    );
  }

  // Widget _buildTopBar() {
  //   return Container(
  //     color: const Color(0xFFF5C518),
  //     padding: EdgeInsets.only(
  //       top: MediaQuery.of(context).padding.top + 4,
  //       left: 8,
  //       right: 8,
  //       bottom: 8,
  //     ),
  //     child: Row(
  //       children: [
  //         IconButton(
  //           icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 22),
  //           onPressed: () => Navigator.maybePop(context),
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.layers, color: Colors.black87, size: 22),
  //           onPressed: _showLayersSheet,
  //         ),
  //         IconButton(
  //           icon: const Icon(
  //             Icons.add_photo_alternate,
  //             color: Colors.black87,
  //             size: 22,
  //           ),
  //           tooltip: 'Upload Background',
  //           onPressed: () => _pickImage(forLogo: false),
  //         ),
  //         if (_isAnimated)
  //           IconButton(
  //             icon: Icon(
  //               _animController.isAnimating
  //                   ? Icons.pause_circle_outline
  //                   : Icons.play_circle_outline,
  //               color: Colors.black87,
  //               size: 22,
  //             ),
  //             onPressed: () {
  //               setState(() {
  //                 if (_animController.isAnimating) {
  //                   _animController.stop();
  //                   _brandAnimController.stop();
  //                 } else {
  //                   _animController.repeat(reverse: true);
  //                   _brandAnimController.repeat();
  //                 }
  //               });
  //             },
  //           ),
  //         const Spacer(),
  //         GestureDetector(
  //           onTap: _startDownload,
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             decoration: BoxDecoration(
  //               color: Colors.black87,
  //               borderRadius: BorderRadius.circular(6),
  //             ),
  //             child: Row(
  //               children: [
  //                 Icon(
  //                   _isAnimated ? Icons.videocam : Icons.download,
  //                   color: Colors.white,
  //                   size: 18,
  //                 ),
  //                 const SizedBox(width: 6),
  //                 Text(
  //                   _isAnimated ? 'Export MP4' : 'Download',
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 14,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTopBar() {
    final isDarkMode = _isDarkMode;

    return Container(
      color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF5C518),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        left: 8,
        right: 8,
        bottom: 8,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black87,
              size: 22,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          IconButton(
            icon: Icon(
              Icons.layers,
              color: isDarkMode ? Colors.white : Colors.black87,
              size: 22,
            ),
            onPressed: _showLayersSheet,
          ),
          IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              color: isDarkMode ? Colors.white : Colors.black87,
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
                color: isDarkMode ? Colors.white : Colors.black87,
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
                color: isDarkMode ? Colors.white : Colors.black87,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    _isAnimated ? Icons.videocam : Icons.download,
                    color: isDarkMode ? Colors.black87 : Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isAnimated ? 'Export MP4' : 'Download',
                    style: TextStyle(
                      color: isDarkMode ? Colors.black87 : Colors.white,
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
      onTap: () => setState(() {
        _selectedTextId = null;
        _selectedBrandItemId = null;
      }),
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
                    // ── Frame renders FIRST (behind everything) ──
                    if (_selectedFrame >= 0)
                      Positioned.fill(
                        child: _buildFrameLayout(
                          _frames[_selectedFrame],
                          showLogo: false,
                        ),
                      ),

                    // ── Image sits INSIDE the frame insets ──
                    Positioned.fill(
                      child: Padding(
                        padding: _getFrameInsets(),
                        child: ClipRect(child: _buildPosterBackground()),
                      ),
                    ),

                    // ── Frame logo (draggable) on top of image ──
                    if (_selectedFrame >= 0)
                      Positioned(
                        left: _frameLogoPosition.dx,
                        top: _frameLogoPosition.dy,
                        child: GestureDetector(
                          onTap: () => _pickImage(forLogo: true),
                          onPanUpdate: (d) {
                            setState(() {
                              _frameLogoPosition += d.delta;
                            });
                          },
                          child: _uploadedLogoPath != null
                              ? ClipOval(
                                  child: Image.file(
                                    File(_uploadedLogoPath!),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : (_brandInfo.logoAsset.isNotEmpty
                                    ? ClipOval(
                                        child: Image.network(
                                          _brandInfo.logoAsset,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : _logoWidget(
                                        const Color(0xFFD4AF37),
                                        size: 50,
                                      )),
                        ),
                      ),

                    // ── Free brand elements (no frame selected) ──
                    if (_selectedFrame < 0) ..._buildFreeBrandElements(),

                    // ── Overlay brand items ──
                    ..._overlayBrandItems
                        .where((e) => e.isVisible)
                        .map((e) => _buildOverlayBrandWidget(e)),

                    // ── Text widgets ──
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

  // Widget _buildPosterBackground() {
  //   Widget img;
  //   if (_uploadedImagePath != null) {
  //     img = Image.file(
  //       File(_uploadedImagePath!),
  //       fit: BoxFit.cover,
  //       width: double.infinity,
  //       height: double.infinity,
  //     );
  //   } else {
  //     img = Image.network(
  //       widget.posterAsset,
  //       fit: BoxFit.fill,
  //       width: double.infinity,
  //       height: double.infinity,
  //     );
  //   }

  //   Widget base = Stack(
  //     children: [
  //       Container(
  //         width: double.infinity,
  //         height: double.infinity,
  //         color: _bgColor,
  //       ),
  //       img,
  //     ],
  //   );

  //   if (_selectedEffect == EffectType.blur) {
  //     base = ImageFiltered(
  //       imageFilter: ui.ImageFilter.blur(
  //         sigmaX: 3 * _effectStrength,
  //         sigmaY: 3 * _effectStrength,
  //       ),
  //       child: base,
  //     );
  //   } else if (_selectedEffect == EffectType.grayscale) {
  //     base = ColorFiltered(
  //       colorFilter: const ColorFilter.matrix([
  //         0.2126,
  //         0.7152,
  //         0.0722,
  //         0,
  //         0,
  //         0.2126,
  //         0.7152,
  //         0.0722,
  //         0,
  //         0,
  //         0.2126,
  //         0.7152,
  //         0.0722,
  //         0,
  //         0,
  //         0,
  //         0,
  //         0,
  //         1,
  //         0,
  //       ]),
  //       child: base,
  //     );
  //   } else if (_selectedEffect == EffectType.sepia) {
  //     base = ColorFiltered(
  //       colorFilter: const ColorFilter.matrix([
  //         0.393,
  //         0.769,
  //         0.189,
  //         0,
  //         0,
  //         0.349,
  //         0.686,
  //         0.168,
  //         0,
  //         0,
  //         0.272,
  //         0.534,
  //         0.131,
  //         0,
  //         0,
  //         0,
  //         0,
  //         0,
  //         1,
  //         0,
  //       ]),
  //       child: base,
  //     );
  //   }

  //   if (_selectedAnimation != AnimationType.none) {
  //     return AnimatedBuilder(
  //       animation: _animValue,
  //       builder: (_, __) => _applyAnimation(base),
  //     );
  //   }
  //   return base;
  // }

  Widget _buildPosterBackground() {
    final isDarkMode = _isDarkMode;
    Widget img;

    if (_uploadedImagePath != null) {
      img = Image.file(
        File(_uploadedImagePath!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      img = Image.network(
        widget.posterAsset,
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
      );
    }

    Widget base = Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: isDarkMode ? const Color(0xFF1A1A1A) : _bgColor,
        ),
        img,
      ],
    );

    // If no image uploaded and no network image (placeholder case)
    if (_uploadedImagePath == null && widget.posterAsset.isEmpty) {
      base = Container(
        width: double.infinity,
        height: double.infinity,
        color: isDarkMode ? const Color(0xFF1A1A1A) : _bgColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 48,
                color: isDarkMode
                    ? Colors.white.withOpacity(0.3)
                    : Colors.black.withOpacity(0.2),
              ),
              const SizedBox(height: 10),
              Text(
                'No Image Selected',
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.35)
                      : Colors.black.withOpacity(0.25),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Upload an image to get started',
                style: TextStyle(
                  fontSize: 11,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.25)
                      : Colors.black.withOpacity(0.15),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Apply effects (keep as is)
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

  // ── OVERLAY BRAND ITEMS (movable/deletable/editable) ──────

  Widget _buildOverlayBrandWidget(OverlayBrandItem item) {
    final isSelected = _selectedBrandItemId == item.id;
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedBrandItemId = item.id;
            _selectedTextId = null;
          });
          if (item.type == BrandElementType.logo) {
            _pickImage(forLogo: true);
          } else {
            _showOverlayBrandEditor(item);
          }
        },
        onPanUpdate: (d) {
          setState(() {
            final idx = _overlayBrandItems.indexWhere((e) => e.id == item.id);
            if (idx != -1)
              _overlayBrandItems[idx] = _overlayBrandItems[idx].copyWith(
                position: item.position + d.delta,
              );
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Delete button
            if (isSelected)
              Positioned(
                top: -12,
                left: -8,
                child: GestureDetector(
                  onTap: () => setState(() {
                    final idx = _overlayBrandItems.indexWhere(
                      (e) => e.id == item.id,
                    );
                    if (idx != -1)
                      _overlayBrandItems[idx] = _overlayBrandItems[idx]
                          .copyWith(isVisible: false);
                    _selectedBrandItemId = null;
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
              child: _buildOverlayBrandContent(item),
            ),
            // Edit button
            if (isSelected && item.type != BrandElementType.logo)
              Positioned(
                top: -12,
                right: -8,
                child: GestureDetector(
                  onTap: () => _showOverlayBrandEditor(item),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
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

  Widget _buildOverlayBrandContent(OverlayBrandItem item) {
    final List<Shadow>? shadows = item.hasShadow
        ? [const Shadow(color: Colors.black54, blurRadius: 4)]
        : null;

    switch (item.type) {
      case BrandElementType.logo:
        return GestureDetector(
          onTap: () => _pickImage(forLogo: true),
          child: _logoWidget(const Color(0xFFD4AF37), size: 56),
        );

      case BrandElementType.name:
        if (_brandInfo.name.isEmpty) return const SizedBox.shrink();
        return Container(
          decoration: item.hasBorder
              ? BoxDecoration(
                  border: Border.all(color: item.color),
                  color: item.backgroundColor == Colors.transparent
                      ? null
                      : item.backgroundColor,
                )
              : BoxDecoration(
                  color: item.backgroundColor == Colors.transparent
                      ? null
                      : item.backgroundColor,
                ),
          padding: item.backgroundColor != Colors.transparent
              ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
              : EdgeInsets.zero,
          child: Text(
            _brandInfo.name,
            style: TextStyle(
              fontSize: item.fontSize,
              color: item.color,
              fontWeight: item.isBold ? FontWeight.bold : FontWeight.normal,
              shadows: shadows,
            ),
          ),
        );

      case BrandElementType.phone:
        if (_brandInfo.phone.isEmpty) return const SizedBox.shrink();
        return Container(
          decoration: BoxDecoration(
            color: item.backgroundColor == Colors.transparent
                ? null
                : item.backgroundColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.phone, size: item.fontSize - 2, color: item.color),
              const SizedBox(width: 4),
              Text(
                _brandInfo.phone,
                style: TextStyle(
                  fontSize: item.fontSize,
                  color: item.color,
                  shadows: shadows,
                ),
              ),
            ],
          ),
        );

      case BrandElementType.address:
        if (_brandInfo.address.isEmpty) return const SizedBox.shrink();
        return Container(
          decoration: BoxDecoration(
            color: item.backgroundColor == Colors.transparent
                ? null
                : item.backgroundColor,
          ),
          child: SizedBox(
            width: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  size: item.fontSize - 2,
                  color: item.color,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _brandInfo.address,
                    style: TextStyle(
                      fontSize: item.fontSize,
                      color: item.color,
                      shadows: shadows,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  void _showOverlayBrandEditor(OverlayBrandItem item) {
    final colors = [
      Colors.white,
      Colors.black,
      Colors.yellow,
      Colors.red,
      Colors.blue,
      Colors.green,
      const Color(0xFFD4AF37),
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];
    final bgColors = [
      Colors.transparent,
      Colors.black87,
      Colors.white,
      Colors.red.shade700,
      Colors.blue.shade700,
      const Color(0xFFD4AF37),
      Colors.green.shade700,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final idx = _overlayBrandItems.indexWhere((e) => e.id == item.id);
          final current = idx != -1 ? _overlayBrandItems[idx] : item;

          void update(OverlayBrandItem updated) {
            setState(() {
              final i = _overlayBrandItems.indexWhere((e) => e.id == item.id);
              if (i != -1) _overlayBrandItems[i] = updated;
            });
            setSheet(() {});
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit ${current.type.name.toUpperCase()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Font size
                  Row(
                    children: [
                      const Text('Size', style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: current.fontSize,
                          min: 8,
                          max: 48,
                          activeColor: const Color(0xFFF5C518),
                          onChanged: (v) =>
                              update(current.copyWith(fontSize: v)),
                        ),
                      ),
                      Text(
                        '${current.fontSize.toInt()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  // Style toggles
                  Row(
                    children: [
                      _styleChip(
                        'Bold',
                        current.isBold,
                        () => update(current.copyWith(isBold: !current.isBold)),
                      ),
                      const SizedBox(width: 8),
                      _styleChip(
                        'Shadow',
                        current.hasShadow,
                        () => update(
                          current.copyWith(hasShadow: !current.hasShadow),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _styleChip(
                        'Border',
                        current.hasBorder,
                        () => update(
                          current.copyWith(hasBorder: !current.hasBorder),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Text Color',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: colors
                        .map(
                          (c) => GestureDetector(
                            onTap: () => update(current.copyWith(color: c)),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: current.color == c
                                      ? Colors.blueAccent
                                      : Colors.grey.shade300,
                                  width: current.color == c ? 2.5 : 1,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Background',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: bgColors
                        .map(
                          (c) => GestureDetector(
                            onTap: () =>
                                update(current.copyWith(backgroundColor: c)),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: c == Colors.transparent
                                    ? Colors.white
                                    : c,
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
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _styleChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.black87 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: active ? Colors.black87 : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
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
      // case BrandElementType.logo:
      //   return GestureDetector(
      //     onTap: () => _pickImage(forLogo: true),
      //     child: _logoWidget(const Color(0xFFD4AF37), size: 56),
      //   );
      case BrandElementType.logo:
        return GestureDetector(
          onTap: () => _pickImage(forLogo: true),
          child: _uploadedLogoPath != null
              ? ClipOval(
                  child: Image.file(
                    File(_uploadedLogoPath!),
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                )
              : (_brandInfo.logoAsset.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          _brandInfo.logoAsset,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      )
                    : _logoWidget(const Color(0xFFD4AF37), size: 56)),
        );
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

  // In pay button
  // void _handlePayButton() async {
  //   String itemName = _selectedItemType == ItemType.poster ? 'poster' : 'video';

  //   await PaymentService.initiatePayment(
  //     userId: currentUserId,
  //     itemName: itemName,
  //     itemId: currentItemId,
  //     amount: _selectedItemType == ItemType.poster ? 5.0 : 10.0, // Different amounts
  //     mediaFile: selectedMediaFile,
  //   );
  // }

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
      child: Stack(
        children: [
          // Frame decorations (non-interactive)
          // Positioned.fill(
          //   child: IgnorePointer(
          //     child: _buildFrameLayout(frame, showLogo: false),
          //   ),
          // ),
          Positioned.fill(child: _buildFrameLayout(frame, showLogo: false)),

          // Draggable logo on top
          Positioned(
            left: _frameLogoPosition.dx,
            top: _frameLogoPosition.dy,
            child: GestureDetector(
              onTap: () => _pickImage(forLogo: true),
              onPanUpdate: (d) {
                setState(() {
                  _frameLogoPosition += d.delta;
                });
              },
              child: _uploadedLogoPath != null
                  ? ClipOval(
                      child: Image.file(
                        File(_uploadedLogoPath!),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  : (_brandInfo.logoAsset.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              _brandInfo.logoAsset,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : _logoWidget(const Color(0xFFD4AF37), size: 50)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameLayout(FrameStyle f, {bool showLogo = false}) {
    switch (f.layout) {
      case FrameLayout.classic:
        return _frameClassic(f, showLogo: showLogo);
      case FrameLayout.banner:
        return _frameBanner(f, showLogo: showLogo);
      case FrameLayout.modern:
        return _frameModern(f, showLogo: showLogo);
      case FrameLayout.elegant:
        return _frameElegant(f, showLogo: showLogo);
      case FrameLayout.neon:
        return _frameNeon(f, showLogo: showLogo);
      case FrameLayout.minimal:
        return _frameMinimal(f, showLogo: showLogo);
      case FrameLayout.card:
        return _frameCard(f, showLogo: showLogo);
      case FrameLayout.ribbon:
        return _frameRibbon(f, showLogo: showLogo);
      case FrameLayout.diagonal:
        return _frameDiagonal(f, showLogo: showLogo);
      case FrameLayout.curved:
        return _frameCurved(f, showLogo: showLogo);
      case FrameLayout.sideStrip:
        return _frameSideStrip(f, showLogo: showLogo);
      case FrameLayout.split:
        return _frameSplit(f, showLogo: showLogo);
      case FrameLayout.badge:
        return _frameBadge(f, showLogo: showLogo);
      case FrameLayout.gradient:
        return _frameGradient(f, showLogo: showLogo);
      case FrameLayout.zigzag:
        return _frameZigzag(f, showLogo: showLogo);
      case FrameLayout.shadow:
        return _frameShadow(f, showLogo: showLogo);
      case FrameLayout.stripe:
        return _frameStripe(f, showLogo: showLogo);
      case FrameLayout.arch:
        return _frameArch(f, showLogo: showLogo);
      case FrameLayout.filmstrip:
        return _frameFilmstrip(f, showLogo: showLogo);
      case FrameLayout.luxury:
        return _frameLuxury(f, showLogo: showLogo);
    }
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

  // // 1. Classic
  // Widget _frameClassic(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 8),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         top: 14,
  //         left: 14,
  //         child: GestureDetector(
  //           onTap: () => _pickImage(forLogo: true),
  //           child: _logoWidget(f.borderColor, size: 52),
  //         ),
  //       ),
  //     Positioned(
  //       bottom: 0,
  //       left: 0,
  //       right: 0,
  //       child: GestureDetector(
  //         onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //         child: Container(
  //           color: f.footerBg ?? f.borderColor,
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               if (_brandInfo.name.isNotEmpty)
  //                 _bt(_brandInfo.name, 14, Colors.white, FontWeight.bold, 0),
  //               if (_brandInfo.name.isNotEmpty) const SizedBox(height: 2),
  //               if (_brandInfo.phone.isNotEmpty)
  //                 _br(Icons.phone, _brandInfo.phone, 11, Colors.white70, 1),
  //               if (_brandInfo.address.isNotEmpty)
  //                 _br(
  //                   Icons.location_on,
  //                   _brandInfo.address,
  //                   10,
  //                   Colors.white60,
  //                   2,
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   ],
  // );

  // // 2. Golden Banner
  // Widget _frameBanner(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     if (showLogo)
  //       Positioned(
  //         top: 0,
  //         left: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: Container(
  //             color: f.headerBg ?? f.borderColor,
  //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //             child: Row(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () => _pickImage(forLogo: true),
  //                   child: _logoWidget(Colors.white.withOpacity(0.2), size: 40),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 if (_brandInfo.name.isNotEmpty)
  //                   _bt(_brandInfo.name, 15, Colors.white, FontWeight.bold, 0),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     Positioned(
  //       bottom: 0,
  //       left: 0,
  //       right: 0,
  //       child: GestureDetector(
  //         onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //         child: Container(
  //           color: (f.footerBg ?? f.borderColor).withOpacity(0.9),
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Brand name section
  //               if (_brandInfo.name.isNotEmpty)
  //                 Padding(
  //                   padding: const EdgeInsets.only(bottom: 4),
  //                   child: _bt(
  //                     _brandInfo.name,
  //                     13,
  //                     Colors.white,
  //                     FontWeight.w600,
  //                     0,
  //                   ),
  //                 ),
  //               // Row for phone and address
  //               Row(
  //                 children: [
  //                   if (_brandInfo.phone.isNotEmpty)
  //                     Expanded(
  //                       child: _br(
  //                         Icons.phone,
  //                         _brandInfo.phone,
  //                         11,
  //                         Colors.white,
  //                         1,
  //                       ),
  //                     ),
  //                   if (_brandInfo.phone.isNotEmpty &&
  //                       _brandInfo.address.isNotEmpty)
  //                     const SizedBox(width: 8),
  //                   if (_brandInfo.address.isNotEmpty)
  //                     Expanded(
  //                       child: _br(
  //                         Icons.location_on,
  //                         _brandInfo.address,
  //                         10,
  //                         Colors.white70,
  //                         2,
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.symmetric(
  //           vertical: BorderSide(color: f.borderColor, width: 4),
  //         ),
  //       ),
  //     ),
  //   ],
  // );

  // // 3. Modern
  // Widget _frameModern(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Positioned(
  //       left: 0,
  //       top: 0,
  //       bottom: 0,
  //       child: Container(width: 8, color: f.borderColor),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         bottom: 16,
  //         left: 16,
  //         right: 16,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: (f.headerBg ?? f.borderColor).withOpacity(0.85),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             padding: const EdgeInsets.all(10),
  //             child: Row(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () => _pickImage(forLogo: true),
  //                   child: _logoWidget(Colors.white.withOpacity(0.2), size: 44),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       // Brand name section
  //                       if (_brandInfo.name.isNotEmpty)
  //                         _bt(
  //                           _brandInfo.name,
  //                           14,
  //                           Colors.white,
  //                           FontWeight.bold,
  //                           0,
  //                         ),
  //                       // Phone section
  //                       if (_brandInfo.phone.isNotEmpty)
  //                         _br(
  //                           Icons.phone,
  //                           _brandInfo.phone,
  //                           11,
  //                           Colors.white70,
  //                           1,
  //                         ),
  //                       // Address section
  //                       if (_brandInfo.address.isNotEmpty)
  //                         _br(
  //                           Icons.location_on,
  //                           _brandInfo.address,
  //                           10,
  //                           Colors.white60,
  //                           2,
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     if (showLogo)
  //       Positioned(
  //         top: 14,
  //         right: 14,
  //         child: GestureDetector(
  //           onTap: () => _pickImage(forLogo: true),
  //           child: _logoWidget(f.borderColor, size: 50),
  //         ),
  //       ),
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.symmetric(
  //           horizontal: BorderSide(color: f.borderColor, width: 4),
  //         ),
  //       ),
  //     ),
  //   ],
  // );

  // // 4. Elegant
  // Widget _frameElegant(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 6),
  //       ),
  //     ),
  //     Positioned.fill(
  //       child: Container(
  //         margin: const EdgeInsets.all(10),
  //         decoration: BoxDecoration(
  //           border: Border.all(color: f.borderColor.withOpacity(0.5), width: 1),
  //         ),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         top: 16,
  //         left: 0,
  //         right: 0,
  //         child: Center(
  //           child: GestureDetector(
  //             onTap: () => _pickImage(forLogo: true),
  //             child: _logoWidget(f.borderColor, size: 56),
  //           ),
  //         ),
  //       ),
  //     Positioned(
  //       bottom: 0,
  //       left: 0,
  //       right: 0,
  //       child: GestureDetector(
  //         onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //         child: Container(
  //           color: f.footerBg ?? f.borderColor,
  //           padding: const EdgeInsets.symmetric(vertical: 8),
  //           child: Column(
  //             children: [
  //               if (_brandInfo.name.isNotEmpty)
  //                 _bt(_brandInfo.name, 14, Colors.white, FontWeight.bold, 0),
  //               if (_brandInfo.name.isNotEmpty) const SizedBox(height: 2),
  //               if (_brandInfo.phone.isNotEmpty)
  //                 _bt(
  //                   _brandInfo.phone,
  //                   11,
  //                   Colors.white70,
  //                   FontWeight.normal,
  //                   1,
  //                 ),
  //               if (_brandInfo.address.isNotEmpty)
  //                 _bt(
  //                   _brandInfo.address.length > 30
  //                       ? '${_brandInfo.address.substring(0, 30)}…'
  //                       : _brandInfo.address,
  //                   10,
  //                   Colors.white60,
  //                   FontWeight.normal,
  //                   2,
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   ],
  // );

  // // 5. Neon
  // Widget _frameNeon(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 3),
  //         boxShadow: [
  //           BoxShadow(
  //             color: f.borderColor.withOpacity(0.5),
  //             blurRadius: 12,
  //             spreadRadius: 2,
  //           ),
  //         ],
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         top: 12,
  //         left: 12,
  //         child: Container(
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: f.borderColor.withOpacity(0.8),
  //                 blurRadius: 12,
  //               ),
  //             ],
  //           ),
  //           child: GestureDetector(
  //             onTap: () => _pickImage(forLogo: true),
  //             child: _logoWidget(f.borderColor, size: 50),
  //           ),
  //         ),
  //       ),
  //     Positioned(
  //       bottom: 12,
  //       left: 12,
  //       right: 12,
  //       child: GestureDetector(
  //         onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.black.withOpacity(0.7),
  //             border: Border.all(color: f.borderColor, width: 1),
  //             borderRadius: BorderRadius.circular(6),
  //           ),
  //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               if (_brandInfo.name.isNotEmpty)
  //                 _bt(_brandInfo.name, 14, f.borderColor, FontWeight.bold, 0),
  //               if (_brandInfo.phone.isNotEmpty)
  //                 _br(Icons.phone, _brandInfo.phone, 11, Colors.white70, 1),
  //               if (_brandInfo.address.isNotEmpty)
  //                 _br(
  //                   Icons.location_on,
  //                   _brandInfo.address,
  //                   10,
  //                   Colors.white54,
  //                   2,
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   ],
  // );

  // // 6. Minimal
  // Widget _frameMinimal(FrameStyle f, {bool showLogo = false}) {
  //   const sz = 24.0, th = 3.0;
  //   final c = f.borderColor;
  //   return Stack(
  //     children: [
  //       Positioned(top: 8, left: 8, child: _corner(c, sz, th, true, true)),
  //       Positioned(top: 8, right: 8, child: _corner(c, sz, th, true, false)),
  //       Positioned(bottom: 8, left: 8, child: _corner(c, sz, th, false, true)),
  //       Positioned(
  //         bottom: 8,
  //         right: 8,
  //         child: _corner(c, sz, th, false, false),
  //       ),
  //       if (showLogo)
  //         Positioned(
  //           top: 20,
  //           right: 20,
  //           child: GestureDetector(
  //             onTap: () => _pickImage(forLogo: true),
  //             child: _logoWidget(c, size: 46),
  //           ),
  //         ),
  //       Positioned(
  //         bottom: 20,
  //         left: 20,
  //         right: 60,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               if (_brandInfo.name.isNotEmpty)
  //                 _bt(_brandInfo.name, 15, Colors.white, FontWeight.bold, 0),
  //               if (_brandInfo.phone.isNotEmpty)
  //                 _br(Icons.phone, _brandInfo.phone, 11, Colors.white70, 1),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // // 7. Card
  // Widget _frameCard(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 5),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         bottom: 14,
  //         left: 14,
  //         right: 14,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: (f.footerBg ?? f.borderColor).withOpacity(0.92),
  //               borderRadius: BorderRadius.circular(12),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black.withOpacity(0.3),
  //                   blurRadius: 8,
  //                   offset: const Offset(0, 4),
  //                 ),
  //               ],
  //             ),
  //             padding: const EdgeInsets.all(12),
  //             child: Row(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () => _pickImage(forLogo: true),
  //                   child: _logoWidget(
  //                     Colors.white.withOpacity(0.15),
  //                     size: 48,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       if (_brandInfo.name.isNotEmpty)
  //                         _bt(
  //                           _brandInfo.name,
  //                           14,
  //                           Colors.white,
  //                           FontWeight.bold,
  //                           0,
  //                         ),
  //                       if (_brandInfo.name.isNotEmpty)
  //                         const SizedBox(height: 2),
  //                       if (_brandInfo.phone.isNotEmpty)
  //                         _br(
  //                           Icons.phone,
  //                           _brandInfo.phone,
  //                           11,
  //                           Colors.white60,
  //                           1,
  //                         ),
  //                       if (_brandInfo.address.isNotEmpty)
  //                         _br(
  //                           Icons.location_on,
  //                           _brandInfo.address,
  //                           10,
  //                           Colors.white60,
  //                           2,
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //   ],
  // );

  // // 8. Ribbon
  // Widget _frameRibbon(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 4),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         top: 0,
  //         left: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: Container(
  //             height: 52,
  //             color: f.headerBg ?? f.borderColor,
  //             padding: const EdgeInsets.symmetric(horizontal: 12),
  //             child: Row(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () => _pickImage(forLogo: true),
  //                   child: _logoWidget(Colors.white.withOpacity(0.2), size: 38),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     if (_brandInfo.name.isNotEmpty)
  //                       _bt(
  //                         _brandInfo.name,
  //                         14,
  //                         Colors.white,
  //                         FontWeight.bold,
  //                         0,
  //                       ),
  //                     if (_brandInfo.phone.isNotEmpty)
  //                       _bt(
  //                         _brandInfo.phone,
  //                         11,
  //                         Colors.white70,
  //                         FontWeight.normal,
  //                         1,
  //                       ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     if (_brandInfo.address.isNotEmpty)
  //       Positioned(
  //         bottom: 0,
  //         left: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: Container(
  //             color: (f.headerBg ?? f.borderColor).withOpacity(0.8),
  //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
  //             child: _br(
  //               Icons.location_on,
  //               _brandInfo.address,
  //               10,
  //               Colors.white70,
  //               2,
  //             ),
  //           ),
  //         ),
  //       ),
  //   ],
  // );

  // // 9. Diagonal
  // Widget _frameDiagonal(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 4),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         bottom: 0,
  //         left: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: ClipPath(
  //             clipper: _DiagonalClipper(),
  //             child: Container(
  //               height: 80,
  //               color: f.footerBg ?? f.borderColor,
  //               padding: const EdgeInsets.fromLTRB(14, 20, 14, 8),
  //               child: Row(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () => _pickImage(forLogo: true),
  //                     child: _logoWidget(
  //                       Colors.white.withOpacity(0.2),
  //                       size: 36,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         if (_brandInfo.name.isNotEmpty)
  //                           _bt(
  //                             _brandInfo.name,
  //                             13,
  //                             Colors.white,
  //                             FontWeight.bold,
  //                             0,
  //                           ),
  //                         if (_brandInfo.phone.isNotEmpty)
  //                           _br(
  //                             Icons.phone,
  //                             _brandInfo.phone,
  //                             10,
  //                             Colors.white70,
  //                             1,
  //                           ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     if (showLogo)
  //       Positioned(
  //         top: 14,
  //         right: 14,
  //         child: GestureDetector(
  //           onTap: () => _pickImage(forLogo: true),
  //           child: _logoWidget(f.borderColor, size: 46),
  //         ),
  //       ),
  //   ],
  // );

  // // 10. Wave/Curved
  // Widget _frameCurved(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 3),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         bottom: 0,
  //         left: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: ClipPath(
  //             clipper: _WaveClipper(),
  //             child: Container(
  //               height: 90,
  //               color: f.footerBg ?? f.borderColor,
  //               alignment: Alignment.bottomCenter,
  //               padding: const EdgeInsets.fromLTRB(14, 28, 14, 8),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () => _pickImage(forLogo: true),
  //                     child: _logoWidget(
  //                       Colors.white.withOpacity(0.2),
  //                       size: 36,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       if (_brandInfo.name.isNotEmpty)
  //                         _bt(
  //                           _brandInfo.name,
  //                           13,
  //                           Colors.white,
  //                           FontWeight.bold,
  //                           0,
  //                         ),
  //                       if (_brandInfo.phone.isNotEmpty)
  //                         _bt(
  //                           _brandInfo.phone,
  //                           10,
  //                           Colors.white70,
  //                           FontWeight.normal,
  //                           1,
  //                         ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //   ],
  // );

  // // 11. Side Strip
  // Widget _frameSideStrip(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     if (showLogo)
  //       Positioned(
  //         right: 0,
  //         top: 0,
  //         bottom: 0,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: Container(
  //             width: 52,
  //             color: f.footerBg ?? f.borderColor,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () => _pickImage(forLogo: true),
  //                   child: _logoWidget(Colors.white.withOpacity(0.2), size: 38),
  //                 ),
  //                 if (_brandInfo.name.isNotEmpty) ...[
  //                   const SizedBox(height: 8),
  //                   RotatedBox(
  //                     quarterTurns: 1,
  //                     child: _bt(
  //                       _brandInfo.name,
  //                       11,
  //                       Colors.white,
  //                       FontWeight.bold,
  //                       0,
  //                     ),
  //                   ),
  //                 ],
  //                 if (_brandInfo.phone.isNotEmpty) ...[
  //                   const SizedBox(height: 6),
  //                   RotatedBox(
  //                     quarterTurns: 1,
  //                     child: _bt(
  //                       _brandInfo.phone,
  //                       9,
  //                       Colors.white70,
  //                       FontWeight.normal,
  //                       1,
  //                     ),
  //                   ),
  //                 ],
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border(
  //           top: BorderSide(color: f.borderColor, width: 4),
  //           bottom: BorderSide(color: f.borderColor, width: 4),
  //           left: BorderSide(color: f.borderColor, width: 4),
  //         ),
  //       ),
  //     ),
  //   ],
  // );

  // // 12. Split
  // Widget _frameSplit(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 4),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         bottom: 0,
  //         left: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: Container(
  //                   color: f.borderColor,
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 10,
  //                     vertical: 8,
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () => _pickImage(forLogo: true),
  //                         child: _logoWidget(
  //                           Colors.white.withOpacity(0.25),
  //                           size: 36,
  //                         ),
  //                       ),
  //                       if (_brandInfo.name.isNotEmpty) ...[
  //                         const SizedBox(height: 4),
  //                         _bt(
  //                           _brandInfo.name,
  //                           12,
  //                           Colors.white,
  //                           FontWeight.bold,
  //                           0,
  //                         ),
  //                       ],
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Container(
  //                   color: (f.footerBg ?? f.borderColor).withOpacity(0.8),
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 10,
  //                     vertical: 8,
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       if (_brandInfo.phone.isNotEmpty)
  //                         _br(
  //                           Icons.phone,
  //                           _brandInfo.phone,
  //                           10,
  //                           Colors.white,
  //                           1,
  //                         ),
  //                       if (_brandInfo.phone.isNotEmpty &&
  //                           _brandInfo.address.isNotEmpty)
  //                         const SizedBox(height: 4),
  //                       if (_brandInfo.address.isNotEmpty)
  //                         _br(
  //                           Icons.location_on,
  //                           _brandInfo.address,
  //                           9,
  //                           Colors.white70,
  //                           2,
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //   ],
  // );

  // // 13. Badge
  // Widget _frameBadge(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 5),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         top: 10,
  //         left: 0,
  //         right: 0,
  //         child: Center(
  //           child: GestureDetector(
  //             onTap: () => _pickImage(forLogo: true),
  //             child: Container(
  //               width: 66,
  //               height: 66,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: f.headerBg ?? f.borderColor,
  //                 border: Border.all(color: Colors.white, width: 3),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withOpacity(0.3),
  //                     blurRadius: 8,
  //                   ),
  //                 ],
  //               ),
  //               child: _uploadedLogoPath != null
  //                   ? ClipOval(
  //                       child: Image.file(
  //                         File(_uploadedLogoPath!),
  //                         fit: BoxFit.cover,
  //                       ),
  //                     )
  //                   : const Center(
  //                       child: Text(
  //                         'LOGO',
  //                         style: TextStyle(
  //                           fontSize: 9,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     Positioned(
  //       bottom: 0,
  //       left: 0,
  //       right: 0,
  //       child: GestureDetector(
  //         onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //         child: Container(
  //           color: f.footerBg ?? f.borderColor,
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     if (_brandInfo.name.isNotEmpty)
  //                       _bt(
  //                         _brandInfo.name,
  //                         13,
  //                         Colors.white,
  //                         FontWeight.bold,
  //                         0,
  //                       ),
  //                     if (_brandInfo.phone.isNotEmpty)
  //                       _br(
  //                         Icons.phone,
  //                         _brandInfo.phone,
  //                         10,
  //                         Colors.white70,
  //                         1,
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //               if (_brandInfo.address.isNotEmpty)
  //                 Flexible(
  //                   child: _br(
  //                     Icons.location_on,
  //                     _brandInfo.address,
  //                     9,
  //                     Colors.white60,
  //                     2,
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   ],
  // );

  // // 14. Gradient
  // Widget _frameGradient(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     if (showLogo)
  //       Positioned(
  //         bottom: 0,
  //         left: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: Container(
  //             height: 110,
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 begin: Alignment.topCenter,
  //                 end: Alignment.bottomCenter,
  //                 colors: [
  //                   Colors.transparent,
  //                   (f.footerBg ?? f.borderColor).withOpacity(0.95),
  //                 ],
  //               ),
  //             ),
  //             padding: const EdgeInsets.fromLTRB(14, 30, 14, 10),
  //             child: Row(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () => _pickImage(forLogo: true),
  //                   child: _logoWidget(f.borderColor, size: 44),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       if (_brandInfo.name.isNotEmpty)
  //                         _bt(
  //                           _brandInfo.name,
  //                           14,
  //                           Colors.white,
  //                           FontWeight.bold,
  //                           0,
  //                         ),
  //                       if (_brandInfo.phone.isNotEmpty)
  //                         _br(
  //                           Icons.phone,
  //                           _brandInfo.phone,
  //                           11,
  //                           Colors.white70,
  //                           1,
  //                         ),
  //                       if (_brandInfo.address.isNotEmpty)
  //                         _br(
  //                           Icons.location_on,
  //                           _brandInfo.address,
  //                           10,
  //                           Colors.white60,
  //                           2,
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 3),
  //       ),
  //     ),
  //   ],
  // );

  // // 15. Zigzag
  // Widget _frameZigzag(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 4),
  //       ),
  //     ),
  //     Positioned(
  //       top: 0,
  //       left: 0,
  //       right: 0,
  //       child: SizedBox(
  //         height: 14,
  //         child: CustomPaint(painter: _ZigzagPainter(color: f.borderColor)),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         top: 16,
  //         left: 12,
  //         child: GestureDetector(
  //           onTap: () => _pickImage(forLogo: true),
  //           child: _logoWidget(f.borderColor, size: 48),
  //         ),
  //       ),
  //     Positioned(
  //       bottom: 0,
  //       left: 0,
  //       right: 0,
  //       child: GestureDetector(
  //         onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //         child: Container(
  //           color: f.footerBg ?? f.borderColor,
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
  //           child: Row(
  //             children: [
  //               if (_brandInfo.name.isNotEmpty)
  //                 Expanded(
  //                   child: _bt(
  //                     _brandInfo.name,
  //                     13,
  //                     Colors.white,
  //                     FontWeight.bold,
  //                     0,
  //                   ),
  //                 ),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   if (_brandInfo.phone.isNotEmpty)
  //                     _bt(
  //                       _brandInfo.phone,
  //                       10,
  //                       Colors.white70,
  //                       FontWeight.normal,
  //                       1,
  //                     ),
  //                   if (_brandInfo.address.isNotEmpty)
  //                     _bt(
  //                       _brandInfo.address.length > 20
  //                           ? '${_brandInfo.address.substring(0, 20)}…'
  //                           : _brandInfo.address,
  //                       9,
  //                       Colors.white60,
  //                       FontWeight.normal,
  //                       2,
  //                     ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   ],
  // );

  // // 16. Shadow
  // Widget _frameShadow(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 4),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         bottom: 14,
  //         left: 14,
  //         right: 14,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: f.footerBg ?? f.borderColor,
  //               borderRadius: BorderRadius.circular(6),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black.withOpacity(0.5),
  //                   blurRadius: 12,
  //                   offset: const Offset(4, 4),
  //                 ),
  //                 BoxShadow(
  //                   color: f.borderColor.withOpacity(0.3),
  //                   blurRadius: 4,
  //                   offset: const Offset(-2, -2),
  //                 ),
  //               ],
  //             ),
  //             padding: const EdgeInsets.all(10),
  //             child: Row(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () => _pickImage(forLogo: true),
  //                   child: _logoWidget(
  //                     Colors.white.withOpacity(0.15),
  //                     size: 44,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       if (_brandInfo.name.isNotEmpty)
  //                         _bt(
  //                           _brandInfo.name,
  //                           13,
  //                           Colors.white,
  //                           FontWeight.bold,
  //                           0,
  //                         ),
  //                       if (_brandInfo.phone.isNotEmpty)
  //                         _br(
  //                           Icons.phone,
  //                           _brandInfo.phone,
  //                           10,
  //                           Colors.white70,
  //                           1,
  //                         ),
  //                       if (_brandInfo.address.isNotEmpty)
  //                         _br(
  //                           Icons.location_on,
  //                           _brandInfo.address,
  //                           9,
  //                           Colors.white60,
  //                           2,
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //   ],
  // );

  // // 17. Stripe
  // Widget _frameStripe(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 4),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         bottom: 0,
  //         left: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(height: 8, color: f.accentColor.withOpacity(0.7)),
  //               Container(
  //                 color: f.footerBg ?? f.borderColor,
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 12,
  //                   vertical: 6,
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () => _pickImage(forLogo: true),
  //                       child: _logoWidget(
  //                         Colors.white.withOpacity(0.2),
  //                         size: 38,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 8),
  //                     if (_brandInfo.name.isNotEmpty)
  //                       Expanded(
  //                         child: _bt(
  //                           _brandInfo.name,
  //                           13,
  //                           Colors.white,
  //                           FontWeight.bold,
  //                           0,
  //                         ),
  //                       ),
  //                     if (_brandInfo.phone.isNotEmpty)
  //                       _bt(
  //                         _brandInfo.phone,
  //                         10,
  //                         Colors.white70,
  //                         FontWeight.normal,
  //                         1,
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //               Container(height: 6, color: f.accentColor.withOpacity(0.5)),
  //             ],
  //           ),
  //         ),
  //       ),
  //   ],
  // );

  // // 18. Arch
  // Widget _frameArch(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.borderColor, width: 4),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         top: 0,
  //         left: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: ClipPath(
  //             clipper: _ArchClipper(),
  //             child: Container(
  //               height: 70,
  //               color: f.headerBg ?? f.borderColor,
  //               padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
  //               child: Row(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () => _pickImage(forLogo: true),
  //                     child: _logoWidget(
  //                       Colors.white.withOpacity(0.2),
  //                       size: 36,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       if (_brandInfo.name.isNotEmpty)
  //                         _bt(
  //                           _brandInfo.name,
  //                           13,
  //                           Colors.white,
  //                           FontWeight.bold,
  //                           0,
  //                         ),
  //                       if (_brandInfo.phone.isNotEmpty)
  //                         _bt(
  //                           _brandInfo.phone,
  //                           10,
  //                           Colors.white70,
  //                           FontWeight.normal,
  //                           1,
  //                         ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     if (_brandInfo.address.isNotEmpty)
  //       Positioned(
  //         bottom: 0,
  //         left: 0,
  //         right: 0,
  //         child: GestureDetector(
  //           onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //           child: Container(
  //             color: (f.footerBg ?? f.borderColor).withOpacity(0.85),
  //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //             child: _br(
  //               Icons.location_on,
  //               _brandInfo.address,
  //               10,
  //               Colors.white70,
  //               2,
  //             ),
  //           ),
  //         ),
  //       ),
  //   ],
  // );

  // // 19. Filmstrip
  // Widget _frameFilmstrip(FrameStyle f, {bool showLogo = false}) {
  //   Widget holes() => Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: List.generate(
  //       10,
  //       (i) => Container(
  //         width: 12,
  //         height: 10,
  //         decoration: BoxDecoration(
  //           color: Colors.white.withOpacity(0.15),
  //           borderRadius: BorderRadius.circular(2),
  //         ),
  //       ),
  //     ),
  //   );
  //   return Stack(
  //     children: [
  //       Positioned(
  //         left: 0,
  //         top: 0,
  //         bottom: 0,
  //         child: Container(width: 22, color: f.borderColor, child: holes()),
  //       ),
  //       Positioned(
  //         right: 0,
  //         top: 0,
  //         bottom: 0,
  //         child: Container(width: 22, color: f.borderColor, child: holes()),
  //       ),
  //       if (showLogo)
  //         Positioned(
  //           bottom: 0,
  //           left: 22,
  //           right: 22,
  //           child: GestureDetector(
  //             onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //             child: Container(
  //               color: f.footerBg ?? f.borderColor,
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 10,
  //                 vertical: 7,
  //               ),
  //               child: Row(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () => _pickImage(forLogo: true),
  //                     child: _logoWidget(
  //                       f.accentColor.withOpacity(0.3),
  //                       size: 36,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         if (_brandInfo.name.isNotEmpty)
  //                           _bt(
  //                             _brandInfo.name,
  //                             12,
  //                             f.accentColor,
  //                             FontWeight.bold,
  //                             0,
  //                           ),
  //                         if (_brandInfo.phone.isNotEmpty)
  //                           _bt(
  //                             _brandInfo.phone,
  //                             9,
  //                             Colors.white70,
  //                             FontWeight.normal,
  //                             1,
  //                           ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //     ],
  //   );
  // }

  // // 20. Luxury
  // Widget _frameLuxury(FrameStyle f, {bool showLogo = false}) => Stack(
  //   children: [
  //     Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: f.accentColor, width: 6),
  //       ),
  //     ),
  //     Positioned.fill(
  //       child: Container(
  //         margin: const EdgeInsets.all(10),
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             color: f.accentColor.withOpacity(0.5),
  //             width: 1.5,
  //           ),
  //         ),
  //       ),
  //     ),
  //     Positioned(top: 14, left: 14, child: _luxuryCorner(f.accentColor)),
  //     Positioned(
  //       top: 14,
  //       right: 14,
  //       child: Transform.flip(flipX: true, child: _luxuryCorner(f.accentColor)),
  //     ),
  //     Positioned(
  //       bottom: 88,
  //       left: 14,
  //       child: Transform.flip(flipY: true, child: _luxuryCorner(f.accentColor)),
  //     ),
  //     Positioned(
  //       bottom: 88,
  //       right: 14,
  //       child: Transform.flip(
  //         flipX: true,
  //         flipY: true,
  //         child: _luxuryCorner(f.accentColor),
  //       ),
  //     ),
  //     if (showLogo)
  //       Positioned(
  //         top: 14,
  //         left: 0,
  //         right: 0,
  //         child: Center(
  //           child: GestureDetector(
  //             onTap: () => _pickImage(forLogo: true),
  //             child: _logoWidget(f.accentColor, size: 54),
  //           ),
  //         ),
  //       ),
  //     Positioned(
  //       bottom: 0,
  //       left: 0,
  //       right: 0,
  //       child: GestureDetector(
  //         onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: f.footerBg ?? f.borderColor,
  //             border: Border(top: BorderSide(color: f.accentColor, width: 2)),
  //           ),
  //           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  //           child: Column(
  //             children: [
  //               if (_brandInfo.name.isNotEmpty)
  //                 _bt(_brandInfo.name, 14, f.accentColor, FontWeight.bold, 0),
  //               if (_brandInfo.phone.isNotEmpty ||
  //                   _brandInfo.address.isNotEmpty)
  //                 const SizedBox(height: 3),
  //               if (_brandInfo.phone.isNotEmpty ||
  //                   _brandInfo.address.isNotEmpty)
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     if (_brandInfo.phone.isNotEmpty) ...[
  //                       Icon(
  //                         Icons.phone,
  //                         size: 10,
  //                         color: f.accentColor.withOpacity(0.7),
  //                       ),
  //                       const SizedBox(width: 4),
  //                       _bt(
  //                         _brandInfo.phone,
  //                         11,
  //                         Colors.white70,
  //                         FontWeight.normal,
  //                         1,
  //                       ),
  //                     ],
  //                     if (_brandInfo.phone.isNotEmpty &&
  //                         _brandInfo.address.isNotEmpty)
  //                       const SizedBox(width: 12),
  //                     if (_brandInfo.address.isNotEmpty) ...[
  //                       Icon(
  //                         Icons.location_on,
  //                         size: 10,
  //                         color: f.accentColor.withOpacity(0.7),
  //                       ),
  //                       const SizedBox(width: 4),
  //                       Flexible(
  //                         child: _bt(
  //                           _brandInfo.address.length > 22
  //                               ? '${_brandInfo.address.substring(0, 22)}…'
  //                               : _brandInfo.address,
  //                           10,
  //                           Colors.white60,
  //                           FontWeight.normal,
  //                           2,
  //                         ),
  //                       ),
  //                     ],
  //                   ],
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   ],
  // );

  // 1. Classic
  Widget _frameClassic(FrameStyle f, {bool showLogo = false}) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 8),
        ),
      ),
      if (showLogo)
        Positioned(
          top: 14,
          left: 14,
          child: GestureDetector(
            onTap: () => _pickImage(forLogo: true),
            child: _logoWidget(f.borderColor, size: 52),
          ),
        ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Container(
            color: f.footerBg ?? f.borderColor,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bt(
                  _brandInfo.name.isNotEmpty ? _brandInfo.name : 'Brand Name',
                  14,
                  Colors.white,
                  FontWeight.bold,
                  0,
                ),
                const SizedBox(height: 2),
                _br(
                  Icons.phone,
                  _brandInfo.phone.isNotEmpty
                      ? _brandInfo.phone
                      : 'Phone Number',
                  11,
                  Colors.white70,
                  1,
                ),
                if (_brandInfo.address.isNotEmpty)
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
        ),
      ),
    ],
  );

  // 2. Golden Banner
  Widget _frameBanner(FrameStyle f, {bool showLogo = false}) => Stack(
    children: [
      if (showLogo)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
            child: Container(
              color: f.headerBg ?? f.borderColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _pickImage(forLogo: true),
                    child: _logoWidget(Colors.white.withOpacity(0.2), size: 40),
                  ),
                  const SizedBox(width: 10),
                  _bt(
                    _brandInfo.name.isNotEmpty ? _brandInfo.name : 'Brand Name',
                    15,
                    Colors.white,
                    FontWeight.bold,
                    0,
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
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Container(
            color: (f.footerBg ?? f.borderColor).withOpacity(0.9),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _bt(
                    _brandInfo.name.isNotEmpty ? _brandInfo.name : 'Brand Name',
                    13,
                    Colors.white,
                    FontWeight.w600,
                    0,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _br(
                        Icons.phone,
                        _brandInfo.phone.isNotEmpty
                            ? _brandInfo.phone
                            : 'Phone Number',
                        11,
                        Colors.white,
                        1,
                      ),
                    ),
                    if (_brandInfo.address.isNotEmpty) ...[
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
                  ],
                ),
              ],
            ),
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
  Widget _frameModern(FrameStyle f, {bool showLogo = false}) => Stack(
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
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Container(
            decoration: BoxDecoration(
              color: (f.headerBg ?? f.borderColor).withOpacity(0.85),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                if (showLogo)
                  GestureDetector(
                    onTap: () => _pickImage(forLogo: true),
                    child: _logoWidget(Colors.white.withOpacity(0.2), size: 44),
                  ),
                if (showLogo) const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bt(
                        _brandInfo.name.isNotEmpty
                            ? _brandInfo.name
                            : 'Brand Name',
                        14,
                        Colors.white,
                        FontWeight.bold,
                        0,
                      ),
                      _br(
                        Icons.phone,
                        _brandInfo.phone.isNotEmpty
                            ? _brandInfo.phone
                            : 'Phone Number',
                        11,
                        Colors.white70,
                        1,
                      ),
                      if (_brandInfo.address.isNotEmpty)
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
      ),
      if (showLogo)
        Positioned(
          top: 14,
          right: 14,
          child: GestureDetector(
            onTap: () => _pickImage(forLogo: true),
            child: _logoWidget(f.borderColor, size: 50),
          ),
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
  Widget _frameElegant(FrameStyle f, {bool showLogo = false}) => Stack(
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
      if (showLogo)
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => _pickImage(forLogo: true),
              child: _logoWidget(f.borderColor, size: 56),
            ),
          ),
        ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Container(
            color: f.footerBg ?? f.borderColor,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                _bt(
                  _brandInfo.name.isNotEmpty ? _brandInfo.name : 'Brand Name',
                  14,
                  Colors.white,
                  FontWeight.bold,
                  0,
                ),
                const SizedBox(height: 2),
                _bt(
                  _brandInfo.phone.isNotEmpty
                      ? _brandInfo.phone
                      : 'Phone Number',
                  11,
                  Colors.white70,
                  FontWeight.normal,
                  1,
                ),
                if (_brandInfo.address.isNotEmpty)
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
      ),
    ],
  );

  // 5. Neon
  Widget _frameNeon(FrameStyle f, {bool showLogo = false}) => Stack(
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
      if (showLogo)
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: f.borderColor.withOpacity(0.8),
                  blurRadius: 12,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => _pickImage(forLogo: true),
              child: _logoWidget(f.borderColor, size: 50),
            ),
          ),
        ),
      Positioned(
        bottom: 12,
        left: 12,
        right: 12,
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
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
                _bt(
                  _brandInfo.name.isNotEmpty ? _brandInfo.name : 'Brand Name',
                  14,
                  f.borderColor,
                  FontWeight.bold,
                  0,
                ),
                _br(
                  Icons.phone,
                  _brandInfo.phone.isNotEmpty
                      ? _brandInfo.phone
                      : 'Phone Number',
                  11,
                  Colors.white70,
                  1,
                ),
                if (_brandInfo.address.isNotEmpty)
                  _br(
                    Icons.location_on,
                    _brandInfo.address,
                    10,
                    Colors.white54,
                    2,
                  ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  // 6. Minimal
  Widget _frameMinimal(FrameStyle f, {bool showLogo = false}) {
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
        if (showLogo)
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => _pickImage(forLogo: true),
              child: _logoWidget(c, size: 46),
            ),
          ),
        Positioned(
          bottom: 20,
          right: 60,
          child: GestureDetector(
            onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(
                  0.3,
                ), // Semi-transparent background
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bt(
                    _brandInfo.name.isNotEmpty ? _brandInfo.name : 'Brand Name',
                    15,
                    Colors.white,
                    FontWeight.bold,
                    0,
                  ),
                  _br(
                    Icons.phone,
                    _brandInfo.phone.isNotEmpty
                        ? _brandInfo.phone
                        : 'Phone Number',
                    11,
                    Colors.white70,
                    1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 7. Card
  Widget _frameCard(FrameStyle f, {bool showLogo = false}) => Stack(
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
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
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
                if (showLogo)
                  GestureDetector(
                    onTap: () => _pickImage(forLogo: true),
                    child: _logoWidget(
                      Colors.white.withOpacity(0.15),
                      size: 48,
                    ),
                  ),
                if (showLogo) const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bt(
                        _brandInfo.name.isNotEmpty
                            ? _brandInfo.name
                            : 'Brand Name',
                        14,
                        Colors.white,
                        FontWeight.bold,
                        0,
                      ),
                      const SizedBox(height: 2),
                      _br(
                        Icons.phone,
                        _brandInfo.phone.isNotEmpty
                            ? _brandInfo.phone
                            : 'Phone Number',
                        11,
                        Colors.white60,
                        1,
                      ),
                      if (_brandInfo.address.isNotEmpty)
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
      ),
    ],
  );

  // 8. Ribbon
  Widget _frameRibbon(FrameStyle f, {bool showLogo = false}) => Stack(
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
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Container(
            height: 52,
            color: f.headerBg ?? f.borderColor,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                if (showLogo)
                  GestureDetector(
                    onTap: () => _pickImage(forLogo: true),
                    child: _logoWidget(Colors.white.withOpacity(0.2), size: 38),
                  ),
              ],
            ),
          ),
        ),
      ),

      Positioned(
        top: 0,
        right: 0,
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Container(
            height: 52,
            color: f.headerBg ?? f.borderColor,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                if (showLogo)
                  GestureDetector(
                    onTap: () => _pickImage(forLogo: true),
                    child: _logoWidget(Colors.white.withOpacity(0.2), size: 38),
                  ),
                if (showLogo) const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bt(
                      _brandInfo.name.isNotEmpty
                          ? _brandInfo.name
                          : 'Brand Name',
                      14,
                      Colors.white,
                      FontWeight.bold,
                      0,
                    ),
                    _bt(
                      _brandInfo.phone.isNotEmpty
                          ? _brandInfo.phone
                          : 'Phone Number',
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
      ),
      if (_brandInfo.address.isNotEmpty)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
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
        ),
    ],
  );

  // 9. Diagonal
  Widget _frameDiagonal(FrameStyle f, {bool showLogo = false}) => Stack(
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
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: ClipPath(
            clipper: _DiagonalClipper(),
            child: Container(
              height: 80,
              color: f.footerBg ?? f.borderColor,
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 8),
              child: Row(
                children: [
                  if (showLogo)
                    GestureDetector(
                      onTap: () => _pickImage(forLogo: true),
                      child: _logoWidget(
                        Colors.white.withOpacity(0.2),
                        size: 36,
                      ),
                    ),
                  if (showLogo) const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _bt(
                          _brandInfo.name.isNotEmpty
                              ? _brandInfo.name
                              : 'Brand Name',
                          13,
                          Colors.white,
                          FontWeight.bold,
                          0,
                        ),
                        _br(
                          Icons.phone,
                          _brandInfo.phone.isNotEmpty
                              ? _brandInfo.phone
                              : 'Phone Number',
                          10,
                          Colors.white70,
                          1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      if (showLogo)
        Positioned(
          top: 14,
          right: 14,
          child: GestureDetector(
            onTap: () => _pickImage(forLogo: true),
            child: _logoWidget(f.borderColor, size: 46),
          ),
        ),
    ],
  );

  // 10. Wave/Curved
  Widget _frameCurved(FrameStyle f, {bool showLogo = false}) => Stack(
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
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
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
                  if (showLogo)
                    GestureDetector(
                      onTap: () => _pickImage(forLogo: true),
                      child: _logoWidget(
                        Colors.white.withOpacity(0.2),
                        size: 36,
                      ),
                    ),
                  if (showLogo) const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _bt(
                        _brandInfo.name.isNotEmpty
                            ? _brandInfo.name
                            : 'Brand Name',
                        13,
                        Colors.white,
                        FontWeight.bold,
                        0,
                      ),
                      _bt(
                        _brandInfo.phone.isNotEmpty
                            ? _brandInfo.phone
                            : 'Phone Number',
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
      ),
    ],
  );

  // 11. Side Strip
  Widget _frameSideStrip(FrameStyle f, {bool showLogo = false}) => Stack(
    children: [
      Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Container(
            width: 52,
            color: f.footerBg ?? f.borderColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showLogo)
                  GestureDetector(
                    onTap: () => _pickImage(forLogo: true),
                    child: _logoWidget(Colors.white.withOpacity(0.2), size: 38),
                  ),
                if (showLogo) const SizedBox(height: 8),
                RotatedBox(
                  quarterTurns: 1,
                  child: _bt(
                    _brandInfo.name.isNotEmpty ? _brandInfo.name : 'Brand Name',
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
                    _brandInfo.phone.isNotEmpty
                        ? _brandInfo.phone
                        : 'Phone Number',
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
  Widget _frameSplit(FrameStyle f, {bool showLogo = false}) => Stack(
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
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
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
                      if (showLogo)
                        GestureDetector(
                          onTap: () => _pickImage(forLogo: true),
                          child: _logoWidget(
                            Colors.white.withOpacity(0.25),
                            size: 36,
                          ),
                        ),
                      if (showLogo) const SizedBox(height: 4),
                      _bt(
                        _brandInfo.name.isNotEmpty
                            ? _brandInfo.name
                            : 'Brand Name',
                        12,
                        Colors.white,
                        FontWeight.bold,
                        0,
                      ),
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
                      _br(
                        Icons.phone,
                        _brandInfo.phone.isNotEmpty
                            ? _brandInfo.phone
                            : 'Phone Number',
                        10,
                        Colors.white,
                        1,
                      ),
                      if (_brandInfo.address.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        _br(
                          Icons.location_on,
                          _brandInfo.address,
                          9,
                          Colors.white70,
                          2,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  // 13. Badge
  Widget _frameBadge(FrameStyle f, {bool showLogo = false}) => Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 5),
        ),
      ),
      if (showLogo)
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => _pickImage(forLogo: true),
              child: Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: f.headerBg ?? f.borderColor,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: _uploadedLogoPath != null
                    ? ClipOval(
                        child: Image.file(
                          File(_uploadedLogoPath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(
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
        ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Container(
            color: f.footerBg ?? f.borderColor,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bt(
                        _brandInfo.name.isNotEmpty
                            ? _brandInfo.name
                            : 'Brand Name',
                        13,
                        Colors.white,
                        FontWeight.bold,
                        0,
                      ),
                      _br(
                        Icons.phone,
                        _brandInfo.phone.isNotEmpty
                            ? _brandInfo.phone
                            : 'Phone Number',
                        10,
                        Colors.white70,
                        1,
                      ),
                    ],
                  ),
                ),
                if (_brandInfo.address.isNotEmpty)
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
      ),
    ],
  );

  // 14. Gradient
  Widget _frameGradient(FrameStyle f, {bool showLogo = false}) => Stack(
    children: [
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
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
                if (showLogo)
                  GestureDetector(
                    onTap: () => _pickImage(forLogo: true),
                    child: _logoWidget(f.borderColor, size: 44),
                  ),
                if (showLogo) const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _bt(
                        _brandInfo.name.isNotEmpty
                            ? _brandInfo.name
                            : 'Brand Name',
                        14,
                        Colors.white,
                        FontWeight.bold,
                        0,
                      ),
                      _br(
                        Icons.phone,
                        _brandInfo.phone.isNotEmpty
                            ? _brandInfo.phone
                            : 'Phone Number',
                        11,
                        Colors.white70,
                        1,
                      ),
                      if (_brandInfo.address.isNotEmpty)
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
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: f.borderColor, width: 3),
        ),
      ),
    ],
  );

  // 15. Zigzag
  Widget _frameZigzag(FrameStyle f, {bool showLogo = false}) => Stack(
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
      if (showLogo)
        Positioned(
          top: 16,
          left: 12,
          child: GestureDetector(
            onTap: () => _pickImage(forLogo: true),
            child: _logoWidget(f.borderColor, size: 48),
          ),
        ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Container(
            color: f.footerBg ?? f.borderColor,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              children: [
                Expanded(
                  child: _bt(
                    _brandInfo.name.isNotEmpty ? _brandInfo.name : 'Brand Name',
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
                      _brandInfo.phone.isNotEmpty
                          ? _brandInfo.phone
                          : 'Phone Number',
                      10,
                      Colors.white70,
                      FontWeight.normal,
                      1,
                    ),
                    if (_brandInfo.address.isNotEmpty)
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
      ),
    ],
  );

  // 16. Shadow
  Widget _frameShadow(FrameStyle f, {bool showLogo = false}) => Stack(
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
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
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
                if (showLogo)
                  GestureDetector(
                    onTap: () => _pickImage(forLogo: true),
                    child: _logoWidget(
                      Colors.white.withOpacity(0.15),
                      size: 44,
                    ),
                  ),
                if (showLogo) const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bt(
                        _brandInfo.name.isNotEmpty
                            ? _brandInfo.name
                            : 'Brand Name',
                        13,
                        Colors.white,
                        FontWeight.bold,
                        0,
                      ),
                      _br(
                        Icons.phone,
                        _brandInfo.phone.isNotEmpty
                            ? _brandInfo.phone
                            : 'Phone Number',
                        10,
                        Colors.white70,
                        1,
                      ),
                      if (_brandInfo.address.isNotEmpty)
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
      ),
    ],
  );

  // 17. Stripe
  Widget _frameStripe(FrameStyle f, {bool showLogo = false}) => Stack(
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
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 8, color: f.accentColor.withOpacity(0.7)),
              Container(
                color: f.footerBg ?? f.borderColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    if (showLogo)
                      GestureDetector(
                        onTap: () => _pickImage(forLogo: true),
                        child: _logoWidget(
                          Colors.white.withOpacity(0.2),
                          size: 38,
                        ),
                      ),
                    if (showLogo) const SizedBox(width: 8),
                    Expanded(
                      child: _bt(
                        _brandInfo.name.isNotEmpty
                            ? _brandInfo.name
                            : 'Brand Name',
                        13,
                        Colors.white,
                        FontWeight.bold,
                        0,
                      ),
                    ),
                    _bt(
                      _brandInfo.phone.isNotEmpty
                          ? _brandInfo.phone
                          : 'Phone Number',
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
      ),
    ],
  );

  // 18. Arch
  Widget _frameArch(FrameStyle f, {bool showLogo = false}) => Stack(
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
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: ClipPath(
            clipper: _ArchClipper(),
            child: Container(
              height: 70,
              color: f.headerBg ?? f.borderColor,
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
              child: Row(
                children: [
                  if (showLogo)
                    GestureDetector(
                      onTap: () => _pickImage(forLogo: true),
                      child: _logoWidget(
                        Colors.white.withOpacity(0.2),
                        size: 36,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),

      Positioned(
        top: 0,
        right: 0,
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: ClipPath(
            clipper: _ArchClipper(),
            child: Container(
              height: 70,
              color: f.headerBg ?? f.borderColor,
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bt(
                        _brandInfo.name.isNotEmpty
                            ? _brandInfo.name
                            : 'Brand Name',
                        13,
                        Colors.white,
                        FontWeight.bold,
                        0,
                      ),
                      _bt(
                        _brandInfo.phone.isNotEmpty
                            ? _brandInfo.phone
                            : 'Phone Number',
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
      ),
      if (_brandInfo.address.isNotEmpty)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
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
        ),
    ],
  );

  // 19. Filmstrip
  Widget _frameFilmstrip(FrameStyle f, {bool showLogo = false}) {
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
          child: GestureDetector(
            onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
            child: Container(
              color: f.footerBg ?? f.borderColor,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Row(
                children: [
                  if (showLogo)
                    GestureDetector(
                      onTap: () => _pickImage(forLogo: true),
                      child: _logoWidget(
                        f.accentColor.withOpacity(0.3),
                        size: 36,
                      ),
                    ),
                  if (showLogo) const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bt(
                          _brandInfo.name.isNotEmpty
                              ? _brandInfo.name
                              : 'Brand Name',
                          12,
                          f.accentColor,
                          FontWeight.bold,
                          0,
                        ),
                        _bt(
                          _brandInfo.phone.isNotEmpty
                              ? _brandInfo.phone
                              : 'Phone Number',
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
        ),
      ],
    );
  }

  // 20. Luxury
  Widget _frameLuxury(FrameStyle f, {bool showLogo = false}) => Stack(
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
      if (showLogo)
        Positioned(
          top: 14,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => _pickImage(forLogo: true),
              child: _logoWidget(f.accentColor, size: 54),
            ),
          ),
        ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Container(
            decoration: BoxDecoration(
              color: f.footerBg ?? f.borderColor,
              border: Border(top: BorderSide(color: f.accentColor, width: 2)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: [
                _bt(
                  _brandInfo.name.isNotEmpty ? _brandInfo.name : 'Brand Name',
                  14,
                  f.accentColor,
                  FontWeight.bold,
                  0,
                ),
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
                      _brandInfo.phone.isNotEmpty
                          ? _brandInfo.phone
                          : 'Phone Number',
                      11,
                      Colors.white70,
                      FontWeight.normal,
                      1,
                    ),
                    if (_brandInfo.address.isNotEmpty) ...[
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
                  ],
                ),
              ],
            ),
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

  // Widget _buildTextWidget(OverlayTextItem item) {
  //   final isSelected = _selectedTextId == item.id;
  //   return Positioned(
  //     left: item.position.dx,
  //     top: item.position.dy,
  //     child: GestureDetector(
  //       onTap: () {
  //         setState(() {
  //           _selectedTextId = item.id;
  //           _selectedBrandItemId = null;
  //         });
  //         _openTextEditor(item);
  //       },
  //       onPanUpdate: (d) {
  //         setState(() {
  //           final idx = _texts.indexWhere((t) => t.id == item.id);
  //           if (idx != -1)
  //             _texts[idx] = _texts[idx].copyWith(
  //               position: item.position + Offset(d.delta.dx, d.delta.dy),
  //             );
  //         });
  //       },
  //       child: Stack(
  //         clipBehavior: Clip.none,
  //         children: [
  //           if (isSelected)
  //             Positioned(
  //               top: -14,
  //               left: -4,
  //               child: GestureDetector(
  //                 onTap: () => setState(() {
  //                   _texts.removeWhere((t) => t.id == item.id);
  //                   _selectedTextId = null;
  //                 }),
  //                 child: Container(
  //                   width: 22,
  //                   height: 22,
  //                   decoration: const BoxDecoration(
  //                     color: Colors.red,
  //                     shape: BoxShape.circle,
  //                   ),
  //                   child: const Icon(
  //                     Icons.close,
  //                     size: 13,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           Container(
  //             decoration: isSelected
  //                 ? BoxDecoration(
  //                     border: Border.all(color: Colors.blueAccent, width: 1.5),
  //                     color: Colors.blue.withOpacity(0.05),
  //                   )
  //                 : null,
  //             padding: const EdgeInsets.all(4),
  //             child: Container(
  //               decoration: item.hasBorder
  //                   ? BoxDecoration(
  //                       border: Border.all(color: item.color, width: 1),
  //                     )
  //                   : null,
  //               color: item.backgroundColor == Colors.transparent
  //                   ? null
  //                   : item.backgroundColor,
  //               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
  //               child: Transform.rotate(
  //                 angle: item.rotation,
  //                 child: Text(
  //                   item.text,
  //                   textAlign: item.align,
  //                   style: TextStyle(
  //                     fontSize: item.fontSize,
  //                     color: item.color,
  //                     fontWeight: item.isBold
  //                         ? FontWeight.bold
  //                         : FontWeight.normal,
  //                     fontStyle: item.isItalic
  //                         ? FontStyle.italic
  //                         : FontStyle.normal,
  //                     decoration: item.isUnderline
  //                         ? TextDecoration.underline
  //                         : TextDecoration.none,
  //                     shadows: item.hasShadow
  //                         ? [
  //                             const Shadow(
  //                               color: Colors.black38,
  //                               offset: Offset(2, 2),
  //                               blurRadius: 4,
  //                             ),
  //                           ]
  //                         : null,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           if (isSelected)
  //             Positioned(
  //               right: -6,
  //               bottom: -6,
  //               child: GestureDetector(
  //                 onPanStart: (d) {
  //                   _resizingTextId = item.id;
  //                   _resizeStartOffset = d.globalPosition;
  //                   _resizeStartFontSize = item.fontSize;
  //                 },
  //                 onPanUpdate: (d) {
  //                   if (_resizingTextId != item.id) return;
  //                   final delta =
  //                       (d.globalPosition.dx -
  //                           _resizeStartOffset.dx +
  //                           d.globalPosition.dy -
  //                           _resizeStartOffset.dy) /
  //                       2;
  //                   final newSize = (_resizeStartFontSize + delta).clamp(
  //                     8.0,
  //                     96.0,
  //                   );
  //                   setState(() {
  //                     final idx = _texts.indexWhere((t) => t.id == item.id);
  //                     if (idx != -1)
  //                       _texts[idx] = _texts[idx].copyWith(fontSize: newSize);
  //                   });
  //                 },
  //                 onPanEnd: (_) => _resizingTextId = null,
  //                 child: Container(
  //                   width: 20,
  //                   height: 20,
  //                   decoration: BoxDecoration(
  //                     color: Colors.blueAccent,
  //                     shape: BoxShape.circle,
  //                     border: Border.all(color: Colors.white, width: 1.5),
  //                   ),
  //                   child: const Icon(
  //                     Icons.open_in_full,
  //                     size: 11,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTextWidget(OverlayTextItem item) {
    final isSelected = _selectedTextId == item.id;
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTextId = item.id;
            _selectedBrandItemId = null;
          });
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
        onLongPress: () {
          // Show confirmation dialog on long press
          _showDeleteConfirmationDialog(item);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
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
                        color: item.backgroundColor == Colors.transparent
                            ? null
                            : item.backgroundColor,
                      )
                    : null,
                color:
                    !item.hasBorder &&
                        item.backgroundColor != Colors.transparent
                    ? item.backgroundColor
                    : null,
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

            // Resize handle (bottom-right)
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

  // This method shows the delete confirmation dialog
  void _showDeleteConfirmationDialog(OverlayTextItem item) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  'Delete Text',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Message
                Text(
                  'Are you sure you want to delete this text?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDarkMode
                              ? Colors.white70
                              : Colors.black87,
                          side: BorderSide(
                            color: isDarkMode
                                ? Colors.white38
                                : Colors.grey.shade400,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _texts.removeWhere((t) => t.id == item.id);
                            if (_selectedTextId == item.id) {
                              _selectedTextId = null;
                            }
                          });
                          Navigator.pop(context);

                          // Show snackbar notification
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Text deleted'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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

  // Widget _buildTextPanel() {
  //   final sel = _selectedText;
  //   return Container(
  //     color: Colors.white,
  //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: Row(
  //             children: [
  //               _ta(
  //                 Icons.palette_outlined,
  //                 'Text Theme',
  //                 sel == null ? null : () => _showTextThemePicker(sel),
  //               ),
  //               _ta(
  //                 Icons.edit,
  //                 'Edit',
  //                 sel == null ? null : () => _openTextEditor(sel),
  //               ),
  //               _ta(
  //                 Icons.font_download_outlined,
  //                 'Font',
  //                 sel == null ? null : () => _showFontPicker(sel),
  //               ),
  //               _ta(
  //                 Icons.format_color_text,
  //                 'Color',
  //                 sel == null ? null : () => _showColorPicker(sel),
  //               ),
  //               _ta(
  //                 Icons.arrow_upward,
  //                 null,
  //                 sel == null ? null : () => _moveText(sel, dy: -10),
  //               ),
  //               _ta(
  //                 Icons.arrow_downward,
  //                 null,
  //                 sel == null ? null : () => _moveText(sel, dy: 10),
  //               ),
  //             ],
  //           ),
  //         ),
  //         SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: Row(
  //             children: [
  //               _ta(
  //                 Icons.wb_sunny_outlined,
  //                 'Shadow',
  //                 sel == null
  //                     ? null
  //                     : () => setState(() {
  //                         final i = _texts.indexWhere((t) => t.id == sel.id);
  //                         _texts[i] = _texts[i].copyWith(
  //                           hasShadow: !sel.hasShadow,
  //                         );
  //                       }),
  //               ),
  //               _ta(
  //                 Icons.border_outer,
  //                 'Border',
  //                 sel == null
  //                     ? null
  //                     : () => setState(() {
  //                         final i = _texts.indexWhere((t) => t.id == sel.id);
  //                         _texts[i] = _texts[i].copyWith(
  //                           hasBorder: !sel.hasBorder,
  //                         );
  //                       }),
  //               ),
  //               _ta(
  //                 Icons.format_color_fill,
  //                 'BG',
  //                 sel == null ? null : () => _showBgColorPicker(sel),
  //               ),
  //               _ta(
  //                 Icons.arrow_back,
  //                 null,
  //                 sel == null ? null : () => _moveText(sel, dx: -10),
  //               ),
  //               _ta(
  //                 Icons.arrow_forward,
  //                 null,
  //                 sel == null ? null : () => _moveText(sel, dx: 10),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             _fb(
  //               'U',
  //               sel?.isUnderline ?? false,
  //               TextDecoration.underline,
  //               sel == null
  //                   ? null
  //                   : () => setState(() {
  //                       final i = _texts.indexWhere((t) => t.id == sel.id);
  //                       _texts[i] = _texts[i].copyWith(
  //                         isUnderline: !sel.isUnderline,
  //                       );
  //                     }),
  //             ),
  //             _fb(
  //               'I',
  //               sel?.isItalic ?? false,
  //               TextDecoration.none,
  //               sel == null
  //                   ? null
  //                   : () => setState(() {
  //                       final i = _texts.indexWhere((t) => t.id == sel.id);
  //                       _texts[i] = _texts[i].copyWith(isItalic: !sel.isItalic);
  //                     }),
  //               italic: true,
  //             ),
  //             _fb(
  //               'B',
  //               sel?.isBold ?? false,
  //               TextDecoration.none,
  //               sel == null
  //                   ? null
  //                   : () => setState(() {
  //                       final i = _texts.indexWhere((t) => t.id == sel.id);
  //                       _texts[i] = _texts[i].copyWith(isBold: !sel.isBold);
  //                     }),
  //               bold: true,
  //             ),
  //             _sb('T', 18, sel),
  //             _sb('T', 24, sel),
  //             IconButton(
  //               icon: const Icon(Icons.format_align_left, size: 20),
  //               onPressed: sel == null
  //                   ? null
  //                   : () => setState(() {
  //                       final i = _texts.indexWhere((t) => t.id == sel.id);
  //                       _texts[i] = _texts[i].copyWith(align: TextAlign.left);
  //                     }),
  //             ),
  //             _ta(Icons.add_circle_outline, 'Add Text', _addText),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTextPanel() {
    final isDarkMode = _isDarkMode;
    final sel = _selectedText;
    return Container(
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
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
              // IconButton(
              //   icon: Icon(
              //     Icons.format_align_left,
              //     size: 20,
              //     color: isDarkMode ? Colors.white70 : Colors.black87,
              //   ),
              //   onPressed: sel == null
              //       ? null
              //       : () => setState(() {
              //           final i = _texts.indexWhere((t) => t.id == sel.id);
              //           _texts[i] = _texts[i].copyWith(align: TextAlign.left);
              //         }),
              // ),
              _ta(Icons.add_circle_outline, 'Add Text', _addText),
            ],
          ),
        ],
      ),
    );
  }

  // Update helper methods
  Widget _ta(IconData icon, String? label, VoidCallback? onTap) {
    final isDarkMode = _isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.35 : 1,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              if (label != null)
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                  ),
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
    final isDarkMode = _isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active
              ? (isDarkMode ? Colors.white : Colors.black87)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: active
                  ? (isDarkMode ? Colors.black87 : Colors.white)
                  : (isDarkMode ? Colors.white70 : Colors.black87),
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
    final isDarkMode = _isDarkMode;
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
          color: isActive
              ? (isDarkMode ? Colors.white : Colors.black87)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: size / 2,
              color: isActive
                  ? (isDarkMode ? Colors.black87 : Colors.white)
                  : (isDarkMode ? Colors.white70 : Colors.black87),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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

  // Widget _ta(IconData icon, String? label, VoidCallback? onTap) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Opacity(
  //       opacity: onTap == null ? 0.35 : 1,
  //       child: Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 4),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(icon, size: 20, color: Colors.black87),
  //             if (label != null)
  //               Text(
  //                 label,
  //                 style: const TextStyle(fontSize: 9, color: Colors.black54),
  //               ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _fb(
  //   String label,
  //   bool active,
  //   TextDecoration deco,
  //   VoidCallback? onTap, {
  //   bool italic = false,
  //   bool bold = false,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       width: 36,
  //       height: 36,
  //       decoration: BoxDecoration(
  //         color: active ? Colors.black87 : Colors.transparent,
  //         borderRadius: BorderRadius.circular(4),
  //       ),
  //       child: Center(
  //         child: Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: active ? Colors.white : Colors.black87,
  //             fontWeight: bold ? FontWeight.bold : FontWeight.normal,
  //             fontStyle: italic ? FontStyle.italic : FontStyle.normal,
  //             decoration: deco,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _sb(String label, double size, OverlayTextItem? sel) {
  //   final isActive = sel?.fontSize == size;
  //   return GestureDetector(
  //     onTap: sel == null
  //         ? null
  //         : () => setState(() {
  //             final i = _texts.indexWhere((t) => t.id == sel.id);
  //             _texts[i] = _texts[i].copyWith(fontSize: size);
  //           }),
  //     child: Container(
  //       width: 36,
  //       height: 36,
  //       decoration: BoxDecoration(
  //         color: isActive ? Colors.black87 : Colors.transparent,
  //         borderRadius: BorderRadius.circular(4),
  //       ),
  //       child: Center(
  //         child: Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: size / 2,
  //             color: isActive ? Colors.white : Colors.black87,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
    final isDarkMode = _isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        Color tempColor = sel.color;

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[700]
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Row(
                      children: [
                        Icon(
                          Icons.color_lens,
                          size: 24,
                          color: const Color(0xFFF5C518),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Choose Text Color',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Color picker - Reduced height to prevent overflow
                    SizedBox(
                      height:
                          MediaQuery.of(ctx).size.height *
                          0.35, // Responsive height
                      child: ColorPicker(
                        pickerColor: tempColor,
                        onColorChanged: (color) {
                          setSheetState(() {
                            tempColor = color;
                          });
                        },
                        showLabel: false,
                        pickerAreaHeightPercent: 0.7,
                        enableAlpha: false,
                        displayThumbColor: true,
                        paletteType: PaletteType.hsv,
                        portraitOnly: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Color preview with RGB
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: tempColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.white24
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Selected Color',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: tempColor.computeLuminance() > 0.5
                                  ? Colors.black87
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'RGB(${tempColor.red}, ${tempColor.green}, ${tempColor.blue})',
                            style: TextStyle(
                              fontSize: 12,
                              color: tempColor.computeLuminance() > 0.5
                                  ? Colors.black54
                                  : Colors.white70,
                            ),
                          ),
                          Text(
                            '#${tempColor.value.toRadixString(16).substring(2, 8).toUpperCase()}',
                            style: TextStyle(
                              fontSize: 11,
                              color: tempColor.computeLuminance() > 0.5
                                  ? Colors.black54
                                  : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isDarkMode
                                  ? Colors.white70
                                  : Colors.black87,
                              side: BorderSide(
                                color: isDarkMode
                                    ? Colors.white38
                                    : Colors.grey.shade400,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                final i = _texts.indexWhere(
                                  (t) => t.id == sel.id,
                                );
                                if (i != -1) {
                                  _texts[i] = _texts[i].copyWith(
                                    color: tempColor,
                                  );
                                }
                              });
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5C518),
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Apply',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), // Extra bottom padding
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBgColorPicker(OverlayTextItem sel) {
    final isDarkMode = _isDarkMode;
    Color tempColor = sel.backgroundColor == Colors.transparent
        ? Colors.white
        : sel.backgroundColor;

    double hue = 0.0;
    double saturation = 1.0;
    double brightness = 1.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            height: MediaQuery.of(ctx).size.height * 0.65,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[700]
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.format_color_fill,
                        size: 24,
                        color: const Color(0xFFF5C518),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Choose Background Color',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // None/Transparent button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              final i = _texts.indexWhere(
                                (t) => t.id == sel.id,
                              );
                              if (i != -1) {
                                _texts[i] = _texts[i].copyWith(
                                  backgroundColor: Colors.transparent,
                                );
                              }
                            });
                            Navigator.pop(ctx);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFF0F172A)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.white24
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'None (Transparent)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Divider with OR
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: isDarkMode
                                    ? Colors.white24
                                    : Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDarkMode
                                      ? Colors.white54
                                      : Colors.black45,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: isDarkMode
                                    ? Colors.white24
                                    : Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Color Preview
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: tempColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Selected Color',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: tempColor.computeLuminance() > 0.5
                                      ? Colors.black87
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'RGB(${tempColor.red}, ${tempColor.green}, ${tempColor.blue})',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: tempColor.computeLuminance() > 0.5
                                      ? Colors.black54
                                      : Colors.white70,
                                ),
                              ),
                              Text(
                                '#${tempColor.value.toRadixString(16).substring(2, 8).toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: tempColor.computeLuminance() > 0.5
                                      ? Colors.black54
                                      : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Hue Picker (Gradient bar)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hue',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onPanUpdate: (details) {
                                final box =
                                    ctx.findRenderObject() as RenderBox?;
                                if (box == null) return;
                                final position = details.localPosition;
                                final width =
                                    MediaQuery.of(ctx).size.width - 40;
                                final newHue =
                                    (position.dx / width).clamp(0.0, 1.0) * 360;
                                hue = newHue;
                                tempColor = HSVColor.fromAHSV(
                                  1.0,
                                  hue,
                                  saturation,
                                  brightness,
                                ).toColor();
                                setSheetState(() {});
                              },
                              child: Container(
                                height: 44,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFFF0000), // Red
                                      Color(0xFFFFA500), // Orange
                                      Color(0xFFFFFF00), // Yellow
                                      Color(0xFF00FF00), // Green
                                      Color(0xFF00FFFF), // Cyan
                                      Color(0xFF0000FF), // Blue
                                      Color(0xFFFF00FF), // Magenta
                                      Color(0xFFFF0000), // Red
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Saturation Slider
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saturation',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Slider(
                              value: saturation,
                              onChanged: (value) {
                                saturation = value;
                                tempColor = HSVColor.fromAHSV(
                                  1.0,
                                  hue,
                                  saturation,
                                  brightness,
                                ).toColor();
                                setSheetState(() {});
                              },
                              activeColor: const Color(0xFFF5C518),
                              inactiveColor: isDarkMode
                                  ? Colors.grey[700]
                                  : Colors.grey[300],
                              min: 0,
                              max: 1,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Brightness Slider
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Brightness',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Slider(
                              value: brightness,
                              onChanged: (value) {
                                brightness = value;
                                tempColor = HSVColor.fromAHSV(
                                  1.0,
                                  hue,
                                  saturation,
                                  brightness,
                                ).toColor();
                                setSheetState(() {});
                              },
                              activeColor: const Color(0xFFF5C518),
                              inactiveColor: isDarkMode
                                  ? Colors.grey[700]
                                  : Colors.grey[300],
                              min: 0,
                              max: 1,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: isDarkMode
                                      ? Colors.white70
                                      : Colors.black87,
                                  side: BorderSide(
                                    color: isDarkMode
                                        ? Colors.white38
                                        : Colors.grey.shade400,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    final i = _texts.indexWhere(
                                      (t) => t.id == sel.id,
                                    );
                                    if (i != -1) {
                                      _texts[i] = _texts[i].copyWith(
                                        backgroundColor: tempColor,
                                      );
                                    }
                                  });
                                  Navigator.pop(ctx);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF5C518),
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Apply',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  // ── FRAMES PANEL ──────────────────────────

  Widget _buildFramesPanel() {
    final isDarkMode = _isDarkMode;

    return Container(
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                Text(
                  'Frames — 20 Styles',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
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
          SizedBox(
            height: 110,
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _showAddBrandElementSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Brand Elements to Canvas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap to add — then drag, edit or delete on canvas',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _addElementChip(
                  Icons.account_circle,
                  'Business Name',
                  'ob_name',
                  Colors.blueAccent,
                ),
                _addElementChip(
                  Icons.phone,
                  'Phone Number',
                  'ob_phone',
                  Colors.green,
                ),
                _addElementChip(
                  Icons.location_on,
                  'Address',
                  'ob_address',
                  Colors.orange,
                ),
                _addElementChip(
                  Icons.image_outlined,
                  'Logo',
                  'ob_logo',
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Show currently visible elements
            const Text(
              'Visible elements (tap to hide):',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _overlayBrandItems
                  .where((e) => e.isVisible)
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        setState(() {
                          final idx = _overlayBrandItems.indexWhere(
                            (x) => x.id == e.id,
                          );
                          if (idx != -1)
                            _overlayBrandItems[idx] = _overlayBrandItems[idx]
                                .copyWith(isVisible: false);
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.visibility,
                              size: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              e.type.name,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.red,
                            ),
                          ],
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

  Widget _addElementChip(IconData icon, String label, String id, Color color) {
    final idx = _overlayBrandItems.indexWhere((e) => e.id == id);
    final isVisible = idx != -1 ? _overlayBrandItems[idx].isVisible : false;

    return GestureDetector(
      onTap: () {
        setState(() {
          final i = _overlayBrandItems.indexWhere((e) => e.id == id);
          if (i != -1) {
            _overlayBrandItems[i] = _overlayBrandItems[i].copyWith(
              isVisible: true,
            );
          }
        });
        Navigator.pop(context);
        if (id == 'ob_logo') _pickImage(forLogo: true);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isVisible ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isVisible ? color : Colors.grey.shade300,
            width: isVisible ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isVisible ? color : Colors.black54),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isVisible ? color : Colors.black87,
                fontWeight: isVisible ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isVisible) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'ON',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _frameThumb(
    String name,
    Color color,
    bool selected,
    FrameStyle? frame,
  ) {
    final isDarkMode = _isDarkMode;

    return Container(
      width: 68,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: selected
              ? Colors.blueAccent
              : (isDarkMode ? Colors.grey[700]! : Colors.grey.shade300),
          width: selected ? 2.5 : 1,
        ),
        borderRadius: BorderRadius.circular(6),
        color: isDarkMode ? const Color(0xFF0F172A) : Colors.grey.shade100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: [
            // Background
            Container(
              color: isDarkMode
                  ? const Color(0xFF1A1A1A)
                  : Colors.grey.shade200,
            ),

            // Frame preview
            if (frame != null)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: color, width: 3),
                ),
              ),

            // Corner decoration for some frames
            if (frame != null && frame.layout == FrameLayout.minimal)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border.all(color: color, width: 1.5),
                  ),
                ),
              ),

            // Frame accent
            if (frame != null && frame.layout == FrameLayout.neon)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.5),
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(0.5), blurRadius: 4),
                    ],
                  ),
                ),
              ),

            // Footer preview for frames that have footer
            if (frame != null && frame.footerBg != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 20,
                  color: color.withOpacity(0.85),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 3,
                        width: 30,
                        color: isDarkMode ? Colors.white54 : Colors.white70,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: 2,
                        width: 20,
                        color: isDarkMode ? Colors.white38 : Colors.white38,
                      ),
                    ],
                  ),
                ),
              ),

            // Header preview for frames that have header
            if (frame != null && frame.headerBg != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(height: 18, color: color.withOpacity(0.85)),
              ),

            // Selection indicator
            if (selected)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                ),
              ),

            // Frame name
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                    color: selected
                        ? Colors.blueAccent
                        : (isDarkMode ? Colors.white54 : Colors.black54),
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
  //     height: 180,
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
  //                   onTap: () {
  //                     setState(() => _selectedAudio = null);
  //                     _playAudio(null);
  //                   },
  //                   child: _audioChip('No Audio', _selectedAudio == null),
  //                 );
  //               final track = _audioTracks[i - 1];
  //               return GestureDetector(
  //                 onTap: () {
  //                   setState(() => _selectedAudio = track.name);
  //                   _playAudio(track.name);
  //                 },
  //                 child: _audioChip(track.name, _selectedAudio == track.name),
  //               );
  //             },
  //           ),
  //         ),
  //         if (_selectedAudio != null)
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
  //             child: Row(
  //               children: [
  //                 Icon(
  //                   _isAudioPlaying ? Icons.volume_up : Icons.volume_off,
  //                   size: 16,
  //                   color: _isAudioPlaying ? Colors.green : Colors.amber,
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Expanded(
  //                   child: Text(
  //                     _isAudioPlaying
  //                         ? 'Playing: $_selectedAudio'
  //                         : 'Selected: $_selectedAudio',
  //                     style: TextStyle(
  //                       fontSize: 11,
  //                       color: _isAudioPlaying ? Colors.green : Colors.black54,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //                 if (_isAudioPlaying)
  //                   IconButton(
  //                     icon: const Icon(Icons.stop, size: 18),
  //                     onPressed: () async {
  //                       await _audioPlayer.stop();
  //                       setState(() => _isAudioPlaying = false);
  //                     },
  //                   ),
  //                 const Icon(Icons.audiotrack, size: 18, color: Colors.green),
  //               ],
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildAudioPanel() {
  //   final isDarkMode = _isDarkMode;
  //   return Container(
  //     height: 180,
  //     color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
  //           child: Text(
  //             'Audio',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 13,
  //               color: isDarkMode ? Colors.white : Colors.black87,
  //             ),
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
  //                   onTap: () {
  //                     setState(() => _selectedAudio = null);
  //                     _playAudio(null);
  //                   },
  //                   child: _audioChip('No Audio', _selectedAudio == null),
  //                 );
  //               final track = _audioTracks[i - 1];
  //               return GestureDetector(
  //                 onTap: () {
  //                   setState(() => _selectedAudio = track.name);
  //                   _playAudio(track.name);
  //                 },
  //                 child: _audioChip(track.name, _selectedAudio == track.name),
  //               );
  //             },
  //           ),
  //         ),
  //         if (_selectedAudio != null)
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
  //             child: Row(
  //               children: [
  //                 Icon(
  //                   _isAudioPlaying ? Icons.volume_up : Icons.volume_off,
  //                   size: 16,
  //                   color: _isAudioPlaying ? Colors.green : Colors.amber,
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Expanded(
  //                   child: Text(
  //                     _isAudioPlaying
  //                         ? 'Playing: $_selectedAudio'
  //                         : 'Selected: $_selectedAudio',
  //                     style: TextStyle(
  //                       fontSize: 11,
  //                       color: _isAudioPlaying
  //                           ? Colors.green
  //                           : (isDarkMode ? Colors.white54 : Colors.black54),
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //                 if (_isAudioPlaying)
  //                   IconButton(
  //                     icon: const Icon(Icons.stop, size: 18),
  //                     onPressed: () async {
  //                       await _audioPlayer.stop();
  //                       setState(() => _isAudioPlaying = false);
  //                     },
  //                   ),
  //                 const Icon(Icons.audiotrack, size: 18, color: Colors.green),
  //               ],
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAudioPanel() {
    final isDarkMode = _isDarkMode;
    return Container(
      height: 220, // Increased height
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text(
              'Audio',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                // 1. No Audio option
                GestureDetector(
                  onTap: () {
                    setState(() => _selectedAudio = null);
                    _playAudio(null);
                  },
                  child: _audioChip('No Audio', _selectedAudio == null),
                ),

                // 2. Upload button
                GestureDetector(
                  onTap: _pickUserAudio,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5C518),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFF5C518),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.upload_file,
                          size: 14,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Upload',
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

                // 3. User uploaded audio tracks
                ..._userAudioTracks.map(
                  (userTrack) => Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedAudio = userTrack.name);
                          _playAudio(userTrack.name);
                        },
                        child: _audioChip(
                          '📱 ${userTrack.name} (${userTrack.durationInSeconds}s)',
                          _selectedAudio == userTrack.name,
                        ),
                      ),
                      // Delete button
                      Positioned(
                        top: -4,
                        right: -4,
                        child: GestureDetector(
                          onTap: () {
                            _showDeleteAudioConfirmation(userTrack);
                          },
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 4. Static audio tracks
                ..._audioTracks.map(
                  (track) => GestureDetector(
                    onTap: () {
                      setState(() => _selectedAudio = track.name);
                      _playAudio(track.name);
                    },
                    child: _audioChip(track.name, _selectedAudio == track.name),
                  ),
                ),
              ],
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
                        color: _isAudioPlaying
                            ? Colors.green
                            : (isDarkMode ? Colors.white54 : Colors.black54),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_isAudioPlaying)
                    IconButton(
                      icon: const Icon(Icons.stop, size: 18),
                      onPressed: () async {
                        await _audioPlayer.stop();
                        setState(() => _isAudioPlaying = false);
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

  void _showDeleteAudioConfirmation(UserAudioTrack userTrack) {
    final isDarkMode = _isDarkMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Delete Audio?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to delete "${userTrack.name}"?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDarkMode
                              ? Colors.white70
                              : Colors.black87,
                          side: BorderSide(
                            color: isDarkMode
                                ? Colors.white38
                                : Colors.grey.shade400,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Delete the file
                          try {
                            final file = File(userTrack.filePath);
                            if (await file.exists()) {
                              await file.delete();
                            }
                          } catch (e) {
                            print('Error deleting file: $e');
                          }

                          setState(() {
                            _userAudioTracks.removeWhere(
                              (t) => t.filePath == userTrack.filePath,
                            );
                            if (_selectedAudio == userTrack.name) {
                              _selectedAudio = null;
                              _audioPlayer.stop();
                              _isAudioPlaying = false;
                            }
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Audio deleted'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _audioChip(String label, bool selected) {
    final isDarkMode = _isDarkMode;
    final isPlaying = _isAudioPlaying && _selectedAudio == label;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFF5C518)
            : (isDarkMode ? const Color(0xFF0F172A) : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPlaying
              ? Colors.green
              : (selected
                    ? const Color(0xFFF5C518)
                    : (isDarkMode ? Colors.grey[700]! : Colors.grey.shade300)),
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
                : (selected
                      ? Colors.black87
                      : (isDarkMode ? Colors.white54 : Colors.black45)),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: isPlaying
                  ? Colors.green
                  : (selected
                        ? Colors.black87
                        : (isDarkMode ? Colors.white54 : Colors.black54)),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _audioChip(String label, bool selected) {
  //   final isPlaying = _isAudioPlaying && _selectedAudio == label;
  //   return Container(
  //     margin: const EdgeInsets.only(right: 10),
  //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: selected ? const Color(0xFFF5C518) : Colors.grey.shade100,
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(
  //         color: isPlaying
  //             ? Colors.green
  //             : (selected ? const Color(0xFFF5C518) : Colors.grey.shade300),
  //         width: isPlaying ? 2 : 1,
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         Icon(
  //           isPlaying ? Icons.play_arrow : Icons.headphones,
  //           size: 14,
  //           color: isPlaying
  //               ? Colors.green
  //               : (selected ? Colors.black87 : Colors.black45),
  //         ),
  //         const SizedBox(width: 4),
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 11,
  //             fontWeight: selected ? FontWeight.bold : FontWeight.normal,
  //             color: isPlaying
  //                 ? Colors.green
  //                 : (selected ? Colors.black87 : Colors.black54),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ── ANIMATION PANEL ───────────────────────

  // Widget _buildAnimationPanel() {
  //   final animations = [
  //     _AnimData(AnimationType.none, Icons.block, 'None'),
  //     _AnimData(AnimationType.fade, Icons.opacity, 'Fade'),
  //     _AnimData(AnimationType.zoom, Icons.zoom_in, 'Zoom'),
  //     _AnimData(AnimationType.rotate, Icons.rotate_right, 'Rotate'),
  //     _AnimData(AnimationType.flipIn, Icons.flip, 'FlipIn'),
  //     _AnimData(AnimationType.wobble, Icons.vibration, 'Wobble'),
  //     _AnimData(AnimationType.rollin, Icons.motion_photos_on, 'Roll In'),
  //     _AnimData(AnimationType.slideLeft, Icons.arrow_back, 'Slide ←'),
  //     _AnimData(AnimationType.slideRight, Icons.arrow_forward, 'Slide →'),
  //     _AnimData(AnimationType.slideUp, Icons.arrow_upward, 'Slide ↑'),
  //     _AnimData(AnimationType.slideDown, Icons.arrow_downward, 'Slide ↓'),
  //   ];
  //   return Container(
  //     color: Colors.white,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Padding(
  //           padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
  //           child: Text(
  //             'Animation',
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 90,
  //           child: ListView.separated(
  //             scrollDirection: Axis.horizontal,
  //             padding: const EdgeInsets.symmetric(horizontal: 12),
  //             itemCount: animations.length,
  //             separatorBuilder: (_, __) => const SizedBox(width: 10),
  //             itemBuilder: (_, i) {
  //               final a = animations[i];
  //               final sel = _selectedAnimation == a.type;
  //               return GestureDetector(
  //                 onTap: () {
  //                   setState(() => _selectedAnimation = a.type);
  //                   if (a.type != AnimationType.none) {
  //                     _animController.repeat(reverse: true);
  //                     _brandAnimController.repeat();
  //                   } else {
  //                     _animController.stop();
  //                     _animController.reset();
  //                     _brandAnimController.stop();
  //                     _brandAnimController.reset();
  //                   }
  //                 },
  //                 child: Container(
  //                   width: 72,
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                       color: sel
  //                           ? const Color(0xFFF5C518)
  //                           : Colors.grey.shade200,
  //                       width: 2,
  //                     ),
  //                     borderRadius: BorderRadius.circular(8),
  //                     color: sel
  //                         ? const Color(0xFFFFFDE7)
  //                         : Colors.grey.shade50,
  //                   ),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Icon(
  //                         a.icon,
  //                         size: 28,
  //                         color: sel ? Colors.amber.shade800 : Colors.black54,
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Text(
  //                         a.label,
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                           fontSize: 9,
  //                           color: sel ? Colors.amber.shade900 : Colors.black54,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAnimationPanel() {
    final isDarkMode = _isDarkMode;
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
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text(
              'Animation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
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
                            : (isDarkMode
                                  ? Colors.grey[800]!
                                  : Colors.grey.shade200),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: sel
                          ? (isDarkMode
                                ? const Color(0xFF332700)
                                : const Color(0xFFFFFDE7))
                          : (isDarkMode
                                ? const Color(0xFF0F172A)
                                : Colors.grey.shade50),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          a.icon,
                          size: 28,
                          color: sel
                              ? (isDarkMode
                                    ? const Color(0xFFF5C518)
                                    : Colors.amber.shade800)
                              : (isDarkMode ? Colors.white54 : Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          a.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            color: sel
                                ? (isDarkMode
                                      ? const Color(0xFFF5C518)
                                      : Colors.amber.shade900)
                                : (isDarkMode
                                      ? Colors.white54
                                      : Colors.black54),
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

  // Widget _buildBrandInfoPanel() {
  //   return Container(
  //     color: Colors.white,
  //     padding: const EdgeInsets.all(12),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             const Text(
  //               'Brand Info',
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
  //             ),
  //             const Spacer(),
  //             GestureDetector(
  //               onTap: () => _pickImage(forLogo: true),
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 10,
  //                   vertical: 4,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFF5C518),
  //                   borderRadius: BorderRadius.circular(16),
  //                 ),
  //                 child: const Row(
  //                   children: [
  //                     Icon(Icons.add_a_photo, size: 14, color: Colors.black87),
  //                     SizedBox(width: 4),
  //                     Text(
  //                       'Upload Logo',
  //                       style: TextStyle(
  //                         fontSize: 11,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.black87,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8),
  //         _bInfoRow(
  //           Icons.account_circle,
  //           'Name',
  //           _brandInfo.name,
  //           () => _editBrandField(
  //             'Name',
  //             _brandInfo.name,
  //             (v) => setState(() => _brandInfo.name = v),
  //           ),
  //         ),
  //         const Divider(height: 12),
  //         _bInfoRow(
  //           Icons.phone,
  //           'Phone',
  //           _brandInfo.phone,
  //           () => _editBrandField(
  //             'Phone',
  //             _brandInfo.phone,
  //             (v) => setState(() => _brandInfo.phone = v),
  //           ),
  //         ),
  //         const Divider(height: 12),
  //         _bInfoRow(
  //           Icons.location_on,
  //           'Address',
  //           _brandInfo.address,
  //           () => _editBrandField(
  //             'Address',
  //             _brandInfo.address,
  //             (v) => setState(() => _brandInfo.address = v),
  //           ),
  //         ),
  //         const Divider(height: 12),
  //         // Row(
  //         //   children: [
  //         //     const Icon(Icons.image, size: 18, color: Colors.grey),
  //         //     const SizedBox(width: 8),
  //         //     const Expanded(
  //         //       child: Text('Show Logo', style: TextStyle(fontSize: 13)),
  //         //     ),
  //         //     Switch(
  //         //       value: _brandElements
  //         //           .firstWhere((e) => e.id == 'logo')
  //         //           .isVisible,
  //         //       onChanged: (v) {
  //         //         setState(() {
  //         //           final i = _brandElements.indexWhere((e) => e.id == 'logo');
  //         //           if (i != -1)
  //         //             _brandElements[i] = _brandElements[i].copyWith(
  //         //               isVisible: v,
  //         //             );
  //         //         });
  //         //       },
  //         //       activeColor: const Color(0xFFF5C518),
  //         //     ),
  //         //   ],
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBrandInfoPanel() {
    final isDarkMode = _isDarkMode;
    return Container(
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Brand Info',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
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
          const Divider(height: 12, color: Colors.grey),
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
          const Divider(height: 12, color: Colors.grey),
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
    final isDarkMode = _isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isDarkMode ? Colors.white54 : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDarkMode ? Colors.white54 : Colors.black45,
                  ),
                ),
                Text(
                  value.isEmpty ? 'Not set' : value,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.edit,
            size: 15,
            color: isDarkMode ? Colors.white38 : Colors.black38,
          ),
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
    final isDarkMode = _isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit $label',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                autofocus: true,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: label,
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.white54 : Colors.black45,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.white38 : Colors.grey.shade300,
                    ),
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

  // Widget _bInfoRow(
  //   IconData icon,
  //   String label,
  //   String value,
  //   VoidCallback onTap,
  // ) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Row(
  //       children: [
  //         Icon(icon, size: 18, color: Colors.grey),
  //         const SizedBox(width: 8),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 label,
  //                 style: const TextStyle(fontSize: 10, color: Colors.black45),
  //               ),
  //               Text(
  //                 value,
  //                 style: const TextStyle(fontSize: 13),
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ],
  //           ),
  //         ),
  //         const Icon(Icons.edit, size: 15, color: Colors.black38),
  //       ],
  //     ),
  //   );
  // }

  // void _editBrandField(
  //   String label,
  //   String current,
  //   ValueChanged<String> onSave,
  // ) {
  //   final ctrl = TextEditingController(text: current);
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) => Padding(
  //       padding: EdgeInsets.only(
  //         bottom: MediaQuery.of(context).viewInsets.bottom,
  //       ),
  //       child: Container(
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //         ),
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               'Edit $label',
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 15,
  //               ),
  //             ),
  //             const SizedBox(height: 12),
  //             TextField(
  //               controller: ctrl,
  //               autofocus: true,
  //               decoration: InputDecoration(
  //                 hintText: label,
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 12),
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: const Color(0xFFF5C518),
  //                   foregroundColor: Colors.black87,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   onSave(ctrl.text);
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text('Save'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // ── EFFECT PANEL ──────────────────────────

  // Widget _buildEffectPanel() {
  //   final effects = [
  //     _EffectData(EffectType.none, Icons.block, 'Remove'),
  //     _EffectData(EffectType.blur, Icons.blur_on, 'Blur'),
  //     _EffectData(EffectType.grayscale, Icons.filter_b_and_w, 'Grayscale'),
  //     _EffectData(EffectType.sepia, Icons.filter_vintage, 'Sepia'),
  //     _EffectData(EffectType.brightness, Icons.brightness_5, 'Bright'),
  //     _EffectData(EffectType.contrast, Icons.contrast, 'Contrast'),
  //   ];
  //   return Container(
  //     color: Colors.white,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Padding(
  //           padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
  //           child: Text(
  //             'Effect',
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 90,
  //           child: ListView.separated(
  //             scrollDirection: Axis.horizontal,
  //             padding: const EdgeInsets.symmetric(horizontal: 12),
  //             itemCount: effects.length,
  //             separatorBuilder: (_, __) => const SizedBox(width: 10),
  //             itemBuilder: (_, i) {
  //               final e = effects[i];
  //               final sel = _selectedEffect == e.type;
  //               return GestureDetector(
  //                 onTap: () => setState(() => _selectedEffect = e.type),
  //                 child: Container(
  //                   width: 72,
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                       color: sel ? Colors.amber : Colors.grey.shade200,
  //                       width: 2,
  //                     ),
  //                     borderRadius: BorderRadius.circular(8),
  //                     color: sel
  //                         ? const Color(0xFFFFF8E1)
  //                         : Colors.grey.shade50,
  //                   ),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Icon(
  //                         e.icon,
  //                         size: 28,
  //                         color: sel ? Colors.amber.shade700 : Colors.black45,
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Text(
  //                         e.label,
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                           fontSize: 9,
  //                           color: sel ? Colors.amber.shade800 : Colors.black45,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //         if (_selectedEffect == EffectType.blur)
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 12),
  //             child: Row(
  //               children: [
  //                 const Text('Strength', style: TextStyle(fontSize: 12)),
  //                 Expanded(
  //                   child: Slider(
  //                     value: _effectStrength,
  //                     min: 0,
  //                     max: 1,
  //                     activeColor: Colors.amber,
  //                     onChanged: (v) => setState(() => _effectStrength = v),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         const SizedBox(height: 8),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildEffectPanel() {
    final isDarkMode = _isDarkMode;
    final effects = [
      _EffectData(EffectType.none, Icons.block, 'Remove'),
      _EffectData(EffectType.blur, Icons.blur_on, 'Blur'),
      _EffectData(EffectType.grayscale, Icons.filter_b_and_w, 'Grayscale'),
      _EffectData(EffectType.sepia, Icons.filter_vintage, 'Sepia'),
      _EffectData(EffectType.brightness, Icons.brightness_5, 'Bright'),
      _EffectData(EffectType.contrast, Icons.contrast, 'Contrast'),
    ];
    return Container(
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text(
              'Effect',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
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
                        color: sel
                            ? const Color(0xFFF5C518)
                            : (isDarkMode
                                  ? Colors.grey[800]!
                                  : Colors.grey.shade200),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: sel
                          ? (isDarkMode
                                ? const Color(0xFF332700)
                                : const Color(0xFFFFF8E1))
                          : (isDarkMode
                                ? const Color(0xFF0F172A)
                                : Colors.grey.shade50),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          e.icon,
                          size: 28,
                          color: sel
                              ? (isDarkMode
                                    ? const Color(0xFFF5C518)
                                    : Colors.amber.shade700)
                              : (isDarkMode ? Colors.white54 : Colors.black45),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            color: sel
                                ? (isDarkMode
                                      ? const Color(0xFFF5C518)
                                      : Colors.amber.shade800)
                                : (isDarkMode
                                      ? Colors.white54
                                      : Colors.black45),
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
                  Text(
                    'Strength',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _effectStrength,
                      min: 0,
                      max: 1,
                      activeColor: const Color(0xFFF5C518),
                      inactiveColor: isDarkMode
                          ? Colors.grey[700]
                          : Colors.grey[300],
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

  // Widget _buildBottomTabBar() {
  //   final tabs = [
  //     _TabData(BottomTab.text, Icons.text_fields, 'Text'),
  //     _TabData(BottomTab.frames, Icons.crop_square, 'Frames'),
  //     _TabData(BottomTab.audio, Icons.volume_up_outlined, 'Audio'),
  //     _TabData(BottomTab.animation, Icons.animation, 'Animation'),
  //     _TabData(
  //       BottomTab.brandInfo,
  //       Icons.business_center_outlined,
  //       'Brand Info',
  //     ),
  //     _TabData(BottomTab.sticker, Icons.auto_fix_high, 'Effect'),
  //   ];
  //   return Container(
  //     color: Colors.white,
  //     padding: const EdgeInsets.only(bottom: 4, top: 4),
  //     child: SafeArea(
  //       top: false,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: tabs
  //             .map(
  //               (t) => GestureDetector(
  //                 onTap: () => setState(() => _activeTab = t.tab),
  //                 child: AnimatedContainer(
  //                   duration: const Duration(milliseconds: 200),
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 8,
  //                     vertical: 4,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     border: Border(
  //                       bottom: BorderSide(
  //                         color: _activeTab == t.tab
  //                             ? const Color(0xFFF5C518)
  //                             : Colors.transparent,
  //                         width: 2,
  //                       ),
  //                     ),
  //                   ),
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Icon(
  //                         t.icon,
  //                         size: 22,
  //                         color: _activeTab == t.tab
  //                             ? const Color(0xFFF5C518)
  //                             : Colors.black54,
  //                       ),
  //                       const SizedBox(height: 2),
  //                       Text(
  //                         t.label,
  //                         style: TextStyle(
  //                           fontSize: 9,
  //                           color: _activeTab == t.tab
  //                               ? const Color(0xFFF5C518)
  //                               : Colors.black54,
  //                           fontWeight: _activeTab == t.tab
  //                               ? FontWeight.bold
  //                               : FontWeight.normal,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             )
  //             .toList(),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBottomTabBar() {
    final isDarkMode = _isDarkMode;
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
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
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
                              : (isDarkMode ? Colors.white54 : Colors.black54),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.label,
                          style: TextStyle(
                            fontSize: 9,
                            color: _activeTab == t.tab
                                ? const Color(0xFFF5C518)
                                : (isDarkMode
                                      ? Colors.white54
                                      : Colors.black54),
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

  // Widget _buildDownloadDialog() {
  //   return Positioned.fill(
  //     child: Container(
  //       color: Colors.black45,
  //       child: Center(
  //         child: Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 40),
  //           padding: const EdgeInsets.all(24),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 _isAnimated ? 'Exporting Video…' : 'Saving to Gallery…',
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(4),
  //                 child: LinearProgressIndicator(
  //                   value: _downloadProgress,
  //                   backgroundColor: Colors.grey.shade200,
  //                   color: const Color(0xFFF5C518),
  //                   minHeight: 8,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     '${(_downloadProgress * 100).toInt()}%',
  //                     style: const TextStyle(
  //                       fontSize: 13,
  //                       color: Colors.black54,
  //                     ),
  //                   ),
  //                   Text(
  //                     '${(_downloadProgress * 100).toInt()}/100',
  //                     style: const TextStyle(
  //                       fontSize: 13,
  //                       color: Colors.black54,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDownloadDialog() {
    final isDarkMode = _isDarkMode;

    return Positioned.fill(
      child: Container(
        color: Colors.black45,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isAnimated ? 'Exporting Video…' : 'Saving to Gallery…',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _downloadProgress,
                    backgroundColor: isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey.shade200,
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
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    Text(
                      '${(_downloadProgress * 100).toInt()}/100',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white54 : Colors.black54,
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

  // void _showLayersSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: false,
  //     builder: (_) => StatefulBuilder(
  //       builder: (ctx, setSheet) => Container(
  //         color: Colors.white,
  //         child: Column(
  //           children: [
  //             const Padding(
  //               padding: EdgeInsets.all(12),
  //               child: Text(
  //                 'Layers',
  //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //               ),
  //             ),
  //             const Divider(height: 1),
  //             ListTile(
  //               leading: const Icon(
  //                 Icons.image_outlined,
  //                 color: Colors.blueGrey,
  //               ),
  //               title: const Text('Poster Background'),
  //               trailing: GestureDetector(
  //                 onTap: () => _pickImage(forLogo: false),
  //                 child: const Icon(
  //                   Icons.swap_horiz,
  //                   color: Colors.blueAccent,
  //                   size: 20,
  //                 ),
  //               ),
  //             ),
  //             ..._brandElements.map(
  //               (e) => ListTile(
  //                 leading: Icon(
  //                   e.type == BrandElementType.logo
  //                       ? Icons.circle
  //                       : e.type == BrandElementType.name
  //                       ? Icons.account_circle
  //                       : e.type == BrandElementType.phone
  //                       ? Icons.phone
  //                       : Icons.location_on,
  //                   color: Colors.amber,
  //                 ),
  //                 title: Text(
  //                   e.type.name[0].toUpperCase() + e.type.name.substring(1),
  //                 ),
  //                 subtitle: Text(
  //                   e.isVisible ? 'Visible' : 'Hidden',
  //                   style: TextStyle(
  //                     fontSize: 11,
  //                     color: e.isVisible ? Colors.green : Colors.red,
  //                   ),
  //                 ),
  //                 trailing: IconButton(
  //                   icon: Icon(
  //                     e.isVisible ? Icons.visibility : Icons.visibility_off,
  //                     size: 18,
  //                     color: e.isVisible ? Colors.teal : Colors.grey,
  //                   ),
  //                   onPressed: () {
  //                     setState(() {
  //                       final i = _brandElements.indexWhere(
  //                         (x) => x.id == e.id,
  //                       );
  //                       if (i != -1)
  //                         _brandElements[i] = _brandElements[i].copyWith(
  //                           isVisible: !e.isVisible,
  //                         );
  //                     });
  //                     setSheet(() {});
  //                   },
  //                 ),
  //               ),
  //             ),
  //             // Overlay brand items in layers
  //             ..._overlayBrandItems.map(
  //               (e) => ListTile(
  //                 leading: Icon(
  //                   e.type == BrandElementType.logo
  //                       ? Icons.image
  //                       : e.type == BrandElementType.name
  //                       ? Icons.badge
  //                       : e.type == BrandElementType.phone
  //                       ? Icons.phone_android
  //                       : Icons.pin_drop,
  //                   color: Colors.purple,
  //                 ),
  //                 title: Text(
  //                   'Canvas: ${e.type.name[0].toUpperCase()}${e.type.name.substring(1)}',
  //                 ),
  //                 subtitle: Text(
  //                   e.isVisible ? 'Visible on canvas' : 'Hidden',
  //                   style: TextStyle(
  //                     fontSize: 11,
  //                     color: e.isVisible ? Colors.green : Colors.red,
  //                   ),
  //                 ),
  //                 trailing: IconButton(
  //                   icon: Icon(
  //                     e.isVisible ? Icons.visibility : Icons.visibility_off,
  //                     size: 18,
  //                     color: e.isVisible ? Colors.purple : Colors.grey,
  //                   ),
  //                   onPressed: () {
  //                     setState(() {
  //                       final i = _overlayBrandItems.indexWhere(
  //                         (x) => x.id == e.id,
  //                       );
  //                       if (i != -1)
  //                         _overlayBrandItems[i] = _overlayBrandItems[i]
  //                             .copyWith(isVisible: !e.isVisible);
  //                     });
  //                     setSheet(() {});
  //                   },
  //                 ),
  //               ),
  //             ),
  //             ..._texts.map(
  //               (t) => ListTile(
  //                 leading: const Icon(Icons.text_fields, color: Colors.teal),
  //                 title: Text(
  //                   t.text,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //                 trailing: IconButton(
  //                   icon: const Icon(
  //                     Icons.delete_outline,
  //                     size: 18,
  //                     color: Colors.red,
  //                   ),
  //                   onPressed: () {
  //                     setState(() => _texts.removeWhere((x) => x.id == t.id));
  //                     setSheet(() {});
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _showLayersSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled:
  //         true, // Optional: allows sheet to expand if content is tall
  //     builder: (_) => StatefulBuilder(
  //       builder: (ctx, setSheet) => Container(
  //         color: Colors.white,
  //         child: SingleChildScrollView(
  //           // Add this widget
  //           child: Column(
  //             children: [
  //               const Padding(
  //                 padding: EdgeInsets.all(12),
  //                 child: Text(
  //                   'Layers',
  //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //                 ),
  //               ),
  //               const Divider(height: 1),
  //               ListTile(
  //                 leading: const Icon(
  //                   Icons.image_outlined,
  //                   color: Colors.blueGrey,
  //                 ),
  //                 title: const Text('Poster Background'),
  //                 trailing: GestureDetector(
  //                   onTap: () => _pickImage(forLogo: false),
  //                   child: const Icon(
  //                     Icons.swap_horiz,
  //                     color: Colors.blueAccent,
  //                     size: 20,
  //                   ),
  //                 ),
  //               ),
  //               ..._brandElements.map(
  //                 (e) => ListTile(
  //                   leading: Icon(
  //                     e.type == BrandElementType.logo
  //                         ? Icons.circle
  //                         : e.type == BrandElementType.name
  //                         ? Icons.account_circle
  //                         : e.type == BrandElementType.phone
  //                         ? Icons.phone
  //                         : Icons.location_on,
  //                     color: Colors.amber,
  //                   ),
  //                   title: Text(
  //                     e.type.name[0].toUpperCase() + e.type.name.substring(1),
  //                   ),
  //                   subtitle: Text(
  //                     e.isVisible ? 'Visible' : 'Hidden',
  //                     style: TextStyle(
  //                       fontSize: 11,
  //                       color: e.isVisible ? Colors.green : Colors.red,
  //                     ),
  //                   ),
  //                   trailing: IconButton(
  //                     icon: Icon(
  //                       e.isVisible ? Icons.visibility : Icons.visibility_off,
  //                       size: 18,
  //                       color: e.isVisible ? Colors.teal : Colors.grey,
  //                     ),
  //                     onPressed: () {
  //                       setState(() {
  //                         final i = _brandElements.indexWhere(
  //                           (x) => x.id == e.id,
  //                         );
  //                         if (i != -1)
  //                           _brandElements[i] = _brandElements[i].copyWith(
  //                             isVisible: !e.isVisible,
  //                           );
  //                       });
  //                       setSheet(() {});
  //                     },
  //                   ),
  //                 ),
  //               ),
  //               // Overlay brand items in layers
  //               ..._overlayBrandItems.map(
  //                 (e) => ListTile(
  //                   leading: Icon(
  //                     e.type == BrandElementType.logo
  //                         ? Icons.image
  //                         : e.type == BrandElementType.name
  //                         ? Icons.badge
  //                         : e.type == BrandElementType.phone
  //                         ? Icons.phone_android
  //                         : Icons.pin_drop,
  //                     color: Colors.purple,
  //                   ),
  //                   title: Text(
  //                     'Canvas: ${e.type.name[0].toUpperCase()}${e.type.name.substring(1)}',
  //                   ),
  //                   subtitle: Text(
  //                     e.isVisible ? 'Visible on canvas' : 'Hidden',
  //                     style: TextStyle(
  //                       fontSize: 11,
  //                       color: e.isVisible ? Colors.green : Colors.red,
  //                     ),
  //                   ),
  //                   trailing: IconButton(
  //                     icon: Icon(
  //                       e.isVisible ? Icons.visibility : Icons.visibility_off,
  //                       size: 18,
  //                       color: e.isVisible ? Colors.purple : Colors.grey,
  //                     ),
  //                     onPressed: () {
  //                       setState(() {
  //                         final i = _overlayBrandItems.indexWhere(
  //                           (x) => x.id == e.id,
  //                         );
  //                         if (i != -1)
  //                           _overlayBrandItems[i] = _overlayBrandItems[i]
  //                               .copyWith(isVisible: !e.isVisible);
  //                       });
  //                       setSheet(() {});
  //                     },
  //                   ),
  //                 ),
  //               ),
  //               ..._texts.map(
  //                 (t) => ListTile(
  //                   leading: const Icon(Icons.text_fields, color: Colors.teal),
  //                   title: Text(
  //                     t.text,
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   trailing: IconButton(
  //                     icon: const Icon(
  //                       Icons.delete_outline,
  //                       size: 18,
  //                       color: Colors.red,
  //                     ),
  //                     onPressed: () {
  //                       setState(() => _texts.removeWhere((x) => x.id == t.id));
  //                       setSheet(() {});
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showLayersSheet() {
    final isDarkMode = _isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Drag handle
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[700]
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Title
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Layers',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                  color: isDarkMode ? Colors.grey[800] : Colors.grey.shade200,
                ),

                // Poster Background
                ListTile(
                  leading: Icon(
                    Icons.image_outlined,
                    color: isDarkMode ? Colors.blueGrey[300] : Colors.blueGrey,
                  ),
                  title: Text(
                    'Poster Background',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () => _pickImage(forLogo: false),
                    child: Icon(
                      Icons.swap_horiz,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                  ),
                ),

                // Brand Elements
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
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
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
                        color: e.isVisible
                            ? Colors.teal
                            : (isDarkMode ? Colors.grey[600] : Colors.grey),
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

                // Divider
                Divider(
                  height: 1,
                  color: isDarkMode ? Colors.grey[800] : Colors.grey.shade200,
                ),

                // Overlay brand items in layers
                ..._overlayBrandItems.map(
                  (e) => ListTile(
                    leading: Icon(
                      e.type == BrandElementType.logo
                          ? Icons.image
                          : e.type == BrandElementType.name
                          ? Icons.badge
                          : e.type == BrandElementType.phone
                          ? Icons.phone_android
                          : Icons.pin_drop,
                      color: Colors.purple,
                    ),
                    title: Text(
                      'Canvas: ${e.type.name[0].toUpperCase()}${e.type.name.substring(1)}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      e.isVisible ? 'Visible on canvas' : 'Hidden',
                      style: TextStyle(
                        fontSize: 11,
                        color: e.isVisible ? Colors.green : Colors.red,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        e.isVisible ? Icons.visibility : Icons.visibility_off,
                        size: 18,
                        color: e.isVisible
                            ? Colors.purple
                            : (isDarkMode ? Colors.grey[600] : Colors.grey),
                      ),
                      onPressed: () {
                        setState(() {
                          final i = _overlayBrandItems.indexWhere(
                            (x) => x.id == e.id,
                          );
                          if (i != -1)
                            _overlayBrandItems[i] = _overlayBrandItems[i]
                                .copyWith(isVisible: !e.isVisible);
                        });
                        setSheet(() {});
                      },
                    ),
                  ),
                ),

                // Divider
                Divider(
                  height: 1,
                  color: isDarkMode ? Colors.grey[800] : Colors.grey.shade200,
                ),

                // Text items
                ..._texts.map(
                  (t) => ListTile(
                    leading: Icon(Icons.text_fields, color: Colors.teal),
                    title: Text(
                      t.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
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

                const SizedBox(height: 12),
              ],
            ),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[700] : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              autofocus: true,
              maxLines: 3,
              minLines: 1,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Enter text…',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.white54 : Colors.black45,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white38 : Colors.grey.shade400,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white38 : Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFF5C518),
                    width: 2,
                  ),
                ),
              ),
              onChanged: (v) => _update(_current.copyWith(text: v)),
            ),
            SizedBox(height: 15),
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
    VoidCallback onTap,
    bool isDarkMode, {
    bool bold = false,
    bool italic = false,
    bool underline = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? (isDarkMode ? Colors.white : Colors.black87)
              : (isDarkMode ? const Color(0xFF0F172A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: active
                ? (isDarkMode ? Colors.black87 : Colors.white)
                : (isDarkMode ? Colors.white70 : Colors.black87),
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
