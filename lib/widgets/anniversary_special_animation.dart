import 'dart:math';
import 'package:flutter/material.dart';

class AnniversaryCelebrationOverlay extends StatefulWidget {
  final VoidCallback? onDismiss;
  const AnniversaryCelebrationOverlay({Key? key, this.onDismiss}) : super(key: key);

  @override
  State<AnniversaryCelebrationOverlay> createState() =>
      _AnniversaryCelebrationOverlayState();
}

class _AnniversaryCelebrationOverlayState
    extends State<AnniversaryCelebrationOverlay> with TickerProviderStateMixin {
  late AnimationController _petalController;
  late AnimationController _burstController;
  late AnimationController _textController;
  late AnimationController _heartFloatController;

  final List<_PetalData> _petals = [];
  final List<_SparkParticle> _sparks = [];
  final List<_RingData> _rings = [];
  final List<_HeartData> _hearts = [];
  final List<_StarData> _stars = [];
  final Random _random = Random();
  bool _dismissing = false;

  static const _petalColors = [
    Color(0xFFFF4D6D), Color(0xFFFF6B8A), Color(0xFFFF8FAB),
    Color(0xFFFF3D5A), Color(0xFFD62839), Color(0xFFFF9EB5),
    Color(0xFFFFB3C1),
  ];
  static const _sparkColors = [
    Color(0xFFFFD700), Color(0xFFFFC0CB), Color(0xFFFF8FAB),
    Colors.white,      Color(0xFFFFD93D),
  ];

  @override
  void initState() {
    super.initState();

    _petalController = AnimationController(
      vsync: this, duration: const Duration(seconds: 5),
    )..repeat();

    _burstController = AnimationController(
      vsync: this, duration: const Duration(seconds: 6),
    )..repeat();

    _heartFloatController = AnimationController(
      vsync: this, duration: const Duration(seconds: 4),
    )..repeat();

    _textController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900),
    )..forward();

    _initParticles();
    _scheduleBursts();

    Future.delayed(const Duration(milliseconds: 4800), () {
      if (mounted && !_dismissing) _dismiss();
    });
  }

  void _initParticles() {
    // Stars (static background sparkle)
    for (int i = 0; i < 55; i++) {
      _stars.add(_StarData(
        xFrac: _random.nextDouble(),
        yFrac: _random.nextDouble() * 0.75,
        radius: 0.8 + _random.nextDouble() * 1.8,
        twinkleSpeed: 0.02 + _random.nextDouble() * 0.07,
        twinkleOffset: _random.nextDouble() * pi * 2,
      ));
    }
    // Petals
    for (int i = 0; i < 55; i++) {
      _petals.add(_PetalData(
        xFrac: _random.nextDouble(),
        yOffset: -_random.nextDouble() * 2.0,
        speedY: 1.2 + _random.nextDouble() * 2.8,
        speedX: (_random.nextDouble() - 0.5) * 1.6,
        wobbleAmp: 3 + _random.nextDouble() * 6,
        wobbleSpeed: 0.03 + _random.nextDouble() * 0.05,
        wobbleOffset: _random.nextDouble() * pi * 2,
        w: 7 + _random.nextDouble() * 8,
        h: 4 + _random.nextDouble() * 5,
        rotation: _random.nextDouble() * pi * 2,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.1,
        color: _petalColors[_random.nextInt(_petalColors.length)],
        delay: _random.nextDouble() * 0.5,
      ));
    }
    // Floating hearts
    for (int i = 0; i < 7; i++) {
      _hearts.add(_HeartData(
        xFrac: 0.08 + _random.nextDouble() * 0.84,
        yFrac: 1.05 + _random.nextDouble() * 0.2,
        size: 8 + _random.nextDouble() * 14,
        speedY: 0.5 + _random.nextDouble() * 1.4,
        speedX: (_random.nextDouble() - 0.5) * 0.8,
        wobbleAmp: 4 + _random.nextDouble() * 8,
        wobbleSpeed: 0.025 + _random.nextDouble() * 0.04,
        wobbleOffset: _random.nextDouble() * pi * 2,
        color: _petalColors[_random.nextInt(_petalColors.length)],
        delay: _random.nextDouble() * 0.4,
      ));
    }
  }

  void _scheduleBursts() {
    final delays = [400, 900, 1300, 1900];
    final positions = [
      const Offset(0.5, 0.35),
      const Offset(0.25, 0.45),
      const Offset(0.75, 0.45),
      const Offset(0.5, 0.55),
    ];
    for (int i = 0; i < delays.length; i++) {
      final pos = positions[i];
      Future.delayed(Duration(milliseconds: delays[i]), () {
        if (!mounted) return;
        setState(() {
          _addBurst(pos);
        });
      });
    }
  }

  void _addBurst(Offset frac) {
    for (int i = 0; i < 24; i++) {
      final angle = (i / 24) * pi * 2 + (_random.nextDouble() - 0.5) * 0.4;
      final speed = 2 + _random.nextDouble() * 8;
      _sparks.add(_SparkParticle(
        xFrac: frac.dx,
        yFrac: frac.dy,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        radius: 1.5 + _random.nextDouble() * 4,
        color: _sparkColors[_random.nextInt(_sparkColors.length)],
        life: 1.0,
      ));
    }
    _rings.add(_RingData(
      xFrac: frac.dx, yFrac: frac.dy,
      color: const Color(0xFFFF4D6D),
    ));
    _rings.add(_RingData(
      xFrac: frac.dx + 0.01, yFrac: frac.dy,
      color: const Color(0xFFFFD700),
    ));
    // Extra burst hearts
    _hearts.add(_HeartData(
      xFrac: frac.dx, yFrac: frac.dy,
      size: 10 + _random.nextDouble() * 14,
      speedY: 1.2 + _random.nextDouble() * 2,
      speedX: (_random.nextDouble() - 0.5) * 1.0,
      wobbleAmp: 6, wobbleSpeed: 0.04, wobbleOffset: 0,
      color: const Color(0xFFFF4D6D), delay: 0,
    ));
  }

  void _dismiss() {
    if (_dismissing) return;
    setState(() => _dismissing = true);
    _textController.reverse().then((_) => widget.onDismiss?.call());
  }

  @override
  void dispose() {
    _petalController.dispose();
    _burstController.dispose();
    _heartFloatController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismiss,
      child: Container(
        color: Colors.black.withOpacity(0.50),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([
                _petalController, _burstController, _heartFloatController,
              ]),
              builder: (_, __) {
                for (final p in _sparks) { p.update(); }
                for (final r in _rings) { r.update(); }
                _sparks.removeWhere((p) => p.isDead);
                _rings.removeWhere((r) => r.isDead);
                return CustomPaint(
                  size: Size.infinite,
                  painter: _AnniversaryPainter(
                    petals: _petals,
                    sparks: _sparks,
                    rings: _rings,
                    hearts: _hearts,
                    stars: _stars,
                    t: _petalController.value,
                    burstT: _burstController.value,
                    heartT: _heartFloatController.value,
                  ),
                );
              },
            ),
            Center(
              child: FadeTransition(
                opacity: _textController,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _textController,
                    curve: Curves.elasticOut,
                  ),
                  child: _buildCard(),
                ),
              ),
            ),
            Positioned(
              bottom: 32, left: 0, right: 0,
              child: FadeTransition(
                opacity: _textController,
                child: const Center(
                  child: Text(
                    'Tap anywhere to continue',
                    style: TextStyle(color: Colors.white60, fontSize: 12, letterSpacing: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF4D6D).withOpacity(0.45),
            blurRadius: 36,
            spreadRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💍', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          const Text(
            'Happy Anniversary!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD62839),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Celebrate your love story ♥',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD62839), Color(0xFFFF8FAB)],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Start Editing 💕',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data Models ───────────────────────────────────────────

class _PetalData {
  final double xFrac, yOffset, speedY, speedX;
  final double wobbleAmp, wobbleSpeed, wobbleOffset;
  final double w, h, rotation, rotationSpeed;
  final Color color;
  final double delay;

  _PetalData({
    required this.xFrac, required this.yOffset,
    required this.speedY, required this.speedX,
    required this.wobbleAmp, required this.wobbleSpeed, required this.wobbleOffset,
    required this.w, required this.h,
    required this.rotation, required this.rotationSpeed,
    required this.color, required this.delay,
  });
}

class _HeartData {
  final double xFrac;
  double yFrac;
  final double size, speedY, speedX;
  final double wobbleAmp, wobbleSpeed, wobbleOffset;
  final Color color;
  final double delay;

  _HeartData({
    required this.xFrac, required this.yFrac,
    required this.size, required this.speedY, required this.speedX,
    required this.wobbleAmp, required this.wobbleSpeed, required this.wobbleOffset,
    required this.color, required this.delay,
  });
}

class _StarData {
  final double xFrac, yFrac, radius, twinkleSpeed, twinkleOffset;
  _StarData({
    required this.xFrac, required this.yFrac,
    required this.radius, required this.twinkleSpeed, required this.twinkleOffset,
  });
}

class _SparkParticle {
  final double xFrac, yFrac;
  double vx, vy;
  final double radius;
  final Color color;
  double life;

  _SparkParticle({
    required this.xFrac, required this.yFrac,
    required this.vx, required this.vy,
    required this.radius, required this.color, required this.life,
  });

  void update() {
    vy += 0.25;
    life -= 0.028;
  }

  bool get isDead => life <= 0;
}

class _RingData {
  final double xFrac, yFrac;
  final Color color;
  double radius = 0;
  double alpha = 0.9;

  _RingData({required this.xFrac, required this.yFrac, required this.color});

  void update() { radius += 2.0; alpha -= 0.025; }
  bool get isDead => alpha <= 0;
}

// ─── Painter ───────────────────────────────────────────────

class _AnniversaryPainter extends CustomPainter {
  final List<_PetalData> petals;
  final List<_SparkParticle> sparks;
  final List<_RingData> rings;
  final List<_HeartData> hearts;
  final List<_StarData> stars;
  final double t, burstT, heartT;

  _AnniversaryPainter({
    required this.petals, required this.sparks, required this.rings,
    required this.hearts, required this.stars,
    required this.t, required this.burstT, required this.heartT,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Stars twinkle
    for (final s in stars) {
      final alpha = 0.35 + 0.65 * ((sin(t * s.twinkleSpeed * 60 + s.twinkleOffset) + 1) / 2);
      final paint = Paint()..color = Colors.white.withOpacity(alpha);
      canvas.drawCircle(Offset(s.xFrac * size.width, s.yFrac * size.height), s.radius, paint);
    }

    // Petals
    for (final p in petals) {
      final progress = ((t - p.delay + 1.0) % 1.0);
      final x = p.xFrac * size.width
          + p.speedX * progress * size.height * 0.25
          + sin(t * p.wobbleSpeed * 60 + p.wobbleOffset) * p.wobbleAmp;
      final y = (p.yOffset + progress) * size.height * 1.1;
      if (y < -30 || y > size.height + 30) continue;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation + p.rotationSpeed * t * 60);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: p.w, height: p.h),
        Paint()..color = p.color.withOpacity(0.82),
      );
      canvas.restore();
    }

    // Rings
    for (final r in rings) {
      canvas.drawCircle(
        Offset(r.xFrac * size.width, r.yFrac * size.height),
        r.radius,
        Paint()
          ..color = r.color.withOpacity((r.alpha * 0.6).clamp(0, 1))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Sparks
    for (final p in sparks) {
      final cx = p.xFrac * size.width + p.vx * (1.0 - p.life) * 40;
      final cy = p.yFrac * size.height + p.vy * (1.0 - p.life) * 40;
      canvas.drawCircle(
        Offset(cx, cy),
        p.radius * p.life.clamp(0, 1),
        Paint()..color = p.color.withOpacity(p.life.clamp(0, 1)),
      );
    }

    // Floating hearts
    for (final h in hearts) {
      final progress = ((heartT - h.delay + 1.0) % 1.0);
      final x = h.xFrac * size.width
          + h.speedX * progress * size.height * 0.2
          + sin(heartT * h.wobbleSpeed * 60 + h.wobbleOffset) * h.wobbleAmp;
      final y = h.yFrac * size.height - progress * (size.height * 1.1);
      if (y < -40 || y > size.height + 40) continue;

      final alpha = (1.0 - progress * 0.6).clamp(0.0, 1.0);
      _drawHeart(canvas, Offset(x, y), h.size, h.color.withOpacity(alpha));
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double r, Color color) {
    final path = Path();
    final x = center.dx, y = center.dy;
    path.moveTo(x, y);
    path.cubicTo(x + r, y - r * 1.1, x + r * 2, y + r * 0.4, x, y + r * 1.4);
    path.cubicTo(x - r * 2, y + r * 0.4, x - r, y - r * 1.1, x, y);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_AnniversaryPainter old) => true;
}