import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_messaging/firebase_messaging.dart';
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
  // ── Colors ──────────────────────────────────────────────────────────────
  static const Color _bg1 = Color(0xFF0A0E21);
  static const Color _bg2 = Color(0xFF1D1E33);
  static const Color _purple = Color(0xFF6C63FF);
  static const Color _blue = Color(0xFF448AFF);

  // ── Bypass Config ────────────────────────────────────────────────────────
  static const int _bypassOtpLength = 4;
  static const int _normalOtpLength = 6;

  // ── State ────────────────────────────────────────────────────────────────
  AuthStep _step = AuthStep.mobile;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _verificationId;

  // Mobile step
  final _mobileCtrl = TextEditingController();

  // OTP step
  final List<TextEditingController> _otpCtrls = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocus = List.generate(6, (_) => FocusNode());
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

  static const List<String> _bypassNumbers = ['9849008143', '9744037599'];

  // ── Helpers ───────────────────────────────────────────────────────────────
  bool get _isBypassNumber => _bypassNumbers.contains(_mobileCtrl.text.trim());
  int get _otpLength => _isBypassNumber ? _bypassOtpLength : _normalOtpLength;

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

  // ── Firebase + Backend Logic ─────────────────────────────────────────────

  Future<void> _callBackendVerify(String firebaseToken) async {
    final smsProvider = Provider.of<SmsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await smsProvider.verifyWithFirebaseToken(firebaseToken);

    if (smsProvider.otpResponse?.statusCode == 200) {
      final data = jsonDecode(smsProvider.otpResponse!.body);
      final user = data['user'];

      await authProvider.login(user['mobile']);

      final hasName = user['name'] != null && user['name'] != '';
      final hasEmail = user['email'] != null && user['email'] != '';

      if (!hasName || !hasEmail) {
        setState(() => _isMobileLocked = true);
        _goTo(AuthStep.signup);
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigationScreen()),
      );
    } else {
      _snack("Backend verification failed");
    }
  }

  Future<void> _handleSendOtp() async {
    final mobile = _mobileCtrl.text.trim();

    if (mobile.length != 10) {
      _snack('Please enter a valid 10-digit mobile number');
      return;
    }

    final phone = "+91$mobile";

    try {
      // ✅ BYPASS NUMBER
      if (_bypassNumbers.contains(mobile)) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.login(mobile);
        _snack('OTP sent successfully!');
        _goTo(AuthStep.otp);
        _startResendTimer();
        return;
      }

      // ✅ NORMAL FIREBASE FLOW
      await FirebaseMessaging.instance.requestPermission();
      await FirebaseMessaging.instance.getToken();

      if (Platform.isIOS) {
        await Future.delayed(const Duration(seconds: 2));
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        print("APNS TOKEN: $apnsToken");
        if (apnsToken == null) {
          _snack("Device not ready. Try again.");
          return;
        }
      }

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          final idToken = await _firebaseAuth.currentUser!.getIdToken();
          await _callBackendVerify(idToken.toString());
        },
        verificationFailed: (FirebaseAuthException e) {
          _snack(e.message ?? "Verification failed");
        },
        codeSent: (verificationId, resendToken) {
          setState(() => _verificationId = verificationId);
          _goTo(AuthStep.otp);
          _startResendTimer();
          _snack("OTP sent via Firebase");
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      print("PhoneAuth Error: $e");
      _snack("Something went wrong. Try again.");
    }
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpCtrls
        .map((c) => c.text)
        .join()
        .substring(
          0,
          _otpLength > _otpCtrls.where((c) => c.text.isNotEmpty).length
              ? _otpCtrls.where((c) => c.text.isNotEmpty).length
              : _otpLength,
        );
    final mobile = _mobileCtrl.text.trim();
    final enteredOtp = _otpCtrls.take(_otpLength).map((c) => c.text).join();

    if (enteredOtp.length < _otpLength) {
      _snack('Please enter the complete $_otpLength-digit OTP');
      return;
    }

    final smsProvider = Provider.of<SmsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    print("bbbbbbbbbbbbbbbbbbbbbbbb${_bypassNumbers.contains(mobile)}");
    print("bbbbbbbbbbbbbbbbbbbbbbbb$enteredOtp");

    // ✅ BYPASS NUMBER FLOW
    if (_bypassNumbers.contains(mobile)) {
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

    // ✅ NORMAL FIREBASE FLOW
    if (_verificationId == null) {
      _snack("Request OTP first");
      return;
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: enteredOtp,
      );
      await _firebaseAuth.signInWithCredential(credential);
      final idToken = await _firebaseAuth.currentUser!.getIdToken();
      await _callBackendVerify(idToken.toString());
    } catch (e) {
      _snack("Invalid OTP");
    }
  }

  Future<void> _handleResendOtp() async {
    final smsProvider = Provider.of<SmsProvider>(context, listen: false);
    final mobile = _mobileCtrl.text.trim();

    final String? resOtp = await smsProvider.resendOtp(mobile);

    if (resOtp != null && resOtp.isNotEmpty) {
      final digits = resOtp.split('');
      for (int i = 0; i < digits.length && i < _otpLength; i++) {
        _otpCtrls[i].text = digits[i];
      }
    }

    _startResendTimer();

    if (smsProvider.resendOtpResponse?.statusCode == 200) {
      _snack('OTP resent successfully!');
    } else {
      _snack('OTP resent successfully!');
    }
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: _bg2,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _pickDate(bool isDob) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(isDob ? 1995 : 2020),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: _purple, surface: _bg2),
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
          _DiagonalShapes(),
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
                      color: Colors.grey.shade400,
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
    return Container(
      decoration: BoxDecoration(
        color: _bg2.withOpacity(0.95),
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
    return Consumer<SmsProvider>(
      builder: (context, smsProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register with Mobile Number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'We will send you a verification code',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
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
                    color: _bg1,
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
                          color: Colors.grey.shade300,
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
                Expanded(child: Divider(color: Colors.grey.shade700)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade700)),
              ],
            ),
            const SizedBox(height: 24),
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
                                // Navigate to home screen or check if profile is complete
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
                                    // Go to signup step if profile incomplete
                                    // You'll need to handle this based on your flow
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
                                  ),
                                );
                              }
                            },
                    );
                  },
                ), // Facebook will be similar
              ],
            ),
          ],
        );
      },
    );
  }

  // ── Step 2: OTP ──────────────────────────────────────────────────────────
  Widget _buildOtpStep() {
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
                  color: _bg1,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _purple.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                children: [
                  const TextSpan(text: 'Sent to +91 '),
                  TextSpan(
                    text: _mobileCtrl.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // ── OTP Boxes: 4 for bypass number, 6 for others ──────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
                if (_resendSeconds == 0)
                  GestureDetector(
                    onTap: smsProvider.isResending ? null : _handleResendOtp,
                    child: Text(
                      smsProvider.isResending ? 'Resending...' : 'Resend',
                      style: const TextStyle(
                        color: _purple,
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
    // Max index depends on whether it's bypass (4 boxes) or normal (6 boxes)
    final maxIndex = _otpLength - 1;

    return SizedBox(
      width: _isBypassNumber ? 58 : 46, // slightly wider boxes for 4-digit
      height: 54,
      child: TextField(
        controller: _otpCtrls[index],
        focusNode: _otpFocus[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: _bg1,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _purple.withOpacity(0.4), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _purple, width: 2),
          ),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (val) {
          if (val.isNotEmpty && index < maxIndex) {
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
                  color: _bg1,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _purple.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _purple.withOpacity(0.15),
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
                      color: Colors.purple.shade100,
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
        color: _bg1,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: _purple.withOpacity(0.4)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: formatters,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
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
    return Container(
      decoration: BoxDecoration(
        color: _bg1,
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
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF12132A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            ),
          ),
          Icon(Icons.lock, color: Colors.grey.shade600, size: 16),
        ],
      ),
    );
  }

  Widget _genderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _bg1,
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
          style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        ),
        dropdownColor: _bg2,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.wc, color: _purple.withOpacity(0.8), size: 20),
          border: InputBorder.none,
          labelText: 'Gender',
          labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        ),
        items: [
          'Male',
          'Female',
          'Other',
        ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: _bg1,
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
                  color: date != null ? Colors.white : Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.calendar_today, color: Colors.grey.shade500, size: 18),
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
          colors: [_purple, _blue],
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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(painter: _DiagonalPainter()),
    );
  }
}

class _DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(0.12)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFF448AFF).withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final paint3 = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(0.06)
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
