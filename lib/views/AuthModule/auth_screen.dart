import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posternova/models/register_model.dart';
import 'package:posternova/providers/auth/google_provider.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:posternova/providers/auth/otp_provider.dart';
import 'package:posternova/providers/auth/register_provider.dart';
import 'package:posternova/views/NavBar/navbar_screen.dart';
import 'package:provider/provider.dart';

// ─── Auth Steps Enum ─────────────────────────────────────────────────────────
enum AuthStep { mobile, otp, signup }

// ─── Auth Screen ─────────────────────────────────────────────────────────────
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  // ── Theme Colors ──────────────────────────────────────────────────────────
  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  Color get _bg1 =>
      _isDarkMode ? const Color(0xFF0A0E21) : const Color(0xFFF5F5F5);
  Color get _bg2 =>
      _isDarkMode ? const Color(0xFF1D1E33) : const Color(0xFFFFFFFF);
  Color get _purple => const Color(0xFF6C63FF);
  Color get _blue => const Color(0xFF448AFF);
  Color get _textPrimary =>
      _isDarkMode ? Colors.white : const Color(0xFF1A1A1A);
  Color get _textSecondary =>
      _isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
  Color get _cardBg =>
      _isDarkMode ? const Color(0xFF12132A) : Colors.grey.shade50;
  Color get _inputBg =>
      _isDarkMode ? const Color(0xFF0A0E21) : Colors.grey.shade100;

  // ── OTP Length (Always 6 for Twilio) ───────────────────────────────────
  static const int _otpLength = 4;

  // ── State ────────────────────────────────────────────────────────────────
  AuthStep _step = AuthStep.mobile;

  // Mobile step
  final _mobileCtrl = TextEditingController();

  // OTP step
  final List<TextEditingController> _otpCtrls = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocus = List.generate(4, (_) => FocusNode());
  int _resendSeconds = 30;
  late final AnimationController _resendTimer;

  // Signup step
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _referralCtrl = TextEditingController();
  String? _gender;
  DateTime? _dob;
  DateTime? _anniversary;
  bool _isMobileLocked = false;

  // ── Animations ───────────────────────────────────────────────────────────
  late final AnimationController _floatCtrl;
  late final Animation<double> _floatAnim;

  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmerAnim;

  late final AnimationController _slideCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  // ── Bypass Numbers (for testing/playstore) ───────────────────────────────
  static const List<String> _bypassNumbers = ['9849008143', '9744037599'];

  // ── Helpers ───────────────────────────────────────────────────────────────
  bool get _isBypassNumber => _bypassNumbers.contains(_mobileCtrl.text.trim());

  @override
  void initState() {
    super.initState();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _shimmerAnim = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear));

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
    _fadeAnim = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);

    _resendTimer = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _shimmerCtrl.dispose();
    _slideCtrl.dispose();
    _resendTimer.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _brandCtrl.dispose();
    _referralCtrl.dispose();
    for (final c in _otpCtrls) {
      c.dispose();
    }
    for (final f in _otpFocus) {
      f.dispose();
    }
    _nameCtrl.dispose();
    super.dispose();
  }

  // ── Navigation ───────────────────────────────────────────────────────────
  void _goTo(AuthStep step) {
    _slideCtrl.reset();
    setState(() => _step = step);
    _slideCtrl.forward();
  }

  void _startResendTimer() {
    _resendSeconds = 30;
    _resendTimer.reset();
    _resendTimer.forward();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendSeconds--);
      return _resendSeconds > 0;
    });
  }

  // ── Backend Logic (Twilio - No Firebase) ─────────────────────────────────

  Future<void> _handleSendOtp() async {
    final mobile = _mobileCtrl.text.trim();

    if (mobile.length != 10) {
      _snack('Please enter a valid 10-digit mobile number');
      return;
    }

    final smsProvider = Provider.of<SmsProvider>(context, listen: false);

    if (_isBypassNumber) {
      _snack('OTP sent successfully!');
      _goTo(AuthStep.otp);
      _startResendTimer();
      return;
    }

    final res = await smsProvider.login(mobile);

    if (res) {
      _snack('OTP sent successfully!');
      _goTo(AuthStep.otp);
      _startResendTimer();
    } else {
      _snack(smsProvider.errorMessage ?? 'Failed to send OTP');
    }
  }

  Future<void> _handleVerifyOtp() async {
    final mobile = _mobileCtrl.text.trim();
    final enteredOtp = _otpCtrls.take(_otpLength).map((c) => c.text).join();

    if (enteredOtp.length < _otpLength) {
      _snack('Please enter the complete $_otpLength-digit OTP');
      return;
    }

    final smsProvider = Provider.of<SmsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_isBypassNumber) {
      await smsProvider.verifyOtp(enteredOtp, mobile, context);

      if (smsProvider.otpResponse?.statusCode == 200) {
        final userData = jsonDecode(smsProvider.otpResponse!.body);
        final user = userData['user'];

        final hasName =
            user['name'] != null && user['name'].toString().isNotEmpty;
        final hasEmail =
            user['email'] != null && user['email'].toString().isNotEmpty;

        if (!hasName || !hasEmail) {
          setState(() => _isMobileLocked = true);
          _goTo(AuthStep.signup);
          return;
        }

        final success = await authProvider.login(mobile);
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainNavigationScreen()),
          );
        }
      } else {
        _snack("Invalid OTP");
      }
      return;
    }

    await smsProvider.verifyOtp(enteredOtp, mobile, context);

    if (smsProvider.otpResponse?.statusCode == 200) {
      final userData = jsonDecode(smsProvider.otpResponse!.body);
      final user = userData['user'];

      final hasName =
          user['name'] != null && user['name'].toString().isNotEmpty;
      final hasEmail =
          user['email'] != null && user['email'].toString().isNotEmpty;

      if (!hasName || !hasEmail) {
        setState(() => _isMobileLocked = true);
        _goTo(AuthStep.signup);
        return;
      }

      final success = await authProvider.login(mobile);
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainNavigationScreen()),
        );
      }
    } else {
      _snack(smsProvider.errorMessage ?? "Invalid OTP");
    }
  }

  Future<void> _handleResendOtp() async {
    final mobile = _mobileCtrl.text.trim();
    final smsProvider = Provider.of<SmsProvider>(context, listen: false);

    if (_isBypassNumber) {
      for (int i = 0; i < _otpLength; i++) {
        _otpCtrls[i].clear();
      }
      _startResendTimer();
      _snack('OTP resent successfully!');
      return;
    }

    final res = await smsProvider.resendOtp(mobile);

    if (res) {
      _snack('OTP resent successfully!');
    } else {
      _snack(smsProvider.errorMessage ?? 'Failed to resend OTP');
    }

    // if (smsProvider.resendOtpResponse?.statusCode == 200) {
    //   for (int i = 0; i < _otpLength; i++) {
    //     _otpCtrls[i].clear();
    //   }
    //   _startResendTimer();
    //   _snack('OTP resent successfully!');
    // } else {
    //   _snack(smsProvider.errorMessage ?? 'Failed to resend OTP');
    // }
  }

  Future<void> _handleSignup() async {
    if (_nameCtrl.text.trim().isEmpty) {
      _snack('Please enter your name');
      return;
    }
    if (_emailCtrl.text.trim().isEmpty) {
      _snack('Please enter your email');
      return;
    }
    if (_mobileCtrl.text.trim().isEmpty ||
        _mobileCtrl.text.trim().length != 10) {
      _snack('Please enter a valid 10-digit mobile number');
      return;
    }

    final signupProvider = Provider.of<SignupProvider>(context, listen: false);

    final signupModel = SignupModel(
      id: '',
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      mobile: _mobileCtrl.text.trim(),
      dob: _dob != null
          ? '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}'
          : null,
      marriageAnniversary: _anniversary != null
          ? '${_anniversary!.year}-${_anniversary!.month.toString().padLeft(2, '0')}-${_anniversary!.day.toString().padLeft(2, '0')}'
          : null,
      referralCode: _referralCtrl.text.trim().isEmpty
          ? null
          : _referralCtrl.text.trim(),
    );

    final success = await signupProvider.registerUser(signupModel);

    if (success) {
      _snack('Registration successful! 🎉');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavigationScreen()),
      );
    } else {
      _snack(signupProvider.errorMessage ?? 'Registration failed');
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _snack(String msg) {
    final isDarkMode = _isDarkMode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Future<void> _pickDate(bool isDob) async {
  //   final isDarkMode = _isDarkMode;
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime(isDob ? 1995 : 2020),
  //     firstDate: DateTime(1950),
  //     lastDate: DateTime.now(),
  //     builder: (ctx, child) => Theme(
  //       data: ThemeData.dark().copyWith(
  //         colorScheme: ColorScheme.dark(primary: _purple, surface: _bg2),
  //         scaffoldBackgroundColor: isDarkMode ? _bg1 : Colors.white,
  //         dialogBackgroundColor: isDarkMode ? _bg2 : Colors.white,
  //       ),
  //       child: child!,
  //     ),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       if (isDob) {
  //         _dob = picked;
  //       } else {
  //         _anniversary = picked;
  //       }
  //     });
  //   }
  // }

  Future<void> _pickDate(bool isDob) async {
    final isDarkMode = _isDarkMode;

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(isDob ? 1995 : 2020),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: isDarkMode
            ? ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(primary: _purple, surface: _bg2),
                dialogBackgroundColor: _bg2,
              )
            : ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: _purple,
                  surface: Colors.white,
                ),
                dialogBackgroundColor: Colors.white,
              ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isDob) {
          _dob = picked;
        } else {
          _anniversary = picked;
        }
      });
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg1,
      body: Stack(
        children: [
          const _DiagonalShapes(),
          SafeArea(
            child: Column(
              children: [
                _buildHeroSection(),
                Expanded(
                  child: SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: _buildStepContent(),
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

  // ── Hero Section ─────────────────────────────────────────────────────────
  Widget _buildHeroSection() {
    final isDarkMode = _isDarkMode;

    return SizedBox(
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _floatAnim,
            builder: (_, __) => Transform.translate(
              offset: Offset(0, _floatAnim.value),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: _purple.withOpacity(0.5),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        'assets/appstore.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _shimmerAnim,
                    builder: (_, __) => ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [
                          (_shimmerAnim.value - 0.3).clamp(0.0, 1.0),
                          _shimmerAnim.value.clamp(0.0, 1.0),
                          (_shimmerAnim.value + 0.3).clamp(0.0, 1.0),
                        ],
                        colors: const [
                          Color(0xFF9C8FFF),
                          Colors.white,
                          Color(0xFF6C63FF),
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'Edit Ezy',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Create Amazing Posters',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                      letterSpacing: 1.5,
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

  // ── Step Content Container ────────────────────────────────────────────────
  Widget _buildStepContent() {
    final isDarkMode = _isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: _bg2.withOpacity(isDarkMode ? 0.95 : 0.98),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border(
          top: BorderSide(color: _purple.withOpacity(0.3), width: 1),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
          child: switch (_step) {
            AuthStep.mobile => _buildMobileStep(),
            AuthStep.otp => _buildOtpStep(),
            AuthStep.signup => _buildSignupStep(),
          },
        ),
      ),
    );
  }

  // ── Step 1: Mobile ───────────────────────────────────────────────────────
  Widget _buildMobileStep() {
    final isDarkMode = _isDarkMode;

    return Consumer<SmsProvider>(
      builder: (context, smsProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Register with Mobile Number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'We will send you a verification code',
              style: TextStyle(fontSize: 13, color: _textSecondary),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: _inputBg,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: _purple.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        '+91',
                        style: TextStyle(
                          color: _textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _inputField(
                    controller: _mobileCtrl,
                    hint: 'Mobile Number',
                    keyboardType: TextInputType.phone,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _gradientButton(
              'Continue',
              smsProvider.isLoading ? null : _handleSendOtp,
              isLoading: smsProvider.isLoading,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: _textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (Platform.isAndroid)

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<GoogleProvider>(
                  builder: (context, googleProvider, child) {
                    return _socialBtn(
                      'G',
                      const Color(0xFF4285F4),
                      Colors.white,
                      onTap: googleProvider.isLoading
                          ? null
                          : () async {
                              final success = await googleProvider
                                  .signInWithGoogle(context);
                              if (success) {
                                if (googleProvider.googleSignInResponse !=
                                    null) {
                                  final data = jsonDecode(
                                    googleProvider.googleSignInResponse!.body,
                                  );
                                  final user = data['user'];

                                  final hasName =
                                      user['name'] != null &&
                                      user['name'] != '';
                                  final hasEmail =
                                      user['email'] != null &&
                                      user['email'] != '';

                                  if (!hasName || !hasEmail) {
                                    if (user['mobile'] != null) {
                                      _mobileCtrl.text = user['mobile'];
                                      setState(() => _isMobileLocked = true);
                                      _goTo(AuthStep.signup);
                                    }
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MainNavigationScreen(),
                                      ),
                                    );
                                  }
                                }
                              } else if (googleProvider.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(googleProvider.error!),
                                    backgroundColor: isDarkMode
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                  ),
                                );
                              }
                            },
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ── Step 2: OTP (4-digit) ───────────────────────────────────────────────
  Widget _buildOtpStep() {
    final isDarkMode = _isDarkMode;

    return Consumer<SmsProvider>(
      builder: (context, smsProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _goTo(AuthStep.mobile),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _purple.withOpacity(0.3)),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: _textPrimary,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: _textSecondary),
                children: [
                  const TextSpan(text: 'Sent to +91 '),
                  TextSpan(
                    text: _mobileCtrl.text,
                    style: const TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_otpLength, (i) => _otpBox(i)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _resendSeconds > 0
                      ? "Resend OTP in ${_resendSeconds}s"
                      : "Didn't receive OTP? ",
                  style: TextStyle(color: _textSecondary, fontSize: 13),
                ),
                if (_resendSeconds == 0)
                  GestureDetector(
                    onTap: smsProvider.isResending ? null : _handleResendOtp,
                    child: Text(
                      smsProvider.isResending ? 'Resending...' : 'Resend',
                      style: const TextStyle(
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            _gradientButton(
              'Verify OTP',
              smsProvider.isLoading ? null : _handleVerifyOtp,
              isLoading: smsProvider.isLoading,
            ),
          ],
        );
      },
    );
  }

  Widget _otpBox(int index) {
    final isDarkMode = _isDarkMode;

    return SizedBox(
      width: 58,
      height: 54,
      child: TextField(
        controller: _otpCtrls[index],
        focusNode: _otpFocus[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: _textPrimary,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: _inputBg,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _purple.withOpacity(0.4), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
          ),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (val) {
          if (val.isNotEmpty && index < _otpLength - 1) {
            _otpFocus[index + 1].requestFocus();
          } else if (val.isEmpty && index > 0) {
            _otpFocus[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  // ── Step 3: Signup ───────────────────────────────────────────────────────
  Widget _buildSignupStep() {
    final isDarkMode = _isDarkMode;

    return Consumer<SignupProvider>(
      builder: (context, signupProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _goTo(AuthStep.otp),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _purple.withOpacity(0.3)),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: _textPrimary,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _purple.withOpacity(isDarkMode ? 0.15 : 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _purple.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.purple.shade300,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Welcome! Please complete your profile',
                    style: TextStyle(
                      color: isDarkMode ? Colors.purple.shade100 : _purple,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _labeledField('Full Name', _nameCtrl, Icons.person_outline),
            const SizedBox(height: 16),
            _labeledField(
              'Email',
              _emailCtrl,
              Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _labeledField('Brand Name', _brandCtrl, Icons.store_outlined),
            const SizedBox(height: 16),
            _lockedField(
              'Mobile Number',
              _mobileCtrl.text,
              Icons.phone_android,
            ),
            const SizedBox(height: 16),
            _genderDropdown(),
            const SizedBox(height: 16),
            _datePicker(
              'Date of Birth (Optional)',
              Icons.cake_outlined,
              _dob,
              () => _pickDate(true),
            ),
            const SizedBox(height: 16),
            _datePicker(
              'Anniversary Date (Optional)',
              Icons.favorite_border,
              _anniversary,
              () => _pickDate(false),
            ),
            const SizedBox(height: 16),
            _labeledField(
              'Referral Code (Optional)',
              _referralCtrl,
              Icons.card_giftcard,
            ),
            const SizedBox(height: 32),
            _gradientButton(
              'Complete Registration',
              signupProvider.isLoading ? null : _handleSignup,
              isLoading: signupProvider.isLoading,
            ),
          ],
        );
      },
    );
  }

  // ── Shared Widgets ───────────────────────────────────────────────────────
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _inputBg,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: _purple.withOpacity(0.4)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: formatters,
        style: TextStyle(color: _textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: _textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _labeledField(
    String label,
    TextEditingController ctrl,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    final isDarkMode = _isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: _inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _purple.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: TextStyle(color: _textPrimary, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: _textSecondary, fontSize: 13),
          prefixIcon: Icon(icon, color: _purple.withOpacity(0.8), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _lockedField(String label, String value, IconData icon) {
    final isDarkMode = _isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.withOpacity(0.2)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: _textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: _textSecondary, fontSize: 15),
            ),
          ),
          Icon(Icons.lock, color: _textSecondary, size: 16),
        ],
      ),
    );
  }

  Widget _genderDropdown() {
    final isDarkMode = _isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _purple.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _gender,
        hint: Text(
          'Select Gender',
          style: TextStyle(color: _textSecondary, fontSize: 13),
        ),
        dropdownColor: _bg2,
        style: TextStyle(color: _textPrimary, fontSize: 15),
        icon: Icon(Icons.keyboard_arrow_down, color: _textSecondary),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.wc, color: _purple.withOpacity(0.8), size: 20),
          border: InputBorder.none,
          labelText: 'Gender',
          labelStyle: TextStyle(color: _textSecondary, fontSize: 13),
        ),
        items: const [
          DropdownMenuItem(value: 'Male', child: Text('Male')),
          DropdownMenuItem(value: 'Female', child: Text('Female')),
          DropdownMenuItem(value: 'Other', child: Text('Other')),
        ],
        onChanged: (v) => setState(() => _gender = v),
      ),
    );
  }

  Widget _datePicker(
    String label,
    IconData icon,
    DateTime? date,
    VoidCallback onTap,
  ) {
    final isDarkMode = _isDarkMode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: _inputBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _purple.withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
              color: _purple.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: _purple.withOpacity(0.8), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date != null
                    ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
                    : label,
                style: TextStyle(
                  color: date != null ? _textPrimary : _textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.calendar_today, color: _textSecondary, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _gradientButton(
    String label,
    VoidCallback? onPressed, {
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF448AFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.45),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
      ),
    );
  }

  Widget _socialBtn(String label, Color bg, Color fg, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: bg.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

// ─── Background Diagonal Shapes ──────────────────────────────────────────────
class _DiagonalShapes extends StatelessWidget {
  const _DiagonalShapes();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(painter: _DiagonalPainter(isDarkMode: isDarkMode)),
    );
  }
}

class _DiagonalPainter extends CustomPainter {
  final bool isDarkMode;

  _DiagonalPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final opacity1 = isDarkMode ? 0.12 : 0.06;
    final opacity2 = isDarkMode ? 0.08 : 0.04;
    final opacity3 = isDarkMode ? 0.06 : 0.03;

    final paint1 = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(opacity1)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFF448AFF).withOpacity(opacity2)
      ..style = PaintingStyle.fill;

    final paint3 = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(opacity3)
      ..style = PaintingStyle.fill;

    final path1 = Path()
      ..moveTo(size.width * 0.3, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.45)
      ..lineTo(size.width * 0.1, size.height * 0.15)
      ..close();
    canvas.drawPath(path1, paint1);

    final path2 = Path()
      ..moveTo(0, size.height * 0.75)
      ..lineTo(size.width * 0.6, size.height * 0.9)
      ..lineTo(size.width * 0.4, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path2, paint2);

    final path3 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.25, 0)
      ..lineTo(0, size.height * 0.18)
      ..close();
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
