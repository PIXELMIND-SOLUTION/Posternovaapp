// // import 'package:flutter/material.dart';

// // class PosterCardSkeleton extends StatelessWidget {
// //   const PosterCardSkeleton();
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: 110,
// //       margin: const EdgeInsets.only(right: 10),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(10),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.06),
// //             blurRadius: 4,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           ClipRRect(
// //             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
// //             child: const SkeletonBox(width: 110, height: 100, borderRadius: 0),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(6),
// //             child: SkeletonBox(width: 70, height: 10, borderRadius: 4),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class ReelCardSkeleton extends StatelessWidget {
// //   const ReelCardSkeleton();
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: 105,
// //       margin: const EdgeInsets.only(right: 10),
// //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
// //       child: const SkeletonBox(width: 105, height: 180, borderRadius: 12),
// //     );
// //   }
// // }

// // class DateSelectorSkeleton extends StatelessWidget {
// //   const DateSelectorSkeleton();
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       height: 68,
// //       child: ListView.builder(
// //         scrollDirection: Axis.horizontal,
// //         padding: const EdgeInsets.symmetric(horizontal: 12),
// //         itemCount: 7,
// //         itemBuilder: (_, __) => Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 4),
// //           child: const SkeletonBox(width: 58, height: 68, borderRadius: 10),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SKELETON SHIMMER HELPERS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class SkeletonBox extends StatefulWidget {
// //   final double width;
// //   final double height;
// //   final double borderRadius;
// //   const SkeletonBox({
// //     required this.width,
// //     required this.height,
// //     this.borderRadius = 8,
// //   });

// //   @override
// //   State<SkeletonBox> createState() => SkeletonBoxState();
// // }

// // class SkeletonBoxState extends State<SkeletonBox>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _animController;
// //   late Animation<double> _anim;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _animController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1200),
// //     )..repeat(reverse: true);
// //     _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
// //       CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _animController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedBuilder(
// //       animation: _anim,
// //       builder: (_, __) => Container(
// //         width: widget.width,
// //         height: widget.height,
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(widget.borderRadius),
// //           gradient: LinearGradient(
// //             colors: [
// //               Colors.grey.withOpacity(_anim.value * 0.6),
// //               Colors.white.withOpacity(_anim.value),
// //               Colors.grey.withOpacity(_anim.value * 0.6),
// //             ],
// //           ),
// //         ),
// //         child: Opacity(
// //           opacity: 0.06,
// //           child: Center(
// //             child: Image.asset(
// //               'assets/images/logo.png',
// //               width: widget.width * 0.4,
// //               height: widget.height * 0.4,
// //               fit: BoxFit.contain,
// //               color: Colors.black,
// //               errorBuilder: (_, __, ___) => Icon(
// //                 Icons.edit,
// //                 color: Colors.black,
// //                 size: widget.width * 0.3,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class BannerSkeleton extends StatelessWidget {
// //   const BannerSkeleton();
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(16),
// //         child: const SkeletonBox(
// //           width: double.infinity,
// //           height: 104,
// //           borderRadius: 16,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class StorySkeleton extends StatelessWidget {
// //   const StorySkeleton();
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       height: 90,
// //       child: ListView.builder(
// //         scrollDirection: Axis.horizontal,
// //         padding: const EdgeInsets.symmetric(horizontal: 12),
// //         itemCount: 6,
// //         itemBuilder: (_, __) => Padding(
// //           padding: const EdgeInsets.only(right: 12),
// //           child: Column(
// //             children: [
// //               const SkeletonBox(width: 56, height: 56, borderRadius: 28),
// //               const SizedBox(height: 6),
// //               SkeletonBox(width: 48, height: 10, borderRadius: 4),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }




























import 'package:flutter/material.dart';
import 'dart:math' as math;


class LogoPlaceholder extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? accentColor;

  const LogoPlaceholder({
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.baseColor,
    this.accentColor,
  });

  @override
  State<LogoPlaceholder> createState() => _LogoPlaceholderState();
}

class _LogoPlaceholderState extends State<LogoPlaceholder>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _ringController;

  late Animation<double> _pulse;
  late Animation<double> _shimmer;
  late Animation<double> _ring;

  static const Color _tealDark = Color(0xFF0077A8);
  static const Color _tealLight = Color(0xFF00BCD4);

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();

    _pulse = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shimmer = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _ring = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.baseColor ?? const Color(0xFFF0FAFE);
    final accent = widget.accentColor ?? _tealLight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulse, _shimmer, _ring]),
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        base,
                        Color.lerp(base, accent.withOpacity(0.15), 0.5)!,
                        base,
                      ],
                      stops: [
                        ((_shimmer.value - 0.5).clamp(0.0, 1.0)),
                        (_shimmer.value.clamp(0.0, 1.0)),
                        ((_shimmer.value + 0.5).clamp(0.0, 1.0)),
                      ],
                    ),
                  ),
                ),

                Transform.rotate(
                  angle: _ring.value * 2 * math.pi,
                  child: CustomPaint(
                    size: Size(
                      math.min(widget.width, widget.height) * 0.62,
                      math.min(widget.width, widget.height) * 0.62,
                    ),
                    painter: _DashedRingPainter(
                      color: accent.withOpacity(0.25),
                      strokeWidth: 1.2,
                    ),
                  ),
                ),

                Transform.rotate(
                  angle: -_ring.value * 2 * math.pi * 0.4,
                  child: CustomPaint(
                    size: Size(
                      math.min(widget.width, widget.height) * 0.80,
                      math.min(widget.width, widget.height) * 0.80,
                    ),
                    painter: _DashedRingPainter(
                      color: _tealDark.withOpacity(0.12),
                      strokeWidth: 0.8,
                      dashCount: 8,
                    ),
                  ),
                ),

                Transform.scale(
                  scale: _pulse.value,
                  child: Container(
                    width: math.min(widget.width, widget.height) * 0.42,
                    height: math.min(widget.width, widget.height) * 0.42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.18 * _pulse.value),
                          blurRadius: 14,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Opacity(
                      opacity: 0.35 + (_pulse.value - 0.85) * 0.8,
                      child: Image.asset(
                        'assets/latestdesigned.jpeg',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.auto_awesome_rounded,
                          color: _tealDark,
                          size: math.min(widget.width, widget.height) * 0.28,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment(-2 + _shimmer.value * 2, -0.3),
                      end: Alignment(-1 + _shimmer.value * 2, 0.3),
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.18),
                        Colors.transparent,
                      ],
                    ).createShader(bounds),
                    child: Container(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


class _DashedRingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;

  const _DashedRingPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashCount = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final dashAngle = (2 * math.pi) / dashCount;
    final gapFraction = 0.35;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final sweepAngle = dashAngle * (1 - gapFraction);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class PosterCardSkeleton extends StatelessWidget {
  const PosterCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
            child: const LogoPlaceholder(
              width: 110,
              height: 100,
              borderRadius: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: LogoPlaceholder(
              width: 70,
              height: 10,
              borderRadius: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class ReelCardSkeleton extends StatelessWidget {
  const ReelCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: const LogoPlaceholder(
        width: 105,
        height: 180,
        borderRadius: 12,
      ),
    );
  }
}

class DateSelectorSkeleton extends StatelessWidget {
  const DateSelectorSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 7,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: const LogoPlaceholder(
            width: 58,
            height: 68,
            borderRadius: 10,
          ),
        ),
      ),
    );
  }
}

class BannerSkeleton extends StatelessWidget {
  const BannerSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: const LogoPlaceholder(
          width: double.infinity,
          height: 104,
          borderRadius: 16,
        ),
      ),
    );
  }
}

class StorySkeleton extends StatelessWidget {
  const StorySkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Column(
            children: [
              const LogoPlaceholder(
                width: 56,
                height: 56,
                borderRadius: 28,
              ),
              const SizedBox(height: 6),
              const LogoPlaceholder(
                width: 48,
                height: 10,
                borderRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


@Deprecated('Use LogoPlaceholder instead')
class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) => LogoPlaceholder(
        width: width,
        height: height,
        borderRadius: borderRadius,
      );
}