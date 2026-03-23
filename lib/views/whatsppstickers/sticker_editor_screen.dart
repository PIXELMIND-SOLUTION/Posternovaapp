import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

// ─────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────

class StickerTextItem {
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

  StickerTextItem({
    required this.id,
    required this.text,
    this.position = const Offset(50, 100),
    this.fontSize = 24,
    this.color = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.hasBorder = false,
    this.hasShadow = false,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.align = TextAlign.center,
    this.rotation = 0,
  });

  StickerTextItem copyWith({
    String? id,
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
    return StickerTextItem(
      id: id ?? this.id,
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

class ExtraStickerItem {
  String emoji;
  Offset position;
  double scale;
  double rotation;

  ExtraStickerItem({
    required this.emoji,
    required this.position,
    this.scale = 1.0,
    this.rotation = 0.0,
  });
}

// ─────────────────────────────────────────────
//  MAIN STICKER EDITOR SCREEN
// ─────────────────────────────────────────────

class StickerEditorScreen extends StatefulWidget {
  final String stickerUrl;
  const StickerEditorScreen({super.key, required this.stickerUrl});

  @override
  State<StickerEditorScreen> createState() => _StickerEditorScreenState();
}

class _StickerEditorScreenState extends State<StickerEditorScreen>
    with TickerProviderStateMixin {
  // ── Main sticker transform state ──────────────────────────────────
  Offset _position = const Offset(0, 0);
  double _scale = 1.0;
  double _rotation = 0.0;
  bool _flipH = false;
  bool _flipV = false;
  bool _isSelected = true;

  // ── Gesture tracking ─────────────────────────────────────────────
  Offset? _panStart;
  Offset _basePosition = const Offset(0, 0);
  double _baseScale = 1.0;
  double _baseRotation = 0.0;

  // ── Extra stickers (emojis) ──────────────────────────────────────
  final List<ExtraStickerItem> _extraStickers = [];
  String? _selectedExtraId;

  // ── Text overlays ────────────────────────────────────────────────
  final List<StickerTextItem> _textItems = [];
  String? _selectedTextId;

  // ── Color tint ───────────────────────────────────────────────────
  Color _tintColor = Colors.transparent;
  double _tintOpacity = 0.0;

  // ── UI state ─────────────────────────────────────────────────────
  bool _showBottomSheet = false;
  String? _resizingTextId;
  Offset _resizeStartOffset = Offset.zero;
  double _resizeStartFontSize = 24;

  // ── Repaint key for export ───────────────────────────────────────
  final GlobalKey _canvasKey = GlobalKey();

  // ── Sticker size ─────────────────────────────────────────────────
  static const double _stickerBaseSize = 200;

  @override
  void initState() {
    super.initState();
  }

  // ── Layout callback: centre sticker once canvas size known ───────
  void _initPosition(Size canvasSize) {
    if (_position == Offset.zero) {
      _position = Offset(
        canvasSize.width / 2 - (_stickerBaseSize * _scale) / 2,
        canvasSize.height / 2 - (_stickerBaseSize * _scale) / 2,
      );
    }
  }

  // ════════════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildCanvas()),
            _buildBottomPanel(),
          ],
        ),
      ),
    );
  }

  // ── Top bar ──────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF161616),
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Row(
        children: [
          _iconBtn(Icons.close, () => Navigator.of(context).maybePop()),
          const SizedBox(width: 8),
          const Text(
            'Sticker Editor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Download button
          GestureDetector(
            onTap: _onDownload,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFFE040FB)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.download, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
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

  // ── Canvas ───────────────────────────────────────────────────────
  Widget _buildCanvas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initPosition(size);

        return GestureDetector(
          onTap: () => setState(() {
            _isSelected = false;
            _selectedTextId = null;
            _selectedExtraId = null;
            _showBottomSheet = false;
          }),
          child: Stack(
            children: [
              // 👇 ONLY for UI (NOT for export)
              _CheckerBackground(size: size),

              // 👇 ONLY this will be exported
              RepaintBoundary(
                key: _canvasKey,
                child: Material(
                  // ✅ ADD THIS
                  type: MaterialType.transparency,
                  child: Stack(
                    children: [
                      ..._extraStickers.asMap().entries.map(
                        (entry) =>
                            _buildExtraStickerWidget(entry.value, entry.key),
                      ),
                      ..._textItems.map((t) => _buildTextWidget(t)),
                      _buildMainSticker(),
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

  // ── Main sticker (draggable + scale + rotate) ────────────────────
  Widget _buildMainSticker() {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onTap: () => setState(() {
          _isSelected = true;
          _selectedTextId = null;
          _selectedExtraId = null;
        }),
        onScaleStart: (d) {
          _panStart = d.focalPoint;
          _basePosition = _position;
          _baseScale = _scale;
          _baseRotation = _rotation;
        },
        onScaleUpdate: (d) {
          setState(() {
            final delta = d.focalPoint - _panStart!;
            _position = _basePosition + delta;
            _scale = (_baseScale * d.scale).clamp(0.3, 5.0);
            _rotation = _baseRotation + d.rotation;
          });
        },
        child: Transform.rotate(
          angle: _rotation,
          child: Transform(
            transform: Matrix4.diagonal3Values(
              _flipH ? -1.0 : 1.0,
              _flipV ? -1.0 : 1.0,
              1.0,
            ),
            alignment: Alignment.center,
            child: Stack(
              children: [
                // Tint overlay + image
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    _tintColor.withOpacity(_tintOpacity),
                    BlendMode.srcATop,
                  ),
                  child: Image.network(
                    widget.stickerUrl,
                    width: _stickerBaseSize * _scale,
                    height: _stickerBaseSize * _scale,
                    fit: BoxFit.contain,
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : SizedBox(
                            width: _stickerBaseSize * _scale,
                            height: _stickerBaseSize * _scale,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF7C4DFF),
                              ),
                            ),
                          ),
                  ),
                ),
                // Selection border
                if (_isSelected)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF7C4DFF),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                // Delete handle
                if (_isSelected)
                  Positioned(
                    top: -12,
                    right: -12,
                    child: _handle(
                      Icons.close,
                      const Color(0xFFFF4444),
                      _showDeleteConfirm,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Extra sticker widget ─────────────────────────────────────────
  Widget _buildExtraStickerWidget(ExtraStickerItem item, int index) {
    final isSelected = _selectedExtraId == index.toString();
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedExtraId = index.toString();
          _isSelected = false;
          _selectedTextId = null;
        }),
        onPanUpdate: (d) {
          setState(() {
            _extraStickers[index] = ExtraStickerItem(
              emoji: item.emoji,
              position: item.position + d.delta,
              scale: item.scale,
              rotation: item.rotation,
            );
          });
        },
        child: Transform.rotate(
          angle: item.rotation,
          child: Stack(
            children: [
              Text(item.emoji, style: TextStyle(fontSize: 60 * item.scale)),
              if (isSelected)
                Positioned(
                  top: -10,
                  right: -10,
                  child: _handle(Icons.close, const Color(0xFFFF4444), () {
                    setState(() => _extraStickers.removeAt(index));
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Text widget ───────────────────────────────────────────────────
  Widget _buildTextWidget(StickerTextItem item) {
    final isSelected = _selectedTextId == item.id;
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTextId = item.id;
            _isSelected = false;
            _selectedExtraId = null;
            _showBottomSheet = true;
          });
          _openTextEditor(item);
        },
        onPanUpdate: (d) {
          setState(() {
            final idx = _textItems.indexWhere((t) => t.id == item.id);
            if (idx != -1) {
              _textItems[idx] = _textItems[idx].copyWith(
                position: item.position + Offset(d.delta.dx, d.delta.dy),
              );
            }
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
                    _textItems.removeWhere((t) => t.id == item.id);
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
                      final idx = _textItems.indexWhere((t) => t.id == item.id);
                      if (idx != -1) {
                        _textItems[idx] = _textItems[idx].copyWith(
                          fontSize: newSize,
                        );
                      }
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

  // ── Bottom Panel ─────────────────────────────────────────────────
  Widget _buildBottomPanel() {
    return Container(
      color: const Color(0xFF161616),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showBottomSheet && _selectedTextId != null)
            _buildTextToolsPanel(),
          if (!_showBottomSheet) _buildMainToolsPanel(),
        ],
      ),
    );
  }

  // ── Main Tools Panel ─────────────────────────────────────────────
  Widget _buildMainToolsPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _toolButton(Icons.text_fields, 'Add Text', _addText),
          _toolButton(Icons.emoji_emotions, 'Sticker', _addEmoji),
          _toolButton(Icons.flip, 'Flip', _showFlipOptions),
          _toolButton(Icons.color_lens, 'Tint', _showTintOptions),
          _toolButton(Icons.rotate_right, 'Rotate', _showRotateOptions),
        ],
      ),
    );
  }

  // ── Text Tools Panel ─────────────────────────────────────────────
  Widget _buildTextToolsPanel() {
    final selectedText = _textItems.firstWhere(
      (t) => t.id == _selectedTextId,
      orElse: () => StickerTextItem(id: '', text: ''),
    );
    if (selectedText.id.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _toolButton(
                Icons.edit,
                'Edit',
                () => _openTextEditor(selectedText),
              ),
              _toolButton(
                Icons.font_download,
                'Font',
                () => _showFontSizePicker(selectedText),
              ),
              _toolButton(
                Icons.format_color_text,
                'Color',
                () => _showColorPicker(selectedText),
              ),
              _toolButton(
                Icons.format_color_fill,
                'BG',
                () => _showBgColorPicker(selectedText),
              ),
              _toolButton(
                Icons.close,
                'Close',
                () => setState(() => _showBottomSheet = false),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _styleButton(
                'B',
                selectedText.isBold,
                () => _toggleTextStyle(selectedText, 'bold'),
              ),
              _styleButton(
                'I',
                selectedText.isItalic,
                () => _toggleTextStyle(selectedText, 'italic'),
              ),
              _styleButton(
                'U',
                selectedText.isUnderline,
                () => _toggleTextStyle(selectedText, 'underline'),
              ),
              _styleButton(
                'Shadow',
                selectedText.hasShadow,
                () => _toggleTextStyle(selectedText, 'shadow'),
              ),
              _styleButton(
                'Border',
                selectedText.hasBorder,
                () => _toggleTextStyle(selectedText, 'border'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toolButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _styleButton(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF7C4DFF) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ── Text Operations ──────────────────────────────────────────────
  void _addText() {
    final item = StickerTextItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Tap to edit',
      position: Offset(100, 200 + _textItems.length * 40.0),
      fontSize: 24,
      color: Colors.white,
    );
    setState(() {
      _textItems.add(item);
      _selectedTextId = item.id;
      _showBottomSheet = true;
    });
    _openTextEditor(item);
  }

  void _openTextEditor(StickerTextItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TextEditorSheet(
        item: item,
        onChanged: (updated) {
          setState(() {
            final idx = _textItems.indexWhere((t) => t.id == updated.id);
            if (idx != -1) _textItems[idx] = updated;
          });
        },
      ),
    );
  }

  void _toggleTextStyle(StickerTextItem item, String style) {
    setState(() {
      final idx = _textItems.indexWhere((t) => t.id == item.id);
      if (idx != -1) {
        switch (style) {
          case 'bold':
            _textItems[idx] = _textItems[idx].copyWith(isBold: !item.isBold);
            break;
          case 'italic':
            _textItems[idx] = _textItems[idx].copyWith(
              isItalic: !item.isItalic,
            );
            break;
          case 'underline':
            _textItems[idx] = _textItems[idx].copyWith(
              isUnderline: !item.isUnderline,
            );
            break;
          case 'shadow':
            _textItems[idx] = _textItems[idx].copyWith(
              hasShadow: !item.hasShadow,
            );
            break;
          case 'border':
            _textItems[idx] = _textItems[idx].copyWith(
              hasBorder: !item.hasBorder,
            );
            break;
        }
      }
    });
  }

  void _showFontSizePicker(StickerTextItem item) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Font Size',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Slider(
              value: item.fontSize,
              min: 10,
              max: 72,
              divisions: 62,
              activeColor: const Color(0xFF7C4DFF),
              label: item.fontSize.toStringAsFixed(0),
              onChanged: (v) {
                setState(() {
                  final idx = _textItems.indexWhere((t) => t.id == item.id);
                  if (idx != -1) {
                    _textItems[idx] = _textItems[idx].copyWith(fontSize: v);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(StickerTextItem item) {
    final colors = [
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      const Color(0xFFD4AF37),
      Colors.cyan,
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
                          final idx = _textItems.indexWhere(
                            (t) => t.id == item.id,
                          );
                          if (idx != -1) {
                            _textItems[idx] = _textItems[idx].copyWith(
                              color: c,
                            );
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
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

  void _showBgColorPicker(StickerTextItem item) {
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
                          final idx = _textItems.indexWhere(
                            (t) => t.id == item.id,
                          );
                          if (idx != -1) {
                            _textItems[idx] = _textItems[idx].copyWith(
                              backgroundColor: c,
                            );
                          }
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

  // ── Emoji Operations ─────────────────────────────────────────────
  void _addEmoji() {
    showModalBottomSheet(
      context: context,
      builder: (_) => _EmojiPickerSheet(
        onEmojiSelected: (emoji) {
          setState(() {
            _extraStickers.add(
              ExtraStickerItem(emoji: emoji, position: Offset(100, 150)),
            );
          });
        },
      ),
    );
  }

  // ── Flip Options ─────────────────────────────────────────────────
  void _showFlipOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Flip Sticker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _flipOption('Flip Horizontal', () {
                  setState(() => _flipH = !_flipH);
                  Navigator.pop(context);
                }),
                _flipOption('Flip Vertical', () {
                  setState(() => _flipV = !_flipV);
                  Navigator.pop(context);
                }),
                _flipOption('Reset', () {
                  setState(() {
                    _flipH = false;
                    _flipV = false;
                    _rotation = 0;
                  });
                  Navigator.pop(context);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _flipOption(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5C518),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ── Tint Options ─────────────────────────────────────────────────
  void _showTintOptions() {
    final colors = [
      Colors.transparent,
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.cyan,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.white,
      Colors.black,
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
              'Color Tint',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors
                  .map(
                    (c) => GestureDetector(
                      onTap: () {
                        setState(() => _tintColor = c);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c == Colors.transparent ? Colors.white : c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _tintColor == c
                                ? Colors.blueAccent
                                : Colors.grey.shade300,
                            width: _tintColor == c ? 2.5 : 1,
                          ),
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
            Row(
              children: [
                const Text('Opacity', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: _tintOpacity,
                    min: 0,
                    max: 1,
                    activeColor: const Color(0xFF7C4DFF),
                    onChanged: (v) => setState(() => _tintOpacity = v),
                  ),
                ),
                Text(
                  '${(_tintOpacity * 100).round()}%',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Rotate Options ───────────────────────────────────────────────
  void _showRotateOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rotate Sticker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _rotateOption('-90°', () {
                  setState(() => _rotation -= math.pi / 2);
                  Navigator.pop(context);
                }),
                _rotateOption('+90°', () {
                  setState(() => _rotation += math.pi / 2);
                  Navigator.pop(context);
                }),
                _rotateOption('Reset', () {
                  setState(() => _rotation = 0);
                  Navigator.pop(context);
                }),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Fine Tune', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: _rotation,
                    min: -math.pi,
                    max: math.pi,
                    activeColor: const Color(0xFF7C4DFF),
                    onChanged: (v) => setState(() => _rotation = v),
                  ),
                ),
                Text(
                  '${(_rotation * 180 / math.pi).round()}°',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rotateOption(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF7C4DFF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ── Delete Confirm ───────────────────────────────────────────────
  void _showDeleteConfirm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Remove Sticker',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Remove this sticker from the canvas?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Color(0xFFFF4444)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Download to Gallery ──────────────────────────────────────────
  Future<void> _onDownload() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C4DFF)),
          ),
        ),
      );

      final boundary =
          _canvasKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        Navigator.pop(context);
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();

      Navigator.pop(context);

      if (bytes != null) {
        final tempDir = await getTemporaryDirectory();
        final fileName = 'sticker_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(bytes);

        final hasAccess = await Gal.hasAccess();
        if (!hasAccess) await Gal.requestAccess();
        await Gal.putImage(file.path, album: 'Sticker Editor');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sticker saved to gallery! ✨'),
              backgroundColor: Color(0xFF7C4DFF),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _iconBtn(IconData icon, VoidCallback? onTap, {Color? color}) =>
      IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: color ?? Colors.white),
        iconSize: 22,
      );

  Widget _handle(IconData icon, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CHECKERBOARD BACKGROUND
// ─────────────────────────────────────────────
class _CheckerBackground extends StatelessWidget {
  final Size size;
  const _CheckerBackground({required this.size});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: size, painter: _CheckerPainter());
}

class _CheckerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cellSize = 20.0;
    final paint1 = Paint()..color = const Color(0xFF1A1A1A);
    final paint2 = Paint()..color = const Color(0xFF222222);
    for (double y = 0; y < size.height; y += cellSize) {
      for (double x = 0; x < size.width; x += cellSize) {
        final even = ((x / cellSize).floor() + (y / cellSize).floor()) % 2 == 0;
        canvas.drawRect(
          Rect.fromLTWH(x, y, cellSize, cellSize),
          even ? paint1 : paint2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
//  TEXT EDITOR BOTTOM SHEET
// ─────────────────────────────────────────────
class _TextEditorSheet extends StatefulWidget {
  final StickerTextItem item;
  final ValueChanged<StickerTextItem> onChanged;

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
  late StickerTextItem _current;

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

  void _update(StickerTextItem updated) {
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
                    activeColor: const Color(0xFF7C4DFF),
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
                _styleChip(
                  'B',
                  _current.isBold,
                  () => _update(_current.copyWith(isBold: !_current.isBold)),
                  bold: true,
                ),
                _styleChip(
                  'I',
                  _current.isItalic,
                  () =>
                      _update(_current.copyWith(isItalic: !_current.isItalic)),
                  italic: true,
                ),
                _styleChip(
                  'U',
                  _current.isUnderline,
                  () => _update(
                    _current.copyWith(isUnderline: !_current.isUnderline),
                  ),
                  underline: true,
                ),
                _styleChip(
                  'Shadow',
                  _current.hasShadow,
                  () => _update(
                    _current.copyWith(hasShadow: !_current.hasShadow),
                  ),
                ),
                _styleChip(
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
                  backgroundColor: const Color(0xFF7C4DFF),
                  foregroundColor: Colors.white,
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

  Widget _styleChip(
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF7C4DFF) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
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
//  EMOJI PICKER SHEET
// ─────────────────────────────────────────────
class _EmojiPickerSheet extends StatelessWidget {
  final Function(String) onEmojiSelected;

  const _EmojiPickerSheet({required this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    final emojis = [
      '😀',
      '😂',
      '🥹',
      '😍',
      '🤩',
      '😎',
      '🥳',
      '🫶',
      '👍',
      '🔥',
      '✨',
      '💥',
      '💯',
      '🎉',
      '❤️',
      '💜',
      '🌈',
      '⭐',
      '🦄',
      '🍀',
      '🎵',
      '🎯',
      '🏆',
      '💎',
      '🚀',
      '🌟',
      '👑',
      '🎀',
      '🍭',
      '🌺',
    ];

    return Container(
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
          const Text(
            'Add Emoji',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: emojis.length,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () {
                onEmojiSelected(emojis[i]);
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(emojis[i], style: const TextStyle(fontSize: 28)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
