import 'dart:convert' show json;
import 'dart:math';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
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

enum BottomTab { text, frames, audio, animation, brandInfo, sticker, fonts }

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

enum EffectType {
  none,
  blur,
  grayscale,
  sepia,
  brightness,
  contrast,
  // New trending effects
  ambient,
  hyperChromatic,
  vintage,
  chromaticAberration,
  grainyFilm,
  dreamyGlow,
  vaporwave,
  cyberpunk,
  cinematic,
  polaroid,
  duotone,
  glitch,
}

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

// class OverlayTextItem {
//   String id, text;
//   Offset position;
//   double fontSize;
//   Color color, backgroundColor;
//   bool hasBorder, hasShadow, isBold, isItalic, isUnderline;
//   TextAlign align;
//   double rotation;

//   OverlayTextItem({
//     required this.id,
//     required this.text,
//     this.position = const Offset(50, 200),
//     this.fontSize = 24,
//     this.color = Colors.black,
//     this.backgroundColor = Colors.transparent,
//     this.hasBorder = false,
//     this.hasShadow = false,
//     this.isBold = false,
//     this.isItalic = false,
//     this.isUnderline = false,
//     this.align = TextAlign.left,
//     this.rotation = 0,
//   });

//   OverlayTextItem copyWith({
//     String? text,
//     Offset? position,
//     double? fontSize,
//     Color? color,
//     Color? backgroundColor,
//     bool? hasBorder,
//     bool? hasShadow,
//     bool? isBold,
//     bool? isItalic,
//     bool? isUnderline,
//     TextAlign? align,
//     double? rotation,
//   }) {
//     return OverlayTextItem(
//       id: id,
//       text: text ?? this.text,
//       position: position ?? this.position,
//       fontSize: fontSize ?? this.fontSize,
//       color: color ?? this.color,
//       backgroundColor: backgroundColor ?? this.backgroundColor,
//       hasBorder: hasBorder ?? this.hasBorder,
//       hasShadow: hasShadow ?? this.hasShadow,
//       isBold: isBold ?? this.isBold,
//       isItalic: isItalic ?? this.isItalic,
//       isUnderline: isUnderline ?? this.isUnderline,
//       align: align ?? this.align,
//       rotation: rotation ?? this.rotation,
//     );
//   }
// }

class OverlayTextItem {
  String id, text;
  Offset position;
  double fontSize;
  Color color, backgroundColor;
  bool hasBorder, hasShadow, isBold, isItalic, isUnderline;
  TextAlign align;
  double rotation;
  String fontFamily; // Add this

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
    this.fontFamily = 'Montserrat', // Add default font
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
    String? fontFamily,
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
      fontFamily: fontFamily ?? this.fontFamily,
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

// Grid painter for Vaporwave effect
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw perspective lines (optional)
    final perspectivePaint = Paint()
      ..color = const ui.Color.fromARGB(255, 255, 133, 33).withOpacity(0.2)
      ..strokeWidth = 2;

    for (int i = 0; i < 5; i++) {
      double x = size.width / 2;
      double y = size.height * (0.7 + i * 0.05);
      canvas.drawLine(
        Offset(x, y),
        Offset(x + 100, size.height),
        perspectivePaint,
      );
      canvas.drawLine(
        Offset(x, y),
        Offset(x - 100, size.height),
        perspectivePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

class GFontEntry {
  final String name;
  final TextStyle Function({TextStyle? textStyle}) font;

  GFontEntry(this.name, this.font);
}

final List<GFontEntry> kGoogleFonts = [
  // Sans Serif
  GFontEntry('Montserrat', GoogleFonts.montserrat),
  GFontEntry('Poppins', GoogleFonts.poppins),
  GFontEntry('Inter', GoogleFonts.inter),
  GFontEntry('Roboto', GoogleFonts.roboto),
  GFontEntry('Open Sans', GoogleFonts.openSans),
  GFontEntry('Lato', GoogleFonts.lato),
  GFontEntry('Nunito', GoogleFonts.nunito),
  GFontEntry('Raleway', GoogleFonts.raleway),
  GFontEntry('Work Sans', GoogleFonts.workSans),
  GFontEntry('Quicksand', GoogleFonts.quicksand),
  GFontEntry('Josefin Sans', GoogleFonts.josefinSans),
  GFontEntry('DM Sans', GoogleFonts.dmSans),
  GFontEntry('Plus Jakarta Sans', GoogleFonts.plusJakartaSans),
  GFontEntry('Urbanist', GoogleFonts.urbanist),
  GFontEntry('Manrope', GoogleFonts.manrope),

  // Serif
  GFontEntry('Playfair Display', GoogleFonts.playfairDisplay),
  GFontEntry('Merriweather', GoogleFonts.merriweather),
  GFontEntry('Cormorant Garamond', GoogleFonts.cormorantGaramond),
  GFontEntry('Lora', GoogleFonts.lora),
  GFontEntry('Crimson Text', GoogleFonts.crimsonText),
  GFontEntry('PT Serif', GoogleFonts.ptSerif),
  GFontEntry('Libre Baskerville', GoogleFonts.libreBaskerville),
  GFontEntry('Cinzel', GoogleFonts.cinzel),
  GFontEntry('Abril Fatface', GoogleFonts.abrilFatface),

  // Display & Decorative
  GFontEntry('Bebas Neue', GoogleFonts.bebasNeue),
  GFontEntry('Righteous', GoogleFonts.righteous),
  GFontEntry('Oswald', GoogleFonts.oswald),
  GFontEntry('Anton', GoogleFonts.anton),
  GFontEntry('Archivo Black', GoogleFonts.archivoBlack),
  GFontEntry('Titan One', GoogleFonts.titanOne),
  GFontEntry('Permanent Marker', GoogleFonts.permanentMarker),
  GFontEntry('Lobster', GoogleFonts.lobster),
  GFontEntry('Pacifico', GoogleFonts.pacifico),

  // Handwriting & Script
  GFontEntry('Dancing Script', GoogleFonts.dancingScript),
  GFontEntry('Satisfy', GoogleFonts.satisfy),
  GFontEntry('Shadows Into Light', GoogleFonts.shadowsIntoLight),
  GFontEntry('Caveat', GoogleFonts.caveat),
  GFontEntry('Amatic SC', GoogleFonts.amaticSc),
  GFontEntry('Indie Flower', GoogleFonts.indieFlower),

  // Monospace
  GFontEntry('Source Code Pro', GoogleFonts.sourceCodePro),
  GFontEntry('JetBrains Mono', GoogleFonts.jetBrainsMono),
  GFontEntry('Fira Code', GoogleFonts.firaCode),
  GFontEntry('Roboto Mono', GoogleFonts.robotoMono),
];

Map<String, List<GFontEntry>> _getFontCategories() {
  final allFonts = kGoogleFonts;

  return {
    'Sans Serif': allFonts
        .where(
          (f) => [
            'Montserrat',
            'Poppins',
            'Inter',
            'Roboto',
            'Open Sans',
            'Lato',
            'Nunito',
            'Raleway',
            'Work Sans',
            'Quicksand',
            'Josefin Sans',
            'DM Sans',
            'Plus Jakarta Sans',
            'Urbanist',
            'Manrope',
          ].contains(f.name),
        )
        .toList(),

    'Serif': allFonts
        .where(
          (f) => [
            'Playfair Display',
            'Merriweather',
            'Cormorant Garamond',
            'Lora',
            'Crimson Text',
            'PT Serif',
            'Libre Baskerville',
            'Cinzel',
            'Abril Fatface',
          ].contains(f.name),
        )
        .toList(),

    'Display': allFonts
        .where(
          (f) => [
            'Bebas Neue',
            'Righteous',
            'Oswald',
            'Anton',
            'Archivo Black',
            'Titan One',
            'Permanent Marker',
            'Lobster',
            'Pacifico',
          ].contains(f.name),
        )
        .toList(),

    'Script': allFonts
        .where(
          (f) => [
            'Dancing Script',
            'Satisfy',
            'Shadows Into Light',
            'Caveat',
            'Amatic SC',
            'Indie Flower',
          ].contains(f.name),
        )
        .toList(),

    'Monospace': allFonts
        .where(
          (f) => [
            'Source Code Pro',
            'JetBrains Mono',
            'Fira Code',
            'Roboto Mono',
          ].contains(f.name),
        )
        .toList(),
  };
}

// Scanline painter for Glitch effect
class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..strokeWidth = 2;

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_ScanlinePainter old) => false;
}

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

  List<AdminAudioTrack> _adminAudioTracks = [];
  bool _isLoadingAudios = false;
  String? _audioLoadError;

  bool _isSelectingAudio = false;

  final Map<String, TextStyle> _googleFontCache = {};

  TextStyle _getCachedGoogleFont(OverlayTextItem item) {
    final cacheKey =
        '${item.fontFamily}_${item.fontSize}_${item.color.value}_${item.isBold}_${item.isItalic}_${item.isUnderline}';

    if (_googleFontCache.containsKey(cacheKey)) {
      return _googleFontCache[cacheKey]!;
    }

    TextStyle style = TextStyle(
      fontSize: item.fontSize,
      color: item.color,
      fontWeight: item.isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: item.isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: item.isUnderline
          ? TextDecoration.underline
          : TextDecoration.none,
    );

    try {
      final fontEntry = kGoogleFonts.firstWhere(
        (e) => e.name == item.fontFamily,
        orElse: () => kGoogleFonts.first,
      );
      style = fontEntry.font(textStyle: style);
    } catch (_) {
      // Use default style
    }

    _googleFontCache[cacheKey] = style;
    return style;
  }

  Future<void> _fetchAdminAudios() async {
    setState(() {
      _isLoadingAudios = true;
      _audioLoadError = null;
    });
    try {
      final response = await http.get(
        Uri.parse('http://31.97.228.17:4061/api/admin/getallaudios'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List audios = data['audios'] ?? [];
        setState(() {
          _adminAudioTracks = audios
              .map((a) => AdminAudioTrack.fromJson(a))
              .where((a) => a.audioUrl.isNotEmpty)
              .toList();
          _isLoadingAudios = false;
        });
      } else {
        setState(() {
          _audioLoadError = 'Failed to load audios';
          _isLoadingAudios = false;
        });
      }
    } catch (e) {
      setState(() {
        _audioLoadError = 'Network error: $e';
        _isLoadingAudios = false;
      });
    }
  }

  List<UserAudioTrack> _userAudioTracks = [];
  String? _selectedUserAudioPath;

  Widget _applyEffect(Widget child, EffectType effect, double strength) {
    switch (effect) {
      case EffectType.blur:
        // Blur effect - sigma range 0 to 5
        return ImageFiltered(
          imageFilter: ui.ImageFilter.blur(
            sigmaX: 5.0 * strength,
            sigmaY: 5.0 * strength,
          ),
          child: child,
        );

      case EffectType.grayscale:
        // Grayscale effect - interpolate between original and grayscale
        double intensity = strength; // 0 = color, 1 = grayscale
        return ColorFiltered(
          colorFilter: ColorFilter.matrix([
            // Standard grayscale matrix
            (0.2126 * intensity) + (1 - intensity),
            (0.7152 * intensity),
            (0.0722 * intensity),
            0,
            0,
            (0.2126 * intensity),
            (0.7152 * intensity) + (1 - intensity),
            (0.0722 * intensity),
            0,
            0,
            (0.2126 * intensity),
            (0.7152 * intensity),
            (0.0722 * intensity) + (1 - intensity),
            0,
            0,
            0, 0, 0, 1, 0,
          ]),
          child: child,
        );

      case EffectType.sepia:
        // Sepia effect - interpolate between original and sepia
        double intensity = strength;
        return ColorFiltered(
          colorFilter: ColorFilter.matrix([
            // Standard sepia matrix
            (0.393 * intensity) + (1 - intensity),
            (0.769 * intensity),
            (0.189 * intensity),
            0,
            0,
            (0.349 * intensity),
            (0.686 * intensity) + (1 - intensity),
            (0.168 * intensity),
            0,
            0,
            (0.272 * intensity),
            (0.534 * intensity),
            (0.131 * intensity) + (1 - intensity),
            0,
            0,
            0, 0, 0, 1, 0,
          ]),
          child: child,
        );

      case EffectType.brightness:
        // Brightness effect - adjust brightness
        double brightness = (strength - 0.5) * 2; // Range -1 to 1
        double offset = brightness * 100;
        return ColorFiltered(
          colorFilter: ColorFilter.matrix([
            1,
            0,
            0,
            0,
            offset,
            0,
            1,
            0,
            0,
            offset,
            0,
            0,
            1,
            0,
            offset,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: child,
        );

      case EffectType.contrast:
        // Contrast effect - adjust contrast
        double contrast = 1 + strength; // Range 1 to 2
        double translate = (1 - contrast) * 128;
        return ColorFiltered(
          colorFilter: ColorFilter.matrix([
            contrast,
            0,
            0,
            0,
            translate,
            0,
            contrast,
            0,
            0,
            translate,
            0,
            0,
            contrast,
            0,
            translate,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: child,
        );

      // Advanced effects (these should work as they are)
      case EffectType.ambient:
        return _applyAmbientEffect(child, strength);
      case EffectType.hyperChromatic:
        return _applyHyperChromaticEffect(child, strength);
      case EffectType.vintage:
        return _applyVintageEffect(child, strength);
      case EffectType.chromaticAberration:
        return _applyChromaticAberration(child, strength);
      case EffectType.grainyFilm:
        return _applyGrainyFilmEffect(child, strength);
      case EffectType.dreamyGlow:
        return _applyDreamyGlowEffect(child, strength);
      case EffectType.vaporwave:
        return _applyVaporwaveEffect(child, strength);
      case EffectType.cyberpunk:
        return _applyCyberpunkEffect(child, strength);
      case EffectType.cinematic:
        return _applyCinematicEffect(child, strength);
      case EffectType.polaroid:
        return _applyPolaroidEffect(child, strength);
      case EffectType.duotone:
        return _applyDuotoneEffect(child, strength);
      case EffectType.glitch:
        return _applyGlitchEffect(child, strength);

      default:
        return child;
    }
  }

  // 1. Ambient Realism - Soft, calm, natural
  Widget _applyAmbientEffect(Widget child, double strength) {
    double intensity = strength; // 0-1
    return ColorFiltered(
      colorFilter: ColorFilter.matrix([
        // Reduce contrast and saturation for calm look
        0.8 + (0.2 * (1 - intensity)), 0.1, 0.1, 0, 20 * intensity,
        0.1, 0.8 + (0.2 * (1 - intensity)), 0.1, 0, 20 * intensity,
        0.1, 0.1, 0.8 + (0.2 * (1 - intensity)), 0, 20 * intensity,
        0, 0, 0, 1, 0,
      ]),
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: 2 * intensity,
          sigmaY: 2 * intensity,
        ),
        child: child,
      ),
    );
  }

  // 2. Hyper Chromatic - Vibrant, electric colors
  Widget _applyHyperChromaticEffect(Widget child, double strength) {
    double sat = 1.5 + (strength * 1.5); // 1.5 to 3.0 saturation
    return ColorFiltered(
      colorFilter: ColorFilter.matrix([
        0.5 + sat * 0.5,
        0,
        0,
        0,
        0,
        0,
        0.5 + sat * 0.5,
        0,
        0,
        0,
        0,
        0,
        0.5 + sat * 0.5,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: child,
    );
  }

  // 3. Vintage/Retro - Warm, faded, nostalgic
  Widget _applyVintageEffect(Widget child, double strength) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix([
        0.8, 0.2, 0.1, 0, 30 * strength, // Warm red boost
        0.1, 0.7, 0.2, 0, 15 * strength, // Green reduced
        0.1, 0.1, 0.6, 0, 10 * strength, // Blue reduced more
        0, 0, 0, 0.8 + (0.2 * strength), 0, // Slight fade
      ]),
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: 0.5 * strength,
          sigmaY: 0.5 * strength,
        ),
        child: child,
      ),
    );
  }

  //   // 4. Chromatic Aberration - RGB split/glitch
  // Widget _applyChromaticAberration(Widget child, double strength) {
  //   // Only apply effect if strength > 0
  //   if (strength <= 0) return child;

  //   // Map strength (0-1) to offset range (0-12 pixels)
  //   // Max offset of 12 pixels gives a strong glitch effect at full strength
  //   double offset = 12 * strength;

  //   // Create a subtle blur at higher strengths to enhance the effect
  //   Widget baseChild = child;
  //   if (strength > 0.5) {
  //     double blurStrength = (strength - 0.5) * 4; // 0 to 2 sigma
  //     baseChild = ImageFiltered(
  //       imageFilter: ui.ImageFilter.blur(
  //         sigmaX: blurStrength,
  //         sigmaY: blurStrength,
  //       ),
  //       child: child,
  //     );
  //   }

  //   return Stack(
  //     children: [
  //       // Red channel shifted left
  //       Transform.translate(
  //         offset: Offset(-offset, 0),
  //         child: ColorFiltered(
  //           colorFilter: const ColorFilter.matrix([
  //             1, 0, 0, 0, 0,  // Red channel pass through
  //             0, 0, 0, 0, 0,  // Green channel removed
  //             0, 0, 0, 0, 0,  // Blue channel removed
  //             0, 0, 0, 1, 0,  // Alpha
  //           ]),
  //           child: baseChild,
  //         ),
  //       ),

  //       // Green channel shifted right (or left based on strength)
  //       Transform.translate(
  //         offset: Offset(offset * 0.7, 0),
  //         child: ColorFiltered(
  //           colorFilter: const ColorFilter.matrix([
  //             0, 0, 0, 0, 0,  // Red channel removed
  //             0, 1, 0, 0, 0,  // Green channel pass through
  //             0, 0, 0, 0, 0,  // Blue channel removed
  //             0, 0, 0, 1, 0,  // Alpha
  //           ]),
  //           child: baseChild,
  //         ),
  //       ),

  //       // Blue channel shifted right
  //       Transform.translate(
  //         offset: Offset(offset, 0),
  //         child: ColorFiltered(
  //           colorFilter: const ColorFilter.matrix([
  //             0, 0, 0, 0, 0,  // Red channel removed
  //             0, 0, 0, 0, 0,  // Green channel removed
  //             0, 0, 1, 0, 0,  // Blue channel pass through
  //             0, 0, 0, 1, 0,  // Alpha
  //           ]),
  //           child: baseChild,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // 4. Chromatic Aberration - RGB split/glitch (Light to Dark intensity)
  Widget _applyChromaticAberration(Widget child, double strength) {
    // No effect at strength 0
    if (strength <= 0) return child;

    // Map strength 0-1 to offset range 0-10 pixels
    // At low strength: subtle color fringing
    // At high strength: strong glitch effect
    final double offset = 10 * strength;

    // At low strength (0-0.3): subtle effect with opacity blending
    // At medium strength (0.3-0.7): stronger offset with some transparency
    // At high strength (0.7-1.0): full glitch with blending

    if (strength < 0.3) {
      // LIGHT EFFECT: Subtle color fringing
      final double opacity = strength / 0.3; // 0 to 1
      final double smallOffset = offset * 0.3;

      return Stack(
        children: [
          // Original image as base (80% opacity)
          Opacity(opacity: 1.0 - (opacity * 0.2), child: child),
          // Red channel subtle shift
          Opacity(
            opacity: opacity * 0.5,
            child: Transform.translate(
              offset: Offset(-smallOffset, 0),
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
                child: child,
              ),
            ),
          ),
          // Blue channel subtle shift opposite direction
          Opacity(
            opacity: opacity * 0.5,
            child: Transform.translate(
              offset: Offset(smallOffset, 0),
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
                child: child,
              ),
            ),
          ),
        ],
      );
    } else if (strength < 0.7) {
      // MEDIUM EFFECT: Noticeable RGB split
      final double intensity = (strength - 0.3) / 0.4; // 0 to 1
      final double currentOffset = offset * (0.3 + intensity * 0.7);

      return Stack(
        children: [
          // Red channel shifted left
          Transform.translate(
            offset: Offset(-currentOffset, 0),
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                1,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0.8,
                0,
              ]),
              child: child,
            ),
          ),
          // Green channel centered with slight shift up/down
          Transform.translate(
            offset: Offset(0, currentOffset * 0.3),
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0.8,
                0,
              ]),
              child: child,
            ),
          ),
          // Blue channel shifted right
          Transform.translate(
            offset: Offset(currentOffset, 0),
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                0.8,
                0,
              ]),
              child: child,
            ),
          ),
        ],
      );
    } else {
      // DARK/HEAVY EFFECT: Full glitch with scanlines and RGB split
      final double intensity = (strength - 0.7) / 0.3; // 0 to 1
      final double currentOffset = offset * (0.7 + intensity * 0.3);
      final double blurAmount = 1.0 * intensity;

      Widget baseChild = child;
      if (blurAmount > 0) {
        baseChild = ImageFiltered(
          imageFilter: ui.ImageFilter.blur(
            sigmaX: blurAmount,
            sigmaY: blurAmount,
          ),
          child: child,
        );
      }

      return Stack(
        children: [
          // Red channel heavily shifted left
          Transform.translate(
            offset: Offset(-currentOffset, 0),
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                1,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0.9,
                0,
              ]),
              child: baseChild,
            ),
          ),
          // Green channel shifted right with slight vertical
          Transform.translate(
            offset: Offset(currentOffset * 0.5, currentOffset * 0.2),
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0.9,
                0,
              ]),
              child: baseChild,
            ),
          ),
          // Blue channel shifted right and slightly down
          Transform.translate(
            offset: Offset(currentOffset, currentOffset * 0.1),
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                0.9,
                0,
              ]),
              child: baseChild,
            ),
          ),
          // Scanline overlay for heavy glitch
          if (strength > 0.85)
            Opacity(
              opacity: 0.15 * ((strength - 0.85) / 0.15),
              child: CustomPaint(
                painter: _ScanlinePainter(),
                size: const Size(double.infinity, double.infinity),
              ),
            ),
        ],
      );
    }
  }

  // 4. Chromatic Aberration - RGB split/glitch
  // Widget _applyChromaticAberration(Widget child, double strength) {
  //   double offset = 5 * strength;
  //   return Stack(
  //     children: [
  //       Transform.translate(
  //         offset: Offset(-offset, 0),
  //         child: ColorFiltered(
  //           colorFilter: const ColorFilter.matrix([
  //             1,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             1,
  //             0,
  //           ]),
  //           child: child,
  //         ),
  //       ),
  //       Transform.translate(
  //         offset: Offset(offset, 0),
  //         child: ColorFiltered(
  //           colorFilter: const ColorFilter.matrix([
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             1,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             0,
  //             1,
  //             0,
  //           ]),
  //           child: child,
  //         ),
  //       ),
  //       ColorFiltered(
  //         colorFilter: const ColorFilter.matrix([
  //           0,
  //           0,
  //           0,
  //           0,
  //           0,
  //           0,
  //           0,
  //           0,
  //           0,
  //           0,
  //           0,
  //           0,
  //           1,
  //           0,
  //           0,
  //           0,
  //           0,
  //           0,
  //           1,
  //           0,
  //         ]),
  //         child: child,
  //       ),
  //     ],
  //   );
  // }

  // 5. Grainy Film / Lo-Fi - Imperfect, textured
  Widget _applyGrainyFilmEffect(Widget child, double strength) {
    return ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          colors: [Colors.white, Colors.white],
        ).createShader(rect);
      },
      blendMode: BlendMode.modulate,
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: 1.5 * strength,
          sigmaY: 1.5 * strength,
        ),
        child: child,
      ),
    );
  }

  // 6. Dreamy Glow - Soft, ethereal, romantic
  Widget _applyDreamyGlowEffect(Widget child, double strength) {
    double intensity = strength; // 0-1
    return Stack(
      children: [
        // Base image with slight blur
        ImageFiltered(
          imageFilter: ui.ImageFilter.blur(
            sigmaX: 8 * intensity,
            sigmaY: 8 * intensity,
          ),
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.2, 0, 0, 0, 20 * intensity, // Increased brightness
              0, 1.2, 0, 0, 20 * intensity,
              0, 0, 1.2, 0, 20 * intensity,
              0, 0, 0, 0.7 + (0.3 * intensity), 0,
            ]),
            child: child,
          ),
        ),
        // Overlay with soft white glow
        Opacity(
          opacity: 0.3 * intensity,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.8,
                colors: [Colors.white.withOpacity(0.4), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 7. Vaporwave / Synthwave - 80s retro-futuristic
  Widget _applyVaporwaveEffect(Widget child, double strength) {
    double intensity = strength;
    return Stack(
      children: [
        // Base with pink/purple tint
        ColorFiltered(
          colorFilter: ColorFilter.matrix([
            1.2, 0.2, 0.3, 0, 30 * intensity, // Boost reds
            0.1, 0.8, 0.4, 0, 10 * intensity, // Slight green
            0.3, 0.1, 1.3, 0, 40 * intensity, // Boost blues
            0, 0, 0, 1, 0,
          ]),
          child: child,
        ),
        // Grid overlay (optional)
        if (intensity > 0.5)
          Opacity(
            opacity: 0.2 * (intensity - 0.5) * 2,
            child: CustomPaint(painter: _GridPainter(), size: Size.infinite),
          ),
      ],
    );
  }

  // 8. Cyberpunk Neon - High-tech urban
  Widget _applyCyberpunkEffect(Widget child, double strength) {
    double intensity = strength;
    return Stack(
      children: [
        // Darken and boost neon colors
        ColorFiltered(
          colorFilter: ColorFilter.matrix([
            1.3, 0.1, 0.2, 0, -20 * intensity, // Boost reds, darken
            0.1, 1.1, 0.3, 0, -25 * intensity, // Boost greens
            0.2, 0.1, 1.4, 0, -15 * intensity, // Boost blues
            0, 0, 0, 1.2, 0,
          ]),
          child: child,
        ),
        // Neon edge glow
        if (intensity > 0.3)
          Opacity(
            opacity: 0.4 * intensity,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.cyan.withOpacity(0.6),
                  width: 3 * intensity,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.5),
                    blurRadius: 10 * intensity,
                    spreadRadius: 2 * intensity,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // 9. Cinematic / Film Stock - Movie look
  Widget _applyCinematicEffect(Widget child, double strength) {
    double intensity = strength;
    return Stack(
      children: [
        // Teal and orange color grading
        ColorFiltered(
          colorFilter: ColorFilter.matrix([
            1.1, -0.1, 0.1, 0, 5 * intensity, // Slight red boost
            -0.1, 1.0, 0.2, 0, 0, // Normal green
            0.1, 0.1, 0.9, 0, -5 * intensity, // Reduce blue
            0, 0, 0, 1, 0,
          ]),
          child: child,
        ),
        // Letterbox bars
        if (intensity > 0.5)
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40 * ((intensity - 0.5) * 2),
                color: Colors.black.withOpacity(0.8),
              ),
              Container(
                height: 40 * ((intensity - 0.5) * 2),
                color: Colors.black.withOpacity(0.8),
              ),
            ],
          ),
        // Film grain
        if (intensity > 0.3)
          Opacity(
            opacity: 0.15 * intensity,
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Container(color: Colors.white),
            ),
          ),
      ],
    );
  }

  // 10. Polaroid / Instant Film - Vintage photo
  Widget _applyPolaroidEffect(Widget child, double strength) {
    double intensity = strength;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2 * intensity),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The photo with vintage effect
          Expanded(
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix([
                1.1,
                0.1,
                0,
                0,
                10 * intensity,
                0,
                1.0,
                0.1,
                0,
                5 * intensity,
                0,
                0,
                0.9,
                0,
                -5 * intensity,
                0,
                0,
                0,
                0.9,
                0,
              ]),
              child: child,
            ),
          ),
          // White border at bottom
          Container(
            height: 30 * (0.5 + intensity * 0.5),
            color: Colors.white,
            child: Center(
              child: Text(
                '✦ INSTANT ✦',
                style: TextStyle(
                  fontSize: 8 * intensity,
                  color: Colors.grey.shade400,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 11. Duotone - Two-color gradient effect
  Widget _applyDuotoneEffect(Widget child, double strength) {
    double intensity = strength;
    return ColorFiltered(
      colorFilter: ColorFilter.matrix([
        // Map to cyan and magenta duotone
        0.8, 0.2, 0, 0, 20 * intensity,
        0.1, 0.6, 0.3, 0, 10 * intensity,
        0.3, 0.1, 0.6, 0, 30 * intensity,
        0, 0, 0, 1, 0,
      ]),
      child: child,
    );
  }

  // 12. Glitch Art - Digital distortion
  Widget _applyGlitchEffect(Widget child, double strength) {
    double intensity = strength;
    return Stack(
      children: [
        // Main image
        child,

        // RGB split layers that shift randomly
        if (intensity > 0.2)
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 100),
            builder: (context, value, _) {
              double offset = 8 * intensity * (value > 0.5 ? 1 : -1);
              return Transform.translate(
                offset: Offset(offset, 0),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    1,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.5,
                    0,
                  ]),
                  child: child,
                ),
              );
            },
          ),

        if (intensity > 0.4)
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 150),
            builder: (context, value, _) {
              double offset = -8 * intensity * (value > 0.3 ? 1 : -1);
              return Transform.translate(
                offset: Offset(offset, 0),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.5,
                    0,
                  ]),
                  child: child,
                ),
              );
            },
          ),

        // Scanlines
        if (intensity > 0.6)
          Opacity(
            opacity: 0.3 * ((intensity - 0.6) / 0.4),
            child: CustomPaint(
              painter: _ScanlinePainter(),
              size: Size.infinite,
            ),
          ),
      ],
    );
  }

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
        return const EdgeInsets.fromLTRB(4, 45, 4, 40); // header + footer
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

  final String _baseUrl = 'http://31.97.228.17:4061/api/users';

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
    _fetchAdminAudios();
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

  // Future<void> _pickUserAudio() async {
  //   try {
  //     // Pick audio file
  //     FilePickerResult? result = await FilePicker.pickFiles(
  //       type: FileType.audio,
  //       allowMultiple: false,
  //     );

  //     if (result == null) return;

  //     String filePath = result.files.single.path!;
  //     String fileName = result.files.single.name;

  //     // Get audio duration
  //     final tempPlayer = AudioPlayer();
  //     await tempPlayer.setSourceDeviceFile(filePath);
  //     final duration = await tempPlayer.getDuration();
  //     await tempPlayer.dispose();

  //     if (duration == null) {
  //       _showErrorSnackBar('Could not read audio duration');
  //       return;
  //     }

  //     // Check if duration exceeds 30 seconds
  //     if (duration.inSeconds > 30) {
  //       _showErrorSnackBar(
  //         'Audio too long! Maximum 30 seconds allowed.\n'
  //         'Selected: ${duration.inSeconds} seconds',
  //       );
  //       return;
  //     }

  //     // Copy to app directory for persistence
  //     final tempDir = await getTemporaryDirectory();
  //     final savedPath =
  //         '${tempDir.path}/user_audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
  //     final File sourceFile = File(filePath);
  //     await sourceFile.copy(savedPath);

  //     // Add to user audio tracks list
  //     final userTrack = UserAudioTrack(
  //       name: fileName,
  //       filePath: savedPath,
  //       durationInSeconds: duration.inSeconds,
  //     );

  //     setState(() {
  //       _userAudioTracks.add(userTrack);
  //       _selectedUserAudioPath = savedPath;
  //       _selectedAudio = fileName;
  //     });

  //     // Play the selected audio
  //     await _playUserAudio(savedPath, fileName);

  //     _showSuccessSnackBar(
  //       'Audio added! Duration: ${duration.inSeconds} seconds',
  //     );
  //   } catch (e) {
  //     print('Error picking audio: $e');
  //     _showErrorSnackBar('Failed to pick audio: $e');
  //   }
  // }

  // Future<void> _pickUserAudio() async {
  //   try {
  //     // Pick audio file
  //     FilePickerResult? result = await FilePicker.pickFiles(
  //       type: FileType.audio,
  //       allowMultiple: false,
  //     );

  //     if (result == null) return;

  //     String filePath = result.files.single.path!;
  //     String fileName = result.files.single.name;

  //     // Show loading indicator
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => const Center(child: CircularProgressIndicator()),
  //     );

  //     try {
  //       // Get audio duration using a more reliable method
  //       final tempPlayer = AudioPlayer();
  //       await tempPlayer.setSourceDeviceFile(filePath);

  //       // Wait for duration to be available
  //       Duration? duration;
  //       int attempts = 0;
  //       while (duration == null && attempts < 10) {
  //         duration = await tempPlayer.getDuration();
  //         if (duration == null) {
  //           await Future.delayed(const Duration(milliseconds: 100));
  //           attempts++;
  //         }
  //       }

  //       await tempPlayer.dispose();

  //       // Check if duration was successfully retrieved
  //       if (duration == null) {
  //         Navigator.pop(context); // Close loading dialog
  //         _showErrorSnackBar(
  //           'Could not read audio duration. Please try another file.',
  //         );
  //         return;
  //       }

  //       print('Audio duration: ${duration.inSeconds} seconds');

  //       // Check if duration exceeds 30 seconds
  //       if (duration.inSeconds > 30) {
  //         Navigator.pop(context); // Close loading dialog
  //         _showErrorSnackBar(
  //           '❌ Audio too long!\n'
  //           'Maximum 30 seconds allowed.\n'
  //           'Selected: ${duration.inSeconds} seconds\n'
  //           'Please select a shorter audio file.',
  //         );
  //         return;
  //       }

  //       // Check if duration is too short (optional, minimum 1 second)
  //       if (duration.inSeconds < 1) {
  //         Navigator.pop(context);
  //         _showErrorSnackBar(
  //           'Audio is too short! Please select a longer audio file (minimum 1 second).',
  //         );
  //         return;
  //       }

  //       // Copy to app directory for persistence
  //       final tempDir = await getTemporaryDirectory();
  //       final savedPath =
  //           '${tempDir.path}/user_audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
  //       final File sourceFile = File(filePath);
  //       await sourceFile.copy(savedPath);

  //       // Add to user audio tracks list
  //       final userTrack = UserAudioTrack(
  //         name: fileName
  //             .replaceAll('.mp3', '')
  //             .replaceAll('.m4a', '')
  //             .replaceAll('.wav', ''),
  //         filePath: savedPath,
  //         durationInSeconds: duration.inSeconds,
  //       );

  //       // Close loading dialog
  //       Navigator.pop(context);

  //       setState(() {
  //         _userAudioTracks.add(userTrack);
  //         _selectedUserAudioPath = savedPath;
  //         _selectedAudio = userTrack.name;
  //       });

  //       // Play the selected audio
  //       await _playUserAudio(savedPath, userTrack.name);

  //       _showSuccessSnackBar(
  //         '✅ Audio added!\n'
  //         'Duration: ${duration.inSeconds} seconds',
  //       );
  //     } catch (e) {
  //       Navigator.pop(context); // Close loading dialog on error
  //       print('Error processing audio: $e');
  //       _showErrorSnackBar('Failed to process audio: ${e.toString()}');
  //     }
  //   } catch (e) {
  //     print('Error picking audio: $e');
  //     _showErrorSnackBar('Failed to pick audio: ${e.toString()}');
  //   }
  // }

  // Future<void> _pickUserAudio() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.pickFiles(
  //       type: FileType.audio,
  //       allowMultiple: false,
  //     );

  //     if (result == null) return;

  //     String filePath = result.files.single.path!;
  //     String fileName = result.files.single.name;

  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => const Center(child: CircularProgressIndicator()),
  //     );

  //     try {
  //       final tempPlayer = AudioPlayer();
  //       await tempPlayer.setSourceDeviceFile(filePath);

  //       Duration? duration;
  //       int attempts = 0;
  //       while (duration == null && attempts < 10) {
  //         duration = await tempPlayer.getDuration();
  //         if (duration == null) {
  //           await Future.delayed(const Duration(milliseconds: 100));
  //           attempts++;
  //         }
  //       }

  //       await tempPlayer.dispose();

  //       if (duration == null) {
  //         Navigator.pop(context);
  //         _showErrorSnackBar(
  //           'Could not read audio duration. Please try another file.',
  //         );
  //         return;
  //       }

  //       if (duration.inSeconds > 30) {
  //         Navigator.pop(context);
  //         _showErrorSnackBar(
  //           '❌ Audio too long!\n'
  //           'Maximum 30 seconds allowed.\n'
  //           'Selected: ${duration.inSeconds} seconds\n'
  //           'Please select a shorter audio file.',
  //         );
  //         return;
  //       }

  //       if (duration.inSeconds < 1) {
  //         Navigator.pop(context);
  //         _showErrorSnackBar(
  //           'Audio is too short! Please select a longer audio file (minimum 1 second).',
  //         );
  //         return;
  //       }

  //       final tempDir = await getTemporaryDirectory();
  //       final savedPath =
  //           '${tempDir.path}/user_audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
  //       final File sourceFile = File(filePath);
  //       await sourceFile.copy(savedPath);

  //       final userTrack = UserAudioTrack(
  //         name: fileName
  //             .replaceAll('.mp3', '')
  //             .replaceAll('.m4a', '')
  //             .replaceAll('.wav', ''),
  //         filePath: savedPath,
  //         durationInSeconds: duration.inSeconds,
  //       );

  //       // Close loading dialog
  //       Navigator.pop(context);

  //       setState(() => _isSelectingAudio = true);

  //       // Show confirmation dialog
  //       final bool? confirmed = await showDialog<bool>(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (ctx) => Dialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(24),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.all(14),
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xFFF5C518).withOpacity(0.15),
  //                     shape: BoxShape.circle,
  //                   ),
  //                   child: const Icon(
  //                     Icons.music_note_rounded,
  //                     size: 36,
  //                     color: Color(0xFFF5C518),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 16),
  //                 const Text(
  //                   'Add Audio?',
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   'Add "${userTrack.name}" to your poster?\nDuration: ${duration!.inSeconds} seconds',
  //                   textAlign: TextAlign.center,
  //                   style: const TextStyle(fontSize: 14, color: Colors.black54),
  //                 ),
  //                 const SizedBox(height: 24),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: OutlinedButton(
  //                         onPressed: () => Navigator.pop(ctx, false),
  //                         style: OutlinedButton.styleFrom(
  //                           padding: const EdgeInsets.symmetric(vertical: 13),
  //                           side: BorderSide(color: Colors.grey.shade300),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                         ),
  //                         child: const Text(
  //                           'No',
  //                           style: TextStyle(color: Colors.black54),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     Expanded(
  //                       child: ElevatedButton(
  //                         onPressed: () => Navigator.pop(ctx, true),
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: const Color(0xFFF5C518),
  //                           foregroundColor: Colors.black87,
  //                           padding: const EdgeInsets.symmetric(vertical: 13),
  //                           elevation: 0,
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                         ),
  //                         child: const Text(
  //                           'Yes, Add',
  //                           style: TextStyle(fontWeight: FontWeight.w600),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );

  //       setState(() => _isSelectingAudio = false);

  //       // User tapped No — delete the copied file and return
  //       if (confirmed != true) {
  //         try {
  //           final File savedFile = File(savedPath);
  //           if (await savedFile.exists()) {
  //             await savedFile.delete();
  //           }
  //         } catch (e) {
  //           print('Error deleting cancelled audio file: $e');
  //         }
  //         return;
  //       }

  //       // User tapped Yes — add the track and play it
  //       setState(() {
  //         _userAudioTracks.add(userTrack);
  //         _selectedUserAudioPath = savedPath;
  //         _selectedAudio = userTrack.name;
  //       });

  //       await _playUserAudio(savedPath, userTrack.name);

  //       _showSuccessSnackBar(
  //         '✅ Audio added!\nDuration: ${duration.inSeconds} seconds',
  //       );
  //     } catch (e) {
  //       Navigator.pop(context);
  //       print('Error processing audio: $e');
  //       _showErrorSnackBar('Failed to process audio: ${e.toString()}');
  //     }
  //   } catch (e) {
  //     print('Error picking audio: $e');
  //     _showErrorSnackBar('Failed to pick audio: ${e.toString()}');
  //   }
  // }

  Future<void> _pickUserAudio() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result == null) return;

      String filePath = result.files.single.path!;
      String fileName = result.files.single.name;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final tempPlayer = AudioPlayer();
        await tempPlayer.setSourceDeviceFile(filePath);

        Duration? duration;
        int attempts = 0;
        while (duration == null && attempts < 10) {
          duration = await tempPlayer.getDuration();
          if (duration == null) {
            await Future.delayed(const Duration(milliseconds: 100));
            attempts++;
          }
        }

        await tempPlayer.dispose();

        if (duration == null) {
          Navigator.pop(context);
          _showErrorSnackBar('Could not read audio duration.');
          return;
        }

        if (duration.inSeconds > 30) {
          Navigator.pop(context);
          _showErrorSnackBar('Audio too long! Max 30 seconds allowed.');
          return;
        }

        if (duration.inSeconds < 1) {
          Navigator.pop(context);
          _showErrorSnackBar('Audio too short! Minimum 1 second.');
          return;
        }

        final tempDir = await getTemporaryDirectory();
        final savedPath =
            '${tempDir.path}/user_audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
        await File(filePath).copy(savedPath);

        final userTrack = UserAudioTrack(
          name: fileName
              .replaceAll('.mp3', '')
              .replaceAll('.m4a', '')
              .replaceAll('.wav', ''),
          filePath: savedPath,
          durationInSeconds: duration.inSeconds,
        );

        Navigator.pop(context); // close loading

        // ✅ Directly add and play — no confirmation dialog here
        // AudioSelectionScreen will show confirmation
        setState(() {
          _userAudioTracks.add(userTrack);
        });

        _showSuccessSnackBar('✅ Audio added! ${duration.inSeconds}s');
      } catch (e) {
        Navigator.pop(context);
        _showErrorSnackBar('Failed to process audio: ${e.toString()}');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick audio: ${e.toString()}');
    }
  }
  // Future<void> _playUserAudio(String filePath, String fileName) async {
  //   try {
  //     await _audioPlayer.stop();
  //     await _audioPlayer.setReleaseMode(ReleaseMode.stop);

  //     await _audioPlayer.play(DeviceFileSource(filePath), volume: 1.0);

  //     setState(() {
  //       _isAudioPlaying = true;
  //       _selectedAudio = fileName;
  //     });

  //     _audioPlayer.onPlayerComplete.listen((event) {
  //       if (mounted) setState(() => _isAudioPlaying = false);
  //     });
  //   } catch (e) {
  //     setState(() => _isAudioPlaying = false);
  //     _showErrorSnackBar('Could not play audio: $e');
  //   }
  // }

  Future<void> _playUserAudio(String filePath, String fileName) async {
    try {
      // Stop any currently playing audio
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);

      // Check if file exists
      if (!await File(filePath).exists()) {
        _showErrorSnackBar('Audio file not found');
        return;
      }

      // Play the audio
      await _audioPlayer.play(DeviceFileSource(filePath), volume: 1.0);

      setState(() {
        _isAudioPlaying = true;
        _selectedAudio = fileName;
      });

      // Listen for completion
      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() => _isAudioPlaying = false);
          print('Audio playback completed');
        }
      });

      // Note: For audioplayers package, error handling is typically done via
      // the onPlayerComplete stream with error states, or using try-catch
      // around the play method. The package doesn't have a separate onPlayerError stream.
    } catch (e) {
      setState(() => _isAudioPlaying = false);
      print('Error playing audio: $e');
      _showErrorSnackBar('Could not play audio: ${e.toString()}');
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
    _audioPlayer.stop(); /////////////// Newly Addeddd/////////////
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

  // Future<void> _playAudio(String? trackName) async {
  //   try {
  //     await _audioPlayer.stop();
  //     await _audioPlayer.setReleaseMode(ReleaseMode.stop);

  //     if (trackName == null || trackName == 'No Audio') {
  //       setState(() {
  //         _isAudioPlaying = false;
  //         _selectedAudio = null;
  //         _selectedUserAudioPath = null;
  //       });
  //       return;
  //     }

  //     // Check if it's a user uploaded audio
  //     final userTrack = _userAudioTracks.firstWhere(
  //       (track) => track.name == trackName,
  //       orElse: () =>
  //           UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
  //     );

  //     // Check if it's an admin audio track
  //     final adminTrack = _adminAudioTracks.firstWhere(
  //       (track) => track.title == trackName,
  //       orElse: () =>
  //           AdminAudioTrack(id: '', title: '', artist: '', audioUrl: ''),
  //     );

  //     if (adminTrack.audioUrl.isNotEmpty) {
  //       await _audioPlayer.play(UrlSource(adminTrack.audioUrl), volume: 1.0);
  //       setState(() {
  //         _isAudioPlaying = true;
  //         _selectedAudio = trackName;
  //         _selectedUserAudioPath = null;
  //       });
  //       _audioPlayer.onPlayerComplete.listen((event) {
  //         if (mounted) setState(() => _isAudioPlaying = false);
  //       });
  //       return;
  //     }

  //     if (userTrack.filePath.isNotEmpty &&
  //         await File(userTrack.filePath).exists()) {
  //       // Play user uploaded audio
  //       await _audioPlayer.play(
  //         DeviceFileSource(userTrack.filePath),
  //         volume: 1.0,
  //       );
  //       setState(() {
  //         _isAudioPlaying = true;
  //         _selectedAudio = trackName;
  //         _selectedUserAudioPath = userTrack.filePath;
  //       });
  //     } else {
  //       // Play static asset audio
  //       final selectedTrack = _audioTracks.firstWhere(
  //         (track) => track.name == trackName,
  //       );
  //       await _audioPlayer.play(
  //         AssetSource(selectedTrack.assetPath),
  //         volume: 1.0,
  //       );
  //       setState(() {
  //         _isAudioPlaying = true;
  //         _selectedAudio = trackName;
  //         _selectedUserAudioPath = null;
  //       });
  //     }

  //     _audioPlayer.onPlayerComplete.listen((event) {
  //       if (mounted) setState(() => _isAudioPlaying = false);
  //     });
  //   } catch (e) {
  //     setState(() => _isAudioPlaying = false);
  //     _showErrorSnackBar('Could not play audio: $e');
  //   }
  // }

  //   Future<void> _playAudio(String? trackName) async {
  //   if (trackName == null || trackName == 'No Audio') {
  //     await _audioPlayer.stop();
  //     setState(() {
  //       _isAudioPlaying = false;
  //       _selectedAudio = null;
  //       _selectedUserAudioPath = null;
  //     });
  //     return;
  //   }

  //   // ── Show confirmation dialog before applying ──
  //   final bool? confirmed = await showDialog<bool>(
  //     context: context,
  //     builder: (ctx) => Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       child: Padding(
  //         padding: const EdgeInsets.all(24),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(14),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFFF5C518).withOpacity(0.15),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: const Icon(
  //                 Icons.music_note_rounded,
  //                 size: 36,
  //                 color: Color(0xFFF5C518),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             const Text(
  //               'Add Audio?',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 8),
  //             Text(
  //               'Add "$trackName" to your poster?',
  //               textAlign: TextAlign.center,
  //               style: const TextStyle(fontSize: 14, color: Colors.black54),
  //             ),
  //             const SizedBox(height: 24),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: OutlinedButton(
  //                     onPressed: () => Navigator.pop(ctx, false),
  //                     style: OutlinedButton.styleFrom(
  //                       padding: const EdgeInsets.symmetric(vertical: 13),
  //                       side: BorderSide(color: Colors.grey.shade300),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                     ),
  //                     child: const Text(
  //                       'No',
  //                       style: TextStyle(color: Colors.black54),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Expanded(
  //                   child: ElevatedButton(
  //                     onPressed: () => Navigator.pop(ctx, true),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: const Color(0xFFF5C518),
  //                       foregroundColor: Colors.black87,
  //                       padding: const EdgeInsets.symmetric(vertical: 13),
  //                       elevation: 0,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                     ),
  //                     child: const Text(
  //                       'Yes, Add',
  //                       style: TextStyle(fontWeight: FontWeight.w600),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );

  //   if (confirmed != true) return; // User tapped No — do nothing

  //   // ── User confirmed — apply and play the audio ──
  //   try {
  //     await _audioPlayer.stop();
  //     await _audioPlayer.setReleaseMode(ReleaseMode.stop);

  //     final userTrack = _userAudioTracks.firstWhere(
  //       (track) => track.name == trackName,
  //       orElse: () =>
  //           UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
  //     );

  //     final adminTrack = _adminAudioTracks.firstWhere(
  //       (track) => track.title == trackName,
  //       orElse: () =>
  //           AdminAudioTrack(id: '', title: '', artist: '', audioUrl: ''),
  //     );

  //     if (adminTrack.audioUrl.isNotEmpty) {
  //       await _audioPlayer.play(UrlSource(adminTrack.audioUrl), volume: 1.0);
  //       setState(() {
  //         _isAudioPlaying = true;
  //         _selectedAudio = trackName;
  //         _selectedUserAudioPath = null;
  //       });
  //     } else if (userTrack.filePath.isNotEmpty &&
  //         await File(userTrack.filePath).exists()) {
  //       await _audioPlayer.play(DeviceFileSource(userTrack.filePath), volume: 1.0);
  //       setState(() {
  //         _isAudioPlaying = true;
  //         _selectedAudio = trackName;
  //         _selectedUserAudioPath = userTrack.filePath;
  //       });
  //     } else {
  //       final selectedTrack = _audioTracks.firstWhere(
  //         (track) => track.name == trackName,
  //       );
  //       await _audioPlayer.play(AssetSource(selectedTrack.assetPath), volume: 1.0);
  //       setState(() {
  //         _isAudioPlaying = true;
  //         _selectedAudio = trackName;
  //         _selectedUserAudioPath = null;
  //       });
  //     }

  //     _audioPlayer.onPlayerComplete.listen((event) {
  //       if (mounted) setState(() => _isAudioPlaying = false);
  //     });
  //   } catch (e) {
  //     setState(() => _isAudioPlaying = false);
  //     _showErrorSnackBar('Could not play audio: $e');
  //   }
  // }

  // Future<void> _playAudio(String? trackName) async {
  //   if (trackName == null || trackName == 'No Audio') {
  //     await _audioPlayer.stop();
  //     setState(() {
  //       _isAudioPlaying = false;
  //       _selectedAudio = null;
  //       _selectedUserAudioPath = null;
  //       _isSelectingAudio = false;
  //     });
  //     return;
  //   }

  //   // Hide poster background while user decides
  //   setState(() => _isSelectingAudio = true);

  //   final bool? confirmed = await showDialog<bool>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (ctx) {
  //       final isDark = Theme.of(ctx).brightness == Brightness.dark;
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
  //         child: Padding(
  //           padding: const EdgeInsets.all(24),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(14),
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFF5C518).withOpacity(0.15),
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: const Icon(
  //                   Icons.music_note_rounded,
  //                   size: 36,
  //                   color: Color(0xFFF5C518),
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               Text(
  //                 'Add Audio?',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: isDark ? Colors.white : Colors.black87,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 'Add "$trackName" to your poster?',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: isDark ? Colors.white54 : Colors.black54,
  //                 ),
  //               ),
  //               const SizedBox(height: 24),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: OutlinedButton(
  //                       onPressed: () => Navigator.pop(ctx, false),
  //                       style: OutlinedButton.styleFrom(
  //                         padding: const EdgeInsets.symmetric(vertical: 13),
  //                         side: BorderSide(
  //                           color: isDark
  //                               ? Colors.white24
  //                               : Colors.grey.shade300,
  //                         ),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                       ),
  //                       child: Text(
  //                         'No',
  //                         style: TextStyle(
  //                           color: isDark ? Colors.white54 : Colors.black54,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   Expanded(
  //                     child: ElevatedButton(
  //                       onPressed: () => Navigator.pop(ctx, true),
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: const Color(0xFFF5C518),
  //                         foregroundColor: Colors.black87,
  //                         padding: const EdgeInsets.symmetric(vertical: 13),
  //                         elevation: 0,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                       ),
  //                       child: const Text(
  //                         'Yes, Add',
  //                         style: TextStyle(fontWeight: FontWeight.w600),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );

  //   // User tapped No — restore poster, change nothing
  //   if (confirmed != true) {
  //     setState(() => _isSelectingAudio = false);
  //     return;
  //   }

  //   // User tapped Yes — restore poster then apply audio
  //   setState(() => _isSelectingAudio = false);

  //   try {
  //     await _audioPlayer.stop();
  //     await _audioPlayer.setReleaseMode(ReleaseMode.stop);

  //     final userTrack = _userAudioTracks.firstWhere(
  //       (track) => track.name == trackName,
  //       orElse: () =>
  //           UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
  //     );

  //     final adminTrack = _adminAudioTracks.firstWhere(
  //       (track) => track.title == trackName,
  //       orElse: () =>
  //           AdminAudioTrack(id: '', title: '', artist: '', audioUrl: ''),
  //     );

  //     if (adminTrack.audioUrl.isNotEmpty) {
  //       await _audioPlayer.play(UrlSource(adminTrack.audioUrl), volume: 1.0);
  //       setState(() {
  //         _isAudioPlaying = true;
  //         _selectedAudio = trackName;
  //         _selectedUserAudioPath = null;
  //       });
  //     } else if (userTrack.filePath.isNotEmpty &&
  //         await File(userTrack.filePath).exists()) {
  //       await _audioPlayer.play(
  //         DeviceFileSource(userTrack.filePath),
  //         volume: 1.0,
  //       );
  //       setState(() {
  //         _isAudioPlaying = true;
  //         _selectedAudio = trackName;
  //         _selectedUserAudioPath = userTrack.filePath;
  //       });
  //     } else {
  //       final selectedTrack = _audioTracks.firstWhere(
  //         (track) => track.name == trackName,
  //       );
  //       await _audioPlayer.play(
  //         AssetSource(selectedTrack.assetPath),
  //         volume: 1.0,
  //       );
  //       setState(() {
  //         _isAudioPlaying = true;
  //         _selectedAudio = trackName;
  //         _selectedUserAudioPath = null;
  //       });
  //     }

  //     _audioPlayer.onPlayerComplete.listen((event) {
  //       if (mounted) setState(() => _isAudioPlaying = false);
  //     });
  //   } catch (e) {
  //     setState(() => _isAudioPlaying = false);
  //     _showErrorSnackBar('Could not play audio: $e');
  //   }
  // }

  Future<void> _playAudio(String? trackName) async {
    if (trackName == null || trackName == 'No Audio') {
      await _audioPlayer.stop();
      setState(() {
        _isAudioPlaying = false;
        _selectedAudio = null;
        _selectedUserAudioPath = null;
        _isSelectingAudio = false;
      });
      return;
    }

    // ✅ REMOVED confirmation dialog — AudioSelectionScreen handles it

    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);

      final userTrack = _userAudioTracks.firstWhere(
        (track) => track.name == trackName,
        orElse: () =>
            UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
      );

      final adminTrack = _adminAudioTracks.firstWhere(
        (track) => track.title == trackName,
        orElse: () =>
            AdminAudioTrack(id: '', title: '', artist: '', audioUrl: ''),
      );

      if (adminTrack.audioUrl.isNotEmpty) {
        await _audioPlayer.play(UrlSource(adminTrack.audioUrl), volume: 1.0);
        setState(() {
          _isAudioPlaying = true;
          _selectedAudio = trackName;
          _selectedUserAudioPath = null;
        });
      } else if (userTrack.filePath.isNotEmpty &&
          await File(userTrack.filePath).exists()) {
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

  // void _openTextEditor(OverlayTextItem item) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) => _TextEditorSheet(
  //       item: item,
  //       onChanged: (updated) {
  //         setState(() {
  //           final idx = _texts.indexWhere((t) => t.id == updated.id);
  //           if (idx != -1) _texts[idx] = updated;
  //         });
  //       },
  //     ),
  //   );
  // }

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
        onDelete: () {
          setState(() {
            _texts.removeWhere((t) => t.id == item.id);
            if (_selectedTextId == item.id) {
              _selectedTextId = null;
            }
          });
          // Show success snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Text deleted'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
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
  //           // Check for user audio first
  //           final userTrack = _userAudioTracks.firstWhere(
  //             (track) => track.name == _selectedAudio,
  //             orElse: () =>
  //                 UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
  //           );

  //           Duration? duration;

  //           if (userTrack.filePath.isNotEmpty &&
  //               await File(userTrack.filePath).exists()) {
  //             // User audio file
  //             final probe = AudioPlayer();
  //             await probe.setSourceDeviceFile(userTrack.filePath);
  //             duration = await probe.getDuration();
  //             await probe.dispose();
  //             print('User audio duration: ${duration?.inSeconds} seconds');
  //           } else {
  //             // Static audio asset
  //             const Map<String, String> audioAssets = {
  //               'Upbeat Pop':
  //                   'assets/audio/Aaja Mahiya - Lofi _ Slowed Reverb.mp3',
  //               'Calm Acoustic':
  //                   'assets/audio/Bharosa Karlo Tum Sath Nibhaunga - Lofi _ Slowed Reverb.mp3',
  //               'Corporate':
  //                   'assets/audio/Jana Mere Sawalo Ka Manzar Tu - Lofi _ Slowed Reverb.mp3',
  //               'Cinematic':
  //                   'assets/audio/Mere Ganpati Deva - Lofi _ Slowed Reverb.mp3',
  //               'Electronic':
  //                   'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //               'Jazz Lounge':
  //                   'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //             };

  //             final String? assetPath = audioAssets[_selectedAudio];
  //             if (assetPath != null) {
  //               final ByteData audioData = await rootBundle.load(assetPath);
  //               final File tempAudioProbe = File(
  //                 '${tempDir.path}/temp_audio_probe_${DateTime.now().millisecondsSinceEpoch}.mp3',
  //               );
  //               await tempAudioProbe.writeAsBytes(
  //                 audioData.buffer.asUint8List(),
  //               );

  //               final probe = AudioPlayer();
  //               await probe.setSourceDeviceFile(tempAudioProbe.path);
  //               duration = await probe.getDuration();
  //               await probe.dispose();

  //               // Clean up temp file
  //               try {
  //                 await tempAudioProbe.delete();
  //               } catch (e) {}
  //             }
  //           }

  //           if (duration != null && duration.inSeconds > 0) {
  //             videoDurationSec = duration.inSeconds;
  //             print('Using audio duration: $videoDurationSec seconds');
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
  //           // First, check if it's a user-uploaded audio
  //           final userTrack = _userAudioTracks.firstWhere(
  //             (track) => track.name == _selectedAudio,
  //             orElse: () =>
  //                 UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
  //           );

  //           if (userTrack.filePath.isNotEmpty &&
  //               await File(userTrack.filePath).exists()) {
  //             // This is a user-uploaded audio file - copy it to temp directory
  //             final File sourceFile = File(userTrack.filePath);
  //             final File tempAudioFile = File(
  //               '${tempDir.path}/temp_user_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
  //             );
  //             await sourceFile.copy(tempAudioFile.path);
  //             audioFilePath = tempAudioFile.path;
  //             print('Using user audio file: ${userTrack.name}');
  //           } else {
  //             // Check static audio assets
  //             const Map<String, String> audioAssets = {
  //               'Upbeat Pop':
  //                   'assets/audio/Aaja Mahiya - Lofi _ Slowed Reverb.mp3',
  //               'Calm Acoustic':
  //                   'assets/audio/Bharosa Karlo Tum Sath Nibhaunga - Lofi _ Slowed Reverb.mp3',
  //               'Corporate':
  //                   'assets/audio/Jana Mere Sawalo Ka Manzar Tu - Lofi _ Slowed Reverb.mp3',
  //               'Cinematic':
  //                   'assets/audio/Mere Ganpati Deva - Lofi _ Slowed Reverb.mp3',
  //               'Electronic':
  //                   'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //               'Jazz Lounge':
  //                   'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //             };

  //             final String? assetPath = audioAssets[_selectedAudio];
  //             if (assetPath != null) {
  //               final ByteData audioData = await rootBundle.load(assetPath);
  //               final File tempAudioFile = File(
  //                 '${tempDir.path}/temp_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
  //               );
  //               await tempAudioFile.writeAsBytes(
  //                 audioData.buffer.asUint8List(),
  //               );
  //               audioFilePath = tempAudioFile.path;
  //               print('Using static audio file: $_selectedAudio');
  //             }
  //           }
  //         } catch (e) {
  //           print('Error loading audio for video: $e');
  //         }
  //       }

  //       final String outputPath =
  //           '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.mp4';
  //       String ffmpegCommand;

  //       if (audioFilePath != null && await File(audioFilePath).exists()) {
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
  //         if (audioFilePath != null) {
  //           final audioFile = File(audioFilePath);
  //           if (await audioFile.exists()) {
  //             await audioFile.delete();
  //           }
  //         }
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

  ////////////////////////  New code for reducing the time of exporting audio//////////////

  //   void _startDownload() async {
  //     print("gggggggggggggggggggggggg${_planProvider?.isPurchase}");
  //     // if (!_planProvider!.isPurchase) {
  //     //   _showPremiumModal();
  //     //   return;
  //     // }
  //     print("Starting download/export...");

  //     setState(() {
  //       _isDownloading = true;
  //       _downloadProgress = 0;
  //     });

  //     try {
  //       if (_isAnimated) {
  //         setState(() => _downloadProgress = 0.05);
  //         final tempDir = await getTemporaryDirectory();

  //         final framesDir = Directory(
  //           '${tempDir.path}/poster_frames_${DateTime.now().millisecondsSinceEpoch}',
  //         );
  //         await framesDir.create(recursive: true);

  //         // Get audio duration
  //         int videoDurationSec = 3;
  //         if (_selectedAudio != null && _selectedAudio != 'No Audio') {
  //           try {
  //             Duration? duration;

  //             // Check user uploaded audio
  //             final userTrack = _userAudioTracks.firstWhere(
  //               (track) => track.name == _selectedAudio,
  //               orElse: () =>
  //                   UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
  //             );

  //             if (userTrack.filePath.isNotEmpty &&
  //                 await File(userTrack.filePath).exists()) {
  //               final probe = AudioPlayer();
  //               await probe.setSourceDeviceFile(userTrack.filePath);
  //               duration = await probe.getDuration();
  //               await probe.dispose();
  //             } else {
  //               final adminTrack = _adminAudioTracks.firstWhere(
  //                 (track) => track.title == _selectedAudio,
  //                 orElse: () => AdminAudioTrack(
  //                   id: '',
  //                   title: '',
  //                   artist: '',
  //                   audioUrl: '',
  //                 ),
  //               );

  //               if (adminTrack.audioUrl.isNotEmpty) {
  //                 final response = await http.get(Uri.parse(adminTrack.audioUrl));
  //                 if (response.statusCode == 200) {
  //                   final tempAudioProbe = File(
  //                     '${tempDir.path}/temp_audio_probe_${DateTime.now().millisecondsSinceEpoch}.mp3',
  //                   );
  //                   await tempAudioProbe.writeAsBytes(response.bodyBytes);
  //                   final probe = AudioPlayer();
  //                   await probe.setSourceDeviceFile(tempAudioProbe.path);
  //                   duration = await probe.getDuration();
  //                   await probe.dispose();
  //                   await tempAudioProbe.delete();
  //                 }
  //               }
  //             }

  //             if (duration != null && duration.inSeconds > 0) {
  //               videoDurationSec = duration.inSeconds;
  //               // Cap at 15 seconds to avoid long exports
  //               if (videoDurationSec > 15) {
  //                 videoDurationSec = 15;
  //                 print("Capping video duration to 15 seconds for faster export");
  //               }
  //             }
  //           } catch (e) {
  //             print('Could not get audio duration: $e');
  //           }
  //         }

  //         // OPTIMIZATION 1: Reduce FPS from 30 to 20
  //         const int fps = 20;
  //         final int totalFrames = videoDurationSec * fps;
  //         final int animationDurationMs = videoDurationSec * 1000;

  //         final bool wasAnimating = _animController.isAnimating;
  //         if (wasAnimating) {
  //           _animController.stop();
  //           _brandAnimController.stop();
  //         }

  //         final int frameDelayMs = animationDurationMs ~/ totalFrames;

  //         // OPTIMIZATION 2: Generate frames at lower resolution first
  //         for (int i = 0; i < totalFrames; i++) {
  //           final DateTime frameStartTime = DateTime.now();
  //           final double progress = (i % fps) / fps;

  //           double animValue;
  //           switch (_selectedAnimation) {
  //             case AnimationType.none:
  //               animValue = 1.0;
  //               break;
  //             case AnimationType.rotate:
  //             case AnimationType.flipIn:
  //             case AnimationType.wobble:
  //             case AnimationType.rollin:
  //               animValue = progress;
  //               break;
  //             default:
  //               animValue = (sin(progress * pi) * 0.5) + 0.5;
  //           }

  //           _animController.value = animValue;
  //           _brandAnimController.value = progress;
  //           setState(() {});

  //           // OPTIMIZATION 3: Reduced wait time
  //           await WidgetsBinding.instance.endOfFrame;
  //           await Future.delayed(const Duration(milliseconds: 2));

  //           final RenderRepaintBoundary? boundary =
  //               _posterKey.currentContext?.findRenderObject()
  //                   as RenderRepaintBoundary?;
  //           if (boundary == null) throw Exception('Poster context not found');

  //           // OPTIMIZATION 4: Lower pixel ratio from 2.0 to 1.2 for video
  //           final ui.Image image = await boundary.toImage(pixelRatio: 1.2);
  //           final ByteData? byteData = await image.toByteData(
  //             format: ui.ImageByteFormat.png,
  //           );
  //           if (byteData == null) throw Exception('Frame $i encoding failed');

  //           final File frameFile = File(
  //             '${framesDir.path}/frame_${i.toString().padLeft(4, '0')}.png',
  //           );
  //           await frameFile.writeAsBytes(byteData.buffer.asUint8List());

  //           final int elapsedMs = DateTime.now()
  //               .difference(frameStartTime)
  //               .inMilliseconds;
  //           final int remainingDelay = frameDelayMs - elapsedMs;
  //           if (remainingDelay > 0) {
  //             await Future.delayed(Duration(milliseconds: remainingDelay));
  //           }

  //           setState(() => _downloadProgress = 0.05 + (i / totalFrames) * 0.55);
  //         }

  //         setState(() => _downloadProgress = 0.62);
  //         String? audioFilePath;

  //         if (_selectedAudio != null && _selectedAudio != 'No Audio') {
  //           try {
  //             final userTrack = _userAudioTracks.firstWhere(
  //               (track) => track.name == _selectedAudio,
  //               orElse: () =>
  //                   UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
  //             );

  //             if (userTrack.filePath.isNotEmpty &&
  //                 await File(userTrack.filePath).exists()) {
  //               final File sourceFile = File(userTrack.filePath);
  //               final File tempAudioFile = File(
  //                 '${tempDir.path}/temp_user_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
  //               );
  //               await sourceFile.copy(tempAudioFile.path);
  //               audioFilePath = tempAudioFile.path;
  //             } else {
  //               final adminTrack = _adminAudioTracks.firstWhere(
  //                 (track) => track.title == _selectedAudio,
  //                 orElse: () => AdminAudioTrack(
  //                   id: '',
  //                   title: '',
  //                   artist: '',
  //                   audioUrl: '',
  //                 ),
  //               );

  //               if (adminTrack.audioUrl.isNotEmpty) {
  //                 final response = await http.get(Uri.parse(adminTrack.audioUrl));
  //                 if (response.statusCode == 200) {
  //                   final File tempAudioFile = File(
  //                     '${tempDir.path}/temp_admin_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
  //                   );
  //                   await tempAudioFile.writeAsBytes(response.bodyBytes);
  //                   audioFilePath = tempAudioFile.path;
  //                 }
  //               }
  //             }
  //           } catch (e) {
  //             print('Error loading audio for video: $e');
  //           }
  //         }

  //         final String outputPath =
  //             '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.mp4';

  //         // OPTIMIZATION 5: Use faster FFmpeg presets
  //         String ffmpegCommand;
  //         if (audioFilePath != null && await File(audioFilePath).exists()) {
  //           ffmpegCommand =
  //               '-y -framerate $fps -i "${framesDir.path}/frame_%04d.png" '
  //               '-i "$audioFilePath" '
  //               '-c:v libx264 -pix_fmt yuv420p -c:a aac -shortest '
  //               '-crf 28 -preset ultrafast ' // CRF 28 is lower quality but MUCH faster, ultrafast preset
  //               '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
  //               '"$outputPath"';
  //         } else {
  //           ffmpegCommand =
  //               '-y -framerate $fps -i "${framesDir.path}/frame_%04d.png" '
  //               '-c:v libx264 -pix_fmt yuv420p '
  //               '-crf 28 -preset ultrafast ' // Faster encoding settings
  //               '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
  //               '"$outputPath"';
  //         }

  //         setState(() => _downloadProgress = 0.65);
  //         print("Running FFmpeg command...");
  //         final ffmpegSession = await FFmpegKit.execute(ffmpegCommand);
  //         final ReturnCode? returnCode = await ffmpegSession.getReturnCode();
  //         setState(() => _downloadProgress = 0.88);

  //         if (!ReturnCode.isSuccess(returnCode)) {
  //           final logs = await ffmpegSession.getAllLogsAsString();
  //           print("FFmpeg failed: $logs");
  //           throw Exception('FFmpeg failed to create video');
  //         }

  //         // Check if video file exists and has content
  //         final videoFile = File(outputPath);
  //         if (!await videoFile.exists() || await videoFile.length() == 0) {
  //           throw Exception('Generated video file is empty');
  //         }

  //         final bool hasAccess = await Gal.hasAccess();
  //         if (!hasAccess) await Gal.requestAccess();
  //         await Gal.putVideo(outputPath, album: 'Poster Editor');
  //         setState(() => _downloadProgress = 1.0);

  //         // Clean up
  //         try {
  //           await framesDir.delete(recursive: true);
  //           if (audioFilePath != null) {
  //             final audioFile = File(audioFilePath);
  //             if (await audioFile.exists()) {
  //               await audioFile.delete();
  //             }
  //           }
  //         } catch (e) {}

  //         if (wasAnimating && mounted) {
  //           _animController.repeat(reverse: true);
  //           _brandAnimController.repeat();
  //         }

  //         await Future.delayed(const Duration(milliseconds: 400));
  //         if (mounted) {
  //           setState(() => _isDownloading = false);
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(
  //                 audioFilePath != null
  //                     ? '✅ Video with audio saved to gallery!'
  //                     : '✅ Video saved to gallery!',
  //               ),
  //               backgroundColor: const Color(0xFF2E7D32),
  //               duration: const Duration(seconds: 3),
  //             ),
  //           );
  //         }
  //       }
  //       // else {
  //       //   // Static image download - keep as is but add optimization
  //       //   setState(() => _downloadProgress = 0.2);
  //       //   await Future.delayed(const Duration(milliseconds: 300));
  //       //   final RenderRepaintBoundary? boundary =
  //       //       _posterKey.currentContext?.findRenderObject()
  //       //           as RenderRepaintBoundary?;
  //       //   if (boundary == null) throw Exception('Poster not found.');
  //       //   setState(() => _downloadProgress = 0.4);
  //       //   await Future.delayed(const Duration(milliseconds: 100));
  //       //   // For images, we can keep higher quality since it's just one frame
  //       //   final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
  //       //   setState(() => _downloadProgress = 0.65);
  //       //   final ByteData? byteData = await image.toByteData(
  //       //     format: ui.ImageByteFormat.png,
  //       //   );
  //       //   if (byteData == null) throw Exception('Failed to encode image');
  //       //   setState(() => _downloadProgress = 0.8);
  //       //   final Uint8List pngBytes = byteData.buffer.asUint8List();
  //       //   final Directory tempDir = await getTemporaryDirectory();
  //       //   final String fileName =
  //       //       'poster_${DateTime.now().millisecondsSinceEpoch}.png';
  //       //   final File file = File('${tempDir.path}/$fileName');
  //       //   await file.writeAsBytes(pngBytes);
  //       //   setState(() => _downloadProgress = 0.92);
  //       //   final bool hasAccess = await Gal.hasAccess();
  //       //   if (!hasAccess) await Gal.requestAccess();
  //       //   await Gal.putImage(file.path, album: 'Poster Editor');
  //       //   setState(() => _downloadProgress = 1.0);
  //       //   await Future.delayed(const Duration(milliseconds: 400));
  //       //   if (mounted) {
  //       //     setState(() => _isDownloading = false);
  //       //     ScaffoldMessenger.of(context).showSnackBar(
  //       //       const SnackBar(
  //       //         content: Text('✅ Image saved to gallery!'),
  //       //         backgroundColor: Color(0xFF2E7D32),
  //       //         duration: Duration(seconds: 3),
  //       //       ),
  //       //     );
  //       //   }
  //       // }
  //       // else {
  //       //   // ── Static image download ──
  //       //   setState(() => _downloadProgress = 0.2);
  //       //   await Future.delayed(const Duration(milliseconds: 300));

  //       //   final RenderRepaintBoundary? boundary =
  //       //       _posterKey.currentContext?.findRenderObject()
  //       //           as RenderRepaintBoundary?;
  //       //   if (boundary == null) throw Exception('Poster not found.');

  //       //   setState(() => _downloadProgress = 0.4);
  //       //   await Future.delayed(const Duration(milliseconds: 100));

  //       //   // ✅ FIX: Use higher pixel ratio for better quality
  //       //   // 3.0 for good quality, 4.0 for HD quality
  //       //   final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

  //       //   setState(() => _downloadProgress = 0.65);
  //       //   final ByteData? byteData = await image.toByteData(
  //       //     format: ui.ImageByteFormat.png,
  //       //   );
  //       //   if (byteData == null) throw Exception('Failed to encode image');
  //       //   setState(() => _downloadProgress = 0.8);

  //       //   final Uint8List pngBytes = byteData.buffer.asUint8List();

  //       //   // Optional: Compress the image if needed for file size
  //       //   // Using image package to compress while maintaining quality
  //       //   img.Image? decodedImage = img.decodeImage(pngBytes);
  //       //   if (decodedImage != null) {
  //       //     // Compress with 95% quality (good balance between quality and size)
  //       //     final compressedBytes = img.encodeJpg(decodedImage, quality: 95);
  //       //     final Directory tempDir = await getTemporaryDirectory();
  //       //     final String fileName =
  //       //         'poster_${DateTime.now().millisecondsSinceEpoch}.jpg';
  //       //     final File file = File('${tempDir.path}/$fileName');
  //       //     await file.writeAsBytes(compressedBytes);

  //       //     final bool hasAccess = await Gal.hasAccess();
  //       //     if (!hasAccess) await Gal.requestAccess();
  //       //     await Gal.putImage(file.path, album: 'Poster Editor');
  //       //     setState(() => _downloadProgress = 1.0);
  //       //   } else {
  //       //     // Fallback to PNG if compression fails
  //       //     final Directory tempDir = await getTemporaryDirectory();
  //       //     final String fileName =
  //       //         'poster_${DateTime.now().millisecondsSinceEpoch}.png';
  //       //     final File file = File('${tempDir.path}/$fileName');
  //       //     await file.writeAsBytes(pngBytes);

  //       //     final bool hasAccess = await Gal.hasAccess();
  //       //     if (!hasAccess) await Gal.requestAccess();
  //       //     await Gal.putImage(file.path, album: 'Poster Editor');
  //       //     setState(() => _downloadProgress = 1.0);
  //       //   }

  //       //   await Future.delayed(const Duration(milliseconds: 400));
  //       //   if (mounted) {
  //       //     setState(() => _isDownloading = false);
  //       //     ScaffoldMessenger.of(context).showSnackBar(
  //       //       const SnackBar(
  //       //         content: Text('✅ Image saved to gallery!'),
  //       //         backgroundColor: Color(0xFF2E7D32),
  //       //         duration: Duration(seconds: 3),
  //       //       ),
  //       //     );
  //       //   }
  //       // }

  //      else {
  //   setState(() => _downloadProgress = 0.2);
  //   await Future.delayed(const Duration(milliseconds: 300));

  //   final RenderRepaintBoundary? boundary =
  //       _posterKey.currentContext?.findRenderObject()
  //           as RenderRepaintBoundary?;
  //   if (boundary == null) throw Exception('Poster not found.');

  //   setState(() => _downloadProgress = 0.4);
  //   await Future.delayed(const Duration(milliseconds: 100));

  //   final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //   setState(() => _downloadProgress = 0.65);

  //   final ByteData? byteData = await image.toByteData(
  //     format: ui.ImageByteFormat.png,  // Keep as PNG, no JPEG conversion
  //   );
  //   if (byteData == null) throw Exception('Failed to encode image');
  //   setState(() => _downloadProgress = 0.8);

  //   final Uint8List pngBytes = byteData.buffer.asUint8List();
  //   final Directory tempDir = await getTemporaryDirectory();
  //   final String fileName = 'poster_${DateTime.now().millisecondsSinceEpoch}.png';
  //   final File file = File('${tempDir.path}/$fileName');
  //   await file.writeAsBytes(pngBytes);
  //   setState(() => _downloadProgress = 0.92);

  //   final bool hasAccess = await Gal.hasAccess();
  //   if (!hasAccess) await Gal.requestAccess();
  //   await Gal.putImage(file.path, album: 'Poster Editor');
  //   setState(() => _downloadProgress = 1.0);

  //   await Future.delayed(const Duration(milliseconds: 400));
  //   if (mounted) {
  //     setState(() => _isDownloading = false);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('✅ Image saved to gallery!'),
  //         backgroundColor: Color(0xFF2E7D32),
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //   }
  // }

  //     } catch (e, stackTrace) {
  //       print('Download error: $e\n$stackTrace');
  //       if (mounted) {
  //         setState(() => _isDownloading = false);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Export failed: ${e.toString()}'),
  //             backgroundColor: Colors.red,
  //             duration: const Duration(seconds: 4),
  //           ),
  //         );
  //       }
  //     }
  //   }

  void _startDownload() async {
    print("gggggggggggggggggggggggg${_planProvider?.isPurchase}");
    // if (!_planProvider!.isPurchase) {
    //   _showPremiumModal();
    //   return;
    // }
    print("Starting download/export...");

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      if (_isAnimated) {
        setState(() => _downloadProgress = 0.05);
        final tempDir = await getTemporaryDirectory();

        final framesDir = Directory(
          '${tempDir.path}/poster_frames_${DateTime.now().millisecondsSinceEpoch}',
        );
        await framesDir.create(recursive: true);

        // Get audio duration
        int videoDurationSec = 3;
        if (_selectedAudio != null && _selectedAudio != 'No Audio') {
          try {
            Duration? duration;

            // Check user uploaded audio
            final userTrack = _userAudioTracks.firstWhere(
              (track) => track.name == _selectedAudio,
              orElse: () =>
                  UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
            );

            if (userTrack.filePath.isNotEmpty &&
                await File(userTrack.filePath).exists()) {
              final probe = AudioPlayer();
              await probe.setSourceDeviceFile(userTrack.filePath);
              duration = await probe.getDuration();
              await probe.dispose();
            } else {
              final adminTrack = _adminAudioTracks.firstWhere(
                (track) => track.title == _selectedAudio,
                orElse: () => AdminAudioTrack(
                  id: '',
                  title: '',
                  artist: '',
                  audioUrl: '',
                ),
              );

              if (adminTrack.audioUrl.isNotEmpty) {
                final response = await http.get(Uri.parse(adminTrack.audioUrl));
                if (response.statusCode == 200) {
                  final tempAudioProbe = File(
                    '${tempDir.path}/temp_audio_probe_${DateTime.now().millisecondsSinceEpoch}.mp3',
                  );
                  await tempAudioProbe.writeAsBytes(response.bodyBytes);
                  final probe = AudioPlayer();
                  await probe.setSourceDeviceFile(tempAudioProbe.path);
                  duration = await probe.getDuration();
                  await probe.dispose();
                  await tempAudioProbe.delete();
                }
              }
            }

            if (duration != null && duration.inSeconds > 0) {
              videoDurationSec = duration.inSeconds;
              // Cap at 15 seconds to avoid long exports
              if (videoDurationSec > 15) {
                videoDurationSec = 15;
                print("Capping video duration to 15 seconds for faster export");
              }
            }
          } catch (e) {
            print('Could not get audio duration: $e');
          }
        }

        // OPTIMIZATION 1: Reduce FPS from 30 to 20
        const int fps = 20;
        final int totalFrames = videoDurationSec * fps;
        final int animationDurationMs = videoDurationSec * 1000;

        final bool wasAnimating = _animController.isAnimating;
        if (wasAnimating) {
          _animController.stop();
          _brandAnimController.stop();
        }

        final int frameDelayMs = animationDurationMs ~/ totalFrames;

        // FIX: Use higher pixel ratio for better quality
        // Use 2.0 for video frames instead of 1.2
        const double pixelRatio = 2.0;

        for (int i = 0; i < totalFrames; i++) {
          final DateTime frameStartTime = DateTime.now();
          final double progress = (i % fps) / fps;

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
          await Future.delayed(const Duration(milliseconds: 2));

          final RenderRepaintBoundary? boundary =
              _posterKey.currentContext?.findRenderObject()
                  as RenderRepaintBoundary?;
          if (boundary == null) throw Exception('Poster context not found');

          // FIX: Use higher pixel ratio for better quality
          final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
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
            final userTrack = _userAudioTracks.firstWhere(
              (track) => track.name == _selectedAudio,
              orElse: () =>
                  UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
            );

            if (userTrack.filePath.isNotEmpty &&
                await File(userTrack.filePath).exists()) {
              final File sourceFile = File(userTrack.filePath);
              final File tempAudioFile = File(
                '${tempDir.path}/temp_user_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
              );
              await sourceFile.copy(tempAudioFile.path);
              audioFilePath = tempAudioFile.path;
            } else {
              final adminTrack = _adminAudioTracks.firstWhere(
                (track) => track.title == _selectedAudio,
                orElse: () => AdminAudioTrack(
                  id: '',
                  title: '',
                  artist: '',
                  audioUrl: '',
                ),
              );

              if (adminTrack.audioUrl.isNotEmpty) {
                final response = await http.get(Uri.parse(adminTrack.audioUrl));
                if (response.statusCode == 200) {
                  final File tempAudioFile = File(
                    '${tempDir.path}/temp_admin_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
                  );
                  await tempAudioFile.writeAsBytes(response.bodyBytes);
                  audioFilePath = tempAudioFile.path;
                }
              }
            }
          } catch (e) {
            print('Error loading audio for video: $e');
          }
        }

        final String outputPath =
            '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.mp4';

        // FIX: Use better quality FFmpeg settings
        String ffmpegCommand;
        if (audioFilePath != null && await File(audioFilePath).exists()) {
          ffmpegCommand =
              '-y -framerate $fps -i "${framesDir.path}/frame_%04d.png" '
              '-i "$audioFilePath" '
              '-c:v libx264 -pix_fmt yuv420p -c:a aac -shortest '
              '-crf 18 -preset medium ' // Better quality: CRF 18 (lower = better), preset medium
              '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
              '-profile:v high -level 4.0 '
              '"$outputPath"';
        } else {
          ffmpegCommand =
              '-y -framerate $fps -i "${framesDir.path}/frame_%04d.png" '
              '-c:v libx264 -pix_fmt yuv420p '
              '-crf 18 -preset medium ' // Better quality settings
              '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '
              '-profile:v high -level 4.0 '
              '"$outputPath"';
        }

        setState(() => _downloadProgress = 0.65);
        print("Running FFmpeg command...");
        final ffmpegSession = await FFmpegKit.execute(ffmpegCommand);
        final ReturnCode? returnCode = await ffmpegSession.getReturnCode();
        setState(() => _downloadProgress = 0.88);

        if (!ReturnCode.isSuccess(returnCode)) {
          final logs = await ffmpegSession.getAllLogsAsString();
          print("FFmpeg failed: $logs");
          throw Exception('FFmpeg failed to create video');
        }

        // Check if video file exists and has content
        final videoFile = File(outputPath);
        if (!await videoFile.exists() || await videoFile.length() == 0) {
          throw Exception('Generated video file is empty');
        }

        final bool hasAccess = await Gal.hasAccess();
        if (!hasAccess) await Gal.requestAccess();
        await Gal.putVideo(outputPath, album: 'Poster Editor');
        setState(() => _downloadProgress = 1.0);

        // Clean up
        try {
          await framesDir.delete(recursive: true);
          if (audioFilePath != null) {
            final audioFile = File(audioFilePath);
            if (await audioFile.exists()) {
              await audioFile.delete();
            }
          }
        } catch (e) {}

        // if (wasAnimating && mounted) {
        //   _animController.repeat(reverse: true);
        //   _brandAnimController.repeat();
        // }

        if (mounted) {
          // Always reset and restart — don't rely on wasAnimating
          _animController.reset();
          _brandAnimController.reset();
          if (_selectedAnimation != AnimationType.none) {
            _animController.repeat(reverse: true);
            _brandAnimController.repeat();
          }
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
        // ── Static image download with HIGH QUALITY ──
        setState(() => _downloadProgress = 0.2);
        await Future.delayed(const Duration(milliseconds: 300));

        final RenderRepaintBoundary? boundary =
            _posterKey.currentContext?.findRenderObject()
                as RenderRepaintBoundary?;
        if (boundary == null) throw Exception('Poster not found.');

        setState(() => _downloadProgress = 0.4);
        await Future.delayed(const Duration(milliseconds: 100));

        // FIX: Use higher pixel ratio for better quality static image
        // 4.0 for HD quality, 5.0 for ultra HD
        final ui.Image image = await boundary.toImage(pixelRatio: 4.0);
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
            content: Text('Export failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  ////// This is the used code previously for exporting the audio/////////////

  // void _startDownload() async {
  //   print("gggggggggggggggggggggggg${_planProvider?.isPurchase}");
  //   // if (!_planProvider!.isPurchase) {
  //   //   _showPremiumModal();
  //   //   return;
  //   // }
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
  //           Duration? duration;

  //           // Check user uploaded audio
  //           final userTrack = _userAudioTracks.firstWhere(
  //             (track) => track.name == _selectedAudio,
  //             orElse: () =>
  //                 UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
  //           );

  //           if (userTrack.filePath.isNotEmpty &&
  //               await File(userTrack.filePath).exists()) {
  //             final probe = AudioPlayer();
  //             await probe.setSourceDeviceFile(userTrack.filePath);
  //             duration = await probe.getDuration();
  //             await probe.dispose();
  //             print('User audio duration: ${duration?.inSeconds} seconds');
  //           } else {
  //             // Check admin audio track
  //             final adminTrack = _adminAudioTracks.firstWhere(
  //               (track) => track.title == _selectedAudio,
  //               orElse: () => AdminAudioTrack(
  //                 id: '',
  //                 title: '',
  //                 artist: '',
  //                 audioUrl: '',
  //               ),
  //             );

  //             if (adminTrack.audioUrl.isNotEmpty) {
  //               // Download temporarily to get duration
  //               print(
  //                 'Downloading admin audio for duration check: ${adminTrack.title}',
  //               );
  //               final response = await http.get(Uri.parse(adminTrack.audioUrl));
  //               if (response.statusCode == 200) {
  //                 final tempAudioProbe = File(
  //                   '${tempDir.path}/temp_audio_probe_${DateTime.now().millisecondsSinceEpoch}.mp3',
  //                 );
  //                 await tempAudioProbe.writeAsBytes(response.bodyBytes);

  //                 final probe = AudioPlayer();
  //                 await probe.setSourceDeviceFile(tempAudioProbe.path);
  //                 duration = await probe.getDuration();
  //                 await probe.dispose();

  //                 // Clean up temp file
  //                 try {
  //                   await tempAudioProbe.delete();
  //                 } catch (e) {}

  //                 print('Admin audio duration: ${duration?.inSeconds} seconds');
  //               }
  //             } else {
  //               // Static audio assets
  //               const Map<String, String> audioAssets = {
  //                 'Upbeat Pop':
  //                     'assets/audio/Aaja Mahiya - Lofi _ Slowed Reverb.mp3',
  //                 'Calm Acoustic':
  //                     'assets/audio/Bharosa Karlo Tum Sath Nibhaunga - Lofi _ Slowed Reverb.mp3',
  //                 'Corporate':
  //                     'assets/audio/Jana Mere Sawalo Ka Manzar Tu - Lofi _ Slowed Reverb.mp3',
  //                 'Cinematic':
  //                     'assets/audio/Mere Ganpati Deva - Lofi _ Slowed Reverb.mp3',
  //                 'Electronic':
  //                     'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //                 'Jazz Lounge':
  //                     'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //               };

  //               final String? assetPath = audioAssets[_selectedAudio];
  //               if (assetPath != null) {
  //                 final ByteData audioData = await rootBundle.load(assetPath);
  //                 final File tempAudioProbe = File(
  //                   '${tempDir.path}/temp_audio_probe_${DateTime.now().millisecondsSinceEpoch}.mp3',
  //                 );
  //                 await tempAudioProbe.writeAsBytes(
  //                   audioData.buffer.asUint8List(),
  //                 );

  //                 final probe = AudioPlayer();
  //                 await probe.setSourceDeviceFile(tempAudioProbe.path);
  //                 duration = await probe.getDuration();
  //                 await probe.dispose();

  //                 // Clean up temp file
  //                 try {
  //                   await tempAudioProbe.delete();
  //                 } catch (e) {}
  //               }
  //             }
  //           }

  //           if (duration != null && duration.inSeconds > 0) {
  //             videoDurationSec = duration.inSeconds;
  //             print('Using audio duration: $videoDurationSec seconds');
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
  //           // First, check if it's a user-uploaded audio
  //           final userTrack = _userAudioTracks.firstWhere(
  //             (track) => track.name == _selectedAudio,
  //             orElse: () =>
  //                 UserAudioTrack(name: '', filePath: '', durationInSeconds: 0),
  //           );

  //           if (userTrack.filePath.isNotEmpty &&
  //               await File(userTrack.filePath).exists()) {
  //             // This is a user-uploaded audio file - copy it to temp directory
  //             final File sourceFile = File(userTrack.filePath);
  //             final File tempAudioFile = File(
  //               '${tempDir.path}/temp_user_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
  //             );
  //             await sourceFile.copy(tempAudioFile.path);
  //             audioFilePath = tempAudioFile.path;
  //             print('Using user audio file: ${userTrack.name}');
  //           } else {
  //             // Check if it's an admin audio track
  //             final adminTrack = _adminAudioTracks.firstWhere(
  //               (track) => track.title == _selectedAudio,
  //               orElse: () => AdminAudioTrack(
  //                 id: '',
  //                 title: '',
  //                 artist: '',
  //                 audioUrl: '',
  //               ),
  //             );

  //             if (adminTrack.audioUrl.isNotEmpty) {
  //               // Download admin audio file
  //               print('Downloading admin audio for video: ${adminTrack.title}');
  //               final response = await http.get(Uri.parse(adminTrack.audioUrl));
  //               if (response.statusCode == 200) {
  //                 final File tempAudioFile = File(
  //                   '${tempDir.path}/temp_admin_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
  //                 );
  //                 await tempAudioFile.writeAsBytes(response.bodyBytes);
  //                 audioFilePath = tempAudioFile.path;
  //                 print(
  //                   'Admin audio downloaded successfully: ${adminTrack.title}',
  //                 );
  //               } else {
  //                 print(
  //                   'Failed to download admin audio: ${response.statusCode}',
  //                 );
  //               }
  //             } else {
  //               // Check static audio assets
  //               const Map<String, String> audioAssets = {
  //                 'Upbeat Pop':
  //                     'assets/audio/Aaja Mahiya - Lofi _ Slowed Reverb.mp3',
  //                 'Calm Acoustic':
  //                     'assets/audio/Bharosa Karlo Tum Sath Nibhaunga - Lofi _ Slowed Reverb.mp3',
  //                 'Corporate':
  //                     'assets/audio/Jana Mere Sawalo Ka Manzar Tu - Lofi _ Slowed Reverb.mp3',
  //                 'Cinematic':
  //                     'assets/audio/Mere Ganpati Deva - Lofi _ Slowed Reverb.mp3',
  //                 'Electronic':
  //                     'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //                 'Jazz Lounge':
  //                     'assets/audio/O Mere Mahiya Jina Sohna - Lofi _ Slowed Reverb.mp3',
  //               };

  //               final String? assetPath = audioAssets[_selectedAudio];
  //               if (assetPath != null) {
  //                 final ByteData audioData = await rootBundle.load(assetPath);
  //                 final File tempAudioFile = File(
  //                   '${tempDir.path}/temp_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
  //                 );
  //                 await tempAudioFile.writeAsBytes(
  //                   audioData.buffer.asUint8List(),
  //                 );
  //                 audioFilePath = tempAudioFile.path;
  //                 print('Using static audio file: $_selectedAudio');
  //               }
  //             }
  //           }
  //         } catch (e) {
  //           print('Error loading audio for video: $e');
  //         }
  //       }

  //       final String outputPath =
  //           '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.mp4';
  //       String ffmpegCommand;

  //       if (audioFilePath != null && await File(audioFilePath).exists()) {
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
  //         if (audioFilePath != null) {
  //           final audioFile = File(audioFilePath);
  //           if (await audioFile.exists()) {
  //             await audioFile.delete();
  //           }
  //         }
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
      color: isDarkMode
          ? const Color(0xFF1E293B)
          : const ui.Color.fromARGB(255, 48, 81, 217),
      padding: EdgeInsets.only(
        top:
            MediaQuery.of(context).padding.top +
            4, 
        left: 8,
        right: 8,
        bottom: 8,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode
                  ? Colors.white
                  : const ui.Color.fromARGB(221, 255, 255, 255),
              size: 22,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          IconButton(
            icon: Icon(
              Icons.layers,
              color: isDarkMode
                  ? Colors.white
                  : const ui.Color.fromARGB(221, 255, 255, 255),
              size: 22,
            ),
            onPressed: _showLayersSheet,
          ),
          IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              color: isDarkMode
                  ? Colors.white
                  : const ui.Color.fromARGB(221, 255, 255, 255),
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
                        child: _buildPosterBackground(), // ← removed ClipRect
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

                    // ── Frame logo (draggable) LAST so it's always on top ──
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
                              : (_brandInfo.logoAsset.isNotEmpty &&
                                        (_brandInfo.logoAsset.startsWith(
                                              'http://',
                                            ) ||
                                            _brandInfo.logoAsset.startsWith(
                                              'https://',
                                            ))
                                    ? ClipOval(
                                        child: Image.network(
                                          _brandInfo.logoAsset,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : _logoWidget(
                                        const Color.fromARGB(255, 48, 81, 217),
                                        size: 50,
                                      )),
                        ),
                      ),
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

  // Widget _buildPosterBackground() {
  //   final isDarkMode = _isDarkMode;
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
  //         color: isDarkMode ? const Color(0xFF1A1A1A) : _bgColor,
  //       ),
  //       img,
  //     ],
  //   );

  //   // If no image uploaded and no network image (placeholder case)
  //   if (_uploadedImagePath == null && widget.posterAsset.isEmpty) {
  //     base = Container(
  //       width: double.infinity,
  //       height: double.infinity,
  //       color: isDarkMode ? const Color(0xFF1A1A1A) : _bgColor,
  //       child: Center(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(
  //               Icons.add_photo_alternate_outlined,
  //               size: 48,
  //               color: isDarkMode
  //                   ? Colors.white.withOpacity(0.3)
  //                   : Colors.black.withOpacity(0.2),
  //             ),
  //             const SizedBox(height: 10),
  //             Text(
  //               'No Image Selected',
  //               style: TextStyle(
  //                 fontSize: 13,
  //                 color: isDarkMode
  //                     ? Colors.white.withOpacity(0.35)
  //                     : Colors.black.withOpacity(0.25),
  //                 fontWeight: FontWeight.w500,
  //                 letterSpacing: 0.5,
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             Text(
  //               'Upload an image to get started',
  //               style: TextStyle(
  //                 fontSize: 11,
  //                 color: isDarkMode
  //                     ? Colors.white.withOpacity(0.25)
  //                     : Colors.black.withOpacity(0.15),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }

  //   // Apply effects (keep as is)
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

  void _openAudioSelectionScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AudioSelectionScreen(
          adminAudioTracks: _adminAudioTracks,
          userAudioTracks: _userAudioTracks,
          selectedAudio: _selectedAudio,
          isLoadingAudios: _isLoadingAudios,
          audioLoadError: _audioLoadError,
          onAudioSelected: (trackName) async {
            // Switch to Frames tab after audio confirmed
            setState(() => _activeTab = BottomTab.frames);
            await _playAudio(trackName);
          },
          onAudioRemoved: () async {
            setState(() => _activeTab = BottomTab.frames);
            await _playAudio(null);
          },
          onPickUserAudio: _pickUserAudio,
          onDeleteUserAudio: _showDeleteAudioConfirmation,
          onRetryFetch: _fetchAdminAudios,
        ),
      ),
    );
  }

  Widget _buildPosterBackground() {
    final isDarkMode = _isDarkMode;

    // While audio confirmation dialog is open — hide the poster image
    if (_isSelectingAudio) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF0F0F0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5C518).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  size: 48,
                  color: Color(0xFFF5C518),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Selecting Audio...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Poster will appear after you confirm',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white38 : Colors.black38,
                ),
              ),
            ],
          ),
        ),
      );
    }

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

    base = _applyEffect(base, _selectedEffect, _effectStrength);

    if (_selectedAnimation != AnimationType.none) {
      return AnimatedBuilder(
        animation: _animValue,
        builder: (_, __) => _applyAnimation(base),
      );
    }
    return base;
  }

  // Widget _buildPosterBackground() {
  //   final isDarkMode = _isDarkMode;
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
  //         color: isDarkMode ? const Color(0xFF1A1A1A) : _bgColor,
  //       ),
  //       img,
  //     ],
  //   );

  //   // Apply effects
  //   base = _applyEffect(base, _selectedEffect, _effectStrength);

  //   if (_selectedAnimation != AnimationType.none) {
  //     return AnimatedBuilder(
  //       animation: _animValue,
  //       builder: (_, __) => _applyAnimation(base),
  //     );
  //   }
  //   return base;
  // }

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

  // 2. Golden Banner - Modern Redesigned Version
  Widget _frameBanner(FrameStyle f, {bool showLogo = false}) => Stack(
    children: [
      // Top header section with gradient background
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  f.headerBg ?? f.borderColor,
                  (f.headerBg ?? f.borderColor).withOpacity(0.85),
                  (f.headerBg ?? f.borderColor).withOpacity(0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Logo with modern styling
                if (showLogo)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () => _pickImage(forLogo: true),
                      child: _logoWidget(
                        Colors.white.withOpacity(0.3),
                        size: 45,
                      ),
                    ),
                  ),

                if (showLogo) const SizedBox(width: 12),

                // Brand info with modern typography
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Brand name with stylish font
                      const SizedBox(height: 2),
                      // Tagline or decorative line
                      Container(
                        width: 40,
                        height: 2,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ],
                  ),
                ),

                // Decorative element on the right
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.star, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Bottom footer with contact info - Modern design
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () => setState(() => _activeTab = BottomTab.brandInfo),
          child: Container(
            decoration: BoxDecoration(
              color: (f.footerBg ?? f.borderColor).withOpacity(0.95),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  _brandInfo.name.isNotEmpty ? _brandInfo.name : 'BRAND NAME',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),

                // Phone
                if (_brandInfo.phone.isNotEmpty)
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.phone,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _brandInfo.phone,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Divider
                if (_brandInfo.phone.isNotEmpty &&
                    _brandInfo.address.isNotEmpty)
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.white.withOpacity(0.3),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),

                // Address
                if (_brandInfo.address.isNotEmpty)
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _brandInfo.address,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

      // Decorative border elements
      Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: f.borderColor, width: 3),
            right: BorderSide(color: f.borderColor, width: 3),
          ),
        ),
      ),

      // Corner decorations
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: f.borderColor,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: f.borderColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
            ),
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

  // Widget _logoWidget(Color bgColor, {double size = 52}) {
  //   if (_uploadedLogoPath != null) {
  //     return Container(
  //       width: size,
  //       height: size,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         border: Border.all(color: Colors.white, width: 2),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.25),
  //             blurRadius: 6,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: ClipOval(
  //         child: Image.file(
  //           File(_uploadedLogoPath!),
  //           fit: BoxFit.cover,
  //           width: size,
  //           height: size,
  //         ),
  //       ),
  //     );
  //   }
  //   return Container(
  //     width: size,
  //     height: size,
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       color: bgColor,
  //       border: Border.all(color: Colors.white, width: 2),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.25),
  //           blurRadius: 6,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: const Center(
  //       child: Text(
  //         'LOGO',
  //         style: TextStyle(
  //           fontSize: 9,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _logoWidget(Color bgColor, {double size = 52}) {
    if (_uploadedLogoPath != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
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

    // ✅ Check if logoAsset is a valid network URL before loading
    if (_brandInfo.logoAsset.isNotEmpty &&
        (_brandInfo.logoAsset.startsWith('http://') ||
            _brandInfo.logoAsset.startsWith('https://'))) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: ClipOval(
          child: Image.network(
            _brandInfo.logoAsset,
            fit: BoxFit.cover,
            width: size,
            height: size,
            errorBuilder: (_, __, ___) => _defaultLogoWidget(bgColor, size),
          ),
        ),
      );
    }

    return _defaultLogoWidget(bgColor, size);
  }

  Widget _defaultLogoWidget(Color bgColor, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(color: Colors.white, width: 2),
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
  //       onLongPress: () {
  //         // Show confirmation dialog on long press
  //         _showDeleteConfirmationDialog(item);
  //       },
  //       child: Stack(
  //         clipBehavior: Clip.none,
  //         children: [
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
  //                       color: item.backgroundColor == Colors.transparent
  //                           ? null
  //                           : item.backgroundColor,
  //                     )
  //                   : null,
  //               color:
  //                   !item.hasBorder &&
  //                       item.backgroundColor != Colors.transparent
  //                   ? item.backgroundColor
  //                   : null,
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

  //           // Resize handle (bottom-right)
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

    // Cache the text style
    final textStyle = _getCachedGoogleFont(item).copyWith(
      shadows: item.hasShadow
          ? const [
              Shadow(
                color: Colors.black38,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ]
          : null,
    );

    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: _DraggableTextWidget(
        key: ValueKey(
          item.id,
        ), // Important: Use key to help Flutter with updates
        item: item,
        isSelected: isSelected,
        textStyle: textStyle,
        onPositionChanged: (newPosition) {
          setState(() {
            final idx = _texts.indexWhere((t) => t.id == item.id);
            if (idx != -1) {
              _texts[idx] = _texts[idx].copyWith(position: newPosition);
            }
          });
        },
        onTap: () {
          setState(() {
            _selectedTextId = item.id;
            _selectedBrandItemId = null;
          });
          _openTextEditor(item);
        },
        onDelete: () {
          setState(() {
            _texts.removeWhere((t) => t.id == item.id);
            if (_selectedTextId == item.id) {
              _selectedTextId = null;
            }
          });
        },
        onResize: (newSize) {
          setState(() {
            final idx = _texts.indexWhere((t) => t.id == item.id);
            if (idx != -1) {
              _texts[idx] = _texts[idx].copyWith(fontSize: newSize);
            }
          });
        },
      ),
    );
  }

  // Widget _buildTextWidget(OverlayTextItem item) {
  //   final isSelected = _selectedTextId == item.id;

  //   // Get Google Font style
  //   TextStyle getGoogleFont() {
  //     try {
  //       final fontEntry = kGoogleFonts.firstWhere(
  //         (e) => e.name == item.fontFamily,
  //       );
  //       return fontEntry.font(
  //         textStyle: TextStyle(
  //           fontSize: item.fontSize,
  //           color: item.color,
  //           fontWeight: item.isBold ? FontWeight.bold : FontWeight.normal,
  //           fontStyle: item.isItalic ? FontStyle.italic : FontStyle.normal,
  //           decoration: item.isUnderline
  //               ? TextDecoration.underline
  //               : TextDecoration.none,
  //         ),
  //       );
  //     } catch (_) {
  //       return TextStyle(
  //         fontSize: item.fontSize,
  //         color: item.color,
  //         fontWeight: item.isBold ? FontWeight.bold : FontWeight.normal,
  //         fontStyle: item.isItalic ? FontStyle.italic : FontStyle.normal,
  //         decoration: item.isUnderline
  //             ? TextDecoration.underline
  //             : TextDecoration.none,
  //       );
  //     }
  //   }

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
  //       onLongPress: () {
  //         _showDeleteConfirmationDialog(item);
  //       },
  //       child: Stack(
  //         clipBehavior: Clip.none,
  //         children: [
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
  //                       color: item.backgroundColor == Colors.transparent
  //                           ? null
  //                           : item.backgroundColor,
  //                     )
  //                   : null,
  //               color:
  //                   !item.hasBorder &&
  //                       item.backgroundColor != Colors.transparent
  //                   ? item.backgroundColor
  //                   : null,
  //               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
  //               child: Transform.rotate(
  //                 angle: item.rotation,
  //                 child: Text(
  //                   item.text,
  //                   textAlign: item.align,
  //                   style: getGoogleFont().copyWith(
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

  Widget _buildFontsPanel() {
    final isDarkMode = _isDarkMode;
    final sel = _selectedText;

    if (sel == null) {
      return Container(
        height: 120,
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        child: Center(
          child: Text(
            'Select a text layer first to change font',
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white54 : Colors.black54,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    final fontCategories = _getFontCategories();

    return Container(
      height: 180,
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      child: DefaultTabController(
        length: fontCategories.length,
        child: Column(
          children: [
            // Category tabs
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TabBar(
                isScrollable: true,
                indicatorColor: const Color(0xFFF5C518),
                labelColor: const Color(0xFFF5C518),
                unselectedLabelColor: isDarkMode
                    ? Colors.white54
                    : Colors.black54,
                labelStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                tabs: fontCategories.keys.map((category) {
                  return Tab(text: category);
                }).toList(),
              ),
            ),

            // Font lists by category
            Expanded(
              child: TabBarView(
                children: fontCategories.values.map((fonts) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: fonts.length,
                    itemBuilder: (_, i) {
                      final f = fonts[i];
                      final active = sel.fontFamily == f.name;
                      final style = f.font(
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: sel.isBold
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: active
                              ? Colors.white
                              : (isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF2D3142)),
                        ),
                      );

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            final idx = _texts.indexWhere(
                              (t) => t.id == sel.id,
                            );
                            if (idx != -1) {
                              _texts[idx] = _texts[idx].copyWith(
                                fontFamily: f.name,
                              );
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFFF5C518)
                                : (isDarkMode
                                      ? const Color(0xFF0F172A)
                                      : Colors.grey.shade100),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: active
                                  ? const Color(0xFFF5C518)
                                  : (isDarkMode
                                        ? Colors.grey[700]!
                                        : Colors.grey.shade300),
                              width: active ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Aa', style: style.copyWith(fontSize: 24)),
                              const SizedBox(height: 6),
                              Text(
                                f.name,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: active
                                      ? Colors.black87
                                      : (isDarkMode
                                            ? Colors.white70
                                            : Colors.black54),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
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
      case BottomTab.fonts: // Add this
        return _buildFontsPanel();
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
                  'Size',
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
              // _sb('T', 18, sel),
              // _sb('T', 24, sel),
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

  // void _showTextThemePicker(OverlayTextItem sel) {
  //   final themes = [
  //     {
  //       'name': 'Default',
  //       'color': Colors.white,
  //       'bg': Colors.transparent,
  //       'bold': false,
  //       'shadow': false,
  //     },
  //     {
  //       'name': 'Bold White',
  //       'color': Colors.white,
  //       'bg': Colors.transparent,
  //       'bold': true,
  //       'shadow': true,
  //     },
  //     {
  //       'name': 'Dark',
  //       'color': Colors.black,
  //       'bg': Colors.white.withOpacity(0.8),
  //       'bold': false,
  //       'shadow': false,
  //     },
  //     {
  //       'name': 'Gold',
  //       'color': const Color(0xFFD4AF37),
  //       'bg': Colors.transparent,
  //       'bold': true,
  //       'shadow': true,
  //     },
  //     {
  //       'name': 'Neon',
  //       'color': Colors.greenAccent,
  //       'bg': Colors.black.withOpacity(0.5),
  //       'bold': true,
  //       'shadow': false,
  //     },
  //     {
  //       'name': 'Red Alert',
  //       'color': Colors.white,
  //       'bg': Colors.red.shade700,
  //       'bold': true,
  //       'shadow': false,
  //     },
  //   ];
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (_) => Container(
  //       color: Colors.white,
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             'Text Theme',
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //           ),
  //           const SizedBox(height: 12),
  //           Wrap(
  //             spacing: 10,
  //             runSpacing: 10,
  //             children: themes
  //                 .map(
  //                   (t) => GestureDetector(
  //                     onTap: () {
  //                       setState(() {
  //                         final i = _texts.indexWhere((x) => x.id == sel.id);
  //                         if (i != -1)
  //                           _texts[i] = _texts[i].copyWith(
  //                             color: t['color'] as Color,
  //                             backgroundColor: t['bg'] as Color,
  //                             isBold: t['bold'] as bool,
  //                             hasShadow: t['shadow'] as bool,
  //                           );
  //                       });
  //                       Navigator.pop(context);
  //                     },
  //                     child: Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 14,
  //                         vertical: 8,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: (t['bg'] as Color) == Colors.transparent
  //                             ? Colors.grey.shade100
  //                             : t['bg'] as Color,
  //                         borderRadius: BorderRadius.circular(8),
  //                         border: Border.all(color: Colors.grey.shade300),
  //                       ),
  //                       child: Text(
  //                         t['name'] as String,
  //                         style: TextStyle(
  //                           color: t['color'] as Color,
  //                           fontWeight: (t['bold'] as bool)
  //                               ? FontWeight.bold
  //                               : FontWeight.normal,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //                 .toList(),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  //   void _showTextThemePicker(OverlayTextItem sel) {
  //   final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  //   final themes = [
  //     {
  //       'name': 'Default',
  //       'color': Colors.white,
  //       'bg': Colors.transparent,
  //       'bold': false,
  //       'shadow': false,
  //     },
  //     {
  //       'name': 'Bold White',
  //       'color': Colors.white,
  //       'bg': Colors.transparent,
  //       'bold': true,
  //       'shadow': true,
  //     },
  //     {
  //       'name': 'Dark',
  //       'color': Colors.black,
  //       'bg': Colors.white.withOpacity(0.8),
  //       'bold': false,
  //       'shadow': false,
  //     },
  //     {
  //       'name': 'Gold',
  //       'color': const Color(0xFFD4AF37),
  //       'bg': Colors.transparent,
  //       'bold': true,
  //       'shadow': true,
  //     },
  //     {
  //       'name': 'Neon',
  //       'color': Colors.greenAccent,
  //       'bg': Colors.black.withOpacity(0.5),
  //       'bold': true,
  //       'shadow': false,
  //     },
  //     {
  //       'name': 'Red Alert',
  //       'color': Colors.white,
  //       'bg': Colors.red.shade700,
  //       'bold': true,
  //       'shadow': false,
  //     },
  //   ];

  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) => Container(
  //       decoration: BoxDecoration(
  //         color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
  //         borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
  //       ),
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Drag handle
  //           Center(
  //             child: Container(
  //               width: 40,
  //               height: 4,
  //               decoration: BoxDecoration(
  //                 color: isDarkMode ? Colors.grey[700] : Colors.grey.shade300,
  //                 borderRadius: BorderRadius.circular(2),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 12),
  //           Text(
  //             'Text Theme',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 15,
  //               color: isDarkMode ? Colors.white : Colors.black87,
  //             ),
  //           ),
  //           const SizedBox(height: 12),
  //           Wrap(
  //             spacing: 10,
  //             runSpacing: 10,
  //             children: themes.map((t) {
  //               final textColor = t['color'] as Color;
  //               final bgColor = t['bg'] as Color;
  //               final isBold = t['bold'] as bool;
  //               final isTransparentBg = bgColor == Colors.transparent;

  //               // Determine chip background for visibility
  //               Color chipBg;
  //               if (isTransparentBg) {
  //                 // For transparent bg themes, use a contrasting preview background
  //                 chipBg = isDarkMode ? const Color(0xFF374151) : Colors.grey.shade200;
  //               } else {
  //                 chipBg = bgColor;
  //               }

  //               // Determine text color for readability on chip
  //               Color chipTextColor;
  //               if (isTransparentBg) {
  //                 // White text themes need dark bg preview
  //                 chipTextColor = textColor;
  //               } else {
  //                 chipTextColor = textColor;
  //               }

  //               return GestureDetector(
  //                 onTap: () {
  //                   setState(() {
  //                     final i = _texts.indexWhere((x) => x.id == sel.id);
  //                     if (i != -1)
  //                       _texts[i] = _texts[i].copyWith(
  //                         color: textColor,
  //                         backgroundColor: bgColor,
  //                         isBold: isBold,
  //                         hasShadow: t['shadow'] as bool,
  //                       );
  //                   });
  //                   Navigator.pop(context);
  //                 },
  //                 child: Container(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 14,
  //                     vertical: 10,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: chipBg,
  //                     borderRadius: BorderRadius.circular(8),
  //                     border: Border.all(
  //                       color: isDarkMode
  //                           ? Colors.grey[600]!
  //                           : Colors.grey.shade300,
  //                       width: 1.5,
  //                     ),
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.black.withOpacity(0.1),
  //                         blurRadius: 4,
  //                         offset: const Offset(0, 2),
  //                       ),
  //                     ],
  //                   ),
  //                   child: Text(
  //                     t['name'] as String,
  //                     style: TextStyle(
  //                       color: chipTextColor,
  //                       fontWeight: isBold
  //                           ? FontWeight.bold
  //                           : FontWeight.normal,
  //                       shadows: (t['shadow'] as bool)
  //                           ? [
  //                               const Shadow(
  //                                 color: Colors.black54,
  //                                 offset: Offset(1, 1),
  //                                 blurRadius: 2,
  //                               ),
  //                             ]
  //                           : null,
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //           const SizedBox(height: 8),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _showTextThemePicker(OverlayTextItem sel) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final themes = [
      {
        'name': 'Default',
        'color': isDarkMode
            ? Colors.white
            : Colors.black87, // Dark text for light mode
        'bg': Colors.transparent,
        'bold': false,
        'shadow': false,
      },
      {
        'name': 'Bold White',
        'color': isDarkMode
            ? Colors.white
            : Colors.black87, // Dark text for light mode
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
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Text Theme',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: themes.map((t) {
                final textColor = t['color'] as Color;
                final bgColor = t['bg'] as Color;
                final isBold = t['bold'] as bool;
                final isTransparentBg = bgColor == Colors.transparent;

                // Determine chip background for visibility
                Color chipBg;
                if (isTransparentBg) {
                  // For transparent bg themes, use a contrasting preview background
                  chipBg = isDarkMode
                      ? const Color(0xFF374151)
                      : Colors.grey.shade200;
                } else {
                  chipBg = bgColor;
                }

                // Determine text color for readability on chip
                Color chipTextColor;
                if (isTransparentBg) {
                  chipTextColor = textColor;
                } else {
                  chipTextColor = textColor;
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      final i = _texts.indexWhere((x) => x.id == sel.id);
                      if (i != -1)
                        _texts[i] = _texts[i].copyWith(
                          color: textColor,
                          backgroundColor: bgColor,
                          isBold: isBold,
                          hasShadow: t['shadow'] as bool,
                        );
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.grey[600]!
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      t['name'] as String,
                      style: TextStyle(
                        color: chipTextColor,
                        fontWeight: isBold
                            ? FontWeight.bold
                            : FontWeight.normal,
                        shadows: (t['shadow'] as bool)
                            ? [
                                const Shadow(
                                  color: Colors.black54,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showFontPicker(OverlayTextItem sel) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        // Get the current live reference
        OverlayTextItem currentItem = sel;

        return StatefulBuilder(
          builder: (context, setModalState) {
            // Find the latest version of this text item
            final liveItem = _texts.firstWhere(
              (t) => t.id == sel.id,
              orElse: () => sel,
            );

            return Container(
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
                    value: liveItem.fontSize,
                    min: 10,
                    max: 72,
                    divisions: 62,
                    activeColor: const Color(0xFFF5C518),
                    label: liveItem.fontSize.toStringAsFixed(0),
                    onChanged: (v) {
                      // Update the modal's local state for smooth slider movement
                      setModalState(() {
                        currentItem = currentItem.copyWith(fontSize: v);
                      });

                      // Update the actual text item
                      setState(() {
                        final i = _texts.indexWhere((t) => t.id == sel.id);
                        if (i != -1) {
                          _texts[i] = _texts[i].copyWith(fontSize: v);
                        }
                      });
                    },
                  ),
                  // Optional: Show current value
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Current size: ${liveItem.fontSize.toStringAsFixed(0)}px',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showColorPicker(OverlayTextItem sel) {
    final isDarkMode = _isDarkMode;
    Color tempColor = sel.color;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
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

                  // Color picker - FIX: Use Flexible with constraints instead of fixed height
                  Flexible(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(ctx).size.height * 0.4,
                        minHeight: 200,
                      ),
                      child: ColorPicker(
                        pickerColor: tempColor,
                        onColorChanged: (color) {
                          setSheetState(() {
                            tempColor = color;
                          });
                        },
                        showLabel: false,
                        pickerAreaHeightPercent: 0.8,
                        enableAlpha: false,
                        displayThumbColor: true,
                        paletteType: PaletteType.hsv,
                        portraitOnly: true,
                      ),
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
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // void _showColorPicker(OverlayTextItem sel) {
  //   final isDarkMode = _isDarkMode;

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) {
  //       Color tempColor = sel.color;

  //       return StatefulBuilder(
  //         builder: (ctx, setSheetState) {
  //           return Container(
  //             decoration: BoxDecoration(
  //               color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
  //               borderRadius: const BorderRadius.vertical(
  //                 top: Radius.circular(16),
  //               ),
  //             ),
  //             padding: const EdgeInsets.all(20),
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // Drag handle
  //                   Container(
  //                     width: 40,
  //                     height: 4,
  //                     decoration: BoxDecoration(
  //                       color: isDarkMode
  //                           ? Colors.grey[700]
  //                           : Colors.grey.shade300,
  //                       borderRadius: BorderRadius.circular(2),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),

  //                   // Title
  //                   Row(
  //                     children: [
  //                       Icon(
  //                         Icons.color_lens,
  //                         size: 24,
  //                         color: const Color(0xFFF5C518),
  //                       ),
  //                       const SizedBox(width: 10),
  //                       Expanded(
  //                         child: Text(
  //                           'Choose Text Color',
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.bold,
  //                             color: isDarkMode ? Colors.white : Colors.black87,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 20),

  //                   // Color picker - Reduced height to prevent overflow
  //                   SizedBox(
  //                     height:
  //                         MediaQuery.of(ctx).size.height *
  //                         0.35, // Responsive height
  //                     child: ColorPicker(
  //                       pickerColor: tempColor,
  //                       onColorChanged: (color) {
  //                         setSheetState(() {
  //                           tempColor = color;
  //                         });
  //                       },
  //                       showLabel: false,
  //                       pickerAreaHeightPercent: 0.7,
  //                       enableAlpha: false,
  //                       displayThumbColor: true,
  //                       paletteType: PaletteType.hsv,
  //                       portraitOnly: true,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),

  //                   // Color preview with RGB
  //                   Container(
  //                     width: double.infinity,
  //                     padding: const EdgeInsets.all(12),
  //                     decoration: BoxDecoration(
  //                       color: tempColor,
  //                       borderRadius: BorderRadius.circular(12),
  //                       border: Border.all(
  //                         color: isDarkMode
  //                             ? Colors.white24
  //                             : Colors.grey.shade300,
  //                         width: 2,
  //                       ),
  //                     ),
  //                     child: Column(
  //                       children: [
  //                         Text(
  //                           'Selected Color',
  //                           style: TextStyle(
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.w500,
  //                             color: tempColor.computeLuminance() > 0.5
  //                                 ? Colors.black87
  //                                 : Colors.white,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 4),
  //                         Text(
  //                           'RGB(${tempColor.red}, ${tempColor.green}, ${tempColor.blue})',
  //                           style: TextStyle(
  //                             fontSize: 12,
  //                             color: tempColor.computeLuminance() > 0.5
  //                                 ? Colors.black54
  //                                 : Colors.white70,
  //                           ),
  //                         ),
  //                         Text(
  //                           '#${tempColor.value.toRadixString(16).substring(2, 8).toUpperCase()}',
  //                           style: TextStyle(
  //                             fontSize: 11,
  //                             color: tempColor.computeLuminance() > 0.5
  //                                 ? Colors.black54
  //                                 : Colors.white70,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),

  //                   // Buttons
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: OutlinedButton(
  //                           onPressed: () => Navigator.pop(ctx),
  //                           style: OutlinedButton.styleFrom(
  //                             foregroundColor: isDarkMode
  //                                 ? Colors.white70
  //                                 : Colors.black87,
  //                             side: BorderSide(
  //                               color: isDarkMode
  //                                   ? Colors.white38
  //                                   : Colors.grey.shade400,
  //                             ),
  //                             padding: const EdgeInsets.symmetric(vertical: 12),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10),
  //                             ),
  //                           ),
  //                           child: const Text('Cancel'),
  //                         ),
  //                       ),
  //                       const SizedBox(width: 12),
  //                       Expanded(
  //                         child: ElevatedButton(
  //                           onPressed: () {
  //                             setState(() {
  //                               final i = _texts.indexWhere(
  //                                 (t) => t.id == sel.id,
  //                               );
  //                               if (i != -1) {
  //                                 _texts[i] = _texts[i].copyWith(
  //                                   color: tempColor,
  //                                 );
  //                               }
  //                             });
  //                             Navigator.pop(ctx);
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: const Color(0xFFF5C518),
  //                             foregroundColor: Colors.black87,
  //                             padding: const EdgeInsets.symmetric(vertical: 12),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10),
  //                             ),
  //                           ),
  //                           child: const Text(
  //                             'Apply',
  //                             style: TextStyle(fontWeight: FontWeight.bold),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 8), // Extra bottom padding
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void _showBgColorPicker(OverlayTextItem sel) {
    final isDarkMode = _isDarkMode;
    Color tempColor = sel.backgroundColor == Colors.transparent
        ? Colors.white
        : sel.backgroundColor;

    // Quick color swatches
    final List<Color> quickColors = [
      Colors.transparent,
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.teal,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      const Color(0xFFD4AF37),
      Colors.brown,
      Colors.grey,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
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
                  const SizedBox(height: 20),

                  // Quick color swatches row
                  Text(
                    'Quick colors',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: quickColors.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) {
                        final c = quickColors[i];
                        final isTransparent = c == Colors.transparent;
                        final isSelected = isTransparent
                            ? sel.backgroundColor == Colors.transparent
                            : tempColor == c;
                        return GestureDetector(
                          onTap: () {
                            if (isTransparent) {
                              setState(() {
                                final idx = _texts.indexWhere(
                                  (t) => t.id == sel.id,
                                );
                                if (idx != -1) {
                                  _texts[idx] = _texts[idx].copyWith(
                                    backgroundColor: Colors.transparent,
                                  );
                                }
                              });
                              Navigator.pop(ctx);
                            } else {
                              setSheetState(() {
                                tempColor = c;
                              });
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isTransparent ? Colors.white : c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFF5C518)
                                    : (isDarkMode
                                          ? Colors.grey[600]!
                                          : Colors.grey.shade400),
                                width: isSelected ? 3 : 1.5,
                              ),
                            ),
                            child: isTransparent
                                ? Center(
                                    child: Text(
                                      '∅',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isDarkMode
                                            ? Colors.white54
                                            : Colors.black45,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
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
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR CUSTOM',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: isDarkMode ? Colors.white54 : Colors.black45,
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

                  // Color picker widget (same as text color picker)
                  SizedBox(
                    height: MediaQuery.of(ctx).size.height * 0.35,
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
                              final idx = _texts.indexWhere(
                                (t) => t.id == sel.id,
                              );
                              if (idx != -1) {
                                _texts[idx] = _texts[idx].copyWith(
                                  backgroundColor: tempColor,
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
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  // ── FRAMES PANEL ──────────────────────────



///// Hided Frames /////////
Widget _buildFramesPanel() {
  final isDarkMode = _isDarkMode;
  
  // Filter out the frames to hide
  final hiddenFrames = [
    FrameLayout.diagonal,
    FrameLayout.curved,  // Wave
    FrameLayout.sideStrip,
    FrameLayout.filmstrip,
    FrameLayout.arch,
  ];
  
  final visibleFrames = _frames.where((frame) => !hiddenFrames.contains(frame.layout)).toList();

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
                'Frames — ${visibleFrames.length} Styles',
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
                    color: const Color.fromARGB(255, 48, 81, 217),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Upload Image',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
            itemCount: visibleFrames.length + 1,
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
              final f = visibleFrames[i - 1];
              // Find the original index in _frames to maintain correct selection
              final originalIndex = _frames.indexOf(f);
              return GestureDetector(
                onTap: () => setState(() => _selectedFrame = originalIndex),
                child: _frameThumb(
                  f.name,
                  f.borderColor,
                  _selectedFrame == originalIndex,
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

  // Widget _buildFramesPanel() {
  //   final isDarkMode = _isDarkMode;

  //   return Container(
  //     color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
  //           child: Row(
  //             children: [
  //               Text(
  //                 'Frames — 20 Styles',
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 13,
  //                   color: isDarkMode ? Colors.white : Colors.black87,
  //                 ),
  //               ),
  //               const Spacer(),
  //               GestureDetector(
  //                 onTap: () => _pickImage(forLogo: false),
  //                 child: Container(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 10,
  //                     vertical: 4,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: const Color.fromARGB(255, 48, 81, 217),
  //                     borderRadius: BorderRadius.circular(16),
  //                   ),
  //                   child: const Row(
  //                     children: [
  //                       Icon(
  //                         Icons.add_photo_alternate,
  //                         size: 14,
  //                         color: Colors.white,
  //                       ),
  //                       SizedBox(width: 4),
  //                       Text(
  //                         'Upload Image',
  //                         style: TextStyle(
  //                           fontSize: 11,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(
  //           height: 110,
  //           child: ListView.separated(
  //             scrollDirection: Axis.horizontal,
  //             padding: const EdgeInsets.symmetric(horizontal: 12),
  //             itemCount: _frames.length + 1,
  //             separatorBuilder: (_, __) => const SizedBox(width: 10),
  //             itemBuilder: (_, i) {
  //               if (i == 0)
  //                 return GestureDetector(
  //                   onTap: () => setState(() => _selectedFrame = -1),
  //                   child: _frameThumb(
  //                     'None',
  //                     Colors.grey.shade400,
  //                     _selectedFrame == -1,
  //                     null,
  //                   ),
  //                 );
  //               final f = _frames[i - 1];
  //               return GestureDetector(
  //                 onTap: () => setState(() => _selectedFrame = i - 1),
  //                 child: _frameThumb(
  //                   f.name,
  //                   f.borderColor,
  //                   _selectedFrame == i - 1,
  //                   f,
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

  // Widget _buildAudioPanel() {
  //   final isDarkMode = _isDarkMode;
  //   return Container(
  //     height: 220, // Increased height
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
  //           child: ListView(
  //             scrollDirection: Axis.horizontal,
  //             padding: const EdgeInsets.symmetric(horizontal: 12),
  //             children: [
  //               // 1. No Audio option
  //               GestureDetector(
  //                 onTap: () {
  //                   setState(() => _selectedAudio = null);
  //                   _playAudio(null);
  //                 },
  //                 child: _audioChip('No Audio', _selectedAudio == null),
  //               ),

  //               // 2. Upload button
  //               GestureDetector(
  //                 onTap: _pickUserAudio,
  //                 child: Container(
  //                   margin: const EdgeInsets.only(right: 10),
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 14,
  //                     vertical: 8,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xFFF5C518),
  //                     borderRadius: BorderRadius.circular(20),
  //                     border: Border.all(
  //                       color: const Color(0xFFF5C518),
  //                       width: 1,
  //                     ),
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       const Icon(
  //                         Icons.upload_file,
  //                         size: 14,
  //                         color: Colors.black87,
  //                       ),
  //                       const SizedBox(width: 4),
  //                       Text(
  //                         'Upload',
  //                         style: TextStyle(
  //                           fontSize: 11,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.black87,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),

  //               // 3. User uploaded audio tracks
  //               ..._userAudioTracks.map(
  //                 (userTrack) => Stack(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         setState(() => _selectedAudio = userTrack.name);
  //                         _playAudio(userTrack.name);
  //                       },
  //                       child: _audioChip(
  //                         '📱 ${userTrack.name} (${userTrack.durationInSeconds}s)',
  //                         _selectedAudio == userTrack.name,
  //                       ),
  //                     ),
  //                     // Delete button
  //                     Positioned(
  //                       top: -4,
  //                       right: -4,
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           _showDeleteAudioConfirmation(userTrack);
  //                         },
  //                         child: Container(
  //                           width: 18,
  //                           height: 18,
  //                           decoration: const BoxDecoration(
  //                             color: Colors.red,
  //                             shape: BoxShape.circle,
  //                           ),
  //                           child: const Icon(
  //                             Icons.close,
  //                             size: 12,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),

  //               // 4. Static audio tracks
  //               ..._audioTracks.map(
  //                 (track) => GestureDetector(
  //                   onTap: () {
  //                     setState(() => _selectedAudio = track.name);
  //                     _playAudio(track.name);
  //                   },
  //                   child: _audioChip(track.name, _selectedAudio == track.name),
  //                 ),
  //               ),
  //             ],
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

  // previous one is the correct one this is code to remove the static music////

  Widget _buildAudioPanel() {
    final isDarkMode = _isDarkMode;
    return Container(
      height: 220,
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                Text(
                  'Audio',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                if (_isLoadingAudios) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
                if (_audioLoadError != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _fetchAdminAudios,
                    child: const Icon(
                      Icons.refresh,
                      size: 16,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: _isLoadingAudios
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      // No Audio option
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedAudio = null);
                          _playAudio(null);
                        },
                        child: _audioChip('No Audio', _selectedAudio == null),
                      ),

                      // Upload user audio button
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
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.upload_file,
                                size: 14,
                                color: Colors.black87,
                              ),
                              SizedBox(width: 4),
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

                      // User uploaded audio tracks
                      ..._userAudioTracks.map(
                        (userTrack) => Stack(
                          clipBehavior: Clip.none,
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
                            Positioned(
                              top: -4,
                              right: -4,
                              child: GestureDetector(
                                onTap: () =>
                                    _showDeleteAudioConfirmation(userTrack),
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

                      // Admin audio tracks from API
                      if (_audioLoadError != null)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Could not load audios',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDarkMode
                                        ? Colors.white54
                                        : Colors.black45,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _fetchAdminAudios,
                                  child: Text(
                                    'Tap to retry',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ..._adminAudioTracks.map(
                          (adminTrack) => GestureDetector(
                            onTap: () {
                              setState(() => _selectedAudio = adminTrack.title);
                              _playAudio(adminTrack.title);
                            },
                            child: _adminAudioChip(adminTrack, isDarkMode),
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

  Widget _adminAudioChip(AdminAudioTrack track, bool isDarkMode) {
    final isSelected = _selectedAudio == track.title;
    final isPlaying = _isAudioPlaying && isSelected;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFF5C518)
            : (isDarkMode ? const Color(0xFF0F172A) : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPlaying
              ? Colors.green
              : (isSelected
                    ? const Color(0xFFF5C518)
                    : (isDarkMode ? Colors.grey[700]! : Colors.grey.shade300)),
          width: isPlaying ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPlaying ? Icons.play_arrow : Icons.music_note,
                size: 12,
                color: isPlaying
                    ? Colors.green
                    : (isSelected
                          ? Colors.black87
                          : (isDarkMode ? Colors.white54 : Colors.black45)),
              ),
              const SizedBox(width: 4),
              Text(
                track.title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isPlaying
                      ? Colors.green
                      : (isSelected
                            ? Colors.black87
                            : (isDarkMode ? Colors.white70 : Colors.black87)),
                ),
              ),
            ],
          ),
          if (track.artist.isNotEmpty)
            Text(
              track.artist,
              style: TextStyle(
                fontSize: 9,
                color: isSelected
                    ? Colors.black54
                    : (isDarkMode ? Colors.white38 : Colors.black38),
              ),
            ),
        ],
      ),
    );
  }

  // Widget _buildAudioPanel() {
  //   final isDarkMode = _isDarkMode;
  //   return Container(
  //     height: 220, // Increased height
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
  //           child: ListView(
  //             scrollDirection: Axis.horizontal,
  //             padding: const EdgeInsets.symmetric(horizontal: 12),
  //             children: [
  //               // 1. No Audio option
  //               GestureDetector(
  //                 onTap: () {
  //                   setState(() => _selectedAudio = null);
  //                   _playAudio(null);
  //                 },
  //                 child: _audioChip('No Audio', _selectedAudio == null),
  //               ),

  //               // 2. Upload button
  //               GestureDetector(
  //                 onTap: _pickUserAudio,
  //                 child: Container(
  //                   margin: const EdgeInsets.only(right: 10),
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 14,
  //                     vertical: 8,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xFFF5C518),
  //                     borderRadius: BorderRadius.circular(20),
  //                     border: Border.all(
  //                       color: const Color(0xFFF5C518),
  //                       width: 1,
  //                     ),
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       const Icon(
  //                         Icons.upload_file,
  //                         size: 14,
  //                         color: Colors.black87,
  //                       ),
  //                       const SizedBox(width: 4),
  //                       Text(
  //                         'Upload',
  //                         style: TextStyle(
  //                           fontSize: 11,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.black87,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),

  //               // 3. User uploaded audio tracks only (no static tracks)
  //               ..._userAudioTracks.map(
  //                 (userTrack) => Stack(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         setState(() => _selectedAudio = userTrack.name);
  //                         _playAudio(userTrack.name);
  //                       },
  //                       child: _audioChip(
  //                         '📱 ${userTrack.name} (${userTrack.durationInSeconds}s)',
  //                         _selectedAudio == userTrack.name,
  //                       ),
  //                     ),
  //                     // Delete button
  //                     Positioned(
  //                       top: -4,
  //                       right: -4,
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           _showDeleteAudioConfirmation(userTrack);
  //                         },
  //                         child: Container(
  //                           width: 18,
  //                           height: 18,
  //                           decoration: const BoxDecoration(
  //                             color: Colors.red,
  //                             shape: BoxShape.circle,
  //                           ),
  //                           child: const Icon(
  //                             Icons.close,
  //                             size: 12,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
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
      color: isDarkMode ? const Color.fromARGB(255, 48, 81, 217) : Colors.white,
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
                            ? const Color.fromARGB(255, 48, 81, 217)
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
                    color: const Color.fromARGB(255, 48, 81, 217),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add_a_photo, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Upload Logo',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
          // const Divider(height: 12, color: Colors.grey),
          // _bInfoRow(
          //   Icons.location_on,
          //   'Address',
          //   _brandInfo.address,
          //   () => _editBrandField(
          //     'Address',
          //     _brandInfo.address,
          //     (v) => setState(() => _brandInfo.address = v),
          //   ),
          // ),
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

  // Widget _buildEffectPanel() {
  //   final isDarkMode = _isDarkMode;
  //   final effects = [
  //     _EffectData(EffectType.none, Icons.block, 'Remove'),
  //     _EffectData(EffectType.blur, Icons.blur_on, 'Blur'),
  //     _EffectData(EffectType.grayscale, Icons.filter_b_and_w, 'Grayscale'),
  //     _EffectData(EffectType.sepia, Icons.filter_vintage, 'Sepia'),
  //     _EffectData(EffectType.brightness, Icons.brightness_5, 'Bright'),
  //     _EffectData(EffectType.contrast, Icons.contrast, 'Contrast'),
  //   ];
  //   return Container(
  //     color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
  //           child: Text(
  //             'Effect',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 13,
  //               color: isDarkMode ? Colors.white : Colors.black87,
  //             ),
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
  //                       color: sel
  //                           ? const Color(0xFFF5C518)
  //                           : (isDarkMode
  //                                 ? Colors.grey[800]!
  //                                 : Colors.grey.shade200),
  //                       width: 2,
  //                     ),
  //                     borderRadius: BorderRadius.circular(8),
  //                     color: sel
  //                         ? (isDarkMode
  //                               ? const Color(0xFF332700)
  //                               : const Color(0xFFFFF8E1))
  //                         : (isDarkMode
  //                               ? const Color(0xFF0F172A)
  //                               : Colors.grey.shade50),
  //                   ),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Icon(
  //                         e.icon,
  //                         size: 28,
  //                         color: sel
  //                             ? (isDarkMode
  //                                   ? const Color(0xFFF5C518)
  //                                   : Colors.amber.shade700)
  //                             : (isDarkMode ? Colors.white54 : Colors.black45),
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Text(
  //                         e.label,
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                           fontSize: 9,
  //                           color: sel
  //                               ? (isDarkMode
  //                                     ? const Color(0xFFF5C518)
  //                                     : Colors.amber.shade800)
  //                               : (isDarkMode
  //                                     ? Colors.white54
  //                                     : Colors.black45),
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
  //                 Text(
  //                   'Strength',
  //                   style: TextStyle(
  //                     fontSize: 12,
  //                     color: isDarkMode ? Colors.white70 : Colors.black87,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Slider(
  //                     value: _effectStrength,
  //                     min: 0,
  //                     max: 1,
  //                     activeColor: const Color(0xFFF5C518),
  //                     inactiveColor: isDarkMode
  //                         ? Colors.grey[700]
  //                         : Colors.grey[300],
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

  // Widget _buildEffectPanel() {
  //   final isDarkMode = _isDarkMode;
  //   final effects = [
  //     _EffectData(EffectType.none, Icons.block, 'None'),
  //     _EffectData(EffectType.blur, Icons.blur_on, 'Blur'),
  //     _EffectData(EffectType.grayscale, Icons.filter_b_and_w, 'Grayscale'),
  //     _EffectData(EffectType.sepia, Icons.filter_vintage, 'Sepia'),
  //     _EffectData(EffectType.brightness, Icons.brightness_5, 'Bright'),
  //     _EffectData(EffectType.contrast, Icons.contrast, 'Contrast'),
  //     // New trending effects
  //     _EffectData(EffectType.ambient, Icons.nature_people, 'Ambient'),
  //     _EffectData(EffectType.hyperChromatic, Icons.auto_awesome, 'Hyper'),
  //     _EffectData(EffectType.vintage, Icons.history, 'Vintage'),
  //     _EffectData(EffectType.chromaticAberration, Icons.grain, 'Chromatic'),
  //     _EffectData(EffectType.grainyFilm, Icons.fiber_manual_record, 'Lo-Fi'),
  //     _EffectData(EffectType.dreamyGlow, Icons.wb_sunny, 'Dreamy'),
  //     _EffectData(EffectType.vaporwave, Icons.sunny, 'Vaporwave'),
  //     _EffectData(EffectType.cyberpunk, Icons.bolt, 'Cyberpunk'),
  //     _EffectData(EffectType.cinematic, Icons.movie, 'Cinematic'),
  //     _EffectData(EffectType.polaroid, Icons.photo_camera, 'Polaroid'),
  //     _EffectData(EffectType.duotone, Icons.gradient, 'Duotone'),
  //     _EffectData(EffectType.glitch, Icons.error, 'Glitch'),
  //   ];

  //   return Container(
  //     color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
  //           child: Text(
  //             'Effects',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 13,
  //               color: isDarkMode ? Colors.white : Colors.black87,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 60,
  //           child: ListView.separated(
  //             scrollDirection: Axis.horizontal,
  //             padding: const EdgeInsets.symmetric(horizontal: 12),
  //             itemCount: effects.length,
  //             separatorBuilder: (_, __) => const SizedBox(width: 10),
  //             itemBuilder: (_, i) {
  //               final e = effects[i];
  //               final sel = _selectedEffect == e.type;
  //               return GestureDetector(
  //                 onTap: () {
  //                   _openEffectSelectionScreen();
  //                 },
  //                 // onTap: () => setState(() => _selectedEffect = e.type),
  //                 child: Container(
  //                   width: 72,
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                       color: sel
  //                           ? const Color.fromARGB(255, 48, 81, 217)
  //                           : (isDarkMode
  //                                 ? Colors.grey[800]!
  //                                 : Colors.grey.shade200),
  //                       width: 2,
  //                     ),
  //                     borderRadius: BorderRadius.circular(8),
  //                     color: sel
  //                         ? (isDarkMode
  //                               ? const Color(0xFF332700)
  //                               : const Color(0xFFFFF8E1))
  //                         : (isDarkMode
  //                               ? const Color(0xFF0F172A)
  //                               : Colors.grey.shade50),
  //                   ),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Icon(
  //                         e.icon,
  //                         size: 28,
  //                         color: sel
  //                             ? (isDarkMode
  //                                   ? const Color(0xFFF5C518)
  //                                   : Colors.amber.shade700)
  //                             : (isDarkMode ? Colors.white54 : Colors.black45),
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Text(
  //                         e.label,
  //                         textAlign: TextAlign.center,
  //                         maxLines: 2,
  //                         style: TextStyle(
  //                           fontSize: 8,
  //                           color: sel
  //                               ? (isDarkMode
  //                                     ? const Color(0xFFF5C518)
  //                                     : Colors.amber.shade800)
  //                               : (isDarkMode
  //                                     ? Colors.white54
  //                                     : Colors.black45),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),

  //         // Strength slider for selected effect
  //         if (_selectedEffect != EffectType.none)
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       _getEffectName(_selectedEffect),
  //                       style: TextStyle(
  //                         fontSize: 13,
  //                         fontWeight: FontWeight.w600,
  //                         color: isDarkMode ? Colors.white70 : Colors.black87,
  //                       ),
  //                     ),
  //                     Text(
  //                       '${(_effectStrength * 100).toInt()}%',
  //                       style: TextStyle(
  //                         fontSize: 13,
  //                         fontWeight: FontWeight.bold,
  //                         color: const Color.fromARGB(255, 48, 81, 217),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Slider(
  //                   value: _effectStrength,
  //                   min: 0,
  //                   max: 1,
  //                   divisions: 100,
  //                   activeColor: const Color.fromARGB(255, 48, 81, 217),
  //                   inactiveColor: isDarkMode
  //                       ? Colors.grey[700]
  //                       : Colors.grey[300],
  //                   onChanged: (v) => setState(() => _effectStrength = v),
  //                 ),
  //               ],
  //             ),
  //           ),

  //         const SizedBox(height: 8),
  //       ],
  //     ),
  //   );
  // }



////This is for adding extra screeen/
  Widget _buildEffectPanel() {
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
                'Effects',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              // Show currently applied effect
              if (_selectedEffect != EffectType.none)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, size: 12, color: Colors.purpleAccent),
                      const SizedBox(width: 4),
                      Text(
                        _getEffectName(_selectedEffect),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(_effectStrength * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Center button to open effect selection
        Center(
          child: GestureDetector(
            onTap: _openEffectSelectionScreen,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_fix_high,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedEffect != EffectType.none
                        ? 'Change Effect'
                        : 'Add Effect',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}



  void _openEffectSelectionScreen() {
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => EffectSelectionScreen(
        selectedEffect: _selectedEffect,
        effectStrength: _effectStrength,
        onEffectApplied: (effect, strength) {
          setState(() {
            _selectedEffect = effect;
            _effectStrength = strength;
          });
        },
        onEffectRemoved: () {
          setState(() {
            _selectedEffect = EffectType.none;
            _effectStrength = 0.5;
          });
        },
      ),
    ),
  );
}

  // Helper methods for effects
  String _getEffectName(EffectType effect) {
    switch (effect) {
      case EffectType.blur:
        return 'Blur Strength';
      case EffectType.grayscale:
        return 'Grayscale Intensity';
      case EffectType.sepia:
        return 'Sepia Tone';
      case EffectType.brightness:
        return 'Brightness';
      case EffectType.contrast:
        return 'Contrast';
      default:
        return 'Effect Strength';
    }
  }

  IconData _getEffectIcon(EffectType effect) {
    switch (effect) {
      case EffectType.blur:
        return Icons.blur_on;
      case EffectType.grayscale:
        return Icons.filter_b_and_w;
      case EffectType.sepia:
        return Icons.filter_vintage;
      case EffectType.brightness:
        return Icons.brightness_5;
      case EffectType.contrast:
        return Icons.contrast;
      default:
        return Icons.tune;
    }
  }

  String _getEffectDescription(EffectType effect, double strength) {
    int percent = (strength * 100).toInt();
    switch (effect) {
      case EffectType.blur:
        if (percent == 0) return 'No blur';
        if (percent < 30) return 'Light blur';
        if (percent < 70) return 'Medium blur';
        return 'Heavy blur';
      case EffectType.grayscale:
        if (percent == 0) return 'Full color';
        if (percent < 30) return 'Slightly desaturated';
        if (percent < 70) return 'Partially grayscale';
        return 'Fully grayscale';
      case EffectType.sepia:
        if (percent == 0) return 'No sepia';
        if (percent < 30) return 'Light sepia tone';
        if (percent < 70) return 'Warm sepia';
        return 'Strong vintage sepia';
      case EffectType.brightness:
        if (percent == 50) return 'Normal brightness';
        if (percent < 50) return 'Darker';
        return 'Brighter';
      case EffectType.contrast:
        if (percent == 50) return 'Normal contrast';
        if (percent < 50) return 'Lower contrast';
        return 'Higher contrast';
      default:
        return 'No effect applied';
    }
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
      _TabData(BottomTab.fonts, Icons.font_download, 'Fonts'), // Add this
    ];
    return Container(
      color: isDarkMode ? const Color.fromARGB(255, 48, 81, 217) : Colors.white,
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).padding.bottom +
            4, // Add system bottom padding
        top: 4,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: tabs
              .map(
                (t) => GestureDetector(
                  onTap: () {
                    if (t.tab == BottomTab.audio) {
                      _openAudioSelectionScreen();
                    } else {
                      setState(() => _activeTab = t.tab);
                    }
                  },
                  // onTap: () => setState(() => _activeTab = t.tab),
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
                              ? const Color.fromARGB(255, 48, 81, 217)
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
                              ? const Color.fromARGB(255, 48, 81, 217)
                              : (isDarkMode ? Colors.white54 : Colors.black54),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.label,
                          style: TextStyle(
                            fontSize: 9,
                            color: _activeTab == t.tab
                                ? const Color.fromARGB(255, 48, 81, 217)
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

  // Widget _buildDownloadDialog() {
  //   final isDarkMode = _isDarkMode;

  //   return Positioned.fill(
  //     child: Container(
  //       color: Colors.black45,
  //       child: Center(
  //         child: Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 40),
  //           padding: const EdgeInsets.all(24),
  //           decoration: BoxDecoration(
  //             color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 _isAnimated ? 'Exporting Video…' : 'Saving to Gallery…',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: isDarkMode ? Colors.white : Colors.black87,
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(4),
  //                 child: LinearProgressIndicator(
  //                   value: _downloadProgress,
  //                   backgroundColor: isDarkMode
  //                       ? Colors.grey[800]
  //                       : Colors.grey.shade200,
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
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       color: isDarkMode ? Colors.white54 : Colors.black54,
  //                     ),
  //                   ),
  //                   Text(
  //                     '${(_downloadProgress * 100).toInt()}/100',
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       color: isDarkMode ? Colors.white54 : Colors.black54,
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
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.82),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animController,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _animController.value * 2 * pi,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const SweepGradient(
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Color(0xFF00BCD4),
                              Color(0xFF00E5FF),
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.4, 0.6, 0.75, 1.0],
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // Inner reverse ring
                    AnimatedBuilder(
                      animation: _animController,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: -_animController.value * 2 * pi * 1.5,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 118,
                        height: 118,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Color(0xFF0077A8),
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.5, 0.65, 1.0],
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // Orbit dots
                    _buildOrbitDot(0.0, const Color(0xFF00E5FF), 7),
                    _buildOrbitDot(pi * 2 / 3, const Color(0xFF00BCD4), 5),
                    _buildOrbitDot(pi * 4 / 3, const Color(0xFF0077A8), 6),
                    // Pulse glow
                    AnimatedBuilder(
                      animation: _animValue,
                      builder: (_, __) {
                        return Container(
                          width: 90 * (0.92 + 0.16 * _animValue.value),
                          height: 90 * (0.92 + 0.16 * _animValue.value),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF00BCD4,
                                ).withOpacity(0.35),
                                blurRadius: 24,
                                spreadRadius: 8,
                              ),
                              BoxShadow(
                                color: const Color(0xFF00E5FF).withOpacity(0.2),
                                blurRadius: 40,
                                spreadRadius: 14,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Logo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        'assets/mainlogo.jpeg',
                        width: 82,
                        height: 82,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0077A8), Color(0xFF00BCD4)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.download,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Arc progress
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(80, 80),
                      painter: _DownloadArcPainter(progress: _downloadProgress),
                    ),
                    Text(
                      '${(_downloadProgress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Animated label
              _buildDownloadLabel(),
              const SizedBox(height: 8),
              Text(
                _isAnimated ? 'Exporting video...' : 'Saving to gallery...',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 12,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrbitDot(double angle, Color color, double size) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (_, __) {
        final computedAngle = angle + (_animController.value * 2 * pi);
        const radius = 52.0;
        final dx = cos(computedAngle) * radius;
        final dy = sin(computedAngle) * radius;
        return Transform.translate(
          offset: Offset(dx, dy),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.8), blurRadius: 6),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDownloadLabel() {
    const label = 'Downloading';
    return AnimatedBuilder(
      animation: _animController,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...List.generate(label.length, (i) {
              final offset =
                  sin((_animController.value * 2 * pi) + (i * 0.45)) * 4.0;
              final t =
                  (sin((_animController.value * 2 * pi) + (i * 0.5)) + 1) / 2;
              final color =
                  Color.lerp(
                    const Color(0xFF0077A8),
                    const Color(0xFF00E5FF),
                    t,
                  ) ??
                  const Color(0xFF00BCD4);
              return Transform.translate(
                offset: Offset(0, offset),
                child: Text(
                  label[i],
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              );
            }),
            ...List.generate(3, (i) {
              final dotPhase = (_animController.value * 3 - i).floor() % 3 == 0;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: dotPhase ? 5 : 0,
                  left: i == 0 ? 2 : 1,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotPhase
                        ? const Color(0xFF00E5FF)
                        : Colors.white.withOpacity(0.3),
                  ),
                ),
              );
            }),
          ],
        );
      },
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

                ///////////// This part is hidden///

                // Divider
                // Divider(
                //   height: 1,
                //   color: isDarkMode ? Colors.grey[800] : Colors.grey.shade200,
                // ),

                // // Overlay brand items in layers
                // ..._overlayBrandItems.map(
                //   (e) => ListTile(
                //     leading: Icon(
                //       e.type == BrandElementType.logo
                //           ? Icons.image
                //           : e.type == BrandElementType.name
                //           ? Icons.badge
                //           : e.type == BrandElementType.phone
                //           ? Icons.phone_android
                //           : Icons.pin_drop,
                //       color: Colors.purple,
                //     ),
                //     title: Text(
                //       'Canvas: ${e.type.name[0].toUpperCase()}${e.type.name.substring(1)}',
                //       style: TextStyle(
                //         color: isDarkMode ? Colors.white : Colors.black87,
                //       ),
                //     ),
                //     subtitle: Text(
                //       e.isVisible ? 'Visible on canvas' : 'Hidden',
                //       style: TextStyle(
                //         fontSize: 11,
                //         color: e.isVisible ? Colors.green : Colors.red,
                //       ),
                //     ),
                //     trailing: IconButton(
                //       icon: Icon(
                //         e.isVisible ? Icons.visibility : Icons.visibility_off,
                //         size: 18,
                //         color: e.isVisible
                //             ? Colors.purple
                //             : (isDarkMode ? Colors.grey[600] : Colors.grey),
                //       ),
                //       onPressed: () {
                //         setState(() {
                //           final i = _overlayBrandItems.indexWhere(
                //             (x) => x.id == e.id,
                //           );
                //           if (i != -1)
                //             _overlayBrandItems[i] = _overlayBrandItems[i]
                //                 .copyWith(isVisible: !e.isVisible);
                //         });
                //         setSheet(() {});
                //       },
                //     ),
                //   ),
                // ),

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

// class _TextEditorSheet extends StatefulWidget {
//   final OverlayTextItem item;
//   final ValueChanged<OverlayTextItem> onChanged;

//   const _TextEditorSheet({
//     Key? key,
//     required this.item,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   State<_TextEditorSheet> createState() => _TextEditorSheetState();
// }

// class _TextEditorSheetState extends State<_TextEditorSheet> {
//   late TextEditingController _ctrl;
//   late OverlayTextItem _current;

//   @override
//   void initState() {
//     super.initState();
//     _current = widget.item;
//     _ctrl = TextEditingController(text: widget.item.text);
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   void _update(OverlayTextItem updated) {
//     setState(() => _current = updated);
//     widget.onChanged(updated);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: isDarkMode ? Colors.grey[700] : Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _ctrl,
//               autofocus: true,
//               maxLines: 3,
//               minLines: 1,
//               style: TextStyle(
//                 color: isDarkMode ? Colors.white : Colors.black87,
//               ),
//               decoration: InputDecoration(
//                 hintText: 'Enter text…',
//                 hintStyle: TextStyle(
//                   color: isDarkMode ? Colors.white54 : Colors.black45,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(
//                     color: isDarkMode ? Colors.white38 : Colors.grey.shade400,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(
//                     color: isDarkMode ? Colors.white38 : Colors.grey.shade400,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(
//                     color: Color(0xFFF5C518),
//                     width: 2,
//                   ),
//                 ),
//               ),
//               onChanged: (v) => _update(_current.copyWith(text: v)),
//             ),
//             SizedBox(height: 15),
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
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Done'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _chip(
//     String label,
//     bool active,
//     VoidCallback onTap,
//     bool isDarkMode, {
//     bool bold = false,
//     bool italic = false,
//     bool underline = false,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//         decoration: BoxDecoration(
//           color: active
//               ? (isDarkMode ? Colors.white : Colors.black87)
//               : (isDarkMode ? const Color(0xFF0F172A) : Colors.grey.shade100),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 13,
//             color: active
//                 ? (isDarkMode ? Colors.black87 : Colors.white)
//                 : (isDarkMode ? Colors.white70 : Colors.black87),
//             fontWeight: bold ? FontWeight.bold : FontWeight.normal,
//             fontStyle: italic ? FontStyle.italic : FontStyle.normal,
//             decoration: underline
//                 ? TextDecoration.underline
//                 : TextDecoration.none,
//           ),
//         ),
//       ),
//     );
//   }
// }

class _TextEditorSheet extends StatefulWidget {
  final OverlayTextItem item;
  final ValueChanged<OverlayTextItem> onChanged;
  final VoidCallback? onDelete; // Add this callback

  const _TextEditorSheet({
    Key? key,
    required this.item,
    required this.onChanged,
    this.onDelete, // Add this
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

  void _showDeleteConfirmation() {
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
                Text(
                  'Delete Text',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to delete this text?',
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
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Close editor sheet
                          widget.onDelete?.call();
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
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[700] : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),

            // Header with title and delete button
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Edit Text',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                // Delete button
                GestureDetector(
                  onTap: _showDeleteConfirmation,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Text input field
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
            const SizedBox(height: 15),

            // Done button
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

class AdminAudioTrack {
  final String id;
  final String title;
  final String artist;
  final String audioUrl;

  AdminAudioTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioUrl,
  });

  factory AdminAudioTrack.fromJson(Map<String, dynamic> json) {
    return AdminAudioTrack(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Unknown',
      artist: json['artist'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
    );
  }
}

////// Newly added class for add text movement/////////////

class _DraggableTextWidget extends StatefulWidget {
  final OverlayTextItem item;
  final bool isSelected;
  final TextStyle textStyle;
  final ValueChanged<Offset> onPositionChanged;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<double> onResize;

  const _DraggableTextWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.textStyle,
    required this.onPositionChanged,
    required this.onTap,
    required this.onDelete,
    required this.onResize,
  }) : super(key: key);

  @override
  State<_DraggableTextWidget> createState() => _DraggableTextWidgetState();
}

class _DraggableTextWidgetState extends State<_DraggableTextWidget> {
  Offset? _resizeStartOffset;
  double? _resizeStartFontSize;
  String? _resizingTextId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onPanUpdate: (d) {
        widget.onPositionChanged(widget.item.position + d.delta);
      },
      onLongPress: () {
        _showDeleteConfirmationDialog();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: widget.isSelected
                ? BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 1.5),
                    color: Colors.blue.withOpacity(0.05),
                  )
                : null,
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: widget.item.hasBorder
                  ? BoxDecoration(
                      border: Border.all(color: widget.item.color, width: 1),
                      color: widget.item.backgroundColor == Colors.transparent
                          ? null
                          : widget.item.backgroundColor,
                    )
                  : null,
              color:
                  !widget.item.hasBorder &&
                      widget.item.backgroundColor != Colors.transparent
                  ? widget.item.backgroundColor
                  : null,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Transform.rotate(
                angle: widget.item.rotation,
                child: Text(
                  widget.item.text,
                  textAlign: widget.item.align,
                  style: widget.textStyle,
                ),
              ),
            ),
          ),
          if (widget.isSelected)
            Positioned(
              right: -6,
              bottom: -6,
              child: GestureDetector(
                onPanStart: (d) {
                  _resizingTextId = widget.item.id;
                  _resizeStartOffset = d.globalPosition;
                  _resizeStartFontSize = widget.item.fontSize;
                },
                onPanUpdate: (d) {
                  if (_resizingTextId != widget.item.id) return;
                  final delta =
                      (d.globalPosition.dx -
                          _resizeStartOffset!.dx +
                          d.globalPosition.dy -
                          _resizeStartOffset!.dy) /
                      2;
                  final newSize = (_resizeStartFontSize! + delta).clamp(
                    8.0,
                    96.0,
                  );
                  widget.onResize(newSize);
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
    );
  }

  void _showDeleteConfirmationDialog() {
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
                Text(
                  'Delete Text',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to delete this text?',
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
                          Navigator.pop(context);
                          widget.onDelete();
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
}

// ─────────────────────────────────────────────
//  AUDIO SELECTION SCREEN
// ─────────────────────────────────────────────

class AudioSelectionScreen extends StatefulWidget {
  final List<AdminAudioTrack> adminAudioTracks;
  final List<UserAudioTrack> userAudioTracks;
  final String? selectedAudio;
  final bool isLoadingAudios;
  final String? audioLoadError;
  final Future<void> Function(String trackName) onAudioSelected;
  final Future<void> Function() onAudioRemoved;
  final VoidCallback onPickUserAudio;
  final void Function(UserAudioTrack) onDeleteUserAudio;
  final VoidCallback onRetryFetch;

  const AudioSelectionScreen({
    Key? key,
    required this.adminAudioTracks,
    required this.userAudioTracks,
    required this.selectedAudio,
    required this.isLoadingAudios,
    required this.audioLoadError,
    required this.onAudioSelected,
    required this.onAudioRemoved,
    required this.onPickUserAudio,
    required this.onDeleteUserAudio,
    required this.onRetryFetch,
  }) : super(key: key);

  @override
  State<AudioSelectionScreen> createState() => _AudioSelectionScreenState();
}

class _AudioSelectionScreenState extends State<AudioSelectionScreen> {
  String? _previewAudio; // track tapped but not confirmed yet
  String? _confirmedAudio;

  @override
  void initState() {
    super.initState();
    _confirmedAudio = widget.selectedAudio;
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  void _onTrackTap(String trackName) {
    setState(() => _previewAudio = trackName);
    _showConfirmDialog(trackName);
  }

  void _showConfirmDialog(String trackName) {
    final isDark = _isDark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5C518).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  size: 36,
                  color: Color(0xFFF5C518),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add Audio?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add "$trackName" to your poster?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() => _previewAudio = null);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(ctx); // close dialog
                        setState(() {
                          _confirmedAudio = trackName;
                          _previewAudio = null;
                        });
                        // call parent callback then pop back to editor
                        await widget.onAudioSelected(trackName);
                        if (mounted) Navigator.pop(context); // back to editor
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5C518),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Yes, Add',
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

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F5F5);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white54 : Colors.black45;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Choose Audio',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          // Remove audio button
          if (_confirmedAudio != null)
            TextButton.icon(
              onPressed: () async {
                await widget.onAudioRemoved();
                if (mounted) Navigator.pop(context);
              },
              icon: const Icon(Icons.volume_off, color: Colors.red, size: 18),
              label: const Text(
                'Remove',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
        ],
      ),
      body: widget.isLoadingAudios
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // ── Currently selected banner ──
                if (_confirmedAudio != null)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5C518).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFF5C518),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.music_note,
                            color: Color(0xFFF5C518),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Currently selected',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: textSecondary,
                                  ),
                                ),
                                Text(
                                  _confirmedAudio!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFFF5C518),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Upload section ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Text(
                      'Upload Your Audio',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: widget.onPickUserAudio,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFF5C518),
                            width: 1.5,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF5C518,
                                ).withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.upload_file,
                                color: Color(0xFFF5C518),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Upload from device',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                                Text(
                                  'Max 30 seconds • MP3, M4A, WAV',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── User uploaded tracks ──
                if (widget.userAudioTracks.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text(
                        'Your Uploads',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((_, i) {
                      final track = widget.userAudioTracks[i];
                      final isSelected = _confirmedAudio == track.name;
                      return _AudioTrackTile(
                        title: track.name,
                        subtitle: '${track.durationInSeconds}s • Your upload',
                        icon: Icons.phone_android,
                        iconColor: Colors.purple,
                        isSelected: isSelected,
                        cardBg: cardBg,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        onTap: () => _onTrackTap(track.name),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () => widget.onDeleteUserAudio(track),
                        ),
                      );
                    }, childCount: widget.userAudioTracks.length),
                  ),
                ],

                // ── Admin/library tracks ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Row(
                      children: [
                        Text(
                          'Music Library',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5C518).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${widget.adminAudioTracks.length}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFF5C518),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                widget.audioLoadError != null
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                Icons.wifi_off,
                                size: 48,
                                color: textSecondary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Could not load music library',
                                style: TextStyle(color: textSecondary),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: widget.onRetryFetch,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF5C518),
                                  foregroundColor: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : widget.adminAudioTracks.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              'No tracks available',
                              style: TextStyle(color: textSecondary),
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((_, i) {
                          final track = widget.adminAudioTracks[i];
                          final isSelected = _confirmedAudio == track.title;
                          return _AudioTrackTile(
                            title: track.title,
                            subtitle: track.artist.isNotEmpty
                                ? track.artist
                                : 'Music Library',
                            icon: Icons.music_note,
                            iconColor: Colors.blueAccent,
                            isSelected: isSelected,
                            cardBg: cardBg,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            onTap: () => _onTrackTap(track.title),
                          );
                        }, childCount: widget.adminAudioTracks.length),
                      ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
    );
  }
}

// ─── Reusable audio tile ───────────────────────

class _AudioTrackTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final Color cardBg;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;
  final Widget? trailing;

  const _AudioTrackTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.cardBg,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF5C518).withOpacity(0.12)
              : cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFF5C518) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (isSelected && trailing == null)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFF5C518),
                size: 22,
              ),
            if (!isSelected && trailing == null)
              Icon(Icons.play_circle_outline, color: textSecondary, size: 22),
          ],
        ),
      ),
    );
  }
}

class _DownloadArcPainter extends CustomPainter {
  final double progress;
  _DownloadArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;
    const startAngle = -pi / 2;
    const fullSweep = 2 * pi;

    final trackPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final glowPaint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fullSweep * progress,
      false,
      glowPaint,
    );

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + fullSweep * progress,
        colors: const [Color(0xFF00BCD4), Color(0xFF00E5FF)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fullSweep * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_DownloadArcPainter old) => old.progress != progress;
}













// ─────────────────────────────────────────────
//  EFFECT SELECTION SCREEN
// ─────────────────────────────────────────────

class EffectSelectionScreen extends StatefulWidget {
  final EffectType selectedEffect;
  final double effectStrength;
  final Function(EffectType effect, double strength) onEffectApplied;
  final VoidCallback onEffectRemoved;

  const EffectSelectionScreen({
    Key? key,
    required this.selectedEffect,
    required this.effectStrength,
    required this.onEffectApplied,
    required this.onEffectRemoved,
  }) : super(key: key);

  @override
  State<EffectSelectionScreen> createState() => _EffectSelectionScreenState();
}

class _EffectSelectionScreenState extends State<EffectSelectionScreen> {
  late EffectType _previewEffect;
  late EffectType _confirmedEffect;
  late double _strength;

  final List<_EffectEntry> _effects = [
    _EffectEntry(EffectType.blur, Icons.blur_on, 'Blur', 'Soft focus look'),
    _EffectEntry(EffectType.grayscale, Icons.filter_b_and_w, 'Grayscale', 'Black & white'),
    _EffectEntry(EffectType.sepia, Icons.filter_vintage, 'Sepia', 'Warm vintage tone'),
    _EffectEntry(EffectType.brightness, Icons.brightness_5, 'Brightness', 'Adjust light'),
    _EffectEntry(EffectType.contrast, Icons.contrast, 'Contrast', 'Adjust contrast'),
    _EffectEntry(EffectType.ambient, Icons.nature_people, 'Ambient', 'Soft & calm'),
    _EffectEntry(EffectType.hyperChromatic, Icons.auto_awesome, 'Hyper', 'Vibrant colors'),
    _EffectEntry(EffectType.vintage, Icons.history, 'Vintage', 'Retro nostalgic'),
    _EffectEntry(EffectType.chromaticAberration, Icons.grain, 'Chromatic', 'RGB split glitch'),
    _EffectEntry(EffectType.grainyFilm, Icons.fiber_manual_record, 'Lo-Fi', 'Grainy film'),
    _EffectEntry(EffectType.dreamyGlow, Icons.wb_sunny, 'Dreamy', 'Soft ethereal glow'),
    _EffectEntry(EffectType.vaporwave, Icons.sunny, 'Vaporwave', '80s retro-futuristic'),
    _EffectEntry(EffectType.cyberpunk, Icons.bolt, 'Cyberpunk', 'High-tech neon'),
    _EffectEntry(EffectType.cinematic, Icons.movie, 'Cinematic', 'Movie film look'),
    _EffectEntry(EffectType.polaroid, Icons.photo_camera, 'Polaroid', 'Instant film'),
    _EffectEntry(EffectType.duotone, Icons.gradient, 'Duotone', 'Two-color gradient'),
    _EffectEntry(EffectType.glitch, Icons.error, 'Glitch', 'Digital distortion'),
  ];

  @override
  void initState() {
    super.initState();
    _previewEffect = widget.selectedEffect;
    _confirmedEffect = widget.selectedEffect;
    _strength = widget.effectStrength;
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  void _onEffectTap(_EffectEntry entry) {
    setState(() => _previewEffect = entry.type);
    _showConfirmDialog(entry);
  }

  void _showConfirmDialog(_EffectEntry entry) {
    final isDark = _isDark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(entry.icon, size: 36, color: Colors.purpleAccent),
              ),
              const SizedBox(height: 16),
              Text(
                'Apply "${entry.label}" Effect?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                entry.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              // Strength slider inside dialog
              StatefulBuilder(
                builder: (_, setSlider) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Strength',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        Text(
                          '${(_strength * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _strength,
                      min: 0,
                      max: 1,
                      divisions: 100,
                      activeColor: Colors.purpleAccent,
                      inactiveColor: isDark ? Colors.grey[700] : Colors.grey[300],
                      onChanged: (v) {
                        setSlider(() => _strength = v);
                        setState(() => _strength = v);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() => _previewEffect = _confirmedEffect);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() => _confirmedEffect = entry.type);
                        widget.onEffectApplied(entry.type, _strength);
                        Navigator.pop(context); // back to poster editor
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply',
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

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F5F5);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white54 : Colors.black45;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Choose Effect',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (_confirmedEffect != EffectType.none)
            TextButton.icon(
              onPressed: () {
                widget.onEffectRemoved();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.auto_fix_off, color: Colors.red, size: 18),
              label: const Text(
                'Remove',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // ── Currently applied banner ──
          if (_confirmedEffect != EffectType.none)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purpleAccent, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_fix_high, color: Colors.purpleAccent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Currently applied',
                            style: TextStyle(fontSize: 11, color: textSecondary),
                          ),
                          Text(
                            _effects
                                .firstWhere(
                                  (e) => e.type == _confirmedEffect,
                                  orElse: () => _EffectEntry(
                                    EffectType.none, Icons.block, 'None', ''),
                                )
                                .label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${(widget.effectStrength * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.purpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.check_circle, color: Colors.purpleAccent, size: 20),
                  ],
                ),
              ),
            ),

          // ── Section header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                children: [
                  Text(
                    'All Effects',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_effects.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.purpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Effects grid ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              delegate: SliverChildBuilderDelegate((_, i) {
                final entry = _effects[i];
                final isSelected = _confirmedEffect == entry.type;
                return GestureDetector(
                  onTap: () => _onEffectTap(entry),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.purpleAccent.withOpacity(0.12)
                          : cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? Colors.purpleAccent
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.purpleAccent.withOpacity(0.2)
                                : (isDark
                                    ? Colors.white10
                                    : Colors.grey.shade100),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            entry.icon,
                            size: 26,
                            color: isSelected
                                ? Colors.purpleAccent
                                : textSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          entry.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.purpleAccent
                                : textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            entry.description,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              color: textSecondary,
                            ),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(height: 6),
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.purpleAccent,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }, childCount: _effects.length),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HELPER DATA CLASS
// ─────────────────────────────────────────────

class _EffectEntry {
  final EffectType type;
  final IconData icon;
  final String label;
  final String description;
  _EffectEntry(this.type, this.icon, this.label, this.description);
}