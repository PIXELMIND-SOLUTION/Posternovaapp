import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ─── Model ────────────────────────────────────────────────────────────────────
class Plan {
  final String id;
  final String name;
  final int originalPrice;
  final int offerPrice;
  final String duration;
  final int discountPercentage;
  final List<String> features;

  Plan({
    required this.id,
    required this.name,
    required this.originalPrice,
    required this.offerPrice,
    required this.duration,
    required this.discountPercentage,
    required this.features,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        originalPrice: json['originalPrice'] ?? 0,
        offerPrice: json['offerPrice'] ?? 0,
        duration: json['duration'] ?? '1',
        discountPercentage: json['discountPercentage'] ?? 0,
        features: List<String>.from(json['features'] ?? []),
      );
}

// ─── Shimmer Painter ──────────────────────────────────────────────────────────
class _ShimmerPainter extends CustomPainter {
  final double progress;
  _ShimmerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final shimmerX = -size.width + (size.width * 2.5 * progress);
    final gradient = LinearGradient(
      colors: [
        Colors.transparent,
        Colors.white.withOpacity(0.08),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
    final rect = Rect.fromLTWH(shimmerX, 0, size.width * 0.7, size.height);
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) => old.progress != progress;
}

// ─── Stars Painter ────────────────────────────────────────────────────────────
class _StarsPainter extends CustomPainter {
  final double animValue;
  final List<Offset> starPositions;
  final List<double> starSizes;

  _StarsPainter(this.animValue, this.starPositions, this.starSizes);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < starPositions.length; i++) {
      final opacity =
          0.2 + 0.5 * math.sin(animValue * math.pi * 2 + i * 0.7).abs();
      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(starPositions[i].dx * size.width,
            starPositions[i].dy * size.height),
        starSizes[i],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarsPainter old) => old.animValue != animValue;
}

// ─── Main Screen ──────────────────────────────────────────────────────────────
class ShowPlanScreen extends StatefulWidget {
  const ShowPlanScreen({super.key});

  @override
  State<ShowPlanScreen> createState() => _ShowPlanScreenState();
}

class _ShowPlanScreenState extends State<ShowPlanScreen>
    with TickerProviderStateMixin {
  List<Plan> _plans = [];
  bool _isLoading = true;
  String? _error;
  int _selectedPlanIndex = 0;

  late AnimationController _bgAnimController;
  late AnimationController _cardAnimController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;

  late Animation<double> _cardSlideAnim;
  late Animation<double> _cardFadeAnim;
  late Animation<double> _pulseAnim;

  // Random star positions (generated once)
  final List<Offset> _starPositions = List.generate(
    40,
    (i) => Offset(
      (i * 137.508 % 100) / 100,
      (i * 97.3 % 100) / 100,
    ),
  );
  final List<double> _starSizes = List.generate(
    40,
    (i) => 0.5 + (i % 3) * 0.5,
  );

  @override
  void initState() {
    super.initState();

    _bgAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _cardSlideAnim = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(parent: _cardAnimController, curve: Curves.easeOutCubic),
    );
    _cardFadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardAnimController, curve: Curves.easeOut),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fetchPlans();
  }

  @override
  void dispose() {
    _bgAnimController.dispose();
    _cardAnimController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlans() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/plans/getallplan'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final plans =
            (data['plans'] as List).map((p) => Plan.fromJson(p)).toList();
        setState(() {
          _plans = plans;
          _isLoading = false;
        });
        _cardAnimController.forward(from: 0);
      } else {
        setState(() {
          _error = 'Failed to load plans (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1E),
      body: AnimatedBuilder(
        animation: _bgAnimController,
        builder: (context, child) {
          return Stack(
            children: [
              // ── Animated starfield background ──
              Positioned.fill(
                child: CustomPaint(
                  painter: _StarsPainter(
                    _bgAnimController.value,
                    _starPositions,
                    _starSizes,
                  ),
                ),
              ),

              // ── Glow orbs ──
              Positioned(
                top: -80,
                left: -60,
                child: _glowOrb(200, const Color(0xFF6C3DE8), 0.25),
              ),
              Positioned(
                top: 120,
                right: -80,
                child: _glowOrb(180, const Color(0xFFE83D8C), 0.2),
              ),
              Positioned(
                bottom: 100,
                left: -40,
                child: _glowOrb(160, const Color(0xFF3DE8C8), 0.15),
              ),

              child!,
            ],
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glowOrb(double size, Color color, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(opacity),
              blurRadius: size * 0.8,
              spreadRadius: size * 0.3,
            ),
          ],
          color: color.withOpacity(0.05),
        ),
      );

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.1), width: 1),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 16),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C3DE8), Color(0xFFE83D8C)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.workspace_premium,
                        color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'UPGRADE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500), Color(0xFFFF6B6B)],
            ).createShader(bounds),
            child: const Text(
              'Choose Your Plan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Unlock premium features & grow faster',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoadingState();
    if (_error != null) return _buildErrorState();
    if (_plans.isEmpty) return _buildEmptyState();
    return _buildPlansContent();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF6C3DE8),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading plans...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  color: Colors.redAccent, size: 34),
            ),
            const SizedBox(height: 20),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7), fontSize: 14),
            ),
            const SizedBox(height: 24),
            _gradientButton('Try Again', _fetchPlans),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No plans available',
        style: TextStyle(color: Colors.white.withOpacity(0.5)),
      ),
    );
  }

  Widget _buildPlansContent() {
    return AnimatedBuilder(
      animation: Listenable.merge([_cardSlideAnim, _cardFadeAnim]),
      builder: (context, child) => Opacity(
        opacity: _cardFadeAnim.value,
        child: Transform.translate(
          offset: Offset(0, _cardSlideAnim.value),
          child: child,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                return _buildPlanCard(_plans[index], index);
              },
            ),
          ),
          _buildBottomCTA(),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Plan plan, int index) {
    final isSelected = _selectedPlanIndex == index;
    final isPopular = index == 0;

    // Duration label
    final durationMonths = int.tryParse(plan.duration) ?? 1;
    final durationLabel = durationMonths == 1
        ? '1 Month'
        : durationMonths == 12
            ? '1 Year'
            : '$durationMonths Months';

    return GestureDetector(
      onTap: () => setState(() => _selectedPlanIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD700)
                : Colors.white.withOpacity(0.08),
            width: isSelected ? 2 : 1,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    const Color(0xFF1E1540).withOpacity(0.95),
                    const Color(0xFF2A1060).withOpacity(0.95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.04),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6C3DE8).withOpacity(0.3),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Shimmer effect on selected card
              if (isSelected)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, _) => CustomPaint(
                      painter: _ShimmerPainter(_shimmerController.value),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top Row ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Plan icon
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF6C3DE8),
                                          Color(0xFFE83D8C)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.workspace_premium,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      plan.name.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3DE8C8).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF3DE8C8).withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  '⏱  $durationLabel',
                                  style: const TextStyle(
                                    color: Color(0xFF3DE8C8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ── Price block ──
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (isPopular)
                              Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFD700),
                                      Color(0xFFFFA500)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '🔥 POPULAR',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '₹',
                                  style: TextStyle(
                                    color: Color(0xFFFFD700),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${plan.offerPrice}',
                                  style: const TextStyle(
                                    color: Color(0xFFFFD700),
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '₹${plan.originalPrice}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.35),
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                                decorationColor:
                                    Colors.white.withOpacity(0.35),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Divider ──
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Discount badge ──
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.greenAccent.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_offer_rounded,
                                  color: Colors.greenAccent, size: 13),
                              const SizedBox(width: 4),
                              Text(
                                'Save ${plan.discountPercentage}%',
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'You save ₹${plan.originalPrice - plan.offerPrice}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ── Features ──
                    ...plan.features.map((feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6C3DE8),
                                      Color(0xFF3DE8C8)
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check,
                                    color: Colors.white, size: 12),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),

                    const SizedBox(height: 4),

                    // ── Selected indicator ──
                    if (isSelected)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFFFD700).withOpacity(0.4),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Color(0xFFFFD700), size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Selected',
                                  style: TextStyle(
                                    color: Color(0xFFFFD700),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildBottomCTA() {
    if (_plans.isEmpty) return const SizedBox.shrink();
    final selectedPlan = _plans[_selectedPlanIndex];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0B1E),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected: ${selectedPlan.name}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              Text(
                '₹${selectedPlan.offerPrice} total',
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (context, child) => Transform.scale(
              scale: _pulseAnim.value,
              child: child,
            ),
            child: _gradientButton(
              '🚀  Get Started — ₹${selectedPlan.offerPrice}',
              () {
                // Handle purchase
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '🔒  Secure payment  •  Cancel anytime',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C3DE8), Color(0xFFE83D8C)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C3DE8).withOpacity(0.45),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}