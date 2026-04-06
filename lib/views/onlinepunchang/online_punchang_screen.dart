import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';

// ─── Animated background painter ───────────────────────────────────────────
class _MandalaBackgroundPainter extends CustomPainter {
  final double animation;
  _MandalaBackgroundPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final cx = size.width * 0.85;
    final cy = size.height * 0.12;

    for (int i = 0; i < 6; i++) {
      final radius = 40.0 + i * 20;
      final opacity = (0.06 - i * 0.008).clamp(0.0, 1.0);
      paint.color = Color.fromRGBO(255, 100, 20, opacity.toDouble());
      final angle = animation * math.pi * 2 + i * math.pi / 6;
      for (int j = 0; j < 8; j++) {
        final a = angle + j * math.pi / 4;
        final x = cx + radius * math.cos(a);
        final y = cy + radius * math.sin(a);
        canvas.drawCircle(Offset(x, y), 3, paint);
      }
      canvas.drawCircle(Offset(cx, cy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_MandalaBackgroundPainter old) =>
      old.animation != animation;
}

// ─── Shimmer loading widget ─────────────────────────────────────────────────
class _ShimmerBox extends StatefulWidget {
  final double width, height;
  final double radius;
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 12,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value, 0),
            colors: [
              Colors.orange.shade50,
              Colors.orange.shade100,
              Colors.orange.shade50,
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Animated entry widget ──────────────────────────────────────────────────
class _FadeSlide extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _FadeSlide({required this.child, this.delay = Duration.zero});

  @override
  State<_FadeSlide> createState() => _FadeSlideState();
}

class _FadeSlideState extends State<_FadeSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade, _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _fade.value,
        child: Transform.translate(
          offset: Offset(0, _slide.value),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

// ─── Main Screen ────────────────────────────────────────────────────────────
class OnlinePunchangScreen extends StatefulWidget {
  const OnlinePunchangScreen({super.key});

  @override
  State<OnlinePunchangScreen> createState() => _OnlinePunchangScreenState();
}

class _OnlinePunchangScreenState extends State<OnlinePunchangScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  Map<String, dynamic>? panchangData;
  String? errorMessage;
  DateTime selectedDate = DateTime.now();
  final TextEditingController _locationController = TextEditingController();
  String location = 'Hyderabad, Telangana, India';
  String? _userName;

  late AnimationController _bgCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('hi');
    initializeDateFormatting('en');
    _locationController.text = location;

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _fetchUserName();
    _fetchPanchangData();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _pulseCtrl.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // ── helpers ────────────────────────────────────────────────
  String _t(String key) {
    final lp = Provider.of<LanguageProvider>(context, listen: false);
    return LocalizationService.translate(key, lp.locale.languageCode);
  }

  String get _langCode {
    final lp = Provider.of<LanguageProvider>(context, listen: false);
    return lp.locale.languageCode;
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('dd MMMM yyyy', _langCode).format(date);
    } catch (_) {
      return DateFormat('dd MMMM yyyy', 'en').format(date);
    }
  }

  String _formatTime(String? isoTime) {
    if (isoTime == null) return 'N/A';
    try {
      return DateFormat('hh:mm a').format(DateTime.parse(isoTime).toLocal());
    } catch (_) {
      return 'N/A';
    }
  }

  Future<void> _fetchUserName() async {
    try {
      final userData = await AuthPreferences.getUserData();
      if (userData == null) return;
      final userId = userData.user.id;
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/users/get-profile/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _userName = data['name']?.toString());
      }
    } catch (e) {
      debugPrint('Profile fetch error: $e');
    }
  }

  Future<void> _fetchPanchangData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      panchangData = null;
    });

    try {
      final userData = await AuthPreferences.getUserData();
      if (userData == null) {
        setState(() {
          errorMessage = _t('user_not_logged_in');
          isLoading = false;
        });
        return;
      }

      final userId = userData.user.id;
      final url = 'http://31.97.206.144:4061/api/users/panchang/$userId';
      final payload = {
        "year": selectedDate.year,
        "month": selectedDate.month,
        "date": selectedDate.day,
        "location": location,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print('Response status code for online punchang ${response.statusCode}');
      print(
        'Response bodyyyyyyyyyyy code for online punchang ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['data'] != null) {
          setState(() {
            panchangData = data;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = _t('panchang_no_data');
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = _t('panchang_load_failed');
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '${_t('error_prefix')}: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFE64A19),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      await _fetchPanchangData();
    }
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          _t('panchang_change_location'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: _t('location'),
            hintText: _t('panchang_location_hint'),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.location_on, color: Color(0xFFE64A19)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE64A19), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(_t('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => location = _locationController.text.trim());
              Navigator.pop(ctx);
              _fetchPanchangData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE64A19),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(_t('save')),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── BUILD ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, _, __) => Scaffold(
        backgroundColor: const Color(0xFFFFF8F3),
        body: AnimatedBuilder(
          animation: _bgCtrl,
          builder: (_, child) => CustomPaint(
            painter: _MandalaBackgroundPainter(_bgCtrl.value),
            child: child,
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: isLoading
                      ? _buildLoadingState()
                      : errorMessage != null
                      ? _buildErrorState()
                      : _buildPanchangContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFBF360C), Color(0xFFE64A19), Color(0xFFFF8F00)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x40E64A19),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🪔 ${_t('online_punchang')}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    _t('panchang_subtitle') ?? 'Vedic Daily Almanac',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (_, child) =>
                    Transform.scale(scale: _pulseAnim.value, child: child),
                child: GestureDetector(
                  onTap: _fetchPanchangData,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildHeaderChip(
                  Icons.calendar_today_rounded,
                  _formatDate(selectedDate),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildHeaderChip(
                  Icons.location_on_rounded,
                  location,
                  onTap: _showLocationDialog,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderChip(
    IconData icon,
    String label, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }

  // ─── Loading State ─────────────────────────────────────────────────────────
  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _ShimmerBox(width: double.infinity, height: 90, radius: 20),
          const SizedBox(height: 16),
          _ShimmerBox(width: double.infinity, height: 70, radius: 16),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: 100,
                  radius: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: 100,
                  radius: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: 100,
                  radius: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: 100,
                  radius: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ShimmerBox(width: double.infinity, height: 160, radius: 20),
          const SizedBox(height: 16),
          _ShimmerBox(width: double.infinity, height: 200, radius: 20),
        ],
      ),
    );
  }

  // ─── Error State ───────────────────────────────────────────────────────────
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red.shade100, width: 2),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 52,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              errorMessage ?? _t('panchang_no_data'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.red.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _fetchPanchangData,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(_t('panchang_retry')),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE64A19),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Main Content ──────────────────────────────────────────────────────────
  Widget _buildPanchangContent() {
    if (panchangData == null || panchangData!['data'] == null)
      return _buildErrorState();
    final data = panchangData!['data'] as Map<String, dynamic>;
    final user = panchangData!['user'] as Map<String, dynamic>?;
    final addInfo = data['additionalInfo'] as Map<String, dynamic>?;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          if (user != null)
            _FadeSlide(
              delay: const Duration(milliseconds: 0),
              child: _buildUserInfo(user),
            ),
          const SizedBox(height: 14),

          // Vaara banner
          if (data['vaara'] != null)
            _FadeSlide(
              delay: const Duration(milliseconds: 60),
              child: _buildVaaraCard(data['vaara']),
            ),
          const SizedBox(height: 14),

          // Sun / Moon 4-column grid
          _FadeSlide(
            delay: const Duration(milliseconds: 120),
            child: _buildSunMoonGrid(data),
          ),
          const SizedBox(height: 14),

          // Auspicious / Inauspicious banner
          if (addInfo != null)
            _FadeSlide(
              delay: const Duration(milliseconds: 180),
              child: _buildAuspiciousBanner(addInfo),
            ),
          const SizedBox(height: 14),

          // Panchang elements grid: Tithi / Nakshatra / Yoga / Karana
          _FadeSlide(
            delay: const Duration(milliseconds: 240),
            child: _buildPanchangElementsGrid(data),
          ),
          const SizedBox(height: 14),

          // Lucky info
          if (addInfo?['lucky'] != null)
            _FadeSlide(
              delay: const Duration(milliseconds: 300),
              child: _buildLuckyCard(addInfo!['lucky']),
            ),
          const SizedBox(height: 14),

          // Deity card
          if (addInfo?['deity'] != null)
            _FadeSlide(
              delay: const Duration(milliseconds: 360),
              child: _buildDeityCard(addInfo!['deity']),
            ),
          const SizedBox(height: 14),

          // Nakshatra details
          if (addInfo?['nakshatra'] != null)
            _FadeSlide(
              delay: const Duration(milliseconds: 420),
              child: _buildNakshatraDetailsCard(addInfo!['nakshatra']),
            ),
          const SizedBox(height: 14),

          // Do's & Don'ts
          if (addInfo?['dosDonts'] != null)
            _FadeSlide(
              delay: const Duration(milliseconds: 480),
              child: _buildDosDonts(addInfo!['dosDonts']),
            ),
          const SizedBox(height: 14),

          // Recommendations
          if (addInfo?['recommendations'] != null)
            _FadeSlide(
              delay: const Duration(milliseconds: 540),
              child: _buildRecommendations(addInfo!['recommendations']),
            ),
        ],
      ),
    );
  }

  // ─── User Info Card ────────────────────────────────────────────────────────
  Widget _buildUserInfo(Map<String, dynamic> user) {
    final name = _userName ?? user['name']?.toString() ?? _t('user');
    final dob = user['dob']?.toString() ?? 'N/A';
    final email = user['email']?.toString();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE64A19), Color(0xFFFF8F00)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                // if (email != null) ...[
                //   const SizedBox(height: 2),
                //   Text(email, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                // ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.cake_rounded,
                      size: 13,
                      color: Color(0xFFE64A19),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dob,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFE64A19),
                        fontWeight: FontWeight.w600,
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
  }

  // ─── Vaara Banner ──────────────────────────────────────────────────────────
  Widget _buildVaaraCard(String vaara) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFFAD1457)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B1FA2).withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _t('panchang_vaara'),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white60,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                vaara,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Text('🕉️', style: TextStyle(fontSize: 42)),
        ],
      ),
    );
  }

  // ─── Sun / Moon 2×2 GridView ────────────────────────────────────────────────
  Widget _buildSunMoonGrid(Map<String, dynamic> data) {
    final items = [
      {
        'icon': '☀️',
        'label': _t('panchang_sunrise'),
        'time': _formatTime(data['sunrise']),
        'color': const Color(0xFFFB8C00),
        'bg': const Color(0xFFFFF8E1),
        'subtitle': 'Rise',
      },
      {
        'icon': '🌅',
        'label': _t('panchang_sunset'),
        'time': _formatTime(data['sunset']),
        'color': const Color(0xFFE64A19),
        'bg': const Color(0xFFFBE9E7),
        'subtitle': 'Set',
      },
      {
        'icon': '🌙',
        'label': _t('panchang_moonrise') ?? 'Moonrise',
        'time': _formatTime(data['moonrise']),
        'color': const Color(0xFF5C6BC0),
        'bg': const Color(0xFFE8EAF6),
        'subtitle': 'Rise',
      },
      {
        'icon': '🌛',
        'label': _t('panchang_moonset') ?? 'Moonset',
        'time': _formatTime(data['moonset']),
        'color': const Color(0xFF283593),
        'bg': const Color(0xFFE8EAF6),
        'subtitle': 'Set',
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: items
          .map(
            (item) => _buildSunMoonCell(
              item['icon'] as String,
              item['label'] as String,
              item['time'] as String,
              item['subtitle'] as String,
              item['color'] as Color,
              item['bg'] as Color,
            ),
          )
          .toList(),
    );
  }

  Widget _buildSunMoonCell(
    String emoji,
    String label,
    String time,
    String subtitle,
    Color color,
    Color bg,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: color.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: color,
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

  // ─── Auspicious Banner ─────────────────────────────────────────────────────
  Widget _buildAuspiciousBanner(Map<String, dynamic> addInfo) {
    final auspicious = addInfo['auspicious'] as Map<String, dynamic>?;
    final inauspicious = addInfo['inauspicious'] as Map<String, dynamic>?;
    final isGoodDay = auspicious?['isGoodDay'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isGoodDay
              ? [const Color(0xFF1B5E20), const Color(0xFF388E3C)]
              : [const Color(0xFF4E342E), const Color(0xFF795548)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isGoodDay ? Colors.green : Colors.brown).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isGoodDay ? '✅' : '⚠️',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  auspicious?['reason']?.toString() ??
                      (isGoodDay ? 'Auspicious Day' : 'Be Cautious'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${auspicious?['multiplier'] ?? '1.0'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTimeRangeChip(
            '🕐',
            '${auspicious?['time']?['start'] ?? ''} – ${auspicious?['time']?['end'] ?? ''}',
            auspicious?['time']?['desc']?.toString() ?? '',
            Colors.greenAccent,
          ),
          if (inauspicious != null) ...[
            const SizedBox(height: 8),
            _buildTimeRangeChip(
              '🚫',
              '${inauspicious['time']?['start'] ?? ''} – ${inauspicious['time']?['end'] ?? ''}',
              inauspicious['time']?['desc']?.toString() ??
                  'Avoid important work',
              Colors.redAccent,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeRangeChip(
    String emoji,
    String time,
    String desc,
    Color chipColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(emoji),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: chipColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Panchang Elements Grid ────────────────────────────────────────────────
  Widget _buildPanchangElementsGrid(Map<String, dynamic> data) {
    final sections = [
      {
        'title': _t('panchang_tithi'),
        'icon': '🌑',
        'color': const Color(0xFF1565C0),
        'items': data['tithi'] as List<dynamic>? ?? [],
        'extra': (Map m) => m['paksha']?.toString(),
      },
      {
        'title': _t('panchang_nakshatra'),
        'icon': '⭐',
        'color': const Color(0xFF6A1B9A),
        'items': data['nakshatra'] as List<dynamic>? ?? [],
        'extra': null,
      },
      {
        'title': _t('panchang_yoga'),
        'icon': '🧘',
        'color': const Color(0xFF2E7D32),
        'items': data['yoga'] as List<dynamic>? ?? [],
        'extra': null,
      },
      {
        'title': _t('panchang_karana'),
        'icon': '⏳',
        'color': const Color(0xFFE65100),
        'items': data['karana'] as List<dynamic>? ?? [],
        'extra': null,
      },
    ];

    return Column(
      children: sections.map((section) {
        final items = section['items'] as List<dynamic>;
        final color = section['color'] as Color;
        final extraFn = section['extra'] as String? Function(Map)?;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDeco(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        section['icon'] as String,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      section['title'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...items.map((item) {
                  if (item == null) return const SizedBox.shrink();
                  final m = item as Map<String, dynamic>;
                  final extra = extraFn != null ? extraFn(m) : null;
                  return _buildElementItem(
                    m['name']?.toString() ?? 'N/A',
                    '${_formatTime(m['start'])} – ${_formatTime(m['end'])}',
                    extra,
                    color,
                  );
                }),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildElementItem(String name, String time, String? sub, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (sub != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Lucky Card ────────────────────────────────────────────────────────────
  Widget _buildLuckyCard(Map<String, dynamic> lucky) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('🍀', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 10),
              const Text(
                'Lucky Today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFAA8C00),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildLuckyChip(
                '🎨 Color',
                lucky['color']?.toString() ?? 'N/A',
                const Color(0xFFFFF9C4),
                const Color(0xFFAA8C00),
              ),
              _buildLuckyChip(
                '🔢 Number',
                lucky['number']?.toString() ?? 'N/A',
                const Color(0xFFE8EAF6),
                const Color(0xFF3949AB),
              ),
              _buildLuckyChip(
                '💎 Gem',
                lucky['gemstone']?.toString() ?? 'N/A',
                const Color(0xFFF3E5F5),
                const Color(0xFF7B1FA2),
              ),
              _buildLuckyChip(
                '🌊 Nakshatra Color',
                lucky['nakshatraColor']?.toString() ?? 'N/A',
                const Color(0xFFE3F2FD),
                const Color(0xFF1565C0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLuckyChip(String label, String value, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: fg.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: fg,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Deity Card ────────────────────────────────────────────────────────────
  Widget _buildDeityCard(Map<String, dynamic> deity) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3E0), Color(0xFFFFFDE7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFCC02).withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFCC02).withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🛕', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Deity',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.brown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    deity['name']?.toString() ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (deity['worshipMethod'] != null)
            _buildDeityRow('🙏', 'How to Worship', deity['worshipMethod']),
          if (deity['mantra'] != null) ...[
            const SizedBox(height: 8),
            _buildDeityRow('📿', 'Mantra', deity['mantra']),
          ],
        ],
      ),
    );
  }

  Widget _buildDeityRow(String emoji, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.brown,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4E342E),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Nakshatra Details Card ────────────────────────────────────────────────
  Widget _buildNakshatraDetailsCard(Map<String, dynamic> n) {
    final specialties =
        (n['specialties'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('✨', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 10),
              Text(
                'Nakshatra: ${n['name'] ?? ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF4A148C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoBadge(
                'Quality',
                n['quality']?.toString() ?? 'N/A',
                const Color(0xFFE8F5E9),
                const Color(0xFF2E7D32),
              ),
              _buildInfoBadge(
                'Element',
                n['element']?.toString() ?? 'N/A',
                const Color(0xFFE3F2FD),
                const Color(0xFF1565C0),
              ),
              _buildInfoBadge(
                'Gana',
                n['gana']?.toString() ?? 'N/A',
                const Color(0xFFF3E5F5),
                const Color(0xFF6A1B9A),
              ),
            ],
          ),
          if (specialties.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Specialties',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: specialties
                  .map(
                    (s) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A148C).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF4A148C).withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        s.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4A148C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoBadge(String label, String value, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: fg.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: fg,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Do's Card ─────────────────────────────────────────────────────────────
  Widget _buildDosCard(List<String> dos) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('✅', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 10),
              const Text(
                "Do's",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${dos.length}',
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...dos.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${e.key + 1}',
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e.value,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1A1A1A),
                        height: 1.5,
                        fontWeight: FontWeight.w500,
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
  }

  // ─── Don'ts Card ───────────────────────────────────────────────────────────
  Widget _buildDontsCard(List<String> donts) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC62828).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC62828).withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('🚫', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 10),
              const Text(
                "Don'ts",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFC62828),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${donts.length}',
                  style: const TextStyle(
                    color: Color(0xFFC62828),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...donts.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${e.key + 1}',
                      style: const TextStyle(
                        color: Color(0xFFC62828),
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e.value,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1A1A1A),
                        height: 1.5,
                        fontWeight: FontWeight.w500,
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
  }

  Widget _buildDosDonts(Map<String, dynamic> dosDonts) {
    final dos =
        (dosDonts['do'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
        [];
    final donts =
        (dosDonts['dont'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    return Column(
      children: [
        _buildDosCard(dos),
        const SizedBox(height: 12),
        _buildDontsCard(donts),
      ],
    );
  }

  // ─── Recommendations ───────────────────────────────────────────────────────
  Widget _buildRecommendations(Map<String, dynamic> rec) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1976D2).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🔮', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'Recommendations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (rec['bestFor'] != null)
                _buildRecChip('Best For', rec['bestFor']),
              if (rec['energy'] != null) _buildRecChip('Energy', rec['energy']),
              if (rec['planet'] != null) _buildRecChip('Planet', rec['planet']),
              if (rec['mood'] != null) _buildRecChip('Mood', rec['mood']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecChip(String label, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value.toString().toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Shared decoration ─────────────────────────────────────────────────────
  BoxDecoration _cardDeco() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
