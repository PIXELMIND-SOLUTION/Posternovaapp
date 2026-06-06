import 'dart:math';
import 'package:flutter/material.dart';

class BirthdayCelebrationOverlay extends StatefulWidget {
  final VoidCallback? onDismiss;

  const BirthdayCelebrationOverlay({Key? key, this.onDismiss}) : super(key: key);

  @override
  State<BirthdayCelebrationOverlay> createState() => _BirthdayCelebrationOverlayState();
}

class _BirthdayCelebrationOverlayState extends State<BirthdayCelebrationOverlay>
    with TickerProviderStateMixin {
  late AnimationController _balloonController;
  late AnimationController _confettiController;
  late AnimationController _textController;
  late AnimationController _burstController;

  final List<_BalloonData> _balloons = [];
  final List<_ConfettiData> _confetti = [];
  final List<_BurstParticle> _burstParticles = [];
  final Random _random = Random();
  bool _dismissing = false;

  static const _balloonColors = [
    Color(0xFFFF6B9D), Color(0xFFFFD93D), Color(0xFF6BCB77),
    Color(0xFF4D96FF), Color(0xFFFF6B6B), Color(0xFFC77DFF),
    Color(0xFFFF9F1C), Color(0xFF00D2FF),
  ];

  static const _confettiColors = [
    Color(0xFFFF6B9D), Color(0xFFFFD93D), Color(0xFF6BCB77),
    Color(0xFF4D96FF), Color(0xFFFF6B6B), Color(0xFFC77DFF),
    Colors.white,     Color(0xFFFF9F1C),
  ];

  @override
  void initState() {
    super.initState();

    _balloonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _initBalloons();
    _initConfetti();
    _schedulePops();

    // Auto-dismiss after 5 seconds
    Future.delayed(const Duration(milliseconds: 4800), () {
      if (mounted && !_dismissing) _dismiss();
    });
  }

  void _initBalloons() {
    for (int i = 0; i < 7; i++) {
      _balloons.add(_BalloonData(
        xFraction: (i + 1) / 8.0,
        color: _balloonColors[i % _balloonColors.length],
        radius: 22 + _random.nextDouble() * 16,
        speed: 0.8 + _random.nextDouble() * 0.8,
        wobbleOffset: _random.nextDouble() * pi * 2,
        delay: i * 0.12,
        stringLen: 30 + _random.nextDouble() * 25,
      ));
    }
  }

  void _initConfetti() {
    for (int i = 0; i < 70; i++) {
      _confetti.add(_ConfettiData(
        xFraction: _random.nextDouble(),
        yOffset: -_random.nextDouble() * 1.5,
        speedY: 1.5 + _random.nextDouble() * 3.5,
        speedX: (_random.nextDouble() - 0.5) * 2.0,
        width: 6 + _random.nextDouble() * 8,
        height: 4 + _random.nextDouble() * 6,
        rotation: _random.nextDouble() * pi * 2,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.15,
        color: _confettiColors[_random.nextInt(_confettiColors.length)],
        delay: _random.nextDouble() * 0.4,
      ));
    }
  }

  void _schedulePops() {
    for (int i = 0; i < _balloons.length; i++) {
      final delay = Duration(milliseconds: 800 + i * 300 + _random.nextInt(400));
      Future.delayed(delay, () {
        if (!mounted) return;
        _popBalloon(i);
      });
    }
  }

  void _popBalloon(int index) {
    if (index >= _balloons.length) return;
    setState(() {
      _balloons[index].popped = true;
      // Add burst particles
      final xFrac = _balloons[index].xFraction;
      for (int i = 0; i < 18; i++) {
        final angle = (i / 18) * pi * 2 + (_random.nextDouble() - 0.5) * 0.4;
        final speed = 3 + _random.nextDouble() * 7;
        _burstParticles.add(_BurstParticle(
          xFraction: xFrac,
          yFraction: 0.15 + _random.nextDouble() * 0.25,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          radius: 2.5 + _random.nextDouble() * 4,
          color: _balloons[index].color,
          life: 1.0,
        ));
      }
    });
  }

  void _dismiss() {
    if (_dismissing) return;
    setState(() => _dismissing = true);
    _textController.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  void dispose() {
    _balloonController.dispose();
    _confettiController.dispose();
    _textController.dispose();
    _burstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismiss,
      child: Container(
        color: Colors.black.withOpacity(0.45),
        child: Stack(
          children: [
            // Confetti layer
            AnimatedBuilder(
              animation: _confettiController,
              builder: (_, __) => CustomPaint(
                size: Size.infinite,
                painter: _ConfettiPainter(
                  confetti: _confetti,
                  t: _confettiController.value,
                ),
              ),
            ),
            // Balloons layer
            AnimatedBuilder(
              animation: _balloonController,
              builder: (_, __) => CustomPaint(
                size: Size.infinite,
                painter: _BalloonPainter(
                  balloons: _balloons,
                  t: _balloonController.value,
                ),
              ),
            ),
            // Burst particles
            AnimatedBuilder(
              animation: _burstController,
              builder: (_, __) {
                for (final p in _burstParticles) {
                  p.update();
                }
                return CustomPaint(
                  size: Size.infinite,
                  painter: _BurstPainter(particles: _burstParticles),
                );
              },
            ),
            // Center card
            Center(
              child: FadeTransition(
                opacity: _textController,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _textController,
                    curve: Curves.elasticOut,
                  ),
                  child: _buildCenterCard(),
                ),
              ),
            ),
            // Tap-to-dismiss hint
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _textController,
                child: const Center(
                  child: Text(
                    'Tap anywhere to continue',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withOpacity(0.4),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎂', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          const Text(
            'Happy Birthday!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD63384),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Make it special ✨',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFFFF9F1C)],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Start Editing 🎈',
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

class _BalloonData {
  final double xFraction;
  final Color color;
  final double radius;
  final double speed;
  final double wobbleOffset;
  final double delay;
  final double stringLen;
  bool popped = false;

  _BalloonData({
    required this.xFraction,
    required this.color,
    required this.radius,
    required this.speed,
    required this.wobbleOffset,
    required this.delay,
    required this.stringLen,
  });
}

class _ConfettiData {
  final double xFraction;
  final double yOffset;
  final double speedY;
  final double speedX;
  final double width;
  final double height;
  final double rotation;
  final double rotationSpeed;
  final Color color;
  final double delay;

  _ConfettiData({
    required this.xFraction,
    required this.yOffset,
    required this.speedY,
    required this.speedX,
    required this.width,
    required this.height,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.delay,
  });
}

class _BurstParticle {
  double xFraction;
  double yFraction;
  double vx;
  double vy;
  double radius;
  Color color;
  double life;

  _BurstParticle({
    required this.xFraction,
    required this.yFraction,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.color,
    required this.life,
  });

  void update() {
    life -= 0.025;
    vy += 0.3; // gravity
  }

  bool get isDead => life <= 0;
}

// ─── Painters ──────────────────────────────────────────────

class _BalloonPainter extends CustomPainter {
  final List<_BalloonData> balloons;
  final double t;

  _BalloonPainter({required this.balloons, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in balloons) {
      if (b.popped) continue;
      final progress = ((t - b.delay) % 1.0 + 1.0) % 1.0;
      if (progress < 0.001 && b.delay > 0) continue;

      final x = b.xFraction * size.width;
      final y = size.height - progress * (size.height + b.radius * 2 + b.stringLen + 40) +
          b.radius + b.stringLen + 20;

      if (y < -100) continue;

      final wobble = sin((t * pi * 2 * 0.8) + b.wobbleOffset) * 10;

      canvas.save();
      canvas.translate(x + wobble, y);

      // String
      final stringPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      final path = Path();
      path.moveTo(0, b.radius);
      path.quadraticBezierTo(wobble * 0.5, b.radius + b.stringLen * 0.5, 0, b.radius + b.stringLen);
      canvas.drawPath(path, stringPaint);

      // Body
      final bodyPaint = Paint()..color = b.color;
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: b.radius * 2, height: b.radius * 2.36), bodyPaint);

      // Highlight
      final hlPaint = Paint()..color = Colors.white.withOpacity(0.35);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(-b.radius * 0.28, -b.radius * 0.32), width: b.radius * 0.46, height: b.radius * 0.28),
        hlPaint,
      );

      // Knot
      canvas.drawCircle(Offset(0, b.radius + 2), 3.5, bodyPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_BalloonPainter old) => true;
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiData> confetti;
  final double t;

  _ConfettiPainter({required this.confetti, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    for (final c in confetti) {
      final progress = ((t - c.delay) % 1.0 + 1.0) % 1.0;
      final x = c.xFraction * size.width + c.speedX * progress * size.height * 0.3;
      final y = (c.yOffset + progress) * size.height * 1.1;
      if (y < -30 || y > size.height + 30) continue;

      final rot = c.rotation + c.rotationSpeed * t * 60;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: c.width, height: c.height),
        Paint()..color = c.color.withOpacity(0.85),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => true;
}

class _BurstPainter extends CustomPainter {
  final List<_BurstParticle> particles;

  _BurstPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      if (p.isDead) continue;
      final cx = p.xFraction * size.width + p.vx * (1.0 - p.life) * 40;
      final cy = p.yFraction * size.height + p.vy * (1.0 - p.life) * 40;
      canvas.drawCircle(
        Offset(cx, cy),
        p.radius * p.life,
        Paint()..color = p.color.withOpacity(p.life.clamp(0, 1)),
      );
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => true;
}