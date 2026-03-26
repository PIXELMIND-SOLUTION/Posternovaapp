import 'dart:async';
import 'package:flutter/material.dart';
import 'package:posternova/providers/usage/usage_provider.dart';
import 'package:provider/provider.dart';

class ActiveTimeWidget extends StatefulWidget {
  const ActiveTimeWidget({super.key});

  @override
  State<ActiveTimeWidget> createState() => _ActiveTimeWidgetState();
}

class _ActiveTimeWidgetState extends State<ActiveTimeWidget>
    with TickerProviderStateMixin {
  late AnimationController _sandController;
  late Animation<double> _sandAnimation;

  @override
  void initState() {
    super.initState();

    _sandController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _sandAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _sandController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _sandController.dispose();
    super.dispose();
  }

  int _getLiveSeconds(UsageProvider usage) {
    int s = usage.totalSeconds;
    if (usage.startTime != null) {
      s += DateTime.now().difference(usage.startTime!).inSeconds;
    }
    return s.clamp(0, UsageProvider.rewardThreshold);
  }

  void _showTimerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<UsageProvider>(),
        child: const _TimerModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usage = context.watch<UsageProvider>();
    final liveSeconds = _getLiveSeconds(usage);
    final coinsEarned = liveSeconds ~/ 60;
    final isMinutes = liveSeconds >= 60;
    final displayValue = isMinutes ? liveSeconds ~/ 60 : liveSeconds;
    final label = isMinutes ? 'min' : 'sec';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Sand timer button
        GestureDetector(
          onTap: () => _showTimerModal(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFAC775).withOpacity(0.6),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.hourglass_full,
                  color: Color.fromARGB(255, 255, 251, 29),
                ),
                const SizedBox(width: 5),
                Text(
                  '$displayValue $label',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 255, 251, 29),
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Sand Timer Icon ──────────────────────────────────────────────────────────

class _SandTimerIcon extends StatelessWidget {
  final double progress;
  final double size;
  final Color color;

  const _SandTimerIcon({
    required this.progress,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SandTimerPainter(progress: progress, color: color),
    );
  }
}

class _SandTimerPainter extends CustomPainter {
  final double progress;
  final Color color;

  _SandTimerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final fill = Paint()
      ..color = color.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final dot = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    canvas.drawLine(Offset(0, 0), Offset(w, 0), stroke);
    canvas.drawLine(Offset(0, h), Offset(w, h), stroke);

    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(w, 0)
        ..lineTo(w * 0.5, h * 0.5)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..lineTo(w * 0.5, h * 0.5)
        ..close(),
      stroke,
    );

    final bh = (h * 0.45) * progress;
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.5, h * 0.5)
        ..lineTo(w * 0.5 - (w * 0.5) * (bh / (h * 0.45)), h - bh)
        ..lineTo(w * 0.5 + (w * 0.5) * (bh / (h * 0.45)), h - bh)
        ..close(),
      fill,
    );

    final th = (h * 0.45) * (1 - progress);
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.5, h * 0.5)
        ..lineTo(w * 0.5 - (w * 0.5) * (th / (h * 0.45)), th)
        ..lineTo(w * 0.5 + (w * 0.5) * (th / (h * 0.45)), th)
        ..close(),
      fill,
    );

    canvas.drawCircle(Offset(w * 0.5, h * 0.5 + 1), 1.0, dot);
  }

  @override
  bool shouldRepaint(_SandTimerPainter old) => old.progress != progress;
}

// ─── Timer Modal ──────────────────────────────────────────────────────────────

class _TimerModal extends StatefulWidget {
  const _TimerModal();

  @override
  State<_TimerModal> createState() => _TimerModalState();
}

class _TimerModalState extends State<_TimerModal>
    with TickerProviderStateMixin {
  Timer? _ticker;
  late AnimationController _coinController;
  late Animation<double> _coinAnimation;
  late AnimationController _sandFlipController;
  late Animation<double> _sandFlipAnimation;
  int _prevCoins = 0;

  @override
  void initState() {
    super.initState();

    _coinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _coinAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _coinController, curve: Curves.elasticOut),
    );

    _sandFlipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _sandFlipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sandFlipController, curve: Curves.easeInOut),
    );

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final usage = context.read<UsageProvider>();
      final liveSeconds = _getLiveSeconds(usage);
      final coins = liveSeconds ~/ 60;
      if (coins > _prevCoins) {
        _coinController.forward(from: 0);
        _prevCoins = coins;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _coinController.dispose();
    _sandFlipController.dispose();
    super.dispose();
  }

  int _getLiveSeconds(UsageProvider usage) {
    int s = usage.totalSeconds;
    if (usage.startTime != null) {
      s += DateTime.now().difference(usage.startTime!).inSeconds;
    }
    return s.clamp(0, UsageProvider.rewardThreshold);
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  Color _arcColor(double progress) {
    if (progress >= 1.0) return const Color(0xFF639922);
    if (progress >= 0.5) return const Color(0xFF1D9E75);
    return const Color(0xFFEF9F27);
  }

  @override
  Widget build(BuildContext context) {
    final usage = context.watch<UsageProvider>();
    final liveSeconds = _getLiveSeconds(usage);
    final progress = (liveSeconds / UsageProvider.rewardThreshold).clamp(
      0.0,
      1.0,
    );
    final coinsEarned = liveSeconds ~/ 60;
    final totalCoins = UsageProvider.rewardThreshold ~/ 60;
    final isMinutes = liveSeconds >= 60;
    final displayValue = isMinutes ? liveSeconds ~/ 60 : liveSeconds;
    final label = isMinutes ? 'min' : 'sec';
    final hrs = _pad(liveSeconds ~/ 3600);
    final mins = _pad((liveSeconds % 3600) ~/ 60);
    final secs = _pad(liveSeconds % 60);
    final remaining = (UsageProvider.rewardThreshold - liveSeconds).clamp(
      0,
      UsageProvider.rewardThreshold,
    );
    final remMins = remaining ~/ 60;
    final color = _arcColor(progress);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 24),

          // Circular progress + sand timer
          Stack(
            alignment: Alignment.center,
            children: [
              // Pulse ring
              AnimatedBuilder(
                animation: _sandFlipAnimation,
                builder: (_, __) => Container(
                  width: 140 + _sandFlipAnimation.value * 8,
                  height: 140 + _sandFlipAnimation.value * 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withOpacity(
                        0.06 + _sandFlipAnimation.value * 0.06,
                      ),
                      width: 2,
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 128,
                height: 128,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 5,
                  backgroundColor: color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
              ),

              usage.isCompleted
                  ? Icon(Icons.check_circle_rounded, color: color, size: 48)
                  : AnimatedBuilder(
                      animation: _sandFlipAnimation,
                      builder: (_, __) => _SandTimerIcon(
                        progress: _sandFlipAnimation.value,
                        size: 52,
                        color: color,
                      ),
                    ),
            ],
          ),

          const SizedBox(height: 20),

          // HH:MM:SS
          Text(
            '$hrs:$mins:$secs',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 3,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),

          const SizedBox(height: 4),

          Text(
            usage.isCompleted
                ? 'Session complete!'
                : '$displayValue $label active',
            style: TextStyle(
              fontSize: 13,
              color: color.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 20),

          // Linear progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: color.withOpacity(0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0',
                      style: TextStyle(fontSize: 11, color: Colors.black38),
                    ),
                    Text(
                      '${UsageProvider.rewardThreshold ~/ 60} min goal',
                      style: TextStyle(fontSize: 11, color: Colors.black38),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _statCard({
    required Color color,
    required String label,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          child,
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
