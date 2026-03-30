import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:posternova/helper/storage_helper.dart';

// ══════════════════════════════════════════════════════════════
//  pubspec.yaml dependencies needed:
//
//  dependencies:
//    google_fonts: ^6.2.1
//    gal: ^2.3.0
//    http: ^1.2.0
// ══════════════════════════════════════════════════════════════

// ─────────────────────────────────────────────
//  DATA MODELS (Updated for your API)
// ─────────────────────────────────────────────

class _TextOverlayPainter extends CustomPainter {
  final List<EditableLayer> layers;
  final ui.Image? bgImage;

  _TextOverlayPainter({required this.layers, required this.bgImage});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background image
    if (bgImage != null) {
      canvas.drawImageRect(
        bgImage!,
        Rect.fromLTWH(
          0,
          0,
          bgImage!.width.toDouble(),
          bgImage!.height.toDouble(),
        ),
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint(),
      );
    }

    // Draw text layers — mirrors Canvas2D fillText exactly
    for (final layer in layers) {
      if (layer.type != LayerType.text) continue;

      final tp = TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: layer.textAlign,
      );

      tp.text = TextSpan(text: layer.content, style: layer.textStyle);

      tp.layout(maxWidth: size.width);

      // Canvas2D: fillText(text, x, y)
      //   x = center of text (textAlign: center)
      //   y = baseline
      // TextPainter: paint(canvas, offset)
      //   offset = top-left of text
      //
      // So: offsetX = centerX - textWidth/2
      //     offsetY = baselineY - tp.computeDistanceToActualBaseline()

      final double centerX = layer.position.dx; // stored as scaled center
      final double baselineY = layer.position.dy; // stored as scaled baseline

      final double textWidth = tp.width;
      double offsetX;
      if (layer.textAlign == TextAlign.center) {
        offsetX = centerX - textWidth / 2;
      } else if (layer.textAlign == TextAlign.right) {
        offsetX = centerX - textWidth;
      } else {
        offsetX = centerX; // left align: x is left edge
      }

      // Get the actual ascent of this font/size
      final baseline = tp.computeDistanceToActualBaseline(
        TextBaseline.alphabetic,
      );
      final double offsetY = baselineY - baseline;

      tp.paint(canvas, Offset(offsetX, offsetY));
    }
  }

  @override
  bool shouldRepaint(covariant _TextOverlayPainter old) => true;
}

class LogoPlaceholder {
  final String id;
  final String type;
  final String label;
  final String defaultValue;
  final Offset position;
  final Size size;
  final TextStyle style;
  final bool required;
  final int maxLength;
  final TextAlign textAlign;

  LogoPlaceholder({
    required this.id,
    required this.type,
    required this.label,
    required this.defaultValue,
    required this.position,
    required this.size,
    required this.style,
    required this.required,
    required this.maxLength,
    required this.textAlign,
  });

  factory LogoPlaceholder.fromJson(Map<String, dynamic> json) {
    return LogoPlaceholder(
      id: json['id'],
      type: json['type'],
      label: json['label'],
      defaultValue: json['defaultValue'],
      position: Offset(
        json['position']['x'].toDouble(),
        json['position']['y'].toDouble(),
      ),
      size: Size(
        json['position']['width'].toDouble(),
        json['position']['height'].toDouble(),
      ),
      style: _parseTextStyle(json['style']),
      required: json['required'] ?? false,
      maxLength: json['maxLength'] ?? 100,
      textAlign: _parseTextAlign(json['style']['textAlign'] ?? 'center'),
    );
  }

  static TextStyle _parseTextStyle(Map<String, dynamic> style) {
    return TextStyle(
      fontSize: (style['fontSize'] ?? 24).toDouble(),
      fontWeight: style['fontWeight'] == 'bold'
          ? FontWeight.bold
          : FontWeight.normal,
      color: Color(
        int.parse(style['color'].replaceFirst('#', 'FF'), radix: 16),
      ),
      letterSpacing: (style['letterSpacing'] ?? 0).toDouble(),
    );
  }

  static TextAlign _parseTextAlign(String align) {
    switch (align.toLowerCase()) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.center;
    }
  }
}

class LogoData {
  final String id;
  final String name;
  final String imageUrl;
  final String previewImageUrl;
  final List<LogoPlaceholder> placeholders;
  final DateTime createdAt;
  final DateTime updatedAt;

  LogoData({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.previewImageUrl,
    required this.placeholders,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LogoData.fromJson(Map<String, dynamic> json) {
    return LogoData(
      id: json['_id'],
      name: json['name'],
      imageUrl: json['image'],
      previewImageUrl: json['previewImage'],
      placeholders: (json['placeholders'] as List)
          .map((p) => LogoPlaceholder.fromJson(p))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

// ─────────────────────────────────────────────
//  GOOGLE FONTS CATALOGUE
// ─────────────────────────────────────────────

class GFontEntry {
  final String name;
  final TextStyle Function({TextStyle? textStyle}) font;

  GFontEntry(this.name, this.font);
}

final List<GFontEntry> kGoogleFonts = [
  GFontEntry('Montserrat', GoogleFonts.montserrat),
  GFontEntry('Roboto', GoogleFonts.roboto),
  GFontEntry('Playfair Display', GoogleFonts.playfairDisplay),
  GFontEntry('Raleway', GoogleFonts.raleway),
  GFontEntry('Lato', GoogleFonts.lato),
  GFontEntry('Oswald', GoogleFonts.oswald),
  GFontEntry('Pacifico', GoogleFonts.pacifico),
  GFontEntry('Dancing Script', GoogleFonts.dancingScript),
  GFontEntry('Bebas Neue', GoogleFonts.bebasNeue),
  GFontEntry('Righteous', GoogleFonts.righteous),
  GFontEntry('Abril Fatface', GoogleFonts.abrilFatface),
  GFontEntry('Lobster', GoogleFonts.lobster),
  GFontEntry('Cinzel', GoogleFonts.cinzel),
  GFontEntry('Exo 2', GoogleFonts.exo2),
  GFontEntry('Nunito', GoogleFonts.nunito),
  GFontEntry('Poppins', GoogleFonts.poppins),
  GFontEntry('Source Code Pro', GoogleFonts.sourceCodePro),
  GFontEntry('Titan One', GoogleFonts.titanOne),
  GFontEntry('Satisfy', GoogleFonts.satisfy),
  GFontEntry('Permanent Marker', GoogleFonts.permanentMarker),
  GFontEntry('Shadows Into Light', GoogleFonts.shadowsIntoLight),
  GFontEntry('Comfortaa', GoogleFonts.comfortaa),
  GFontEntry('Press Start 2P', GoogleFonts.pressStart2p),
];

// ─────────────────────────────────────────────
//  UNIFIED EDITABLE LAYER
// ─────────────────────────────────────────────

enum LayerType { text, sticker }

class EditableLayer {
  final String id;
  final LayerType type;

  String content;
  Offset position;
  double fontSize;

  // text-only styling
  Color color;
  FontWeight fontWeight;
  String fontFamily;
  TextAlign textAlign;

  double centerX;

  // true = originally from the API (cannot be deleted, shown as "Logo Text")
  final bool isPlaceholder;
  final int maxLength;

  EditableLayer({
    required this.id,
    required this.type,
    required this.content,
    required this.position,
    this.fontSize = 24,
    this.color = Colors.white,
    this.fontWeight = FontWeight.bold,
    this.fontFamily = 'Montserrat',
    this.textAlign = TextAlign.center,
    this.isPlaceholder = false,
    this.maxLength = 80,
    this.centerX = -1,
  });

  /// Resolved TextStyle using the chosen Google Font.
  TextStyle get textStyle {
    final base = TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: 0.5,
    );
    try {
      final entry = kGoogleFonts.firstWhere((e) => e.name == fontFamily);
      return entry.font(textStyle: base);
    } catch (_) {
      return base;
    }
  }

  /// Auto-contrasting halo so text is always readable on any background.
  List<Shadow> get visibilityShadows {
    final lum = color.computeLuminance();
    final sc = lum > 0.4
        ? Colors.black.withOpacity(0.7)
        : Colors.white.withOpacity(0.7);
    return [
      Shadow(color: sc, offset: Offset.zero, blurRadius: 8),
      Shadow(color: sc, offset: const Offset(1, 1), blurRadius: 2),
    ];
  }
}

// ─────────────────────────────────────────────
//  LOGOS GRID SCREEN
// ─────────────────────────────────────────────

class LogosGridScreen extends StatefulWidget {
  final String userId;
  final String categoryId;

  const LogosGridScreen({
    Key? key,
    required this.userId,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<LogosGridScreen> createState() => _LogosGridScreenState();
}

class _LogosGridScreenState extends State<LogosGridScreen> {
  List<LogoData> _logos = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLogos();
  }

  Future<void> _fetchLogos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse(
        'http://31.97.206.144:4061/api/admin/getlogos/${widget.userId}?logoCategoryId=${widget.categoryId}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _logos = data.map((json) => LogoData.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to load logos. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Logo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetchLogos, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_logos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No logos found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _logos.length,
      itemBuilder: (context, index) {
        final logo = _logos[index];
        return _buildLogoCard(logo);
      },
    );
  }

  Widget _buildLogoCard(LogoData logo) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to editor screen with selected logo
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LogoEditorScreen(logoData: logo),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  logo.previewImageUrl,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                logo.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  LOGO EDITOR SCREEN
// ─────────────────────────────────────────────

class LogoEditorScreen extends StatefulWidget {
  final LogoData logoData;
  const LogoEditorScreen({super.key, required this.logoData});

  @override
  State<LogoEditorScreen> createState() => _LogoEditorScreenState();
}

class _LogoEditorScreenState extends State<LogoEditorScreen> {
  final List<EditableLayer> _layers = [];
  String? _selectedId;

  final GlobalKey _canvasKey = GlobalKey();
  bool _isSaving = false;
  bool _isCapturing = false;
  bool _isLoading = true;
  ui.Image? _loadedImage;
  Size _originalImageSize = Size(1080, 1080);

  static const double _canvasSize = 320.0;

  // Replace the fixed _canvasSize with dynamic width/height
  static const double _canvasWidth = 320.0;
  double get _canvasHeight => _originalImageSize == Size.zero
      ? 320.0
      : 320.0 * (_originalImageSize.height / _originalImageSize.width);

  // bottom panel tab: 0=Text 1=Stickers 2=Fonts
  int _activeTab = 0;

  // pinch state
  double _fontSizeAtScaleStart = 24.0;

  static const List<String> _stickers = [
    '⭐',
    '🔥',
    '💎',
    '🎯',
    '🏆',
    '✨',
    '🎨',
    '🚀',
    '💡',
    '🎵',
    '❤️',
    '👑',
    '🌟',
    '💪',
    '🎉',
    '🌈',
    '🦋',
    '🌸',
    '🍀',
    '⚡',
    '🎸',
    '🎤',
    '📸',
    '🎬',
  ];

  static const List<Color> _palette = [
    Colors.white,
    Colors.black,
    Color(0xFFFF6B6B),
    Color(0xFFFFD93D),
    Color(0xFF6BCB77),
    Color(0xFF4D96FF),
    Color(0xFFFF6FC8),
    Color(0xFFFF9A3C),
    Color(0xFF845EC2),
    Color(0xFF00C9A7),
    Color(0xFFF9F871),
    Color(0xFFFF8066),
    Color(0xFF2D3142),
    Color(0xFF4ECDC4),
    Color(0xFFC7F2A4),
    Color(0xFFE8C1F4),
  ];

  // ── Init ─────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // _initLayers();
    _loadImage();
  }

  /// Convert every API placeholder into an EditableLayer.
  Future<void> _loadImage() async {
    try {
      String? username;
      final userData = await AuthPreferences.getUserData();
      if (userData != null) {
        setState(() {
          username = userData.user.name;
        });
      }
      final res = await http.get(Uri.parse(widget.logoData.imageUrl));
      if (res.statusCode == 200) {
        final codec = await ui.instantiateImageCodec(res.bodyBytes);
        final frame = await codec.getNextFrame();
        if (mounted) {
          setState(() {
            _loadedImage = frame.image;
            _originalImageSize = Size(
              frame.image.width.toDouble(),
              frame.image.height.toDouble(),
            );
            _isLoading = false;
          });
          _initLayers(username); // ✅ Now called AFTER real size is known
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _initLayers(String? username) {
    _layers.clear();

    final srcWidth = 840;
    final srcHeight = 859;
    final scaleX = _canvasWidth / srcWidth;
    final scaleY = _canvasHeight / srcHeight;

    for (final p in widget.logoData.placeholders) {
      if (p.type != 'text') continue;

      // Get the actual text content (replace with your dynamic text source)
      String content =
          p.defaultValue ?? "YOUR NAME"; // or whatever your dynamic text is

      // API position is ALWAYS the center point
      final centerPoint = Offset(
        p.position.dx * scaleX * 0.6,
        p.position.dy * scaleY * 0.72,
      );

      final scaledFontSize = ((75) * scaleX).clamp(8.0, 120.0);

      _layers.add(
        EditableLayer(
          id: p.id,
          type: LayerType.text,
          content: content,
          position: centerPoint, // Store as center point
          centerX: centerPoint.dx,
          fontSize: scaledFontSize,
          color: p.style.color ?? Colors.white,
          fontWeight: p.style.fontWeight ?? FontWeight.bold,
          fontFamily: p.style.fontFamily ?? 'Montserrat',
          textAlign: p.textAlign, // This controls how we use the center point
          isPlaceholder: true,
          maxLength: p.maxLength,
        ),
      );
    }
  }

  Offset _calculateDynamicPosition({
    required Offset originalPosition,
    required String textContent,
    required double maxWidth,
    required double scaleX,
    required double scaleY,
    required TextAlign textAlign,
  }) {
    // Scale the original position
    double scaledX = originalPosition.dx * scaleX * 0.15;
    double scaledY = originalPosition.dy * scaleY * 0.75;

    // Calculate approximate text width
    const double avgCharWidth = 12.0;
    double textWidth = textContent.length * avgCharWidth;

    // Adjust X position based on text length and alignment
    switch (textAlign) {
      case TextAlign.center:
        // For center-aligned text, we might need to adjust if text is too long
        if (textWidth > maxWidth * 0.8) {
          // If text is very long, shift left slightly to keep within bounds
          scaledX = scaledX.clamp(maxWidth * 0.2, maxWidth - (maxWidth * 0.2));
        }
        break;

      case TextAlign.left:
      case TextAlign.start:
        // For left-aligned text, ensure it doesn't go out of bounds
        scaledX = scaledX.clamp(10.0, maxWidth - textWidth - 10);
        break;

      case TextAlign.right:
      case TextAlign.end:
        // For right-aligned text, adjust based on text length
        scaledX = scaledX.clamp(textWidth + 10, maxWidth - 10);
        break;

      case TextAlign.justify:
        // For justify, treat like left alignment for positioning
        scaledX = scaledX.clamp(10.0, maxWidth - textWidth - 10);
        break;
    }

    // Adjust Y position based on text length
    if (textContent.length > 20) {
      scaledY = scaledY - 10;
    }

    return Offset(scaledX, scaledY);
  }

  // ── Helpers ──────────────────────────────────────────────────
  Offset scalePosition(
    Offset originalPosition,
    Size originalSize,
    Size targetSize,
  ) {
    return Offset(
      (originalPosition.dx / originalSize.width) * targetSize.width,
      (originalPosition.dy / originalSize.height) * targetSize.height,
    );
  }

  Size scaleSize(Size originalSize, Size originalImageSize, Size targetSize) {
    return Size(
      (originalSize.width / originalImageSize.width) * targetSize.width,
      (originalSize.height / originalImageSize.height) * targetSize.height,
    );
  }

  EditableLayer? get _selected => _selectedId == null
      ? null
      : _layers.cast<EditableLayer?>().firstWhere(
          (l) => l!.id == _selectedId,
          orElse: () => null,
        );

  void _select(String id) => setState(() {
    _selectedId = id;
    _activeTab = 0;
  });

  void _deselect() => setState(() => _selectedId = null);

  void _deleteSelected() {
    final sel = _selected;
    if (sel == null) return;
    if (sel.isPlaceholder) {
      _deselect();
      return;
    }
    setState(() {
      _layers.removeWhere((l) => l.id == _selectedId);
      _selectedId = null;
    });
  }

  void _addText() {
    final layer = EditableLayer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LayerType.text,
      content: 'New Text',
      position: Offset(
        _canvasWidth / 2 - 50, // Center horizontally
        _canvasHeight / 2, // Center vertically
      ),
      fontSize: 22,
      color: Colors.white,
      fontFamily: 'Montserrat',
      textAlign: TextAlign.center,
    );
    setState(() {
      _layers.add(layer);
      _selectedId = layer.id;
    });
    _openEditSheet(layer);
  }

  void _addSticker(String emoji) {
    final layer = EditableLayer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LayerType.sticker,
      content: emoji,
      position: const Offset(110, 110),
      fontSize: 48,
    );
    setState(() {
      _layers.add(layer);
      _selectedId = layer.id;
    });
  }

  // ── Save ─────────────────────────────────────────────────────

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _selectedId = null;
      _isCapturing = true;
    });
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      final boundary =
          _canvasKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;
      final img = await boundary.toImage(pixelRatio: 3.0);
      final bd = await img.toByteData(format: ui.ImageByteFormat.png);
      final bytes = bd?.buffer.asUint8List();
      if (bytes != null) {
        await Gal.putImageBytes(
          bytes,
          name: 'Logo_${DateTime.now().millisecondsSinceEpoch}',
          album: 'Logo Maker',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Logo saved to gallery!'),
                ],
              ),
              backgroundColor: Color(0xFF6C63FF),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted)
        setState(() {
          _isSaving = false;
          _isCapturing = false;
        });
    }
  }

  // ── Open edit sheet ──────────────────────────────────────────

  void _openEditSheet(EditableLayer layer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LayerEditSheet(
        layer: layer,
        palette: _palette,
        fonts: kGoogleFonts,
        canDelete: !layer.isPlaceholder,
        onChanged: () => setState(() {}),
        onDelete: () {
          Navigator.pop(context);
          _deleteSelected();
        },
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: _appBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            )
          : Column(
              children: [
                Expanded(child: _canvas()),
                _bottomPanel(),
              ],
            ),
    );
  }

  // ── App bar ──────────────────────────────────────────────────

  PreferredSizeWidget _appBar() {
    final sel = _selected;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Color(0xFF2D3142),
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.logoData.name,
        style: const TextStyle(
          color: Color(0xFF2D3142),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      actions: [
        if (sel != null && !sel.isPlaceholder)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _deleteSelected,
          ),
        IconButton(
          icon: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.download_outlined,
                    color: Color(0xFF6C63FF),
                    size: 20,
                  ),
                ),
          onPressed: _isSaving ? null : _save,
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  // ── Canvas ───────────────────────────────────────────────────

  Widget _canvas() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        width: _canvasWidth, // Use _canvasWidth instead of _canvasSize
        height: _canvasHeight, // Use dynamic height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: RepaintBoundary(
            key: _canvasKey,
            child: SizedBox(
              width: _canvasWidth,
              height: _canvasHeight,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned.fill(child: Container(color: Colors.white)),
                  if (_loadedImage != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _BgPainter(image: _loadedImage!),
                      ),
                    ),
                  ..._layers.map(_layerWidget),
                  if (!_isCapturing)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _deselect,
                        behavior: HitTestBehavior.translucent,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _layerWidget(EditableLayer layer) {
    final isSelected = layer.id == _selectedId && !_isCapturing;

    if (layer.type == LayerType.text) {
      // Measure text to get dimensions
      final textPainter = TextPainter(
        text: TextSpan(text: layer.content, style: layer.textStyle),
        textDirection: TextDirection.ltr,
        maxLines: null,
      );
      textPainter.layout(maxWidth: _canvasWidth);

      final textWidth = textPainter.width;
      final textHeight = textPainter.height;

      // Calculate position based on anchor point and alignment
      double left = layer.position.dx;
      double top = layer.position.dy;

      switch (layer.textAlign) {
        case TextAlign.center:
          // Anchor point is the center - adjust left so text is centered on anchor
          left = layer.position.dx - (textWidth / 2);
          break;
        case TextAlign.right:
        case TextAlign.end:
          // Anchor point is the right edge - adjust left so text ends at anchor
          left = layer.position.dx - textWidth;
          break;
        case TextAlign.left:
        case TextAlign.start:
        case TextAlign.justify:
          // Anchor point is the left edge - no adjustment needed
          left = layer.position.dx;
          break;
      }

      // Keep text within bounds
      left = left.clamp(0.0, _canvasWidth - textWidth);
      top = top.clamp(0.0, _canvasHeight - textHeight);

      return Positioned(
        left: left,
        top: top,
        child: GestureDetector(
          onTap: () {
            _select(layer.id);
            _openEditSheet(layer);
          },
          onScaleStart: (_) => _fontSizeAtScaleStart = layer.fontSize,
          onScaleUpdate: (d) {
            setState(() {
              if (d.pointerCount == 1) {
                // Move the anchor point when dragging
                double newX = layer.position.dx + d.focalPointDelta.dx;
                double newY = layer.position.dy + d.focalPointDelta.dy;

                // Clamp anchor point within canvas
                layer.position = Offset(
                  newX.clamp(0.0, _canvasWidth),
                  newY.clamp(0.0, _canvasHeight),
                );
              } else if (d.pointerCount >= 2) {
                layer.fontSize = (_fontSizeAtScaleStart * d.scale).clamp(
                  8.0,
                  120.0,
                );
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: isSelected
                ? BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF6C63FF),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  )
                : null,
            child: Text(
              layer.content,
              style: layer.textStyle.copyWith(shadows: layer.visibilityShadows),
              textAlign: layer.textAlign,
            ),
          ),
        ),
      );
    }

    // Sticker layer
    return Positioned(
      left: layer.position.dx,
      top: layer.position.dy,
      child: GestureDetector(
        onTap: () => _select(layer.id),
        onScaleStart: (_) => _fontSizeAtScaleStart = layer.fontSize,
        onScaleUpdate: (d) {
          setState(() {
            if (d.pointerCount == 1) {
              layer.position = Offset(
                (layer.position.dx + d.focalPointDelta.dx).clamp(
                  0.0,
                  _canvasWidth - 20,
                ),
                (layer.position.dy + d.focalPointDelta.dy).clamp(
                  0.0,
                  _canvasHeight - 20,
                ),
              );
            } else if (d.pointerCount >= 2) {
              layer.fontSize = (_fontSizeAtScaleStart * d.scale).clamp(
                8.0,
                120.0,
              );
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: isSelected
              ? BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF6C63FF),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: Text(
            layer.content,
            style: TextStyle(fontSize: layer.fontSize),
          ),
        ),
      ),
    );
  }

  // ── Bottom panel ─────────────────────────────────────────────

  Widget _bottomPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Tab row + Add Text button
          SizedBox(
            height: 60, // Set a fixed height
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _tabBtn(0, Icons.text_fields_rounded, 'Text'),
                  const SizedBox(width: 8),
                  _tabBtn(1, Icons.emoji_emotions_outlined, 'Stickers'),
                  const SizedBox(width: 8),
                  _tabBtn(2, Icons.font_download_outlined, 'Fonts'),
                  const Spacer(),
                  _addTextBtn(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: KeyedSubtree(
              key: ValueKey(_activeTab),
              child: _tabContent(),
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _tabBtn(int idx, IconData icon, String label) {
    final active = _activeTab == idx;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF6C63FF).withOpacity(0.12)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: active
              ? Border.all(color: const Color(0xFF6C63FF), width: 1.5)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: active ? const Color(0xFF6C63FF) : Colors.grey[600],
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? const Color(0xFF6C63FF) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addTextBtn() => GestureDetector(
    onTap: _addText,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, color: Colors.white, size: 15),
          SizedBox(width: 4),
          Text(
            'Add Text',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _tabContent() {
    switch (_activeTab) {
      case 0:
        return _textTab();
      case 1:
        return _stickerTab();
      case 2:
        return _fontTab();
      default:
        return const SizedBox.shrink();
    }
  }

  // Text chips
  Widget _textTab() {
    final texts = _layers.where((l) => l.type == LayerType.text).toList();
    if (texts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Text(
          'Tap "Add Text" to add a text layer.',
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
      );
    }
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: texts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final l = texts[i];
          final isActive = l.id == _selectedId;
          return GestureDetector(
            onTap: () {
              _select(l.id);
              _openEditSheet(l);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isActive
                      ? [const Color(0xFF4B44B8), const Color(0xFF3830A0)]
                      : [const Color(0xFF6C63FF), const Color(0xFF5A52D5)],
                ),
                borderRadius: BorderRadius.circular(30),
                border: isActive
                    ? Border.all(color: Colors.white, width: 1.5)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit, color: Colors.white, size: 14),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l.isPlaceholder ? 'Logo Text' : 'Custom',
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white60,
                        ),
                      ),
                      Text(
                        l.content.length > 14
                            ? '${l.content.substring(0, 14)}…'
                            : l.content,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _stickerTab() => SizedBox(
    height: 80,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _stickers.length,
      itemBuilder: (_, i) => GestureDetector(
        onTap: () => _addSticker(_stickers[i]),
        child: Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Center(
            child: Text(_stickers[i], style: const TextStyle(fontSize: 28)),
          ),
        ),
      ),
    ),
  );

  Widget _fontTab() {
    final sel = _selected;
    if (sel == null || sel.type != LayerType.text) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          'Select a text layer on the canvas first.',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kGoogleFonts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = kGoogleFonts[i];
          final active = sel.fontFamily == f.name;
          final preview = f.font(
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          );
          return GestureDetector(
            onTap: () => setState(() => sel.fontFamily = f.name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF6C63FF) : Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: active ? const Color(0xFF6C63FF) : Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Aa',
                    style: preview.copyWith(
                      fontSize: 18,
                      color: active ? Colors.white : const Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    f.name,
                    style: TextStyle(
                      fontSize: 9,
                      color: active ? Colors.white70 : Colors.grey[500],
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
}

// ─────────────────────────────────────────────
//  LAYER EDIT BOTTOM SHEET
// ─────────────────────────────────────────────

class _LayerEditSheet extends StatefulWidget {
  final EditableLayer layer;
  final List<Color> palette;
  final List<GFontEntry> fonts;
  final bool canDelete;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  const _LayerEditSheet({
    required this.layer,
    required this.palette,
    required this.fonts,
    required this.canDelete,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_LayerEditSheet> createState() => _LayerEditSheetState();
}

class _LayerEditSheetState extends State<_LayerEditSheet>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _ctrl;
  late final TabController _tabCtrl;

  late Color _color;
  late String _fontFamily;
  late FontWeight _fontWeight;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.layer.content);
    _tabCtrl = TabController(length: 3, vsync: this);
    _color = widget.layer.color;
    _fontFamily = widget.layer.fontFamily;
    _fontWeight = widget.layer.fontWeight;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    final text = _ctrl.text.trim();
    if (text.isNotEmpty) widget.layer.content = text;
    widget.layer.color = _color;
    widget.layer.fontFamily = _fontFamily;
    widget.layer.fontWeight = _fontWeight;
    widget.onChanged();
    Navigator.pop(context);
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),

            // Header row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Edit Text',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const Spacer(),
                  if (widget.canDelete)
                    TextButton.icon(
                      onPressed: widget.onDelete,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 18,
                      ),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                ],
              ),
            ),

            // Tabs
            TabBar(
              controller: _tabCtrl,
              indicatorColor: const Color(0xFF6C63FF),
              labelColor: const Color(0xFF6C63FF),
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Text'),
                Tab(text: 'Color'),
                Tab(text: 'Font'),
              ],
            ),

            // Tab views
            SizedBox(
              height: 240,
              child: TabBarView(
                controller: _tabCtrl,
                children: [_textPane(), _colorPane(), _fontPane()],
              ),
            ),

            // Apply
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _apply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Text pane ────────────────────────────────────────────────
  Widget _textPane() => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _ctrl,
          autofocus: true,
          maxLength: widget.layer.maxLength,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Enter text…',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              'Bold',
              style: TextStyle(fontSize: 13, color: Color(0xFF2D3142)),
            ),
            const Spacer(),
            Switch(
              value: _fontWeight == FontWeight.bold,
              activeColor: const Color(0xFF6C63FF),
              onChanged: (v) => setState(
                () => _fontWeight = v ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // ── Color pane ───────────────────────────────────────────────
  Widget _colorPane() => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Selected:',
              style: TextStyle(fontSize: 13, color: Color(0xFF2D3142)),
            ),
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 1.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.palette.map((c) {
            final active = _color.value == c.value;
            return GestureDetector(
              onTap: () => setState(() => _color = c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: active ? const Color(0xFF6C63FF) : Colors.grey[300]!,
                    width: active ? 3 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: c.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: active
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: c.computeLuminance() > 0.4
                            ? Colors.black
                            : Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );

  // ── Font pane ────────────────────────────────────────────────
  Widget _fontPane() => ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    itemCount: widget.fonts.length,
    itemBuilder: (_, i) {
      final f = widget.fonts[i];
      final active = _fontFamily == f.name;
      final style = f.font(
        textStyle: TextStyle(
          fontSize: 17,
          fontWeight: _fontWeight,
          color: active ? Colors.white : const Color(0xFF2D3142),
        ),
      );
      return GestureDetector(
        onTap: () => setState(() => _fontFamily = f.name),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF6C63FF) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? const Color(0xFF6C63FF) : Colors.grey[200]!,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text('Aa  ${f.name}', style: style)),
              if (active)
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
            ],
          ),
        ),
      );
    },
  );
}

// ─────────────────────────────────────────────
//  BACKGROUND PAINTER
// ─────────────────────────────────────────────

class _BgPainter extends CustomPainter {
  final ui.Image image;
  const _BgPainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
