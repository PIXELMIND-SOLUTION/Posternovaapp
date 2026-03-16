import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

enum EffectType {
  none,
  blur,
  grayscale,
  sepia,
  brightness,
  contrast,
}

class OverlayTextItem {
  String id;
  String text;
  Offset position;
  double fontSize;
  Color color;
  Color backgroundColor;
  bool hasBorder;
  bool hasShadow;
  bool isBold;
  bool isItalic;
  bool isUnderline;
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

// ─────────────────────────────────────────────
//  MAIN SCREEN
// ─────────────────────────────────────────────

class PosterEditorScreen extends StatefulWidget {
  /// Pass your asset image path here, e.g. 'assets/images/poster.png'
  final String posterAsset;

  const PosterEditorScreen({Key? key, required this.posterAsset})
      : super(key: key);

  @override
  State<PosterEditorScreen> createState() => _PosterEditorScreenState();
}

class _PosterEditorScreenState extends State<PosterEditorScreen>
    with TickerProviderStateMixin {
  // ── bottom tab
  BottomTab _activeTab = BottomTab.text;

  // ── poster background
  Color _bgColor = const Color(0xFFF5F0E8);

  // ── overlay texts
  final List<OverlayTextItem> _texts = [];
  String? _selectedTextId;

  // ── logo overlay
  bool _showLogo = true;
  Offset _logoPosition = const Offset(20, 20); // relative inside poster

  // ── frame selection
  int _selectedFrame = -1; // -1 = none
  final List<_FrameData> _frames = [
    _FrameData('Classic', Colors.brown.shade700, Colors.transparent),
    _FrameData('Golden', const Color(0xFFD4AF37), Colors.transparent),
    _FrameData('Modern', Colors.blueGrey.shade800, Colors.transparent),
    _FrameData('Neon', Colors.greenAccent.shade700, Colors.transparent),
    _FrameData('Rose', Colors.pinkAccent, Colors.transparent),
    _FrameData('Dark', Colors.black87, Colors.transparent),
    _FrameData('Coral', Colors.deepOrangeAccent, Colors.transparent),
    _FrameData('Sky', Colors.lightBlue.shade400, Colors.transparent),
  ];

  // ── animation
  AnimationType _selectedAnimation = AnimationType.none;
  late AnimationController _animController;
  late Animation<double> _animValue;

  // ── effect
  EffectType _selectedEffect = EffectType.none;
  double _effectStrength = 0.5;

  // ── audio
  String? _selectedAudio;
  final List<String> _audioTracks = [
    'Upbeat Pop',
    'Calm Acoustic',
    'Corporate',
    'Cinematic',
    'Electronic',
    'Jazz Lounge',
  ];

  // ── downloading dialog
  bool _isDownloading = false;
  double _downloadProgress = 0;

  // ── poster area key for size
  final GlobalKey _posterKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animValue =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────
  //  helpers
  // ──────────────────────────────────────────

  bool get _isAnimated =>
      _selectedAnimation != AnimationType.none ||
      _selectedEffect != EffectType.none ||
      _selectedAudio != null;

  String get _downloadLabel =>
      _isAnimated ? 'Export Video (MP4)' : 'Download Image (PNG)';

  OverlayTextItem? get _selectedText =>
      _selectedTextId == null
          ? null
          : _texts.firstWhere((t) => t.id == _selectedTextId,
              orElse: () => _texts.first);

  void _addText() {
    final item = OverlayTextItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Tap to edit',
      position: Offset(60, 300 + _texts.length * 40.0),
      fontSize: 22,
    );
    setState(() {
      _texts.add(item);
      _selectedTextId = item.id;
    });
    _openTextEditor(item);
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

  void _startDownload() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });
    for (int i = 1; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      setState(() => _downloadProgress = i / 100);
    }
    setState(() => _isDownloading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isAnimated
              ? 'Video exported successfully!'
              : 'Image saved to gallery!'),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
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
              Expanded(
                child: _buildPosterArea(),
              ),
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

  // ── TOP BAR ──────────────────────────────

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
            icon:
                const Icon(Icons.arrow_back, color: Colors.black87, size: 22),
            onPressed: () => Navigator.maybePop(context),
          ),
          IconButton(
            icon: const Icon(Icons.layers, color: Colors.black87, size: 22),
            onPressed: () => _showLayersSheet(),
          ),
          IconButton(
            icon: const Icon(Icons.save_outlined,
                color: Colors.black87, size: 22),
            onPressed: () {},
          ),
          if (_isAnimated)
            IconButton(
              icon: const Icon(Icons.pause_circle_outline,
                  color: Colors.black87, size: 22),
              onPressed: () {
                if (_animController.isAnimating) {
                  _animController.stop();
                } else {
                  _animController.repeat(reverse: true);
                }
              },
            ),
          const Spacer(),
          GestureDetector(
            onTap: _startDownload,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.download, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  const Text('Download',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── POSTER AREA ───────────────────────────

  Widget _buildPosterArea() {
    return GestureDetector(
      onTap: () => setState(() => _selectedTextId = null),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                key: _posterKey,
                children: [
                  // — background poster image
                  _buildPosterBackground(),

                  // — frame overlay
                  if (_selectedFrame >= 0)
                    _buildFrameOverlay(_frames[_selectedFrame]),

                  // — logo
                  if (_showLogo) _buildLogoWidget(),

                  // — overlay texts
                  ..._texts.map((t) => _buildTextWidget(t)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPosterBackground() {
    Widget img = Image.asset(
      widget.posterAsset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );

    // apply color tint as background
    Widget base = Container(
      width: double.infinity,
      height: double.infinity,
      color: _bgColor,
      child: img,
    );

    // apply effects
    if (_selectedEffect == EffectType.blur) {
      base = ImageFiltered(
        imageFilter:
            ui.ImageFilter.blur(sigmaX: 3 * _effectStrength, sigmaY: 3 * _effectStrength),
        child: base,
      );
    } else if (_selectedEffect == EffectType.grayscale) {
      base = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: base,
      );
    } else if (_selectedEffect == EffectType.sepia) {
      base = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.393, 0.769, 0.189, 0, 0,
          0.349, 0.686, 0.168, 0, 0,
          0.272, 0.534, 0.131, 0, 0,
          0,     0,     0,     1, 0,
        ]),
        child: base,
      );
    }

    // apply animation to the poster content
    if (_selectedAnimation != AnimationType.none) {
      base = AnimatedBuilder(
        animation: _animValue,
        builder: (_, child) => _applyAnimation(base),
      );
    }

    return base;
  }

  Widget _applyAnimation(Widget child) {
    switch (_selectedAnimation) {
      case AnimationType.fade:
        return Opacity(
            opacity: 0.4 + 0.6 * _animValue.value, child: child);
      case AnimationType.zoom:
        return Transform.scale(
            scale: 0.95 + 0.05 * _animValue.value, child: child);
      case AnimationType.rotate:
        return Transform.rotate(
            angle: 0.03 * sin(_animValue.value * pi), child: child);
      case AnimationType.slideLeft:
        return Transform.translate(
            offset: Offset(-10 * _animValue.value, 0), child: child);
      case AnimationType.slideRight:
        return Transform.translate(
            offset: Offset(10 * _animValue.value, 0), child: child);
      case AnimationType.slideUp:
        return Transform.translate(
            offset: Offset(0, -10 * _animValue.value), child: child);
      case AnimationType.slideDown:
        return Transform.translate(
            offset: Offset(0, 10 * _animValue.value), child: child);
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
            angle: 0.05 * sin(_animValue.value * pi * 2), child: child);
      case AnimationType.rollin:
        return Transform.rotate(
            angle: _animValue.value * 0.1, child: child);
      default:
        return child;
    }
  }

  Widget _buildFrameOverlay(_FrameData frame) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: frame.borderColor, width: 8),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoWidget() {
    return Positioned(
      right: 12,
      top: 12,
      child: GestureDetector(
        onPanUpdate: (d) {
          // draggable logo – simplified
        },
        child: AnimatedBuilder(
          animation: _animValue,
          builder: (_, __) {
            Widget logo = Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4AF37),
                border:
                    Border.all(color: Colors.white, width: 2),
              ),
              child: const Center(
                child: Text(
                  'LOGO',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            );
            if (_selectedAnimation != AnimationType.none) {
              logo = Transform.scale(
                  scale: 0.9 + 0.1 * _animValue.value, child: logo);
            }
            return logo;
          },
        ),
      ),
    );
  }

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
            if (idx != -1) {
              _texts[idx] = _texts[idx].copyWith(
                position: item.position + d.delta,
              );
            }
          });
        },
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  border:
                      Border.all(color: Colors.blueAccent, width: 1.5),
                  color: Colors.blue.withOpacity(0.05),
                )
              : null,
          padding: const EdgeInsets.all(4),
          child: Stack(
            children: [
              if (isSelected)
                Positioned(
                  top: -10,
                  left: 0,
                  child: GestureDetector(
                    onTap: () => setState(
                        () => _texts.removeWhere((t) => t.id == item.id)),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          size: 12, color: Colors.white),
                    ),
                  ),
                ),
              Container(
                decoration: item.hasBorder
                    ? BoxDecoration(
                        border: Border.all(color: item.color, width: 1))
                    : null,
                color: item.backgroundColor == Colors.transparent
                    ? null
                    : item.backgroundColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 2),
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
                              Shadow(
                                  color: Colors.black38,
                                  offset: const Offset(2, 2),
                                  blurRadius: 4)
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
          const Text('Background colour',
              style: TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 6),
          SizedBox(
            height: 28,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = colors[i];
                final isSelected = _bgColor == c;
                return GestureDetector(
                  onTap: () => setState(() => _bgColor = c),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
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

  // text sub-toolbar
  Widget _buildTextPanel() {
    final sel = _selectedText;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // row 1: theme, edit, font, font colour, arrows
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _textAction(Icons.palette_outlined, 'Text Theme', () {}),
                _textAction(Icons.edit, 'Edit',
                    sel == null ? null : () => _openTextEditor(sel)),
                _textAction(Icons.font_download_outlined, 'Font', () {}),
                _textAction(Icons.format_color_text, 'Font Color',
                    sel == null ? null : () => _showColorPicker(sel)),
                _textAction(Icons.arrow_upward, null,
                    sel == null ? null : () => _moveText(sel, dy: -10)),
                _textAction(Icons.arrow_downward, null,
                    sel == null ? null : () => _moveText(sel, dy: 10)),
              ],
            ),
          ),
          // row 2: shadow, border, background, arrows LR
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _textAction(Icons.wb_sunny_outlined, 'Shadow',
                    sel == null
                        ? null
                        : () => setState(() {
                              final idx =
                                  _texts.indexWhere((t) => t.id == sel.id);
                              _texts[idx] = _texts[idx]
                                  .copyWith(hasShadow: !sel.hasShadow);
                            })),
                _textAction(Icons.border_outer, 'Border',
                    sel == null
                        ? null
                        : () => setState(() {
                              final idx =
                                  _texts.indexWhere((t) => t.id == sel.id);
                              _texts[idx] = _texts[idx]
                                  .copyWith(hasBorder: !sel.hasBorder);
                            })),
                _textAction(Icons.format_color_fill, 'Background',
                    sel == null ? null : () {}),
                _textAction(Icons.arrow_back, null,
                    sel == null ? null : () => _moveText(sel, dx: -10)),
                _textAction(Icons.arrow_forward, null,
                    sel == null ? null : () => _moveText(sel, dx: 10)),
              ],
            ),
          ),
          // row 3: formatting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _fmtBtn(
                  'U',
                  sel?.isUnderline ?? false,
                  TextDecoration.underline,
                  sel == null
                      ? null
                      : () => setState(() {
                            final idx =
                                _texts.indexWhere((t) => t.id == sel.id);
                            _texts[idx] = _texts[idx]
                                .copyWith(isUnderline: !sel.isUnderline);
                          })),
              _fmtBtn(
                  'I',
                  sel?.isItalic ?? false,
                  TextDecoration.none,
                  sel == null
                      ? null
                      : () => setState(() {
                            final idx =
                                _texts.indexWhere((t) => t.id == sel.id);
                            _texts[idx] = _texts[idx]
                                .copyWith(isItalic: !sel.isItalic);
                          }),
                  italic: true),
              _fmtBtn(
                  'B',
                  sel?.isBold ?? false,
                  TextDecoration.none,
                  sel == null
                      ? null
                      : () => setState(() {
                            final idx =
                                _texts.indexWhere((t) => t.id == sel.id);
                            _texts[idx] = _texts[idx]
                                .copyWith(isBold: !sel.isBold);
                          }),
                  bold: true),
              _sizeBtn('T', 18, sel),
              _sizeBtn('T', 24, sel),
              IconButton(
                icon: const Icon(Icons.format_align_left, size: 20),
                onPressed: sel == null
                    ? null
                    : () => setState(() {
                          final idx =
                              _texts.indexWhere((t) => t.id == sel.id);
                          _texts[idx] = _texts[idx]
                              .copyWith(align: TextAlign.left);
                        }),
              ),
              _textAction(Icons.add_circle_outline, 'Add Text', _addText),
            ],
          ),
        ],
      ),
    );
  }

  void _moveText(OverlayTextItem sel,
      {double dx = 0, double dy = 0}) {
    setState(() {
      final idx = _texts.indexWhere((t) => t.id == sel.id);
      if (idx != -1) {
        _texts[idx] = _texts[idx].copyWith(
            position: sel.position + Offset(dx, dy));
      }
    });
  }

  Widget _textAction(IconData icon, String? label, VoidCallback? onTap) {
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
                Text(label,
                    style: const TextStyle(
                        fontSize: 9, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fmtBtn(String label, bool active, TextDecoration deco,
      VoidCallback? onTap,
      {bool italic = false, bool bold = false}) {
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
              fontStyle:
                  italic ? FontStyle.italic : FontStyle.normal,
              decoration: deco,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sizeBtn(String label, double size, OverlayTextItem? sel) {
    final isActive = sel?.fontSize == size;
    return GestureDetector(
      onTap: sel == null
          ? null
          : () => setState(() {
                final idx = _texts.indexWhere((t) => t.id == sel.id);
                _texts[idx] = _texts[idx].copyWith(fontSize: size);
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
    ];
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors
              .map((c) => GestureDetector(
                    onTap: () {
                      setState(() {
                        final idx =
                            _texts.indexWhere((t) => t.id == sel.id);
                        _texts[idx] = _texts[idx].copyWith(color: c);
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
                            color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  // frames panel
  Widget _buildFramesPanel() {
    return Container(
      height: 120,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text('Frames',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _frames.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                if (i == 0) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFrame = -1),
                    child: _frameThumb(
                        'None', Colors.grey.shade200, _selectedFrame == -1),
                  );
                }
                final f = _frames[i - 1];
                return GestureDetector(
                  onTap: () => setState(() => _selectedFrame = i - 1),
                  child: _frameThumb(
                      f.name, f.borderColor, _selectedFrame == i - 1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _frameThumb(String name, Color color, bool selected) {
    return Container(
      width: 64,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(
            color: selected ? Colors.blueAccent : color, width: 3),
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey.shade100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(color: color, width: 4),
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 4),
          Text(name,
              style:
                  const TextStyle(fontSize: 9, color: Colors.black54)),
        ],
      ),
    );
  }

  // audio panel
  Widget _buildAudioPanel() {
    return Container(
      height: 150,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text('Audio',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _audioTracks.length + 1,
              itemBuilder: (_, i) {
                if (i == 0) {
                  final isSelected = _selectedAudio == null;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAudio = null),
                    child: _audioChip('No Audio', isSelected),
                  );
                }
                final t = _audioTracks[i - 1];
                final isSelected = _selectedAudio == t;
                return GestureDetector(
                  onTap: () => setState(() => _selectedAudio = t),
                  child: _audioChip(t, isSelected),
                );
              },
            ),
          ),
          if (_selectedAudio != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  const Icon(Icons.music_note,
                      size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('Playing: $_selectedAudio',
                      style: const TextStyle(
                          fontSize: 11, color: Colors.black54)),
                  const Spacer(),
                  const Icon(Icons.equalizer,
                      size: 18, color: Colors.green),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _audioChip(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color:
            selected ? const Color(0xFFF5C518) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: selected
                ? const Color(0xFFF5C518)
                : Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.headphones,
              size: 14,
              color: selected ? Colors.black87 : Colors.black45),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: selected ? Colors.black87 : Colors.black54)),
        ],
      ),
    );
  }

  // animation panel
  Widget _buildAnimationPanel() {
    final animations = [
      _AnimData(AnimationType.none, Icons.block, 'Remove\nAnimation'),
      _AnimData(AnimationType.fade, Icons.opacity, 'Fade'),
      _AnimData(AnimationType.zoom, Icons.zoom_in, 'PageZoom'),
      _AnimData(AnimationType.rotate, Icons.rotate_right, 'RotateLeftUp'),
      _AnimData(AnimationType.flipIn, Icons.flip, 'FlipIn'),
      _AnimData(AnimationType.wobble, Icons.vibration, 'Wobble'),
      _AnimData(AnimationType.rollin, Icons.motion_photos_on, 'Rollin'),
      _AnimData(AnimationType.slideLeft, Icons.arrow_back, 'SlideLeft'),
      _AnimData(AnimationType.slideRight, Icons.arrow_forward, 'SlideRight'),
      _AnimData(AnimationType.slideUp, Icons.arrow_upward, 'SlideUp'),
      _AnimData(AnimationType.slideDown, Icons.arrow_downward, 'SlideDown'),
    ];
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text('Animation',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                final isSelected = _selectedAnimation == a.type;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedAnimation = a.type);
                    if (a.type != AnimationType.none) {
                      _animController.repeat(reverse: true);
                    } else {
                      _animController.stop();
                      _animController.reset();
                    }
                  },
                  child: Container(
                    width: 72,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isSelected
                              ? const Color(0xFFF5C518)
                              : Colors.grey.shade200,
                          width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? const Color(0xFFFFFDE7)
                          : Colors.grey.shade50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(a.icon,
                            size: 28,
                            color: isSelected
                                ? Colors.amber.shade800
                                : Colors.black54),
                        const SizedBox(height: 4),
                        Text(a.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 9,
                                color: isSelected
                                    ? Colors.amber.shade900
                                    : Colors.black54)),
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

  // brand info panel
  Widget _buildBrandInfoPanel() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Brand Info',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.account_circle, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('VISHNU P',
                    style: TextStyle(fontSize: 13, color: Colors.black87)),
              ),
              Switch(
                value: _showLogo,
                onChanged: (v) => setState(() => _showLogo = v),
                activeColor: const Color(0xFFF5C518),
              ),
            ],
          ),
          const Divider(height: 1),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.phone, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text('6282714883', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Expanded(
                child: Text('NBRRA-3, Maradu, Kochi, null, Kerala',
                    style: TextStyle(fontSize: 12), maxLines: 2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // effect panel (Sticker tab)
  Widget _buildEffectPanel() {
    final effects = [
      _EffectData(EffectType.none, Icons.block, 'Remove\nEffect'),
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
            child: Text('Effect',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                final isSelected = _selectedEffect == e.type;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEffect = e.type),
                  child: Container(
                    width: 72,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isSelected
                              ? Colors.amber
                              : Colors.grey.shade200,
                          width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? const Color(0xFFFFF8E1)
                          : Colors.grey.shade50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(e.icon,
                            size: 28,
                            color: isSelected
                                ? Colors.amber.shade700
                                : Colors.black45),
                        const SizedBox(height: 4),
                        Text(e.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 9,
                                color: isSelected
                                    ? Colors.amber.shade800
                                    : Colors.black45)),
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

  // ── BOTTOM TAB BAR ────────────────────────

  Widget _buildBottomTabBar() {
    final tabs = [
      _TabData(BottomTab.text, Icons.text_fields, 'Text'),
      _TabData(BottomTab.frames, Icons.crop_square, 'Frames'),
      _TabData(BottomTab.audio, Icons.volume_up_outlined, 'Audio'),
      _TabData(BottomTab.animation, Icons.animation, 'Animation'),
      _TabData(BottomTab.brandInfo, Icons.business_center_outlined,
          'Brand Info'),
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
              .map((t) => GestureDetector(
                    onTap: () => setState(() => _activeTab = t.tab),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                  ))
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
                  _isAnimated ? 'Exporting Video…' : 'Downloading…',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
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
                          fontSize: 13, color: Colors.black54),
                    ),
                    Text(
                      '${(_downloadProgress * 100).toInt()}/100',
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54),
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
      builder: (_) => Container(
        color: Colors.white,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Layers',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            const Divider(height: 1),
            ListTile(
              leading:
                  const Icon(Icons.image_outlined, color: Colors.blueGrey),
              title: const Text('Poster Background'),
              trailing: const Icon(Icons.lock_outline, size: 16),
            ),
            if (_showLogo)
              ListTile(
                leading: const Icon(Icons.circle, color: Colors.amber),
                title: const Text('Logo'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility_off_outlined, size: 18),
                  onPressed: () {
                    setState(() => _showLogo = false);
                    Navigator.pop(context);
                  },
                ),
              ),
            ..._texts.map((t) => ListTile(
                  leading:
                      const Icon(Icons.text_fields, color: Colors.teal),
                  title: Text(t.text, maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: Colors.red),
                    onPressed: () {
                      setState(() =>
                          _texts.removeWhere((x) => x.id == t.id));
                      Navigator.pop(context);
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TEXT EDITOR BOTTOM SHEET
// ─────────────────────────────────────────────

class _TextEditorSheet extends StatefulWidget {
  final OverlayTextItem item;
  final ValueChanged<OverlayTextItem> onChanged;

  const _TextEditorSheet(
      {Key? key, required this.item, required this.onChanged})
      : super(key: key);

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
          bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (v) =>
                  _update(_current.copyWith(text: v)),
            ),
            const SizedBox(height: 12),
            // font size slider
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
                    onChanged: (v) =>
                        _update(_current.copyWith(fontSize: v)),
                  ),
                ),
                Text(_current.fontSize.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            // formatting row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _chip('B', _current.isBold,
                    () => _update(_current.copyWith(isBold: !_current.isBold)),
                    bold: true),
                _chip('I', _current.isItalic,
                    () => _update(_current.copyWith(isItalic: !_current.isItalic)),
                    italic: true),
                _chip('U', _current.isUnderline,
                    () => _update(_current.copyWith(
                        isUnderline: !_current.isUnderline)),
                    underline: true),
                _chip('Shadow', _current.hasShadow,
                    () => _update(_current.copyWith(
                        hasShadow: !_current.hasShadow))),
                _chip('Border', _current.hasBorder,
                    () => _update(_current.copyWith(
                        hasBorder: !_current.hasBorder))),
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
                      borderRadius: BorderRadius.circular(8)),
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

  Widget _chip(String label, bool active, VoidCallback onTap,
      {bool bold = false, bool italic = false, bool underline = false}) {
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
            decoration:
                underline ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HELPER DATA CLASSES
// ─────────────────────────────────────────────

class _FrameData {
  final String name;
  final Color borderColor;
  final Color bgColor;
  _FrameData(this.name, this.borderColor, this.bgColor);
}

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