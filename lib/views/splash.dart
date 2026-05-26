import 'package:flutter/material.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:posternova/views/AuthModule/auth_screen.dart';
import 'package:posternova/views/NavBar/navbar_screen.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  int _currentDot = 0;
  Timer? _dotTimer;
  bool _isCheckingLogin = false; // prevents double-tap

  // Controllers
  late AnimationController _logoController;
  late AnimationController _textWaveController;
  late AnimationController _shimmerController;
  late AnimationController _taglineController;
  late AnimationController _buttonController;
  late AnimationController _floatController;
  late AnimationController _glowController;

  // Logo animations
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _logoRotate;

  // Shimmer on name
  late Animation<double> _shimmer;

  // Tagline
  late Animation<Offset> _taglineSlide;
  late Animation<double> _taglineFade;

  // Button
  late Animation<double> _buttonScale;
  late Animation<double> _buttonFade;

  // Logo floating
  late Animation<double> _float;

  // Glow pulse
  late Animation<double> _glow;

  final String _appName = 'Edit Ezy';

  static const Color _tealDark = Color(0xFF0077A8);
  static const Color _tealLight = Color(0xFF00BCD4);
  static const Color _accent = Color(0xFF00E5FF);
  static const Color _bgTop = Color(0xFFF0FAFE);
  static const Color _bgBottom = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _logoScale = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoRotate = Tween<double>(begin: -0.15, end: 0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _textWaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _shimmer = Tween<double>(begin: -2, end: 3).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _taglineSlide = Tween<Offset>(begin: const Offset(0, 1.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _taglineController,
            curve: Curves.easeOutCubic,
          ),
        );
    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _buttonScale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOutBack),
    );
    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _float = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.3, end: 0.9).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        _shimmerController.repeat(period: const Duration(seconds: 3));
      }
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _taglineController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) _buttonController.forward();
    });

    _dotTimer = Timer.periodic(const Duration(milliseconds: 750), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_currentDot < 3) {
        setState(() => _currentDot++);
      } else {
        t.cancel();
      }
    });

    // ── AUTO-CHECK LOGIN on launch ──────────────────────────────
    // After a short splash delay, silently check if already logged in.
    // If yes → go straight to MainNavigationScreen.
    // If no  → stay on this screen and wait for the user to tap the button.
    _autoCheckLogin();
  }

  /// Called once on init. Waits for the splash animations to feel complete,
  /// then checks login state. If logged in, navigates away immediately.
  // Future<void> _autoCheckLogin() async {
  //   // Give animations time to play (matches the dot-timer + button reveal)
  //   await Future.delayed(const Duration(milliseconds: 1600));
  //   if (!mounted) return;

  //   try {
  //     final isLoggedIn = await AuthPreferences.isLoggedIn();
  //     final userData = await AuthPreferences.getUserData();

  //     if (!mounted) return;

  //     if (isLoggedIn && userData != null) {
  //       // User is already authenticated → skip splash entirely
  //       final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //       await authProvider.initialize();
  //       if (!mounted) return;
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => MainNavigationScreen()),
  //       );
  //     }
  //     // else: not logged in → stay on screen, wait for button tap
  //   } catch (_) {
  //     // On any error just stay on the splash screen
  //   }
  // }




////// This is the new code for auto navigate without that button///

  Future<void> _autoCheckLogin() async {
  await Future.delayed(const Duration(milliseconds: 2000)); // splash display time
  if (!mounted) return;

  try {
    final isLoggedIn = await AuthPreferences.isLoggedIn();
    final userData = await AuthPreferences.getUserData();

    if (!mounted) return;

    if (isLoggedIn && userData != null) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initialize();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigationScreen()),
      );
    } else {
      // ← Auto-navigate to AuthScreen instead of waiting for button tap
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  } catch (_) {
    // On error, still go to AuthScreen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }
}

  /// Called when the user taps "Agree to terms & Continue".
  /// Shows the Truecaller-style verification bottom sheet.
  void _showVerificationBottomSheet() {
    if (_isCheckingLogin) return; // debounce
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   barrierColor: Colors.black.withOpacity(0.5),
    //   builder: (context) => _VerificationBottomSheet(
    //     onUseNumber: () {
    //       Navigator.pop(context);
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (_) => const AuthScreen()),
    //       );
    //     },
    //     onSkip: () {
    //       Navigator.pop(context);
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (_) => const AuthScreen()),
    //       );
    //     },
    //   ),
    // );
  }

  @override
  void dispose() {
    _dotTimer?.cancel();
    _logoController.dispose();
    _textWaveController.dispose();
    _shimmerController.dispose();
    _taglineController.dispose();
    _buttonController.dispose();
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Widget _waveLetter(
    String letter,
    int index,
    Animation<double> wave,
    Animation<double> shimmerAnim,
  ) {
    return AnimatedBuilder(
      animation: Listenable.merge([wave, shimmerAnim]),
      builder: (_, __) {
        final offset =
            math.sin((wave.value * 2 * math.pi) + (index * 0.6)) * 10.0;
        final t = ((shimmerAnim.value - index * 0.25) % 4) / 4;
        final Color letterColor =
            Color.lerp(
              _tealDark,
              _accent,
              (math.sin(t * math.pi).clamp(0.0, 1.0)),
            ) ??
            _tealDark;

        return Transform.translate(
          offset: Offset(0, offset),
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: letterColor,
              letterSpacing: 1,
              shadows: [
                Shadow(
                  color: _tealLight.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── CENTRE / LOGO SECTION ──────────────────────────
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Floating logo with glow
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _glow,
                          _float,
                          _logoController,
                        ]),
                        builder: (_, __) {
                          return Transform.translate(
                            offset: Offset(0, _float.value),
                            child: FadeTransition(
                              opacity: _logoFade,
                              child: Transform.scale(
                                scale: _logoScale.value,
                                child: Transform.rotate(
                                  angle: _logoRotate.value,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Outer glow rings
                                      Container(
                                        width: 180,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: _tealLight.withOpacity(
                                                _glow.value * 0.5,
                                              ),
                                              blurRadius: 50,
                                              spreadRadius: 10,
                                            ),
                                            BoxShadow(
                                              color: _accent.withOpacity(
                                                _glow.value * 0.3,
                                              ),
                                              blurRadius: 80,
                                              spreadRadius: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // App icon
                                      Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            32,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _tealDark.withOpacity(
                                                0.25,
                                              ),
                                              blurRadius: 24,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            32,
                                          ),
                                          child: Image.asset(
                                            'assets/mainlogo.jpeg',
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          32,
                                                        ),
                                                    gradient:
                                                        const LinearGradient(
                                                          colors: [
                                                            _tealDark,
                                                            _tealLight,
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.edit,
                                                    size: 70,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 36),

                      // Waving + shimmering app name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          _appName.length,
                          (i) => _waveLetter(
                            _appName[i],
                            i,
                            _textWaveController,
                            _shimmer,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Tagline slide-in
                      ClipRect(
                        child: SlideTransition(
                          position: _taglineSlide,
                          child: FadeTransition(
                            opacity: _taglineFade,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _dot(_tealDark),
                                const SizedBox(width: 8),
                                Text('Create', style: _tagStyle(_tealDark)),
                                const SizedBox(width: 8),
                                _dot(_tealLight),
                                const SizedBox(width: 8),
                                Text('Manage', style: _tagStyle(_tealLight)),
                                const SizedBox(width: 8),
                                _dot(_accent),
                                const SizedBox(width: 8),
                                Text('Grow', style: _tagStyle(_accent)),
                                const SizedBox(width: 8),
                                _dot(_tealDark),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── BOTTOM SECTION ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
                child: Column(
                  children: [
                    // Progress dots
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: List.generate(4, (i) {
                    //     final active = i == _currentDot;
                    //     return AnimatedContainer(
                    //       duration: const Duration(milliseconds: 350),
                    //       curve: Curves.easeInOut,
                    //       margin: const EdgeInsets.symmetric(horizontal: 5),
                    //       width: active ? 24 : 8,
                    //       height: 8,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(4),
                    //         color: active ? _tealDark : Colors.grey.shade300,
                    //       ),
                    //     );
                    //   }),
                    // ),

                    // const SizedBox(height: 28),

                    // "Agree to terms & Continue" button
                    // ScaleTransition(
                    //   scale: _buttonScale,
                    //   child: FadeTransition(
                    //     opacity: _buttonFade,
                    //     child: SizedBox(
                    //       width: double.infinity,
                    //       height: 56,
                    //       child: DecoratedBox(
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(16),
                    //           gradient: const LinearGradient(
                    //             colors: [_tealDark, _tealLight],
                    //             begin: Alignment.centerLeft,
                    //             end: Alignment.centerRight,
                    //           ),
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: _tealDark.withOpacity(0.4),
                    //               blurRadius: 18,
                    //               offset: const Offset(0, 6),
                    //             ),
                    //           ],
                    //         ),
                    //         child: ElevatedButton(
                    //           onPressed: _showVerificationBottomSheet,
                    //           style: ElevatedButton.styleFrom(
                    //             backgroundColor: Colors.transparent,
                    //             shadowColor: Colors.transparent,
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(16),
                    //             ),
                    //           ),
                    //           child: const Text(
                    //             'Agree to terms & Continue',
                    //             style: TextStyle(
                    //               fontSize: 16,
                    //               fontWeight: FontWeight.w700,
                    //               color: Colors.white,
                    //               letterSpacing: 0.4,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(height: 18),

                    FadeTransition(
                      opacity: _buttonFade,
                      child: GestureDetector(
                        onTap: () {
                          final Uri url = Uri.parse(
                            'https://editezy.onrender.com/privacy-and-policy',
                          );
                          launchUrl(url);
                        },
                        child: const Text(
                          'Terms & Privacy policies',
                          style: TextStyle(
                            fontSize: 13,
                            color: _tealDark,
                            decoration: TextDecoration.underline,
                            decorationColor: _tealDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _tagStyle(Color color) => TextStyle(
    fontSize: 13,
    color: color,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w500,
  );

  Widget _dot(Color color) => Container(
    width: 4,
    height: 4,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

// ══════════════════════════════════════════════════════════════════
//  Verification Bottom Sheet  (Truecaller-style)
// ══════════════════════════════════════════════════════════════════
class _VerificationBottomSheet extends StatefulWidget {
  final VoidCallback onUseNumber;
  final VoidCallback onSkip;

  const _VerificationBottomSheet({
    required this.onUseNumber,
    required this.onSkip,
  });

  @override
  State<_VerificationBottomSheet> createState() =>
      _VerificationBottomSheetState();
}

class _VerificationBottomSheetState extends State<_VerificationBottomSheet>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Replace with real number from device / Truecaller SDK
  static const String _phoneNumber = '9961593179';

  static const Color _tealDark = Color(0xFF0077A8);
  static const Color _tealLight = Color(0xFF00BCD4);

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const SizedBox(height: 24),

            // ── White card section ──
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Hi,',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'To get started, please verify mobile number',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // USE NUMBER button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: widget.onUseNumber,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _tealDark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'USE $_phoneNumber',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // SKIP
                  Center(
                    child: GestureDetector(
                      onTap: widget.onSkip,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'SKIP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Divider(color: Colors.grey.shade200, height: 1),
                  const SizedBox(height: 14),

                  // Consent text
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Colors.black45,
                              height: 1.5,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    'By continuing you consent to share your name and number with ',
                              ),
                              const TextSpan(
                                text: 'EditEzy',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black54,
                                ),
                              ),
                              const TextSpan(text: ', and agree to the '),
                              TextSpan(
                                text: 'privacy policy',
                                style: const TextStyle(
                                  color: Color(0xFF0077A8),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'terms of service',
                                style: const TextStyle(
                                  color: Color(0xFF0077A8),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(text: ' of '),
                              const TextSpan(
                                text: 'EditEzy',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black54,
                                ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => _expanded = !_expanded),
                        child: Icon(
                          _expanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.black38,
                          size: 22,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Truecaller badge
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Instant Verification by ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          'truecaller',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
