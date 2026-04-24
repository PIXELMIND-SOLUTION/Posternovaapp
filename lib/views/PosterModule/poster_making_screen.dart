import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/providers/customer/customer_provider.dart';
import 'package:posternova/views/chat/chat_module.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ════════════════════════════════════════════════════════
//  ENUMS
// ════════════════════════════════════════════════════════

enum BottomTab { none, text, frames, effects, animation, design }

enum PosterAnimation {
  none,
  flipInX,
  flipInY,
  wobble,
  rollIn,
  largeZoom,
  rotateLeft,
  rotateRight,
  bounce,
  fadeIn,
}

enum PosterEffectType { none, sparkle, stars, snow, confetti }

enum BarLayoutStyle {
  classic,
  stacked,
  badgeChip,
  centered,
  cardSplit,
  minimal,
  ribbon,
  neon,
  wave,
  magazine,
}

class BottomBarDesign {
  final String id;
  final String name;
  final BarLayoutStyle layoutStyle;
  final Gradient? gradient;
  final Color? solidColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color iconBgColor;
  final Color dividerColor;
  final double borderRadiusTop;
  final bool showTopBorder;
  final Color topBorderColor;
  final bool showIcons;
  final double elevation;

  const BottomBarDesign({
    required this.id,
    required this.name,
    required this.layoutStyle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.iconBgColor,
    required this.dividerColor,
    this.gradient,
    this.solidColor,
    this.borderRadiusTop = 0,
    this.showTopBorder = true,
    this.topBorderColor = const Color(0x33FFFFFF),
    this.showIcons = true,
    this.elevation = 0,
  });
}

const List<BottomBarDesign> kBottomBarDesigns = [
  BottomBarDesign(
    id: 'classic',
    name: 'Classic',
    layoutStyle: BarLayoutStyle.classic,
    solidColor: Color(0xF0000000),
    primaryColor: Colors.white,
    secondaryColor: Color(0xAAFFFFFF),
    iconBgColor: Color(0x449C27B0),
    dividerColor: Colors.white30,
    topBorderColor: Colors.white24,
  ),
  BottomBarDesign(
    id: 'stacked',
    name: 'Stacked',
    layoutStyle: BarLayoutStyle.stacked,
    gradient: LinearGradient(
      colors: [Color(0xFF1A237E), Color(0xFF283593)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    primaryColor: Colors.white,
    secondaryColor: Color(0xAAFFFFFF),
    iconBgColor: Color(0x447986CB),
    dividerColor: Color(0x557986CB),
    topBorderColor: Color(0x887986CB),
  ),
  BottomBarDesign(
    id: 'badge',
    name: 'Badge',
    layoutStyle: BarLayoutStyle.badgeChip,
    solidColor: Color(0xFF1A1A1A),
    primaryColor: Color(0xFFFFE500),
    secondaryColor: Colors.white70,
    iconBgColor: Color(0x44FFE500),
    dividerColor: Colors.transparent,
    topBorderColor: Color(0x88FFE500),
    showTopBorder: true,
  ),
  BottomBarDesign(
    id: 'centered',
    name: 'Centered',
    layoutStyle: BarLayoutStyle.centered,
    gradient: LinearGradient(
      colors: [Color(0xFF880E4F), Color(0xFFAD1457)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    primaryColor: Colors.white,
    secondaryColor: Color(0xDDFFFFFF),
    iconBgColor: Colors.transparent,
    dividerColor: Colors.white30,
    topBorderColor: Color(0x55F48FB1),
    showIcons: false,
  ),
  BottomBarDesign(
    id: 'card_split',
    name: 'Cards',
    layoutStyle: BarLayoutStyle.cardSplit,
    solidColor: Color(0xEE111111),
    primaryColor: Colors.white,
    secondaryColor: Color(0xAAFFFFFF),
    iconBgColor: Color(0x4400BCD4),
    dividerColor: Colors.transparent,
    topBorderColor: Colors.transparent,
    showTopBorder: false,
    elevation: 8,
  ),
  BottomBarDesign(
    id: 'minimal',
    name: 'Minimal',
    layoutStyle: BarLayoutStyle.minimal,
    solidColor: Color(0xCC000000),
    primaryColor: Color(0xFFFFFFFF),
    secondaryColor: Color(0x99FFFFFF),
    iconBgColor: Colors.transparent,
    dividerColor: Color(0x55FFFFFF),
    topBorderColor: Colors.transparent,
    showIcons: false,
    showTopBorder: false,
  ),
  BottomBarDesign(
    id: 'ribbon',
    name: 'Ribbon',
    layoutStyle: BarLayoutStyle.ribbon,
    gradient: LinearGradient(
      colors: [Color(0xFF004D40), Color(0xFF00695C), Color(0xFF00897B)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    primaryColor: Colors.white,
    secondaryColor: Color(0xCCFFFFFF),
    iconBgColor: Color(0x4480CBC4),
    dividerColor: Colors.white30,
    topBorderColor: Color(0x8880CBC4),
  ),
  BottomBarDesign(
    id: 'neon',
    name: 'Neon',
    layoutStyle: BarLayoutStyle.neon,
    solidColor: Color(0xFF0A0A0A),
    primaryColor: Color(0xFF00FF88),
    secondaryColor: Color(0xAA00FF88),
    iconBgColor: Color(0x2200FF88),
    dividerColor: Color(0x8800FF88),
    topBorderColor: Color(0xFF00FF88),
    elevation: 0,
  ),
  BottomBarDesign(
    id: 'wave',
    name: 'Wave',
    layoutStyle: BarLayoutStyle.wave,
    gradient: LinearGradient(
      colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    primaryColor: Colors.white,
    secondaryColor: Color(0xCCFFFFFF),
    iconBgColor: Color(0x44CE93D8),
    dividerColor: Colors.white24,
    topBorderColor: Colors.transparent,
    showTopBorder: false,
    borderRadiusTop: 24,
  ),
  BottomBarDesign(
    id: 'magazine',
    name: 'Magazine',
    layoutStyle: BarLayoutStyle.magazine,
    gradient: LinearGradient(
      colors: [Color(0xFFB71C1C), Color(0xFFC62828)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    primaryColor: Colors.white,
    secondaryColor: Color(0xCCFFFFFF),
    iconBgColor: Color(0x44EF9A9A),
    dividerColor: Colors.white30,
    topBorderColor: Color(0x55EF9A9A),
  ),
  BottomBarDesign(
    id: 'gold',
    name: 'Gold',
    layoutStyle: BarLayoutStyle.classic,
    gradient: LinearGradient(
      colors: [Color(0xFF1A1A1A), Color(0xFF3D2B00)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    primaryColor: Color(0xFFFFD700),
    secondaryColor: Color(0xAAFFD700),
    iconBgColor: Color(0x44FFD700),
    dividerColor: Color(0x66FFD700),
    topBorderColor: Color(0xAAFFD700),
  ),
  BottomBarDesign(
    id: 'white',
    name: 'White',
    layoutStyle: BarLayoutStyle.stacked,
    solidColor: Colors.white,
    primaryColor: Color(0xFF1A1A1A),
    secondaryColor: Color(0x996A1B9A),
    iconBgColor: Color(0x1A6A1B9A),
    dividerColor: Color(0x226A1B9A),
    topBorderColor: Color(0x336A1B9A),
    borderRadiusTop: 18,
  ),
];

// ════════════════════════════════════════════════════════
//  SPARKLE EFFECT
// ════════════════════════════════════════════════════════

class _Sparkle {
  double x, y, size, opacity, speed, rotation, rotationSpeed;
  _Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class _SparkleParticlesPainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  final PosterEffectType effectType;
  _SparkleParticlesPainter(this.sparkles, this.effectType);

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sparkles) {
      final paint = Paint()
        ..color = _color(effectType).withOpacity(s.opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(s.x * size.width, s.y * size.height);
      canvas.rotate(s.rotation);
      switch (effectType) {
        case PosterEffectType.sparkle:
          _drawSparkle(canvas, paint, s.size);
          break;
        case PosterEffectType.stars:
          _drawStar(canvas, paint, s.size);
          break;
        case PosterEffectType.snow:
          canvas.drawCircle(Offset.zero, s.size * 0.5, paint);
          break;
        case PosterEffectType.confetti:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: s.size * 0.6,
              height: s.size * 1.2,
            ),
            paint,
          );
          break;
        default:
          break;
      }
      canvas.restore();
    }
  }

  Color _color(PosterEffectType t) {
    switch (t) {
      case PosterEffectType.sparkle:
        return Colors.white;
      case PosterEffectType.stars:
        return Colors.yellowAccent;
      case PosterEffectType.snow:
        return Colors.lightBlueAccent;
      case PosterEffectType.confetti:
        return Colors.pinkAccent;
      default:
        return Colors.white;
    }
  }

  void _drawSparkle(Canvas canvas, Paint paint, double size) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final r = i.isEven ? size : size * 0.25;
      final x = cos(angle) * r;
      final y = sin(angle) * r;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity(paint.color.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
  }

  void _drawStar(Canvas canvas, Paint paint, double size) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final angle = i * pi / 5 - pi / 2;
      final r = i.isEven ? size : size * 0.4;
      final x = cos(angle) * r;
      final y = sin(angle) * r;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparkleParticlesPainter old) => true;
}

class PosterEffectOverlay extends StatefulWidget {
  final PosterEffectType effectType;
  final double width, height;
  const PosterEffectOverlay({
    super.key,
    required this.effectType,
    required this.width,
    required this.height,
  });

  @override
  State<PosterEffectOverlay> createState() => _PosterEffectOverlayState();
}

class _PosterEffectOverlayState extends State<PosterEffectOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<_Sparkle> _sparkles;
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _initSparkles();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(_update);
    if (widget.effectType != PosterEffectType.none) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(PosterEffectOverlay old) {
    super.didUpdateWidget(old);
    if (widget.effectType != old.effectType) {
      _initSparkles();
      widget.effectType != PosterEffectType.none
          ? _ctrl.repeat()
          : _ctrl.stop();
    }
  }

  int get _count {
    switch (widget.effectType) {
      case PosterEffectType.sparkle:
        return 20;
      case PosterEffectType.stars:
        return 25;
      case PosterEffectType.snow:
        return 35;
      case PosterEffectType.confetti:
        return 30;
      default:
        return 0;
    }
  }

  void _initSparkles() => _sparkles = List.generate(_count, (_) => _rand());

  _Sparkle _rand() => _Sparkle(
    x: _rnd.nextDouble(),
    y: _rnd.nextDouble(),
    size: _rnd.nextDouble() * 14 + 6,
    opacity: _rnd.nextDouble(),
    speed: _rnd.nextDouble() * 0.003 + 0.001,
    rotation: _rnd.nextDouble() * 2 * pi,
    rotationSpeed: (_rnd.nextDouble() - 0.5) * 0.05,
  );

  void _update() {
    if (!mounted) return;
    setState(() {
      for (final s in _sparkles) {
        s.rotation += s.rotationSpeed;
        s.opacity = (s.opacity + (_rnd.nextDouble() - 0.5) * 0.15).clamp(
          0.1,
          1.0,
        );
        switch (widget.effectType) {
          case PosterEffectType.snow:
            s.y += s.speed;
            s.x += sin(s.rotation) * 0.002;
            break;
          case PosterEffectType.confetti:
            s.y += s.speed * 1.5;
            s.x += cos(s.rotation) * 0.003;
            break;
          case PosterEffectType.sparkle:
          case PosterEffectType.stars:
            if (_rnd.nextDouble() < 0.02) {
              s.x = _rnd.nextDouble();
              s.y = _rnd.nextDouble();
              s.opacity = 1.0;
              s.size = _rnd.nextDouble() * 18 + 6;
            }
            break;
          default:
            break;
        }
        if (s.y > 1.05 || s.x < -0.05 || s.x > 1.05) {
          s.x = _rnd.nextDouble();
          s.y = -0.05;
          s.opacity = 0.8;
        }
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.effectType == PosterEffectType.none)
      return const SizedBox.shrink();
    return IgnorePointer(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(
          painter: _SparkleParticlesPainter(_sparkles, widget.effectType),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  FRAME MODEL & PAINTER
// ════════════════════════════════════════════════════════

class PosterFrame {
  final String id, name;
  final Color borderColor;
  final double borderWidth, borderRadius;
  final List<Color> gradientColors;
  final bool isDefault;

  const PosterFrame({
    required this.id,
    required this.name,
    required this.borderColor,
    this.borderWidth = 8.0,
    this.borderRadius = 0.0,
    this.gradientColors = const [],
    this.isDefault = false,
  });
}

class FrameBorderPainter extends CustomPainter {
  final PosterFrame frame;
  FrameBorderPainter(this.frame);

  @override
  void paint(Canvas canvas, Size size) {
    final hw = frame.borderWidth / 2;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        hw,
        hw,
        size.width - frame.borderWidth,
        size.height - frame.borderWidth,
      ),
      Radius.circular(frame.borderRadius),
    );
    if (frame.gradientColors.isNotEmpty) {
      canvas.drawRRect(
        rrect,
        Paint()
          ..shader = LinearGradient(
            colors: frame.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.stroke
          ..strokeWidth = frame.borderWidth,
      );
    } else {
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = frame.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = frame.borderWidth,
      );
    }
  }

  @override
  bool shouldRepaint(FrameBorderPainter old) => true;
}

// ════════════════════════════════════════════════════════
//  ANIMATION WRAPPER
// ════════════════════════════════════════════════════════

class AnimatedPosterWrapper extends StatefulWidget {
  final PosterAnimation animation;
  final Widget child;
  const AnimatedPosterWrapper({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  State<AnimatedPosterWrapper> createState() => _AnimatedPosterWrapperState();
}

class _AnimatedPosterWrapperState extends State<AnimatedPosterWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    if (widget.animation != PosterAnimation.none) _ctrl.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(AnimatedPosterWrapper old) {
    super.didUpdateWidget(old);
    if (widget.animation != old.animation) {
      if (widget.animation == PosterAnimation.none) {
        _ctrl.stop();
        _ctrl.reset();
      } else {
        _ctrl.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animation == PosterAnimation.none) return widget.child;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) {
        switch (widget.animation) {
          case PosterAnimation.flipInX:
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateX((_anim.value - 0.5) * 0.3),
              child: child,
            );
          case PosterAnimation.flipInY:
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY((_anim.value - 0.5) * 0.3),
              child: child,
            );
          case PosterAnimation.wobble:
            return Transform.rotate(
              angle: sin(_anim.value * 2 * pi) * 0.04,
              child: child,
            );
          case PosterAnimation.rollIn:
            return Transform.rotate(
              angle: (_anim.value - 0.5) * 0.15,
              child: child,
            );
          case PosterAnimation.largeZoom:
            return Transform.scale(
              scale: 1.0 + _anim.value * 0.04,
              child: child,
            );
          case PosterAnimation.rotateLeft:
            return Transform.rotate(angle: -_anim.value * 0.06, child: child);
          case PosterAnimation.rotateRight:
            return Transform.rotate(angle: _anim.value * 0.06, child: child);
          case PosterAnimation.bounce:
            return Transform.translate(
              offset: Offset(0, -_anim.value * 8),
              child: child,
            );
          case PosterAnimation.fadeIn:
            return Opacity(opacity: 0.85 + _anim.value * 0.15, child: child);
          default:
            return child!;
        }
      },
      child: widget.child,
    );
  }
}

// ════════════════════════════════════════════════════════
//  BOTTOM PANELS
// ════════════════════════════════════════════════════════

class FramesPanel extends StatefulWidget {
  final PosterFrame? selectedFrame;
  final ValueChanged<PosterFrame?> onFrameSelected;
  const FramesPanel({
    super.key,
    required this.selectedFrame,
    required this.onFrameSelected,
  });

  @override
  State<FramesPanel> createState() => _FramesPanelState();
}

class _FramesPanelState extends State<FramesPanel> {
  int _selectedColorIndex = -1;

  static const List<Color> _suggestedColors = [
    Color(0xFF00BFA5),
    Color(0xFF8D6E63),
    Color(0xFF90A4AE),
    Color(0xFF66BB6A),
    Color(0xFFFFA726),
    Color(0xFF26A69A),
    Color(0xFF4CAF50),
    Color(0xFF00ACC1),
    Color(0xFFB2DFDB),
  ];

  final List<PosterFrame> _frames = const [
    PosterFrame(
      id: 'default',
      name: 'Use\nDefault',
      borderColor: Colors.transparent,
      isDefault: true,
    ),
    PosterFrame(
      id: 'gold',
      name: 'Gold',
      borderColor: Color(0xFFFFD700),
      borderWidth: 10,
      gradientColors: [Color(0xFFFFD700), Color(0xFFFFA000)],
    ),
    PosterFrame(
      id: 'modern',
      name: 'Modern',
      borderColor: Color(0xFF2196F3),
      borderWidth: 8,
      borderRadius: 12,
    ),
    PosterFrame(
      id: 'elegant',
      name: 'Elegant',
      borderColor: Color(0xFF9C27B0),
      borderWidth: 12,
      gradientColors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
    ),
    PosterFrame(
      id: 'business',
      name: 'Business',
      borderColor: Color(0xFF37474F),
      borderWidth: 8,
    ),
    PosterFrame(
      id: 'nature',
      name: 'Nature',
      borderColor: Color(0xFF388E3C),
      borderWidth: 10,
      borderRadius: 8,
    ),
    PosterFrame(
      id: 'sunset',
      name: 'Sunset',
      borderColor: Color(0xFFFF5722),
      borderWidth: 10,
      gradientColors: [Color(0xFFFF5722), Color(0xFFFF9800)],
    ),
    PosterFrame(
      id: 'ocean',
      name: 'Ocean',
      borderColor: Color(0xFF0288D1),
      borderWidth: 10,
      gradientColors: [Color(0xFF0288D1), Color(0xFF00BCD4)],
      borderRadius: 16,
    ),
    PosterFrame(
      id: 'rose',
      name: 'Rose',
      borderColor: Color(0xFFE91E63),
      borderWidth: 8,
      gradientColors: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    ),
    PosterFrame(
      id: 'silver',
      name: 'Silver',
      borderColor: Color(0xFF9E9E9E),
      borderWidth: 10,
      gradientColors: [Color(0xFFBDBDBD), Color(0xFF757575)],
    ),
    PosterFrame(
      id: 'royal',
      name: 'Royal',
      borderColor: Color(0xFF283593),
      borderWidth: 12,
      gradientColors: [Color(0xFF283593), Color(0xFF3949AB)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Suggested Colours',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _suggestedColors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final isSel = _selectedColorIndex == i;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedColorIndex = i);
                    widget.onFrameSelected(
                      PosterFrame(
                        id: 'color_$i',
                        name: 'Color',
                        borderColor: _suggestedColors[i],
                        borderWidth: 10,
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _suggestedColors[i],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSel ? Colors.white : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _frames.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final f = _frames[i];
                final isSel = widget.selectedFrame?.id == f.id;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedColorIndex = -1);
                    widget.onFrameSelected(f.isDefault ? null : f);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 86,
                    height: 108,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSel ? Colors.white : Colors.grey.shade300,
                        width: isSel ? 2.5 : 1,
                      ),
                      boxShadow: isSel
                          ? [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.4),
                                blurRadius: 8,
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _FrameThumb(frame: f),
                        const SizedBox(height: 6),
                        Text(
                          f.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
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
}

class _FrameThumb extends StatelessWidget {
  final PosterFrame frame;
  const _FrameThumb({required this.frame});

  @override
  Widget build(BuildContext context) {
    if (frame.isDefault) {
      return Container(
        width: 58,
        height: 66,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            color: const Color(0xFFFFE500),
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: Text(
            'Use\nDefault',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 8, color: Colors.black54),
          ),
        ),
      );
    }
    if (frame.gradientColors.isNotEmpty) {
      return Container(
        width: 58,
        height: 66,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: frame.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(frame.borderRadius),
        ),
        child: Container(
          margin: EdgeInsets.all(frame.borderWidth * 0.5),
          color: Colors.white,
        ),
      );
    }
    return Container(
      width: 58,
      height: 66,
      decoration: BoxDecoration(
        border: Border.all(color: frame.borderColor, width: 3),
        borderRadius: BorderRadius.circular(frame.borderRadius),
      ),
    );
  }
}

class AnimationPanel extends StatelessWidget {
  final PosterAnimation currentAnimation;
  final ValueChanged<PosterAnimation> onAnimationSelected;
  const AnimationPanel({
    super.key,
    required this.currentAnimation,
    required this.onAnimationSelected,
  });

  static const List<({PosterAnimation type, String label, IconData icon})>
  _opts = [
    (type: PosterAnimation.none, label: 'Remove', icon: Icons.block),
    (type: PosterAnimation.flipInX, label: 'FlipInX', icon: Icons.flip),
    (
      type: PosterAnimation.flipInY,
      label: 'FlipInY',
      icon: Icons.flip_camera_android,
    ),
    (type: PosterAnimation.wobble, label: 'Wobble', icon: Icons.waves),
    (type: PosterAnimation.rollIn, label: 'RollIn', icon: Icons.rotate_right),
    (type: PosterAnimation.largeZoom, label: 'LargeZoom', icon: Icons.zoom_in),
    (
      type: PosterAnimation.rotateLeft,
      label: 'RotateLeft',
      icon: Icons.rotate_left,
    ),
    (
      type: PosterAnimation.rotateRight,
      label: 'RotateRight',
      icon: Icons.rotate_right_outlined,
    ),
    (
      type: PosterAnimation.bounce,
      label: 'Bounce',
      icon: Icons.sports_basketball_outlined,
    ),
    (
      type: PosterAnimation.fadeIn,
      label: 'FadeIn',
      icon: Icons.brightness_medium,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Animation',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _opts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final opt = _opts[i];
                final isSel = currentAnimation == opt.type;
                return GestureDetector(
                  onTap: () => onAnimationSelected(opt.type),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: opt.type == PosterAnimation.none
                              ? Colors.grey.shade800
                              : Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSel ? Colors.white : Colors.grey.shade700,
                            width: isSel ? 2.5 : 1,
                          ),
                          boxShadow: isSel
                              ? [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 8,
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: opt.type == PosterAnimation.none
                              ? const Text(
                                  'Remove\nAnimation',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Icon(
                                  opt.icon,
                                  color: const Color(0xFFFFE500),
                                  size: 28,
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        opt.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSel ? Colors.white : Colors.white60,
                          fontSize: 9,
                          fontWeight: isSel
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TextToolsPanel extends StatelessWidget {
  final VoidCallback onAddText, onAddLogo, onAddImage;
  const TextToolsPanel({
    super.key,
    required this.onAddText,
    required this.onAddLogo,
    required this.onAddImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Text & Elements',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ToolBtn(
                icon: Icons.text_fields,
                label: 'Add Text',
                onTap: onAddText,
              ),
              const SizedBox(width: 12),
              _ToolBtn(
                icon: Icons.image_outlined,
                label: 'Add Image',
                onTap: onAddImage,
              ),
              const SizedBox(width: 12),
              _ToolBtn(
                icon: Icons.business_center_outlined,
                label: 'Add Logo',
                onTap: onAddLogo,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ToolBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    ),
  );
}

class EffectsPanel extends StatelessWidget {
  final PosterEffectType currentEffect;
  final ValueChanged<PosterEffectType> onEffectSelected;
  const EffectsPanel({
    super.key,
    required this.currentEffect,
    required this.onEffectSelected,
  });

  @override
  Widget build(BuildContext context) {
    final effects = [
      _EffectOption(
        type: PosterEffectType.none,
        label: 'Remove',
        preview: _buildRemovePreview(),
      ),
      _EffectOption(
        type: PosterEffectType.sparkle,
        label: 'Sparkle',
        preview: _buildSparklePreview(),
      ),
      _EffectOption(
        type: PosterEffectType.stars,
        label: 'Stars',
        preview: _buildStarsPreview(),
      ),
      _EffectOption(
        type: PosterEffectType.snow,
        label: 'Snow',
        preview: _buildSnowPreview(),
      ),
      _EffectOption(
        type: PosterEffectType.confetti,
        label: 'Confetti',
        preview: _buildConfettiPreview(),
      ),
    ];

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Effect',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: effects.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final opt = effects[i];
                final isSelected = currentEffect == opt.type;
                return GestureDetector(
                  onTap: () => onEffectSelected(opt.type),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.35),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: opt.preview,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        opt.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white60,
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemovePreview() => Container(
    color: Colors.grey.shade800,
    child: const Center(
      child: Text(
        'Remove\nEffect',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    ),
  );

  Widget _buildSparklePreview() => Container(
    color: const Color(0xFFFFB300),
    child: Stack(
      children: [
        Positioned(
          top: 8,
          left: 10,
          child: Icon(Icons.auto_awesome, color: Colors.white, size: 16),
        ),
        Positioned(
          bottom: 10,
          right: 6,
          child: Icon(Icons.auto_awesome, color: Colors.white, size: 22),
        ),
        Positioned(
          top: 28,
          right: 18,
          child: Icon(Icons.auto_awesome, color: Colors.white70, size: 11),
        ),
        Positioned(
          bottom: 22,
          left: 6,
          child: Icon(Icons.auto_awesome, color: Colors.white60, size: 10),
        ),
      ],
    ),
  );

  Widget _buildStarsPreview() => Container(
    color: const Color(0xFFFFD700),
    child: Stack(
      children: [
        Positioned(
          top: 8,
          left: 8,
          child: Icon(Icons.star, color: Colors.white, size: 18),
        ),
        Positioned(
          bottom: 8,
          right: 6,
          child: Icon(Icons.star, color: Colors.white, size: 22),
        ),
        Positioned(
          top: 30,
          right: 20,
          child: Icon(Icons.star, color: Colors.white70, size: 12),
        ),
        Positioned(
          bottom: 24,
          left: 4,
          child: Icon(Icons.star, color: Colors.white60, size: 10),
        ),
      ],
    ),
  );

  Widget _buildSnowPreview() => Container(
    color: const Color(0xFF64B5F6),
    child: Stack(
      children: [
        Positioned(
          top: 8,
          left: 10,
          child: Icon(Icons.ac_unit, color: Colors.white, size: 16),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Icon(Icons.ac_unit, color: Colors.white, size: 20),
        ),
        Positioned(
          top: 30,
          right: 18,
          child: Icon(Icons.ac_unit, color: Colors.white70, size: 11),
        ),
        Positioned(
          bottom: 26,
          left: 4,
          child: Icon(Icons.ac_unit, color: Colors.white60, size: 10),
        ),
      ],
    ),
  );

  Widget _buildConfettiPreview() => Container(
    color: const Color(0xFFE91E63),
    child: Stack(
      children: [
        Positioned(
          top: 8,
          left: 10,
          child: Icon(Icons.celebration, color: Colors.white, size: 16),
        ),
        Positioned(
          bottom: 8,
          right: 6,
          child: Icon(Icons.celebration, color: Colors.white, size: 22),
        ),
        Positioned(
          top: 30,
          right: 18,
          child: Icon(Icons.celebration, color: Colors.white70, size: 11),
        ),
        Positioned(
          bottom: 24,
          left: 4,
          child: Icon(Icons.celebration, color: Colors.white60, size: 10),
        ),
      ],
    ),
  );
}

class _EffectOption {
  final PosterEffectType type;
  final String label;
  final Widget preview;
  const _EffectOption({
    required this.type,
    required this.label,
    required this.preview,
  });
}

class DesignPanel extends StatelessWidget {
  final BottomBarDesign currentDesign;
  final ValueChanged<BottomBarDesign> onDesignSelected;
  const DesignPanel({
    super.key,
    required this.currentDesign,
    required this.onDesignSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Bottom Bar Style',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE500),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentDesign.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kBottomBarDesigns.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final d = kBottomBarDesigns[i];
                final isSelected = currentDesign.id == d.id;
                return GestureDetector(
                  onTap: () => onDesignSelected(d),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 110,
                        height: 94,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFFFE500)
                                : Colors.grey.shade700,
                            width: isSelected ? 2.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFFE500,
                                    ).withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : [],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _BarStylePreview(design: d),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFFFFE500),
                              size: 12,
                            ),
                          if (isSelected) const SizedBox(width: 3),
                          Text(
                            d.name,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFFFFE500)
                                  : Colors.white60,
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BarStylePreview extends StatelessWidget {
  final BottomBarDesign design;
  const _BarStylePreview({required this.design});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: design.gradient,
        color: design.gradient == null ? design.solidColor : null,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 40,
            child: Container(
              color: const Color(0xFFE0E0E0),
              child: Center(
                child: Icon(Icons.image, color: Colors.grey.shade400, size: 22),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 40,
            child: _buildBarLayout(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarLayout() {
    final tc = design.primaryColor;
    final sc = design.secondaryColor;
    final ibg = design.iconBgColor;

    Widget _bar(Color c, double maxW) => Flexible(
      child: Container(
        height: 4,
        constraints: BoxConstraints(maxWidth: maxW),
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );

    switch (design.layoutStyle) {
      case BarLayoutStyle.stacked:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            color: design.gradient == null ? design.solidColor : null,
            border: design.showTopBorder
                ? Border(
                    top: BorderSide(color: design.topBorderColor, width: 1),
                  )
                : null,
            borderRadius: design.borderRadiusTop > 0
                ? BorderRadius.vertical(
                    top: Radius.circular(design.borderRadiusTop),
                  )
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.business, color: tc, size: 8),
                  const SizedBox(width: 3),
                  _bar(tc.withOpacity(0.9), 44),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(Icons.phone, color: sc, size: 8),
                  const SizedBox(width: 3),
                  _bar(sc.withOpacity(0.7), 32),
                ],
              ),
            ],
          ),
        );

      case BarLayoutStyle.badgeChip:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            color: design.gradient == null ? design.solidColor : null,
            border: Border(
              top: BorderSide(color: design.topBorderColor, width: 1.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: ibg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: tc.withOpacity(0.5), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.business, color: tc, size: 8),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Container(
                          height: 4,
                          constraints: const BoxConstraints(maxWidth: 18),
                          decoration: BoxDecoration(
                            color: tc,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: ibg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: tc.withOpacity(0.5), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone, color: tc, size: 8),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Container(
                          height: 4,
                          constraints: const BoxConstraints(maxWidth: 18),
                          decoration: BoxDecoration(
                            color: tc,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      case BarLayoutStyle.centered:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            color: design.gradient == null ? design.solidColor : null,
            border: Border(
              top: BorderSide(color: design.topBorderColor, width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      height: 5,
                      constraints: const BoxConstraints(maxWidth: 55),
                      decoration: BoxDecoration(
                        color: tc,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      height: 3,
                      constraints: const BoxConstraints(maxWidth: 38),
                      decoration: BoxDecoration(
                        color: sc,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case BarLayoutStyle.cardSplit:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            color: design.gradient == null ? design.solidColor : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ibg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.business, color: tc, size: 8),
                      const SizedBox(width: 3),
                      _bar(tc, 22),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ibg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: tc, size: 8),
                      const SizedBox(width: 3),
                      _bar(tc, 22),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      case BarLayoutStyle.minimal:
        return Container(
          color: design.solidColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: tc,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 16,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: design.dividerColor,
              ),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: sc,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        );

      case BarLayoutStyle.ribbon:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            border: Border(
              top: BorderSide(color: design.topBorderColor, width: 2),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 28,
                color: tc.withOpacity(0.7),
                margin: const EdgeInsets.only(right: 5),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: tc,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      height: 3,
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 32),
                      decoration: BoxDecoration(
                        color: tc.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case BarLayoutStyle.neon:
        return Container(
          decoration: BoxDecoration(
            color: design.solidColor,
            border: Border(
              top: BorderSide(color: design.topBorderColor, width: 1.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: tc, width: 1),
                        boxShadow: [
                          BoxShadow(color: tc.withOpacity(0.5), blurRadius: 4),
                        ],
                      ),
                      child: Icon(Icons.business, color: tc, size: 7),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: tc,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: tc.withOpacity(0.4),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 20, color: design.dividerColor),
              Expanded(
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: tc, width: 1),
                        boxShadow: [
                          BoxShadow(color: tc.withOpacity(0.5), blurRadius: 4),
                        ],
                      ),
                      child: Icon(Icons.phone, color: tc, size: 7),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: tc,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: tc.withOpacity(0.4),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case BarLayoutStyle.wave:
        return ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: design.gradient,
              color: design.gradient == null ? design.solidColor : null,
            ),
            padding: const EdgeInsets.fromLTRB(6, 10, 6, 4),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.business, color: design.primaryColor, size: 8),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: design.primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 16, color: design.dividerColor),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      Icon(Icons.phone, color: design.secondaryColor, size: 8),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: design.secondaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      case BarLayoutStyle.magazine:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            color: design.gradient == null ? design.solidColor : null,
            border: Border(
              top: BorderSide(color: design.topBorderColor, width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: design.primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: design.primaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 24,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: design.dividerColor,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: design.secondaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: design.secondaryColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case BarLayoutStyle.classic:
      default:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            color: design.gradient == null ? design.solidColor : null,
            border: design.showTopBorder
                ? Border(
                    top: BorderSide(color: design.topBorderColor, width: 1),
                  )
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: ibg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(Icons.business, color: tc, size: 9),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: tc,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 22, color: design.dividerColor),
              Expanded(
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: ibg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(Icons.phone, color: tc, size: 9),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: tc,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 8);
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 6);
    path.quadraticBezierTo(size.width * 0.75, 12, size.width, 4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper old) => false;
}

// ════════════════════════════════════════════════════════
//  DATA MODELS
// ════════════════════════════════════════════════════════

class PosterTemplate {
  String id, name, categoryName, description, title, email, mobile;
  double width, height;
  String? backgroundImage;
  Color backgroundColor;
  List<TextElement> textElements;
  List<ImageElement> imageElements;
  DesignData designData;

  PosterTemplate({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.description,
    required this.title,
    required this.email,
    required this.mobile,
    required this.width,
    required this.height,
    this.backgroundImage,
    this.backgroundColor = Colors.white,
    this.textElements = const [],
    this.imageElements = const [],
    required this.designData,
  });

  factory PosterTemplate.fromApiResponse(Map<String, dynamic> r) {
    final p = r['poster'] as Map<String, dynamic>;
    final d = p['designData'] as Map<String, dynamic>;
    final ts = TextSettings.fromJson(d['textSettings'] ?? {});
    final tst = TextStyles.fromJson(d['textStyles'] ?? {});
    final tv = TextVisibility.fromJson(d['textVisibility'] ?? {});

    List<TextElement> textElements = [];
    if (tv.isVisible('title'))
      textElements.add(
        TextElement(
          id: 'title',
          text: p['title'] ?? '',
          x: ts.titleX,
          y: ts.titleY,
          width: 800,
          height: 200,
          fontSize: tst.title.fontSize ?? 36,
          color: tst.title.color ?? Colors.black,
          fontWeight: tst.title.fontWeight ?? FontWeight.bold,
          fontFamily: tst.title.fontFamily ?? 'Times New Roman',
          textAlign: TextAlign.center,
        ),
      );
    if (tv.isVisible('description'))
      textElements.add(
        TextElement(
          id: 'description',
          text: p['description'] ?? '',
          x: ts.descriptionX,
          y: ts.descriptionY,
          width: 900,
          height: 400,
          fontSize: tst.description.fontSize ?? 20,
          color: tst.description.color ?? Colors.black,
          fontWeight: tst.description.fontWeight ?? FontWeight.bold,
          fontFamily: tst.description.fontFamily ?? 'Times New Roman',
        ),
      );
    if (tv.isVisible('name'))
      textElements.add(
        TextElement(
          id: 'name',
          text: 'Business Name',
          x: ts.nameX,
          y: ts.nameY,
          width: 400,
          height: 100,
          fontSize: 2,
          color: tst.name.color ?? Colors.black,
          fontWeight: tst.name.fontWeight ?? FontWeight.bold,
          fontFamily: tst.name.fontFamily ?? 'Arial',
        ),
      );

    List<ImageElement> imageElements = [];
    if (d['overlayImages'] != null) {
      final oi = d['overlayImages'] as List;
      final ov = (d['overlaySettings']?['overlays'] as List?) ?? [];
      for (int i = 0; i < oi.length; i++) {
        final img = oi[i];
        final o = i < ov.length ? ov[i] : null;
        imageElements.add(
          ImageElement(
            id: img['_id'] ?? 'ov_$i',
            imageUrl: img['url'] ?? '',
            x: _pd(o?['x'], 324),
            y: _pd(o?['y'], 521),
            width: _pd(o?['width'], 252),
            height: _pd(o?['height'], 252),
          ),
        );
      }
    }

    return PosterTemplate(
      id: p['_id'] ?? 'tpl_${DateTime.now().millisecondsSinceEpoch}',
      name: p['name'] ?? 'Untitled',
      categoryName: p['categoryName'] ?? '',
      description: p['description'] ?? '',
      title: p['title'] ?? '',
      email: p['email'] ?? '',
      mobile: p['mobile'] ?? '',
      width: 900,
      height: 1200,
      backgroundImage: d['bgImage']?['url'],
      textElements: textElements,
      imageElements: imageElements,
      designData: DesignData.fromJson(d),
    );
  }

  static double _pd(dynamic v, double d) {
    if (v == null) return d;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? d;
    return d;
  }
}

class DesignData {
  DesignData();
  factory DesignData.fromJson(Map<String, dynamic> j) => DesignData();
}

class TextSettings {
  double nameX,
      nameY,
      emailX,
      emailY,
      mobileX,
      mobileY,
      titleX,
      titleY,
      descriptionX,
      descriptionY,
      tagsX,
      tagsY;
  TextSettings({
    this.nameX = 0,
    this.nameY = 0,
    this.emailX = 0,
    this.emailY = 0,
    this.mobileX = 0,
    this.mobileY = 0,
    this.titleX = 0,
    this.titleY = 0,
    this.descriptionX = 0,
    this.descriptionY = 0,
    this.tagsX = 0,
    this.tagsY = 0,
  });
  factory TextSettings.fromJson(Map<String, dynamic> j) => TextSettings(
    nameX: _p(j['nameX'], 0),
    nameY: _p(j['nameY'], 0),
    emailX: _p(j['emailX'], 0),
    emailY: _p(j['emailY'], 0),
    mobileX: _p(j['mobileX'], 0),
    mobileY: _p(j['mobileY'], 0),
    titleX: _p(j['titleX'], 0),
    titleY: _p(j['titleY'], 0),
    descriptionX: _p(j['descriptionX'], 0),
    descriptionY: _p(j['descriptionY'], 0),
    tagsX: _p(j['tagsX'], 0),
    tagsY: _p(j['tagsY'], 0),
  );
  static double _p(dynamic v, double d) {
    if (v == null) return d;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? d;
    return d;
  }
}

class TextStyles {
  TextStyle name, email, mobile, title, description, tags;
  TextStyles({
    required this.name,
    required this.email,
    required this.mobile,
    required this.title,
    required this.description,
    required this.tags,
  });
  factory TextStyles.fromJson(Map<String, dynamic> j) => TextStyles(
    name: _ts(j['name'] ?? {}),
    email: _ts(j['email'] ?? {}),
    mobile: _ts(j['mobile'] ?? {}),
    title: _ts(j['title'] ?? {}),
    description: _ts(j['description'] ?? {}),
    tags: _ts(j['tags'] ?? {}),
  );
  static TextStyle _ts(Map<String, dynamic> j) => TextStyle(
    fontSize: _p(j['fontSize'], 16),
    color: _c(j['color']),
    fontFamily: j['fontFamily'] ?? 'Arial',
    fontWeight: _fw(j['fontWeight'] ?? 'normal'),
    fontStyle: j['fontStyle'] == 'italic' ? FontStyle.italic : FontStyle.normal,
  );
  static Color _c(dynamic v) {
    if (v == null) return Colors.black;
    if (v is int) return Color(v);
    if (v is String) {
      String h = v.replaceAll('#', '');
      if (h.length == 6) h = 'FF$h';
      final i = int.tryParse(h, radix: 16);
      if (i != null) return Color(i);
    }
    return Colors.black;
  }

  static double _p(dynamic v, double d) {
    if (v == null) return d;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? d;
    return d;
  }

  static FontWeight _fw(String w) {
    switch (w.toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'w600':
        return FontWeight.w600;
      case 'w300':
        return FontWeight.w300;
      default:
        return FontWeight.normal;
    }
  }
}

class TextVisibility {
  String name, email, mobile, title, description, tags;
  TextVisibility({
    this.name = 'visible',
    this.email = 'visible',
    this.mobile = 'visible',
    this.title = 'visible',
    this.description = 'visible',
    this.tags = 'visible',
  });
  factory TextVisibility.fromJson(Map<String, dynamic> j) => TextVisibility(
    name: j['name'] ?? 'visible',
    email: j['email'] ?? 'visible',
    mobile: j['mobile'] ?? 'visible',
    title: j['title'] ?? 'visible',
    description: j['description'] ?? 'visible',
    tags: j['tags'] ?? 'visible',
  );
  bool isVisible(String f) {
    switch (f) {
      case 'name':
        return name == 'visible';
      case 'email':
        return email == 'visible';
      case 'mobile':
        return mobile == 'visible';
      case 'title':
        return title == 'visible';
      case 'description':
        return description == 'visible';
      default:
        return true;
    }
  }
}

class TextElement {
  String id, text, fontFamily;
  double x, y, width, height, fontSize, rotation;
  Color color;
  FontWeight fontWeight;
  TextAlign textAlign;
  bool isSelected;
  TextElement({
    required this.id,
    required this.text,
    required this.x,
    required this.y,
    this.width = 200,
    this.height = 50,
    this.fontSize = 16,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontFamily = 'Roboto',
    this.textAlign = TextAlign.left,
    this.isSelected = false,
    this.rotation = 0,
  });
}

class ImageElement {
  String id, imageUrl;
  double x, y, width, height, rotation, borderRadius;
  bool isSelected;
  ImageElement({
    required this.id,
    required this.imageUrl,
    required this.x,
    required this.y,
    this.width = 100,
    this.height = 100,
    this.isSelected = false,
    this.rotation = 0,
    this.borderRadius = 4,
  });
}

class ProfileElement {
  String id, imageUrl;
  double x, y, width, height, rotation;
  bool isSelected;
  ProfileElement({
    required this.id,
    required this.imageUrl,
    required this.x,
    required this.y,
    this.width = 200,
    this.height = 200,
    this.isSelected = false,
    this.rotation = 0,
  });
}

// ════════════════════════════════════════════════════════
//  POSTER PREVIEW SCREEN
// ════════════════════════════════════════════════════════

class PosterPreviewScreen extends StatefulWidget {
  final Widget posterWidget;
  final String posterName;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const PosterPreviewScreen({
    super.key,
    required this.posterWidget,
    required this.posterName,
    required this.onSave,
    required this.onShare,
  });

  @override
  State<PosterPreviewScreen> createState() => _PosterPreviewScreenState();
}

class _PosterPreviewScreenState extends State<PosterPreviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  double _scale = 1.0;
  double _prevScale = 1.0;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [Color(0x226A1B9A), Color(0xFF0D0D0D)],
                ),
              ),
            ),
          ),
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Material(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Preview',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              widget.posterName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.pinch, color: Colors.white54, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Pinch to zoom',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onScaleStart: (_) => _prevScale = _scale,
                  onScaleUpdate: (d) => setState(
                    () => _scale = (_prevScale * d.scale).clamp(0.5, 4.0),
                  ),
                  child: Center(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Transform.scale(
                          scale: _scale,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF6A1B9A,
                                  ).withOpacity(0.35),
                                  blurRadius: 40,
                                  spreadRadius: 4,
                                  offset: const Offset(0, 10),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.6),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: widget.posterWidget,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _PreviewActionButton(
                          icon: Icons.save_alt_rounded,
                          label: 'Save',
                          color: const Color(0xFF6A1B9A),
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onSave();
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _PreviewActionButton(
                          icon: Icons.share_rounded,
                          label: 'Share',
                          color: const Color(0xFF1565C0),
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onShare();
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _PreviewActionButton(
                          icon: Icons.edit_rounded,
                          label: 'Edit',
                          color: const Color(0xFF2E7D32),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PreviewActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  MAIN SCREEN
// ════════════════════════════════════════════════════════

class SamplePosterScreen extends StatefulWidget {
  final String posterId;
  const SamplePosterScreen({super.key, required this.posterId});

  @override
  State<SamplePosterScreen> createState() => _ApiPosterEditorState();
}

class _ApiPosterEditorState extends State<SamplePosterScreen> {
  final TextEditingController _fontSizeCtrl = TextEditingController();

  // ── KEY CHANGE: One RepaintBoundary key that wraps everything
  //    including animation + effects ──
  final GlobalKey _canvasKey = GlobalKey();

  PosterTemplate? _template;
  bool _isLoading = true;
  String? _errorMessage;

  TextElement? _selectedText;
  ImageElement? _selectedImage;
  ProfileElement? _selectedProfile;
  bool _showToolbar = false;

  double _currentScale = 1.0, _previousScale = 1.0, _baseScale = 1.0;
  Offset _currentOffset = Offset.zero,
      _startOffset = Offset.zero,
      _focusPoint = Offset.zero;
  Offset? _initialFocalPoint;

  String? phoneNumber, email, userId, profileImageUrl;
  Uint8List? _logoImage, _profileImageBytes;
  ProfileElement? _profileImageElement;
  ImageElement? _logoImageElement;
  double _businessNameFontSize = 20.0, _phoneNumberFontSize = 20.0;
  BottomBarDesign _selectedBarDesign = kBottomBarDesigns[0];

  BottomTab _activeTab = BottomTab.none;
  PosterEffectType _currentEffect = PosterEffectType.none;
  PosterFrame? _selectedFrame;
  PosterAnimation _currentAnimation = PosterAnimation.none;

  final ImagePicker _picker = ImagePicker();

  final List<String> _fontFamilies = [
    'Roboto',
    'Arial',
    'Times New Roman',
    'Helvetica',
    'Verdana',
    'Georgia',
    'Montserrat',
    'Poppins',
    'Lato',
    'Open Sans',
    'Raleway',
    'Nunito',
    'Oswald',
    'Playfair Display',
    'Dancing Script',
    'Pacifico',
    'Lobster',
    'Bebas Neue',
    'Caveat',
    'Permanent Marker',
    'Quicksand',
    'Inter',
    'Manrope',
  ];
  final List<FontWeight> _fontWeights = [
    FontWeight.w100,
    FontWeight.w200,
    FontWeight.w300,
    FontWeight.w400,
    FontWeight.w500,
    FontWeight.w600,
    FontWeight.w700,
    FontWeight.w800,
    FontWeight.w900,
  ];

  @override
  void initState() {
    super.initState();
    _loadPosterFromApi();
    _loadUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Provider.of<LanguageProvider>(
          context,
          listen: false,
        ).addListener(_onLangChanged);
      } catch (_) {}
    });
  }

  void _onLangChanged() {
    try {
      if (userId != null)
        Provider.of<CreateCustomerProvider>(
          context,
          listen: false,
        ).fetchUser(userId!);
    } catch (_) {}
  }

  @override
  void dispose() {
    try {
      Provider.of<LanguageProvider>(
        context,
        listen: false,
      ).removeListener(_onLangChanged);
    } catch (_) {}
    super.dispose();
  }

  // ── LOADING ──

  Future<void> _loadUserData() async {
    final data = await AuthPreferences.getUserData();
    if (data != null) {
      setState(() {
        phoneNumber = data.user.mobile ?? phoneNumber;
        profileImageUrl = data.user.profileImage;
        email = data.user.email ?? email;
        userId = data.user.id ?? userId;
      });
      if (profileImageUrl != null && profileImageUrl!.isNotEmpty)
        _loadProfileImage();
      if (_template != null) _updateTextWithUserData();
    }
  }

  Future<void> _loadPosterFromApi() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final res = await http.get(
        Uri.parse(
          'http://31.97.228.17:4061/api/poster/singlecanvasposters/${widget.posterId}',
        ),
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        final tpl = PosterTemplate.fromApiResponse(json.decode(res.body));
        setState(() {
          _template = tpl;
          _isLoading = false;
        });
        _updateTextWithUserData();
        await _loadSavedBusinessName();
      } else {
        throw Exception('Status: ${res.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSavedBusinessName() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('business_name');
    if (saved != null && saved.isNotEmpty && _template != null) {
      setState(() {
        _template!.textElements
                .firstWhere(
                  (e) => e.id == 'name',
                  orElse: () => TextElement(id: 'name', text: '', x: 0, y: 0),
                )
                .text =
            saved;
      });
    }
  }

  Future<void> _saveBusinessName(String n) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('business_name', n);
  }

  Future<void> _loadProfileImage() async {
    try {
      final res = await http.get(Uri.parse(profileImageUrl!));
      if (res.statusCode == 200)
        setState(() {
          _profileImageBytes = res.bodyBytes;
          _profileImageElement = ProfileElement(
            id: 'profile_image',
            imageUrl: '',
            x: 10,
            y: 10,
            width: 200,
            height: 200,
          );
        });
    } catch (_) {}
  }

  void _updateTextWithUserData() {
    if (_template == null) return;
    setState(() {
      for (var el in _template!.textElements) {
        if (el.id == 'email' && email != null && email!.isNotEmpty)
          el.text = email!;
        if (el.id == 'mobile' && phoneNumber != null && phoneNumber!.isNotEmpty)
          el.text = phoneNumber!;
      }
    });
  }

  // ── TAB ──

  void _setTab(BottomTab tab) => setState(() {
    _activeTab = _activeTab == tab ? BottomTab.none : tab;
    if (_activeTab != BottomTab.none) {
      _deselectAll();
      _showToolbar = false;
    }
  });

  // ── SELECTION ──

  void _selectText(TextElement el) => setState(() {
    _deselectAllSilent();
    el.isSelected = true;
    _selectedText = el;
    _selectedImage = null;
    _selectedProfile = null;
    _showToolbar = true;
    _activeTab = BottomTab.none;
  });
  void _selectImage(ImageElement el) => setState(() {
    _deselectAllSilent();
    el.isSelected = true;
    _selectedImage = el;
    _selectedText = null;
    _selectedProfile = null;
    _showToolbar = true;
    _activeTab = BottomTab.none;
  });
  void _selectProfile(ProfileElement el) => setState(() {
    _deselectAllSilent();
    el.isSelected = true;
    _selectedProfile = el;
    _selectedText = null;
    _selectedImage = null;
    _showToolbar = true;
    _activeTab = BottomTab.none;
  });

  void _deselectAllSilent() {
    _template?.textElements.forEach((e) => e.isSelected = false);
    _template?.imageElements.forEach((e) => e.isSelected = false);
    _profileImageElement?.isSelected = false;
    _logoImageElement?.isSelected = false;
  }

  void _deselectAll() => setState(() {
    _deselectAllSilent();
    _selectedText = null;
    _selectedImage = null;
    _selectedProfile = null;
    _showToolbar = false;
  });

  // ── MOVE / RESIZE ──

  void _moveText(TextElement el, Offset d) => setState(() {
    el.x = (el.x + d.dx).clamp(-_template!.width * 0.5, _template!.width * 1.5);
    el.y = (el.y + d.dy).clamp(
      -_template!.height * 0.5,
      _template!.height * 1.5,
    );
  });
  void _moveImage(ImageElement el, Offset d) => setState(() {
    el.x = (el.x + d.dx).clamp(0, _template!.width - el.width);
    el.y = (el.y + d.dy).clamp(0, _template!.height - el.height);
  });
  void _moveProfile(ProfileElement el, Offset d) => setState(() {
    el.x = (el.x + d.dx).clamp(0, _template!.width - el.width);
    el.y = (el.y + d.dy).clamp(0, _template!.height - el.height);
  });
  void _resizeImage(ImageElement el, double s) => setState(() {
    final ns = (_baseScale * s).clamp(50.0, _template!.width * 0.8);
    el.width = ns;
    el.height = ns;
  });
  void _resizeProfile(ProfileElement el, double s) => setState(() {
    final ns = (_baseScale * s).clamp(50.0, _template!.width * 0.8);
    el.width = ns;
    el.height = ns;
  });

  // ── DELETE ──

  void _deleteSelected() {
    if (_selectedText != null) {
      setState(() {
        _template!.textElements.remove(_selectedText);
        _selectedText = null;
        _showToolbar = false;
      });
    } else if (_selectedImage != null) {
      setState(() {
        if (_selectedImage!.id == 'logo_image') {
          _logoImageElement = null;
          _logoImage = null;
        } else {
          _template!.imageElements.remove(_selectedImage);
        }
        _selectedImage = null;
        _showToolbar = false;
      });
    } else if (_selectedProfile != null) {
      setState(() {
        _profileImageElement = null;
        _profileImageBytes = null;
        _selectedProfile = null;
        _showToolbar = false;
      });
    }
  }

  // ── ADD ──

  void _addText() {
    if (_template == null) return;
    final el = TextElement(
      id: 'txt_${DateTime.now().millisecondsSinceEpoch}',
      text: 'New Text',
      x: 350,
      y: 350,
      fontSize: 50,
      color: Colors.black,
    );
    setState(() {
      _template!.textElements.add(el);
      _selectText(el);
    });
  }

  Future<void> _pickLogo() async {
    final f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) {
      final bytes = await f.readAsBytes();
      setState(() {
        _logoImage = bytes;
        _logoImageElement = ImageElement(
          id: 'logo_image',
          imageUrl: '',
          x: _template != null ? _template!.width - 120 : 20,
          y: 20,
          width: 100,
          height: 100,
        );
      });
    }
  }

  Future<void> _pickAdditionalImage() async {
    final f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) {
      final bytes = await f.readAsBytes();
      final tmp = await getTemporaryDirectory();
      final file = File(
        '${tmp.path}/add_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes);
      setState(() {
        _template?.imageElements.add(
          ImageElement(
            id: 'add_${DateTime.now().millisecondsSinceEpoch}',
            imageUrl: file.path,
            x: _template!.width / 2 - 100,
            y: _template!.height / 2 - 100,
            width: 200,
            height: 200,
          ),
        );
      });
    }
  }

  // ══════════════════════════════════════════════════════
  //  CAPTURE HELPER
  //  ▸ Waits for the next frame so animations/effects are
  //    actively painting when toImage() is called.
  //  ▸ The RepaintBoundary (_canvasKey) now wraps INSIDE
  //    the AnimatedPosterWrapper so the transform is baked in.
  // ══════════════════════════════════════════════════════
  Future<Uint8List> _capturePosterBytes() async {
    // Wait a couple frames so animation/effect is mid-cycle
    await Future.delayed(const Duration(milliseconds: 80));
    await WidgetsBinding.instance.endOfFrame;

    final boundary =
        _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final img = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // ── SAVE / SHARE ──

  Future<void> _savePoster() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 13),
              Text('Saving...'),
            ],
          ),
        ),
      );
      final bytes = await _capturePosterBytes();
      await Gal.putImageBytes(
        bytes,
        album: 'Posters',
        name: 'poster_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _sharePoster() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 12),
              Text('Preparing...'),
            ],
          ),
        ),
      );
      final bytes = await _capturePosterBytes();
      final tmp = await getTemporaryDirectory();
      final file = File(
        '${tmp.path}/share_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes);
      Navigator.of(context).pop();
      await Share.shareXFiles([XFile(file.path)], text: 'Check out my poster!');
    } catch (e) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // ── PREVIEW ──

  void _openPreview() {
    if (_template == null) return;
    _deselectAll();
    // Pass the LIVE poster canvas (with animation/effects active)
    // into the preview screen via a fitted box wrapper
    final posterWidget = FittedBox(
      fit: BoxFit.contain,
      child: _buildPosterCanvas(interactive: false),
    );
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: PosterPreviewScreen(
            posterWidget: posterWidget,
            posterName: _template!.name,
            onSave: _savePoster,
            onShare: _sharePoster,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 380),
        reverseTransitionDuration: const Duration(milliseconds: 280),
      ),
    );
  }

  // ── DIALOGS ──

  void _showEditDialog({
    required String title,
    required String currentValue,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onSave,
  }) {
    final ctrl = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: Colors.deepPurple),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          autofocus: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            prefixIcon: Icon(icon),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(ctrl.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showColorPicker() {
    if (_selectedText == null) return;
    Color temp = _selectedText!.color;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: const Text('Pick Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: temp,
              onColorChanged: (c) => set(() => temp = c),
              pickerAreaHeightPercent: 0.4,
              enableAlpha: false,
              hexInputBar: false,
              labelTypes: const [],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() => _selectedText!.color = temp);
                Navigator.pop(ctx);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomerDialog() async {
    try {
      final cp = Provider.of<CreateCustomerProvider>(context, listen: false);
      if (cp.customers.isEmpty && userId != null) await cp.fetchUser(userId!);
      if (cp.customers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No customers found.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      Set<String> sel = {};
      showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (ctx, set) => AlertDialog(
            title: const Text('Share with Customers'),
            content: SizedBox(
              width: double.maxFinite,
              height: 350,
              child: ListView.builder(
                itemCount: cp.customers.length,
                itemBuilder: (_, i) {
                  final c = cp.customers[i];
                  final id = c['_id'] as String;
                  return CheckboxListTile(
                    title: Text(c['name'] ?? ''),
                    subtitle: Text(c['mobile'] ?? ''),
                    value: sel.contains(id),
                    onChanged: (v) =>
                        set(() => v! ? sel.add(id) : sel.remove(id)),
                    activeColor: Colors.deepPurple,
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: sel.isEmpty
                    ? null
                    : () async {
                        Navigator.pop(ctx);
                        await _sharePosterWithCustomers(sel, cp.customers);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: Text('Share (${sel.length})'),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _sharePosterWithCustomers(
    Set<String> ids,
    List<Map<String, dynamic>> customers,
  ) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Preparing...'),
            ],
          ),
        ),
      );
      final bytes = await _capturePosterBytes();
      final tmp = await getTemporaryDirectory();
      final file = File(
        '${tmp.path}/share_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes);
      Navigator.of(context).pop();
      final selected = customers.where((c) => ids.contains(c['_id'])).toList();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatModule(
            posterImagePath: file.path,
            selectedCustomers: selected,
          ),
        ),
      );
    } catch (e) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // ── BUILD ELEMENTS ──

  Widget _buildTextEl(TextElement el) => Positioned(
    left: el.x,
    top: el.y,
    child: GestureDetector(
      onTap: () => _selectText(el),
      onPanUpdate: (d) => _moveText(el, d.delta),
      child: Transform.rotate(
        angle: el.rotation * pi / 180,
        child: Container(
          constraints: BoxConstraints(
            minWidth: 50,
            maxWidth: _template!.width * 3,
            minHeight: 20,
            maxHeight: _template!.height * 3,
          ),
          decoration: el.isSelected
              ? BoxDecoration(
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.6),
                    width: 1,
                  ),
                )
              : null,
          child: Text(
            el.text,
            style: TextStyle(
              fontSize: el.fontSize,
              color: el.color,
              fontWeight: el.fontWeight,
              fontFamily: el.fontFamily,
              height: 1.2,
            ),
            textAlign: el.textAlign,
            maxLines: null,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
        ),
      ),
    ),
  );

  Widget _buildImageEl(ImageElement el) => Positioned(
    left: el.x,
    top: el.y,
    width: el.width,
    height: el.height,
    child: GestureDetector(
      onTap: () => _selectImage(el),
      onScaleStart: (d) {
        _baseScale = el.width;
        _initialFocalPoint = d.focalPoint;
      },
      onScaleUpdate: (d) {
        if (d.scale != 1.0) _resizeImage(el, d.scale);
        if (_initialFocalPoint != null) {
          _moveImage(el, d.focalPoint - _initialFocalPoint!);
          _initialFocalPoint = d.focalPoint;
        }
      },
      onScaleEnd: (_) => _initialFocalPoint = null,
      child: Transform.rotate(
        angle: el.rotation * pi / 180,
        child: Container(
          decoration: el.isSelected
              ? BoxDecoration(
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.6),
                    width: 1,
                  ),
                )
              : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(el.borderRadius),
            child: el.imageUrl.startsWith('http')
                ? Image.network(
                    el.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey.shade300),
                  )
                : (el.imageUrl.isNotEmpty
                      ? Image.file(File(el.imageUrl), fit: BoxFit.fill)
                      : Container(color: Colors.grey.shade300)),
          ),
        ),
      ),
    ),
  );

  Widget _buildProfileEl() {
    if (_profileImageBytes == null || _profileImageElement == null)
      return const SizedBox.shrink();
    final el = _profileImageElement!;
    return Positioned(
      left: el.x,
      top: el.y,
      width: el.width,
      height: el.height,
      child: GestureDetector(
        onTap: () => _selectProfile(el),
        onScaleStart: (d) {
          _baseScale = el.width;
          _initialFocalPoint = d.focalPoint;
        },
        onScaleUpdate: (d) {
          if (d.scale != 1.0) _resizeProfile(el, d.scale);
          if (_initialFocalPoint != null) {
            _moveProfile(el, d.focalPoint - _initialFocalPoint!);
            _initialFocalPoint = d.focalPoint;
          }
        },
        onScaleEnd: (_) => _initialFocalPoint = null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.memory(_profileImageBytes!, fit: BoxFit.fill),
        ),
      ),
    );
  }

  Widget _buildLogoEl() {
    if (_logoImage == null || _logoImageElement == null)
      return const SizedBox.shrink();
    final el = _logoImageElement!;
    return Positioned(
      left: el.x,
      top: el.y,
      width: el.width,
      height: el.height,
      child: GestureDetector(
        onTap: () => _selectImage(el),
        onScaleStart: (d) {
          _baseScale = el.width;
          _initialFocalPoint = d.focalPoint;
        },
        onScaleUpdate: (d) {
          if (d.scale != 1.0) _resizeImage(el, d.scale);
          if (_initialFocalPoint != null) {
            _moveImage(el, d.focalPoint - _initialFocalPoint!);
            _initialFocalPoint = d.focalPoint;
          }
        },
        onScaleEnd: (_) => _initialFocalPoint = null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.memory(_logoImage!, fit: BoxFit.cover),
        ),
      ),
    );
  }

  // ── ELEMENT TOOLBAR ──

  String _fwLabel(FontWeight w) {
    switch (w) {
      case FontWeight.w100:
        return 'Thin';
      case FontWeight.w200:
        return 'XLight';
      case FontWeight.w300:
        return 'Light';
      case FontWeight.w400:
        return 'Regular';
      case FontWeight.w500:
        return 'Medium';
      case FontWeight.w600:
        return 'SemiBold';
      case FontWeight.w700:
        return 'Bold';
      case FontWeight.w800:
        return 'XBold';
      default:
        return 'Black';
    }
  }

  Widget _buildElementToolbar() {
    if (!_showToolbar || _activeTab != BottomTab.none)
      return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (_selectedText != null) ...[
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.deepPurple),
                onPressed: () => _showEditDialog(
                  title: 'Edit Text',
                  currentValue: _selectedText!.text,
                  icon: Icons.edit,
                  onSave: (v) => setState(() => _selectedText!.text = v),
                ),
              ),
              const VerticalDivider(width: 16),
              const Text('Size:', style: TextStyle(fontSize: 12)),
              SizedBox(
                width: 130,
                child: Slider(
                  value: _selectedText!.fontSize,
                  min: 8,
                  max: 300,
                  divisions: 60,
                  label: '${_selectedText!.fontSize.round()}',
                  onChanged: (v) => setState(() => _selectedText!.fontSize = v),
                ),
              ),
              Text(
                '${_selectedText!.fontSize.round()}px',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const VerticalDivider(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedText!.fontFamily,
                    items: _fontFamilies
                        .toSet()
                        .map(
                          (f) => DropdownMenuItem(
                            value: f,
                            child: Text(
                              f,
                              style: TextStyle(fontFamily: f, fontSize: 13),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null)
                        setState(() => _selectedText!.fontFamily = v);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<FontWeight>(
                    value: _selectedText!.fontWeight,
                    items: _fontWeights
                        .map(
                          (w) => DropdownMenuItem(
                            value: w,
                            child: Text(
                              _fwLabel(w),
                              style: TextStyle(fontWeight: w, fontSize: 13),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null)
                        setState(() => _selectedText!.fontWeight = v);
                    },
                  ),
                ),
              ),
              const VerticalDivider(width: 16),
              IconButton(
                icon: Icon(
                  Icons.format_align_left,
                  color: _selectedText!.textAlign == TextAlign.left
                      ? Colors.deepPurple
                      : Colors.grey,
                ),
                onPressed: () =>
                    setState(() => _selectedText!.textAlign = TextAlign.left),
              ),
              IconButton(
                icon: Icon(
                  Icons.format_align_center,
                  color: _selectedText!.textAlign == TextAlign.center
                      ? Colors.deepPurple
                      : Colors.grey,
                ),
                onPressed: () =>
                    setState(() => _selectedText!.textAlign = TextAlign.center),
              ),
              IconButton(
                icon: Icon(
                  Icons.format_align_right,
                  color: _selectedText!.textAlign == TextAlign.right
                      ? Colors.deepPurple
                      : Colors.grey,
                ),
                onPressed: () =>
                    setState(() => _selectedText!.textAlign = TextAlign.right),
              ),
              const VerticalDivider(width: 16),
              IconButton(
                icon: Icon(Icons.color_lens, color: _selectedText!.color),
                onPressed: _showColorPicker,
              ),
              const VerticalDivider(width: 16),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _deleteSelected,
              ),
            ] else if (_selectedImage != null) ...[
              const Text('Size:', style: TextStyle(fontSize: 12)),
              SizedBox(
                width: 120,
                child: Slider(
                  value: _selectedImage!.width,
                  min: 20,
                  max: 800,
                  divisions: 50,
                  label: '${_selectedImage!.width.round()}',
                  onChanged: (v) => setState(() {
                    final ar = _selectedImage!.width / _selectedImage!.height;
                    _selectedImage!.width = v;
                    _selectedImage!.height = v / ar;
                  }),
                ),
              ),
              const VerticalDivider(width: 16),
              const Text('Corner:', style: TextStyle(fontSize: 12)),
              SizedBox(
                width: 100,
                child: Slider(
                  value: _selectedImage!.borderRadius,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: '${_selectedImage!.borderRadius.round()}',
                  onChanged: (v) =>
                      setState(() => _selectedImage!.borderRadius = v),
                ),
              ),
              const VerticalDivider(width: 16),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _deleteSelected,
              ),
            ] else if (_selectedProfile != null) ...[
              const Text('Size:', style: TextStyle(fontSize: 12)),
              SizedBox(
                width: 120,
                child: Slider(
                  value: _selectedProfile!.width,
                  min: 50,
                  max: 600,
                  divisions: 50,
                  label: '${_selectedProfile!.width.round()}',
                  onChanged: (v) => setState(() {
                    _selectedProfile!.width = v;
                    _selectedProfile!.height = v;
                  }),
                ),
              ),
              const VerticalDivider(width: 16),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _deleteSelected,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── BOTTOM PANEL ──

  Widget _buildActivePanel() {
    switch (_activeTab) {
      case BottomTab.text:
        return TextToolsPanel(
          onAddText: _addText,
          onAddLogo: _pickLogo,
          onAddImage: _pickAdditionalImage,
        );
      case BottomTab.frames:
        return FramesPanel(
          selectedFrame: _selectedFrame,
          onFrameSelected: (f) => setState(() => _selectedFrame = f),
        );
      case BottomTab.effects:
        return EffectsPanel(
          currentEffect: _currentEffect,
          onEffectSelected: (e) => setState(() => _currentEffect = e),
        );
      case BottomTab.animation:
        return AnimationPanel(
          currentAnimation: _currentAnimation,
          onAnimationSelected: (a) => setState(() => _currentAnimation = a),
        );
      case BottomTab.design:
        return DesignPanel(
          currentDesign: _selectedBarDesign,
          onDesignSelected: (d) => setState(() => _selectedBarDesign = d),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // ── BOTTOM NAV ──

  Widget _buildBottomNav() {
    final items = [
      (BottomTab.text, Icons.text_fields, 'Text'),
      (BottomTab.frames, Icons.crop_square, 'Frames'),
      (BottomTab.effects, Icons.auto_awesome, 'Effects'),
      (BottomTab.animation, Icons.animation, 'Animation'),
      (BottomTab.design, Icons.style, 'Design'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: items.map((item) {
            final (tab, icon, label) = item;
            final isActive = _activeTab == tab;
            return Expanded(
              child: GestureDetector(
                onTap: () => _setTab(tab),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isActive
                            ? const Color(0xFFFFE500)
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        color: isActive
                            ? const Color(0xFFFFE500)
                            : Colors.white54,
                        size: 22,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        label,
                        style: TextStyle(
                          color: isActive
                              ? const Color(0xFFFFE500)
                              : Colors.white54,
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  //  POSTER CANVAS BUILDER
  //
  //  KEY ARCHITECTURE CHANGE:
  //  The RepaintBoundary is placed INSIDE AnimatedPosterWrapper
  //  so when we call toImage() it captures the poster content
  //  AT THE CURRENT ANIMATION FRAME POSITION including:
  //    • Particle effects (snow, sparkle, stars, confetti)
  //    • Frame border overlay
  //    • Info bar design
  //    • All text/image/logo elements
  //
  //  The outer transform (zoom/pan) is NOT included — we only
  //  want the raw poster at full resolution.
  // ══════════════════════════════════════════════════════
  Widget _buildPosterCanvas({bool interactive = true}) {
    if (_template == null) return const SizedBox.shrink();

    // Core poster content (no animation wrapper here — animation
    // goes OUTSIDE the RepaintBoundary in editor view but the
    // capture key is on the inner content for full-res export)
    final posterContent = Container(
      width: _template!.width,
      height: _template!.height,
      decoration: BoxDecoration(
        color: _template!.backgroundColor,
        boxShadow: interactive
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
              ]
            : [],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Background
          if (_template!.backgroundImage != null)
            Positioned.fill(
              child: Image.network(
                _template!.backgroundImage!,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) =>
                    Container(color: _template!.backgroundColor),
              ),
            ),

          // Text elements
          ..._template!.textElements.map(_buildTextEl),
          // Image elements
          ..._template!.imageElements.map(_buildImageEl),
          // Profile image
          _buildProfileEl(),
          // Logo
          _buildLogoEl(),

          // ── EFFECTS overlay (particles rendered live) ──
          if (_currentEffect != PosterEffectType.none)
            Positioned.fill(
              child: PosterEffectOverlay(
                effectType: _currentEffect,
                width: _template!.width,
                height: _template!.height,
              ),
            ),

          // ── FRAME border overlay ──
          if (_selectedFrame != null && !_selectedFrame!.isDefault)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: FrameBorderPainter(_selectedFrame!),
                ),
              ),
            ),

          // ── Business info bar ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: interactive
                ? GestureDetector(
                    onTap: () {
                      final nameEl = _template?.textElements.firstWhere(
                        (e) => e.id == 'name',
                        orElse: () => TextElement(
                          id: 'name',
                          text: 'Business Name',
                          x: 0,
                          y: 0,
                        ),
                      );
                      final mobileEl = _template?.textElements.firstWhere(
                        (e) => e.id == 'mobile',
                        orElse: () =>
                            TextElement(id: 'mobile', text: '', x: 0, y: 0),
                      );
                      _showBottomInfoSheet(nameEl, mobileEl);
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: anim,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                          child: child,
                        ),
                      ),
                      child: KeyedSubtree(
                        key: ValueKey(_selectedBarDesign.id),
                        child: _buildInfoBar(),
                      ),
                    ),
                  )
                : _buildInfoBar(),
          ),
        ],
      ),
    );

    if (!interactive) {
      // Preview mode: wrap with animation so preview shows live animation
      return AnimatedPosterWrapper(
        animation: _currentAnimation,
        child: posterContent,
      );
    }

    // Editor mode: RepaintBoundary wraps the posterContent directly
    // (not the AnimatedPosterWrapper) so captures are full-res.
    // The animation wrapper is applied OUTSIDE for visual effect only.
    return posterContent;
  }

  // ── MAIN BUILD ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          _template?.name ?? 'Poster Editor',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (_template != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: TextButton.icon(
                onPressed: _openPreview,
                icon: const Icon(
                  Icons.visibility_rounded,
                  color: Color(0xFFFFE500),
                  size: 18,
                ),
                label: const Text(
                  'Preview',
                  style: TextStyle(
                    color: Color(0xFFFFE500),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white10,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          if (_selectedText != null ||
              _selectedImage != null ||
              _selectedProfile != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: _deleteSelected,
            ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'save',
                child: Row(
                  children: [
                    Icon(Icons.save_alt),
                    SizedBox(width: 8),
                    Text('Save to Gallery'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'customers',
                child: Row(
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 8),
                    Text('Share to Customers'),
                  ],
                ),
              ),
            ],
            onSelected: (v) {
              if (v == 'save') _savePoster();
              if (v == 'share') _sharePoster();
              if (v == 'customers') _showCustomerDialog();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading poster...'),
                ],
              ),
            )
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadPosterFromApi,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : _template == null
          ? const Center(child: Text('No poster data'))
          : Column(
              children: [
                _buildElementToolbar(),
                Expanded(
                  child: GestureDetector(
                    onScaleStart: (d) {
                      _focusPoint = d.focalPoint;
                      _previousScale = _currentScale;
                      _startOffset = _currentOffset;
                    },
                    onScaleUpdate: (d) => setState(() {
                      if (d.scale != 1.0)
                        _currentScale = (_previousScale * d.scale).clamp(
                          0.5,
                          3.0,
                        );
                      _currentOffset =
                          _startOffset + (d.focalPoint - _focusPoint);
                    }),
                    onScaleEnd: (_) {
                      _previousScale = _currentScale;
                      _startOffset = _currentOffset;
                    },
                    onTap: () {
                      _deselectAll();
                      setState(() => _activeTab = BottomTab.none);
                    },
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(_currentOffset.dx, _currentOffset.dy)
                        ..scale(_currentScale),
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.95,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.72,
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            // ── ANIMATION wraps the RepaintBoundary ──
                            // This means the visual animation is shown in
                            // editor view. The RepaintBoundary inside
                            // captures the un-transformed content at full
                            // poster resolution (no FittedBox scaling).
                            child: AnimatedPosterWrapper(
                              animation: _currentAnimation,
                              child: RepaintBoundary(
                                key: _canvasKey,
                                child: _buildPosterCanvas(interactive: true),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(parent: anim, curve: Curves.easeOut),
                        ),
                    child: child,
                  ),
                  child: _activeTab != BottomTab.none
                      ? KeyedSubtree(
                          key: ValueKey(_activeTab),
                          child: _buildActivePanel(),
                        )
                      : const SizedBox.shrink(key: ValueKey('none')),
                ),
                _buildBottomNav(),
              ],
            ),
    );
  }

  // ── Build info bar ──
  Widget _buildInfoBar() {
    final d = _selectedBarDesign;
    final businessName =
        _template?.textElements
            .firstWhere(
              (e) => e.id == 'name',
              orElse: () =>
                  TextElement(id: 'name', text: 'Business Name', x: 0, y: 0),
            )
            .text ??
        'Business Name';
    final phone =
        phoneNumber ??
        _template?.textElements
            .firstWhere(
              (e) => e.id == 'mobile',
              orElse: () =>
                  TextElement(id: 'mobile', text: 'Not Set', x: 0, y: 0),
            )
            .text ??
        'Not Set';
    final tc = d.primaryColor;
    final sc = d.secondaryColor;
    final ibg = d.iconBgColor;

    BoxDecoration bgDecor = BoxDecoration(
      gradient: d.gradient,
      color: d.gradient == null ? d.solidColor : null,
      borderRadius: d.borderRadiusTop > 0
          ? BorderRadius.vertical(top: Radius.circular(d.borderRadiusTop))
          : null,
      border: d.showTopBorder
          ? Border(top: BorderSide(color: d.topBorderColor, width: 1.5))
          : null,
    );

    switch (d.layoutStyle) {
      case BarLayoutStyle.stacked:
        return Container(
          decoration: bgDecor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: ibg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.business, color: tc, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      businessName,
                      style: TextStyle(
                        fontSize: _businessNameFontSize,
                        fontWeight: FontWeight.bold,
                        color: tc,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: ibg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.phone, color: sc, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      phone,
                      style: TextStyle(
                        fontSize: _phoneNumberFontSize,
                        fontWeight: FontWeight.w600,
                        color: sc,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case BarLayoutStyle.badgeChip:
        return Container(
          decoration: bgDecor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: ibg,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: tc.withOpacity(0.6), width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.business, color: tc, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      businessName,
                      style: TextStyle(
                        fontSize: _businessNameFontSize.clamp(10, 16),
                        fontWeight: FontWeight.bold,
                        color: tc,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: ibg,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: tc.withOpacity(0.6), width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.phone, color: tc, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      phone,
                      style: TextStyle(
                        fontSize: _phoneNumberFontSize.clamp(10, 16),
                        fontWeight: FontWeight.bold,
                        color: tc,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case BarLayoutStyle.centered:
        return Container(
          decoration: bgDecor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                businessName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _businessNameFontSize,
                  fontWeight: FontWeight.bold,
                  color: tc,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                phone,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _phoneNumberFontSize,
                  fontWeight: FontWeight.w500,
                  color: sc,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );

      case BarLayoutStyle.cardSplit:
        return Container(
          color: d.solidColor ?? Colors.black.withOpacity(0.85),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ibg.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: tc.withOpacity(0.2), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.business, color: tc, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          businessName,
                          style: TextStyle(
                            fontSize: _businessNameFontSize.clamp(10, 16),
                            fontWeight: FontWeight.bold,
                            color: tc,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ibg.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: tc.withOpacity(0.2), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: tc, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          phone,
                          style: TextStyle(
                            fontSize: _phoneNumberFontSize.clamp(10, 16),
                            fontWeight: FontWeight.bold,
                            color: tc,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      case BarLayoutStyle.minimal:
        return Container(
          color: d.solidColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  businessName,
                  style: TextStyle(
                    fontSize: _businessNameFontSize,
                    fontWeight: FontWeight.w600,
                    color: tc,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 1,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: d.dividerColor,
              ),
              Expanded(
                child: Text(
                  phone,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: _phoneNumberFontSize,
                    fontWeight: FontWeight.w400,
                    color: sc,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );

      case BarLayoutStyle.ribbon:
        return Container(
          decoration: bgDecor,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 5,
                color: tc.withOpacity(0.8),
                margin: const EdgeInsets.only(right: 14),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      businessName,
                      style: TextStyle(
                        fontSize: _businessNameFontSize,
                        fontWeight: FontWeight.bold,
                        color: tc,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, color: sc, size: 13),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            phone,
                            style: TextStyle(
                              fontSize: _phoneNumberFontSize.clamp(10, 14),
                              color: sc,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        );

      case BarLayoutStyle.neon:
        return Container(
          decoration: BoxDecoration(
            color: d.solidColor,
            border: Border(top: BorderSide(color: tc, width: 1.5)),
            boxShadow: [
              BoxShadow(
                color: tc.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: tc, width: 1.5),
                        boxShadow: [
                          BoxShadow(color: tc.withOpacity(0.5), blurRadius: 8),
                        ],
                      ),
                      child: Icon(Icons.business, color: tc, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        businessName,
                        style: TextStyle(
                          fontSize: _businessNameFontSize,
                          fontWeight: FontWeight.bold,
                          color: tc,
                          shadows: [
                            Shadow(color: tc.withOpacity(0.8), blurRadius: 8),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 36,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                color: d.dividerColor,
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: tc, width: 1.5),
                        boxShadow: [
                          BoxShadow(color: tc.withOpacity(0.5), blurRadius: 8),
                        ],
                      ),
                      child: Icon(Icons.phone, color: tc, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        phone,
                        style: TextStyle(
                          fontSize: _phoneNumberFontSize,
                          fontWeight: FontWeight.bold,
                          color: tc,
                          shadows: [
                            Shadow(color: tc.withOpacity(0.8), blurRadius: 8),
                          ],
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
        );

      case BarLayoutStyle.wave:
        return ClipPath(
          clipper: _WaveInfoBarClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: d.gradient,
              color: d.gradient == null ? d.solidColor : null,
            ),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: ibg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.business, color: tc, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          businessName,
                          style: TextStyle(
                            fontSize: _businessNameFontSize,
                            fontWeight: FontWeight.bold,
                            color: tc,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  color: d.dividerColor,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: ibg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.phone, color: sc, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          phone,
                          style: TextStyle(
                            fontSize: _phoneNumberFontSize,
                            fontWeight: FontWeight.bold,
                            color: sc,
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
        );

      case BarLayoutStyle.magazine:
        return Container(
          decoration: bgDecor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      businessName,
                      style: TextStyle(
                        fontSize: _businessNameFontSize + 2,
                        fontWeight: FontWeight.w900,
                        color: tc,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'BUSINESS',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: tc.withOpacity(0.5),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: d.dividerColor,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTACT',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: sc.withOpacity(0.5),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.phone, color: sc, size: 13),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            phone,
                            style: TextStyle(
                              fontSize: _phoneNumberFontSize.clamp(10, 14),
                              fontWeight: FontWeight.bold,
                              color: sc,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case BarLayoutStyle.classic:
      default:
        return Container(
          decoration: bgDecor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ibg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.business, color: tc, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        businessName,
                        style: TextStyle(
                          fontSize: _businessNameFontSize,
                          fontWeight: FontWeight.bold,
                          color: tc,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                color: d.dividerColor,
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ibg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.phone, color: tc, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        phone,
                        style: TextStyle(
                          fontSize: _phoneNumberFontSize,
                          fontWeight: FontWeight.bold,
                          color: tc,
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
        );
    }
  }

  void _showBottomInfoSheet(TextElement? nameEl, TextElement? mobileEl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, set) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
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
              const SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple.shade100,
                  child: Icon(Icons.business, color: Colors.purple.shade700),
                ),
                title: const Text(
                  'Business Name',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(nameEl?.text ?? 'Tap to edit'),
                trailing: const Icon(Icons.edit, size: 18),
                onTap: () {
                  Navigator.pop(ctx);
                  if (nameEl != null)
                    _showEditDialog(
                      title: 'Business Name',
                      currentValue: nameEl.text,
                      icon: Icons.business,
                      onSave: (v) async {
                        await _saveBusinessName(v);
                        setState(() => nameEl.text = v);
                      },
                    );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text('Name Size:', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Slider(
                        value: _businessNameFontSize,
                        min: 10,
                        max: 40,
                        divisions: 30,
                        activeColor: Colors.purple,
                        onChanged: (v) {
                          setState(() => _businessNameFontSize = v);
                          set(() {});
                        },
                      ),
                    ),
                    Text(
                      '${_businessNameFontSize.round()}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.phone, color: Colors.blue.shade700),
                ),
                title: const Text(
                  'Phone Number',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(phoneNumber ?? mobileEl?.text ?? 'Tap to edit'),
                trailing: const Icon(Icons.edit, size: 18),
                onTap: () {
                  Navigator.pop(ctx);
                  if (mobileEl != null)
                    _showEditDialog(
                      title: 'Phone Number',
                      currentValue: mobileEl.text,
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      onSave: (v) {
                        setState(() {
                          mobileEl.text = v;
                          phoneNumber = v;
                        });
                      },
                    );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text('Phone Size:', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Slider(
                        value: _phoneNumberFontSize,
                        min: 10,
                        max: 40,
                        divisions: 30,
                        activeColor: Colors.blue,
                        onChanged: (v) {
                          setState(() => _phoneNumberFontSize = v);
                          set(() {});
                        },
                      ),
                    ),
                    Text(
                      '${_phoneNumberFontSize.round()}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Wave clipper for info bar ──
class _WaveInfoBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 16);
    path.quadraticBezierTo(size.width * 0.15, 4, size.width * 0.35, 12);
    path.quadraticBezierTo(size.width * 0.55, 22, size.width * 0.75, 10);
    path.quadraticBezierTo(size.width * 0.9, 2, size.width, 8);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveInfoBarClipper old) => false;
}
