// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:posternova/models/register_model.dart';
// // import 'package:posternova/providers/auth/google_provider.dart';
// // import 'package:posternova/providers/auth/login_provider.dart';
// // import 'package:posternova/providers/auth/otp_provider.dart';
// // import 'package:posternova/providers/auth/register_provider.dart';
// // import 'package:posternova/views/NavBar/navbar_screen.dart';
// // import 'package:provider/provider.dart';

// // // ─── Auth Steps Enum ─────────────────────────────────────────────────────────
// // enum AuthStep { mobile, otp, signup }

// // // ─── Auth Screen ─────────────────────────────────────────────────────────────
// // class AuthScreen extends StatefulWidget {
// //   const AuthScreen({Key? key}) : super(key: key);

// //   @override
// //   State<AuthScreen> createState() => _AuthScreenState();
// // }

// // class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
// //   // ── Theme Colors ──────────────────────────────────────────────────────────
// //   bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

// //   Color get _bg1 =>
// //       _isDarkMode ? const Color(0xFF0A0E21) : const Color(0xFFF5F5F5);
// //   Color get _bg2 =>
// //       _isDarkMode ? const Color(0xFF1D1E33) : const Color(0xFFFFFFFF);
// //   Color get _purple => const Color(0xFF6C63FF);
// //   Color get _blue => const Color(0xFF448AFF);
// //   Color get _textPrimary =>
// //       _isDarkMode ? Colors.white : const Color(0xFF1A1A1A);
// //   Color get _textSecondary =>
// //       _isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
// //   Color get _cardBg =>
// //       _isDarkMode ? const Color(0xFF12132A) : Colors.grey.shade50;
// //   Color get _inputBg =>
// //       _isDarkMode ? const Color(0xFF0A0E21) : Colors.grey.shade100;

// //   // ── OTP Length (Always 6 for Twilio) ───────────────────────────────────
// //   static const int _otpLength = 4;

// //   // ── State ────────────────────────────────────────────────────────────────
// //   AuthStep _step = AuthStep.mobile;

// //   // Mobile step
// //   final _mobileCtrl = TextEditingController();

// //   // OTP step
// //   final List<TextEditingController> _otpCtrls = List.generate(
// //     6,
// //     (_) => TextEditingController(),
// //   );
// //   final List<FocusNode> _otpFocus = List.generate(4, (_) => FocusNode());
// //   int _resendSeconds = 30;
// //   late final AnimationController _resendTimer;

// //   // Signup step
// //   final _nameCtrl = TextEditingController();
// //   final _emailCtrl = TextEditingController();
// //   final _brandCtrl = TextEditingController();
// //   final _referralCtrl = TextEditingController();
// //   String? _gender;
// //   DateTime? _dob;
// //   DateTime? _anniversary;
// //   bool _isMobileLocked = false;

// //   // ── Animations ───────────────────────────────────────────────────────────
// //   late final AnimationController _floatCtrl;
// //   late final Animation<double> _floatAnim;

// //   late final AnimationController _shimmerCtrl;
// //   late final Animation<double> _shimmerAnim;

// //   late final AnimationController _slideCtrl;
// //   late final Animation<Offset> _slideAnim;
// //   late final Animation<double> _fadeAnim;

// //   // ── Bypass Numbers (for testing/playstore) ───────────────────────────────
// //   static const List<String> _bypassNumbers = ['9849008143', '9744037599'];

// //   // ── Helpers ───────────────────────────────────────────────────────────────
// //   bool get _isBypassNumber => _bypassNumbers.contains(_mobileCtrl.text.trim());

// //   @override
// //   void initState() {
// //     super.initState();

// //     _floatCtrl = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 3),
// //     )..repeat(reverse: true);
// //     _floatAnim = Tween<double>(
// //       begin: -8,
// //       end: 8,
// //     ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

// //     _shimmerCtrl = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 2),
// //     )..repeat();
// //     _shimmerAnim = Tween<double>(
// //       begin: -1,
// //       end: 2,
// //     ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear));

// //     _slideCtrl = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 500),
// //     )..forward();
// //     _slideAnim = Tween<Offset>(
// //       begin: const Offset(0, 0.3),
// //       end: Offset.zero,
// //     ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
// //     _fadeAnim = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);

// //     _resendTimer = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 30),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _floatCtrl.dispose();
// //     _shimmerCtrl.dispose();
// //     _slideCtrl.dispose();
// //     _resendTimer.dispose();
// //     _mobileCtrl.dispose();
// //     _emailCtrl.dispose();
// //     _brandCtrl.dispose();
// //     _referralCtrl.dispose();
// //     for (final c in _otpCtrls) {
// //       c.dispose();
// //     }
// //     for (final f in _otpFocus) {
// //       f.dispose();
// //     }
// //     _nameCtrl.dispose();
// //     super.dispose();
// //   }

// //   // ── Navigation ───────────────────────────────────────────────────────────
// //   void _goTo(AuthStep step) {
// //     _slideCtrl.reset();
// //     setState(() => _step = step);
// //     _slideCtrl.forward();
// //   }

// //   void _startResendTimer() {
// //     _resendSeconds = 30;
// //     _resendTimer.reset();
// //     _resendTimer.forward();
// //     Future.doWhile(() async {
// //       await Future.delayed(const Duration(seconds: 1));
// //       if (!mounted) return false;
// //       setState(() => _resendSeconds--);
// //       return _resendSeconds > 0;
// //     });
// //   }

// //   // ── Backend Logic (Twilio - No Firebase) ─────────────────────────────────

// //   Future<void> _handleSendOtp() async {
// //     final mobile = _mobileCtrl.text.trim();

// //     if (mobile.length != 10) {
// //       _snack('Please enter a valid 10-digit mobile number');
// //       return;
// //     }

// //     final smsProvider = Provider.of<SmsProvider>(context, listen: false);

// //     if (_isBypassNumber) {
// //       _snack('OTP sent successfully!');
// //       _goTo(AuthStep.otp);
// //       _startResendTimer();
// //       return;
// //     }

// //     final res = await smsProvider.login(mobile);

// //     if (res) {
// //       _snack('OTP sent successfully!');
// //       _goTo(AuthStep.otp);
// //       _startResendTimer();
// //     } else {
// //       _snack(smsProvider.errorMessage ?? 'Failed to send OTP');
// //     }
// //   }

// //   Future<void> _handleVerifyOtp() async {
// //     final mobile = _mobileCtrl.text.trim();
// //     final enteredOtp = _otpCtrls.take(_otpLength).map((c) => c.text).join();

// //     if (enteredOtp.length < _otpLength) {
// //       _snack('Please enter the complete $_otpLength-digit OTP');
// //       return;
// //     }

// //     final smsProvider = Provider.of<SmsProvider>(context, listen: false);
// //     final authProvider = Provider.of<AuthProvider>(context, listen: false);

// //     if (_isBypassNumber) {
// //       await smsProvider.verifyOtp(enteredOtp, mobile, context);

// //       if (smsProvider.otpResponse?.statusCode == 200) {
// //         final userData = jsonDecode(smsProvider.otpResponse!.body);
// //         final user = userData['user'];

// //         final hasName =
// //             user['name'] != null && user['name'].toString().isNotEmpty;
// //         final hasEmail =
// //             user['email'] != null && user['email'].toString().isNotEmpty;

// //         if (!hasName || !hasEmail) {
// //           setState(() => _isMobileLocked = true);
// //           _goTo(AuthStep.signup);
// //           return;
// //         }

// //         final success = await authProvider.login(mobile);
// //         if (success) {
// //           Navigator.pushReplacement(
// //             context,
// //             MaterialPageRoute(builder: (_) => MainNavigationScreen()),
// //           );
// //         }
// //       } else {
// //         _snack("Invalid OTP");
// //       }
// //       return;
// //     }

// //     await smsProvider.verifyOtp(enteredOtp, mobile, context);

// //     if (smsProvider.otpResponse?.statusCode == 200) {
// //       final userData = jsonDecode(smsProvider.otpResponse!.body);
// //       final user = userData['user'];

// //       final hasName =
// //           user['name'] != null && user['name'].toString().isNotEmpty;
// //       final hasEmail =
// //           user['email'] != null && user['email'].toString().isNotEmpty;

// //       if (!hasName || !hasEmail) {
// //         setState(() => _isMobileLocked = true);
// //         _goTo(AuthStep.signup);
// //         return;
// //       }

// //       final success = await authProvider.login(mobile);
// //       if (success) {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (_) => MainNavigationScreen()),
// //         );
// //       }
// //     } else {
// //       _snack(smsProvider.errorMessage ?? "Invalid OTP");
// //     }
// //   }

// //   Future<void> _handleResendOtp() async {
// //     final mobile = _mobileCtrl.text.trim();
// //     final smsProvider = Provider.of<SmsProvider>(context, listen: false);

// //     if (_isBypassNumber) {
// //       for (int i = 0; i < _otpLength; i++) {
// //         _otpCtrls[i].clear();
// //       }
// //       _startResendTimer();
// //       _snack('OTP resent successfully!');
// //       return;
// //     }

// //     final res = await smsProvider.resendOtp(mobile);

// //     if (res) {
// //       _snack('OTP resent successfully!');
// //     } else {
// //       _snack(smsProvider.errorMessage ?? 'Failed to resend OTP');
// //     }

// //     // if (smsProvider.resendOtpResponse?.statusCode == 200) {
// //     //   for (int i = 0; i < _otpLength; i++) {
// //     //     _otpCtrls[i].clear();
// //     //   }
// //     //   _startResendTimer();
// //     //   _snack('OTP resent successfully!');
// //     // } else {
// //     //   _snack(smsProvider.errorMessage ?? 'Failed to resend OTP');
// //     // }
// //   }

// //   Future<void> _handleSignup() async {
// //     if (_nameCtrl.text.trim().isEmpty) {
// //       _snack('Please enter your name');
// //       return;
// //     }
// //     if (_emailCtrl.text.trim().isEmpty) {
// //       _snack('Please enter your email');
// //       return;
// //     }
// //     if (_mobileCtrl.text.trim().isEmpty ||
// //         _mobileCtrl.text.trim().length != 10) {
// //       _snack('Please enter a valid 10-digit mobile number');
// //       return;
// //     }

// //     final signupProvider = Provider.of<SignupProvider>(context, listen: false);

// //     final signupModel = SignupModel(
// //       id: '',
// //       name: _nameCtrl.text.trim(),
// //       email: _emailCtrl.text.trim(),
// //       mobile: _mobileCtrl.text.trim(),
// //       dob: _dob != null
// //           ? '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}'
// //           : null,
// //       marriageAnniversary: _anniversary != null
// //           ? '${_anniversary!.year}-${_anniversary!.month.toString().padLeft(2, '0')}-${_anniversary!.day.toString().padLeft(2, '0')}'
// //           : null,
// //       referralCode: _referralCtrl.text.trim().isEmpty
// //           ? null
// //           : _referralCtrl.text.trim(),
// //     );

// //     final success = await signupProvider.registerUser(signupModel);

// //     if (success) {
// //       _snack('Registration successful! 🎉');
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (context) => MainNavigationScreen()),
// //       );
// //     } else {
// //       _snack(signupProvider.errorMessage ?? 'Registration failed');
// //     }
// //   }

// //   // ── Helpers ───────────────────────────────────────────────────────────────
// //   void _snack(String msg) {
// //     final isDarkMode = _isDarkMode;
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(
// //           msg,
// //           style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
// //         ),
// //         backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
// //         behavior: SnackBarBehavior.floating,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       ),
// //     );
// //   }

// //   // Future<void> _pickDate(bool isDob) async {
// //   //   final isDarkMode = _isDarkMode;
// //   //   final picked = await showDatePicker(
// //   //     context: context,
// //   //     initialDate: DateTime(isDob ? 1995 : 2020),
// //   //     firstDate: DateTime(1950),
// //   //     lastDate: DateTime.now(),
// //   //     builder: (ctx, child) => Theme(
// //   //       data: ThemeData.dark().copyWith(
// //   //         colorScheme: ColorScheme.dark(primary: _purple, surface: _bg2),
// //   //         scaffoldBackgroundColor: isDarkMode ? _bg1 : Colors.white,
// //   //         dialogBackgroundColor: isDarkMode ? _bg2 : Colors.white,
// //   //       ),
// //   //       child: child!,
// //   //     ),
// //   //   );
// //   //   if (picked != null) {
// //   //     setState(() {
// //   //       if (isDob) {
// //   //         _dob = picked;
// //   //       } else {
// //   //         _anniversary = picked;
// //   //       }
// //   //     });
// //   //   }
// //   // }

// //   Future<void> _pickDate(bool isDob) async {
// //     final isDarkMode = _isDarkMode;

// //     final picked = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime(isDob ? 1995 : 2020),
// //       firstDate: DateTime(1950),
// //       lastDate: DateTime.now(),
// //       builder: (ctx, child) => Theme(
// //         data: isDarkMode
// //             ? ThemeData.dark().copyWith(
// //                 colorScheme: ColorScheme.dark(primary: _purple, surface: _bg2),
// //                 dialogBackgroundColor: _bg2,
// //               )
// //             : ThemeData.light().copyWith(
// //                 colorScheme: ColorScheme.light(
// //                   primary: _purple,
// //                   surface: Colors.white,
// //                 ),
// //                 dialogBackgroundColor: Colors.white,
// //               ),
// //         child: child!,
// //       ),
// //     );

// //     if (picked != null) {
// //       setState(() {
// //         if (isDob) {
// //           _dob = picked;
// //         } else {
// //           _anniversary = picked;
// //         }
// //       });
// //     }
// //   }

// //   // ── Build ────────────────────────────────────────────────────────────────
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: _bg1,
// //       body: Stack(
// //         children: [
// //           const _DiagonalShapes(),
// //           SafeArea(
// //             child: Column(
// //               children: [
// //                 _buildHeroSection(),
// //                 Expanded(
// //                   child: SlideTransition(
// //                     position: _slideAnim,
// //                     child: FadeTransition(
// //                       opacity: _fadeAnim,
// //                       child: _buildStepContent(),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ── Hero Section ─────────────────────────────────────────────────────────
// //   Widget _buildHeroSection() {
// //     final isDarkMode = _isDarkMode;

// //     return SizedBox(
// //       height: 260,
// //       child: Stack(
// //         alignment: Alignment.center,
// //         children: [
// //           AnimatedBuilder(
// //             animation: _floatAnim,
// //             builder: (_, __) => Transform.translate(
// //               offset: Offset(0, _floatAnim.value),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Container(
// //                     width: 90,
// //                     height: 90,
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(22),
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: _purple.withOpacity(0.5),
// //                           blurRadius: 24,
// //                           spreadRadius: 4,
// //                         ),
// //                       ],
// //                     ),
// //                     child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(22),
// //                       child: Image.asset(
// //                         'assets/appstore.png',
// //                         fit: BoxFit.cover,
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   AnimatedBuilder(
// //                     animation: _shimmerAnim,
// //                     builder: (_, __) => ShaderMask(
// //                       shaderCallback: (bounds) => LinearGradient(
// //                         begin: Alignment.centerLeft,
// //                         end: Alignment.centerRight,
// //                         stops: [
// //                           (_shimmerAnim.value - 0.3).clamp(0.0, 1.0),
// //                           _shimmerAnim.value.clamp(0.0, 1.0),
// //                           (_shimmerAnim.value + 0.3).clamp(0.0, 1.0),
// //                         ],
// //                         colors: const [
// //                           Color(0xFF9C8FFF),
// //                           Colors.white,
// //                           Color(0xFF6C63FF),
// //                         ],
// //                       ).createShader(bounds),
// //                       child: const Text(
// //                         'Edit Ezy',
// //                         style: TextStyle(
// //                           fontSize: 40,
// //                           fontWeight: FontWeight.w900,
// //                           color: Colors.white,
// //                           letterSpacing: 2,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 6),
// //                   Text(
// //                     'Create Amazing Posters',
// //                     style: TextStyle(
// //                       fontSize: 13,
// //                       color: isDarkMode
// //                           ? Colors.grey.shade400
// //                           : Colors.grey.shade600,
// //                       letterSpacing: 1.5,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ── Step Content Container ────────────────────────────────────────────────
// //   Widget _buildStepContent() {
// //     final isDarkMode = _isDarkMode;

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: _bg2.withOpacity(isDarkMode ? 0.95 : 0.98),
// //         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
// //         border: Border(
// //           top: BorderSide(color: _purple.withOpacity(0.3), width: 1),
// //         ),
// //       ),
// //       child: ClipRRect(
// //         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
// //           child: switch (_step) {
// //             AuthStep.mobile => _buildMobileStep(),
// //             AuthStep.otp => _buildOtpStep(),
// //             AuthStep.signup => _buildSignupStep(),
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   // ── Step 1: Mobile ───────────────────────────────────────────────────────
// //   Widget _buildMobileStep() {
// //     final isDarkMode = _isDarkMode;

// //     return Consumer<SmsProvider>(
// //       builder: (context, smsProvider, child) {
// //         return Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Register with Mobile Number',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w700,
// //                 color: _textPrimary,
// //                 letterSpacing: 0.3,
// //               ),
// //             ),
// //             const SizedBox(height: 6),
// //             Text(
// //               'We will send you a verification code',
// //               style: TextStyle(fontSize: 13, color: _textSecondary),
// //             ),
// //             const SizedBox(height: 28),
// //             Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 14,
// //                     vertical: 16,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     color: _inputBg,
// //                     borderRadius: BorderRadius.circular(50),
// //                     border: Border.all(color: _purple.withOpacity(0.4)),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       const Text('🇮🇳', style: TextStyle(fontSize: 18)),
// //                       const SizedBox(width: 6),
// //                       Text(
// //                         '+91',
// //                         style: TextStyle(
// //                           color: _textSecondary,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: _inputField(
// //                     controller: _mobileCtrl,
// //                     hint: 'Mobile Number',
// //                     keyboardType: TextInputType.phone,
// //                     formatters: [
// //                       FilteringTextInputFormatter.digitsOnly,
// //                       LengthLimitingTextInputFormatter(10),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 28),
// //             _gradientButton(
// //               'Continue',
// //               smsProvider.isLoading ? null : _handleSendOtp,
// //               isLoading: smsProvider.isLoading,
// //             ),
// //             // const SizedBox(height: 28),
// //             // Row(
// //             //   children: [
// //             //     Expanded(
// //             //       child: Divider(
// //             //         color: isDarkMode
// //             //             ? Colors.grey.shade700
// //             //             : Colors.grey.shade300,
// //             //       ),
// //             //     ),
// //             //     Padding(
// //             //       padding: const EdgeInsets.symmetric(horizontal: 16),
// //             //       child: Text(
// //             //         'OR',
// //             //         style: TextStyle(
// //             //           color: _textSecondary,
// //             //           fontWeight: FontWeight.w600,
// //             //           letterSpacing: 1,
// //             //         ),
// //             //       ),
// //             //     ),
// //             //     Expanded(
// //             //       child: Divider(
// //             //         color: isDarkMode
// //             //             ? Colors.grey.shade700
// //             //             : Colors.grey.shade300,
// //             //       ),
// //             //     ),
// //             //   ],
// //             // ),
// //             const SizedBox(height: 24),
// //             if (Platform.isAndroid)

// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Consumer<GoogleProvider>(
// //                   builder: (context, googleProvider, child) {
// //                     return _socialBtn(
// //                       'G',
// //                       const Color(0xFF4285F4),
// //                       Colors.white,
// //                       onTap: googleProvider.isLoading
// //                           ? null
// //                           : () async {
// //                               final success = await googleProvider
// //                                   .signInWithGoogle(context);
// //                               if (success) {
// //                                 if (googleProvider.googleSignInResponse !=
// //                                     null) {
// //                                   final data = jsonDecode(
// //                                     googleProvider.googleSignInResponse!.body,
// //                                   );
// //                                   final user = data['user'];

// //                                   final hasName =
// //                                       user['name'] != null &&
// //                                       user['name'] != '';
// //                                   final hasEmail =
// //                                       user['email'] != null &&
// //                                       user['email'] != '';

// //                                   if (!hasName || !hasEmail) {
// //                                     if (user['mobile'] != null) {
// //                                       _mobileCtrl.text = user['mobile'];
// //                                       setState(() => _isMobileLocked = true);
// //                                       _goTo(AuthStep.signup);
// //                                     }
// //                                   } else {
// //                                     Navigator.pushReplacement(
// //                                       context,
// //                                       MaterialPageRoute(
// //                                         builder: (_) => MainNavigationScreen(),
// //                                       ),
// //                                     );
// //                                   }
// //                                 }
// //                               } else if (googleProvider.error != null) {
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   SnackBar(
// //                                     content: Text(googleProvider.error!),
// //                                     backgroundColor: isDarkMode
// //                                         ? const Color(0xFF1E293B)
// //                                         : Colors.white,
// //                                   ),
// //                                 );
// //                               }
// //                             },
// //                     );
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   // ── Step 2: OTP (4-digit) ───────────────────────────────────────────────
// //   // Widget _buildOtpStep() {
// //   //   final isDarkMode = _isDarkMode;

// //   //   return Consumer<SmsProvider>(
// //   //     builder: (context, smsProvider, child) {
// //   //       return Column(
// //   //                 mainAxisSize: MainAxisSize.min, // Add this

// //   //         crossAxisAlignment: CrossAxisAlignment.start,
// //   //         children: [
// //   //           GestureDetector(
// //   //             onTap: () => _goTo(AuthStep.mobile),
// //   //             child: Container(
// //   //               padding: const EdgeInsets.all(8),
// //   //               decoration: BoxDecoration(
// //   //                 color: _inputBg,
// //   //                 borderRadius: BorderRadius.circular(12),
// //   //                 border: Border.all(color: _purple.withOpacity(0.3)),
// //   //               ),
// //   //               child: Icon(
// //   //                 Icons.arrow_back_ios_new,
// //   //                 color: _textPrimary,
// //   //                 size: 18,
// //   //               ),
// //   //             ),
// //   //           ),
// //   //           const SizedBox(height: 20),
// //   //           Text(
// //   //             'Enter OTP',
// //   //             style: TextStyle(
// //   //               fontSize: 22,
// //   //               fontWeight: FontWeight.w800,
// //   //               color: _textPrimary,
// //   //             ),
// //   //           ),
// //   //           const SizedBox(height: 6),
// //   //           RichText(
// //   //             text: TextSpan(
// //   //               style: TextStyle(fontSize: 13, color: _textSecondary),
// //   //               children: [
// //   //                 const TextSpan(text: 'Sent to +91 '),
// //   //                 TextSpan(
// //   //                   text: _mobileCtrl.text,
// //   //                   style: const TextStyle(
// //   //                     color: Color(0xFF6C63FF),
// //   //                     fontWeight: FontWeight.w600,
// //   //                   ),
// //   //                 ),
// //   //               ],
// //   //             ),
// //   //           ),
// //   //           const SizedBox(height: 32),
// //   //           Row(
// //   //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //   //             children: List.generate(_otpLength, (i) => _otpBox(i)),
// //   //           ),
// //   //           const SizedBox(height: 20),
// //   //           Row(
// //   //             mainAxisAlignment: MainAxisAlignment.center,
// //   //             children: [
// //   //               Text(
// //   //                 _resendSeconds > 0
// //   //                     ? "Resend OTP in ${_resendSeconds}s"
// //   //                     : "Didn't receive OTP? ",
// //   //                 style: TextStyle(color: _textSecondary, fontSize: 13),
// //   //               ),
// //   //               if (_resendSeconds == 0)
// //   //                 GestureDetector(
// //   //                   onTap: smsProvider.isResending ? null : _handleResendOtp,
// //   //                   child: Text(
// //   //                     smsProvider.isResending ? 'Resending...' : 'Resend',
// //   //                     style: const TextStyle(
// //   //                       color: Color(0xFF6C63FF),
// //   //                       fontWeight: FontWeight.w700,
// //   //                       fontSize: 13,
// //   //                     ),
// //   //                   ),
// //   //                 ),
// //   //             ],
// //   //           ),
// //   //           const SizedBox(height: 32),
// //   //           _gradientButton(
// //   //             'Verify OTP',
// //   //             smsProvider.isLoading ? null : _handleVerifyOtp,
// //   //             isLoading: smsProvider.isLoading,
// //   //           ),
// //   //         ],
// //   //       );
// //   //     },
// //   //   );
// //   // }

// // Widget _buildOtpStep() {
// //   final isDarkMode = _isDarkMode;

// //   return Consumer<SmsProvider>(
// //     builder: (context, smsProvider, child) {
// //       return Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         mainAxisSize: MainAxisSize.min, // Add this
// //         children: [
// //           GestureDetector(
// //             onTap: () => _goTo(AuthStep.mobile),
// //             child: Container(
// //               padding: const EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 color: _inputBg,
// //                 borderRadius: BorderRadius.circular(12),
// //                 border: Border.all(color: _purple.withOpacity(0.3)),
// //               ),
// //               child: Icon(
// //                 Icons.arrow_back_ios_new,
// //                 color: _textPrimary,
// //                 size: 18,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 20),
// //           Text(
// //             'Enter OTP',
// //             style: TextStyle(
// //               fontSize: 22,
// //               fontWeight: FontWeight.w800,
// //               color: _textPrimary,
// //             ),
// //           ),
// //           const SizedBox(height: 6),
// //           RichText(
// //             text: TextSpan(
// //               style: TextStyle(fontSize: 13, color: _textSecondary),
// //               children: [
// //                 const TextSpan(text: 'Sent to +91 '),
// //                 TextSpan(
// //                   text: _mobileCtrl.text,
// //                   style: const TextStyle(
// //                     color: Color(0xFF6C63FF),
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 32),
// //           // Wrap OTP boxes with RepaintBoundary
// //           RepaintBoundary(
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: List.generate(_otpLength, (i) => _otpBox(i)),
// //             ),
// //           ),
// //           const SizedBox(height: 20),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Text(
// //                 _resendSeconds > 0
// //                     ? "Resend OTP in ${_resendSeconds}s"
// //                     : "Didn't receive OTP? ",
// //                 style: TextStyle(color: _textSecondary, fontSize: 13),
// //               ),
// //               if (_resendSeconds == 0)
// //                 GestureDetector(
// //                   onTap: smsProvider.isResending ? null : _handleResendOtp,
// //                   child: Text(
// //                     smsProvider.isResending ? 'Resending...' : 'Resend',
// //                     style: const TextStyle(
// //                       color: Color(0xFF6C63FF),
// //                       fontWeight: FontWeight.w700,
// //                       fontSize: 13,
// //                     ),
// //                   ),
// //                 ),
// //             ],
// //           ),
// //           const SizedBox(height: 32),
// //           _gradientButton(
// //             'Verify OTP',
// //             smsProvider.isLoading ? null : _handleVerifyOtp,
// //             isLoading: smsProvider.isLoading,
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }

// //   // Widget _otpBox(int index) {
// //   //   final isDarkMode = _isDarkMode;

// //   //   return SizedBox(
// //   //     width: 58,
// //   //     height: 54,
// //   //     child: TextField(
// //   //       controller: _otpCtrls[index],
// //   //       focusNode: _otpFocus[index],
// //   //       textAlign: TextAlign.center,
// //   //       keyboardType: TextInputType.number,
// //   //       maxLength: 1,
// //   //       style: TextStyle(
// //   //         fontSize: 22,
// //   //         fontWeight: FontWeight.w800,
// //   //         color: _textPrimary,
// //   //       ),
// //   //       decoration: InputDecoration(
// //   //         counterText: '',
// //   //         filled: true,
// //   //         fillColor: _inputBg,
// //   //         enabledBorder: OutlineInputBorder(
// //   //           borderRadius: BorderRadius.circular(12),
// //   //           borderSide: BorderSide(color: _purple.withOpacity(0.4), width: 1.5),
// //   //         ),
// //   //         focusedBorder: OutlineInputBorder(
// //   //           borderRadius: BorderRadius.circular(12),
// //   //           borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
// //   //         ),
// //   //       ),
// //   //       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
// //   //       onChanged: (val) {
// //   //         if (val.isNotEmpty && index < _otpLength - 1) {
// //   //           _otpFocus[index + 1].requestFocus();
// //   //         } else if (val.isEmpty && index > 0) {
// //   //           _otpFocus[index - 1].requestFocus();
// //   //         }
// //   //       },
// //   //     ),
// //   //   );
// //   // }

// //   Widget _otpBox(int index) {
// //   final isDarkMode = _isDarkMode;

// //   return SizedBox(
// //     width: 58,
// //     height: 54,
// //     child: TextField(
// //       controller: _otpCtrls[index],
// //       focusNode: _otpFocus[index],
// //       textAlign: TextAlign.center,
// //       keyboardType: TextInputType.number,
// //       maxLength: 1,
// //       style: TextStyle(
// //         fontSize: 22,
// //         fontWeight: FontWeight.w800,
// //         color: _textPrimary,
// //       ),
// //       decoration: InputDecoration(
// //         counterText: '',
// //         filled: true,
// //         fillColor: _inputBg,
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: _purple.withOpacity(0.4), width: 1.5),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
// //         ),
// //       ),
// //       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
// //       onChanged: (val) {
// //         if (val.isNotEmpty && index < _otpLength - 1) {
// //           // Request focus without causing keyboard to dismiss
// //           FocusScope.of(context).requestFocus(_otpFocus[index + 1]);
// //         } else if (val.isEmpty && index > 0) {
// //           FocusScope.of(context).requestFocus(_otpFocus[index - 1]);
// //         }
// //       },
// //     ),
// //   );
// // }

// //   // ── Step 3: Signup ───────────────────────────────────────────────────────
// //   Widget _buildSignupStep() {
// //     final isDarkMode = _isDarkMode;

// //     return Consumer<SignupProvider>(
// //       builder: (context, signupProvider, child) {
// //         return Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             GestureDetector(
// //               onTap: () => _goTo(AuthStep.otp),
// //               child: Container(
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: _inputBg,
// //                   borderRadius: BorderRadius.circular(12),
// //                   border: Border.all(color: _purple.withOpacity(0.3)),
// //                 ),
// //                 child: Icon(
// //                   Icons.arrow_back_ios_new,
// //                   color: _textPrimary,
// //                   size: 18,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             Container(
// //               padding: const EdgeInsets.all(14),
// //               decoration: BoxDecoration(
// //                 color: _purple.withOpacity(isDarkMode ? 0.15 : 0.1),
// //                 borderRadius: BorderRadius.circular(12),
// //                 border: Border.all(color: _purple.withOpacity(0.4)),
// //               ),
// //               child: Row(
// //                 children: [
// //                   Icon(
// //                     Icons.info_outline,
// //                     color: Colors.purple.shade300,
// //                     size: 20,
// //                   ),
// //                   const SizedBox(width: 10),
// //                   Text(
// //                     'Welcome! Please complete your profile',
// //                     style: TextStyle(
// //                       color: isDarkMode ? Colors.purple.shade100 : _purple,
// //                       fontSize: 13.5,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             _labeledField('Full Name', _nameCtrl, Icons.person_outline),
// //             const SizedBox(height: 16),
// //             _labeledField(
// //               'Email',
// //               _emailCtrl,
// //               Icons.email_outlined,
// //               keyboardType: TextInputType.emailAddress,
// //             ),
// //             const SizedBox(height: 16),
// //             _labeledField('Brand Name', _brandCtrl, Icons.store_outlined),
// //             const SizedBox(height: 16),
// //             _lockedField(
// //               'Mobile Number',
// //               _mobileCtrl.text,
// //               Icons.phone_android,
// //             ),
// //             const SizedBox(height: 16),
// //             _genderDropdown(),
// //             const SizedBox(height: 16),
// //             _datePicker(
// //               'Date of Birth (Optional)',
// //               Icons.cake_outlined,
// //               _dob,
// //               () => _pickDate(true),
// //             ),
// //             const SizedBox(height: 16),
// //             _datePicker(
// //               'Anniversary Date (Optional)',
// //               Icons.favorite_border,
// //               _anniversary,
// //               () => _pickDate(false),
// //             ),
// //             const SizedBox(height: 16),
// //             _labeledField(
// //               'Referral Code (Optional)',
// //               _referralCtrl,
// //               Icons.card_giftcard,
// //             ),
// //             const SizedBox(height: 32),
// //             _gradientButton(
// //               'Complete Registration',
// //               signupProvider.isLoading ? null : _handleSignup,
// //               isLoading: signupProvider.isLoading,
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   // ── Shared Widgets ───────────────────────────────────────────────────────
// //   Widget _inputField({
// //     required TextEditingController controller,
// //     required String hint,
// //     TextInputType? keyboardType,
// //     List<TextInputFormatter>? formatters,
// //   }) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: _inputBg,
// //         borderRadius: BorderRadius.circular(50),
// //         border: Border.all(color: _purple.withOpacity(0.4)),
// //       ),
// //       child: TextField(
// //         controller: controller,
// //         keyboardType: keyboardType,
// //         inputFormatters: formatters,
// //         style: TextStyle(color: _textPrimary, fontSize: 15),
// //         decoration: InputDecoration(
// //           hintText: hint,
// //           hintStyle: TextStyle(color: _textSecondary),
// //           border: InputBorder.none,
// //           contentPadding: const EdgeInsets.symmetric(
// //             horizontal: 20,
// //             vertical: 16,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _labeledField(
// //     String label,
// //     TextEditingController ctrl,
// //     IconData icon, {
// //     TextInputType? keyboardType,
// //   }) {
// //     final isDarkMode = _isDarkMode;

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: _inputBg,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: _purple.withOpacity(0.35)),
// //         boxShadow: [
// //           BoxShadow(
// //             color: _purple.withOpacity(0.08),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: TextField(
// //         controller: ctrl,
// //         keyboardType: keyboardType,
// //         style: TextStyle(color: _textPrimary, fontSize: 15),
// //         decoration: InputDecoration(
// //           labelText: label,
// //           labelStyle: TextStyle(color: _textSecondary, fontSize: 13),
// //           prefixIcon: Icon(icon, color: _purple.withOpacity(0.8), size: 20),
// //           border: InputBorder.none,
// //           contentPadding: const EdgeInsets.symmetric(
// //             horizontal: 16,
// //             vertical: 16,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _lockedField(String label, String value, IconData icon) {
// //     final isDarkMode = _isDarkMode;

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
// //       decoration: BoxDecoration(
// //         color: _cardBg,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(
// //           color: isDarkMode
// //               ? Colors.grey.withOpacity(0.2)
// //               : Colors.grey.shade200,
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(icon, color: _textSecondary, size: 20),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Text(
// //               value,
// //               style: TextStyle(color: _textSecondary, fontSize: 15),
// //             ),
// //           ),
// //           Icon(Icons.lock, color: _textSecondary, size: 16),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _genderDropdown() {
// //     final isDarkMode = _isDarkMode;

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: _inputBg,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: _purple.withOpacity(0.35)),
// //         boxShadow: [
// //           BoxShadow(
// //             color: _purple.withOpacity(0.08),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: DropdownButtonFormField<String>(
// //         value: _gender,
// //         hint: Text(
// //           'Select Gender',
// //           style: TextStyle(color: _textSecondary, fontSize: 13),
// //         ),
// //         dropdownColor: _bg2,
// //         style: TextStyle(color: _textPrimary, fontSize: 15),
// //         icon: Icon(Icons.keyboard_arrow_down, color: _textSecondary),
// //         decoration: InputDecoration(
// //           prefixIcon: Icon(Icons.wc, color: _purple.withOpacity(0.8), size: 20),
// //           border: InputBorder.none,
// //           labelText: 'Gender',
// //           labelStyle: TextStyle(color: _textSecondary, fontSize: 13),
// //         ),
// //         items: const [
// //           DropdownMenuItem(value: 'Male', child: Text('Male')),
// //           DropdownMenuItem(value: 'Female', child: Text('Female')),
// //           DropdownMenuItem(value: 'Other', child: Text('Other')),
// //         ],
// //         onChanged: (v) => setState(() => _gender = v),
// //       ),
// //     );
// //   }

// //   Widget _datePicker(
// //     String label,
// //     IconData icon,
// //     DateTime? date,
// //     VoidCallback onTap,
// //   ) {
// //     final isDarkMode = _isDarkMode;

// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(14),
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
// //         decoration: BoxDecoration(
// //           color: _inputBg,
// //           borderRadius: BorderRadius.circular(14),
// //           border: Border.all(color: _purple.withOpacity(0.35)),
// //           boxShadow: [
// //             BoxShadow(
// //               color: _purple.withOpacity(0.08),
// //               blurRadius: 10,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Row(
// //           children: [
// //             Icon(icon, color: _purple.withOpacity(0.8), size: 20),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Text(
// //                 date != null
// //                     ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
// //                     : label,
// //                 style: TextStyle(
// //                   color: date != null ? _textPrimary : _textSecondary,
// //                   fontSize: 14,
// //                 ),
// //               ),
// //             ),
// //             Icon(Icons.calendar_today, color: _textSecondary, size: 18),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _gradientButton(
// //     String label,
// //     VoidCallback? onPressed, {
// //     bool isLoading = false,
// //   }) {
// //     return Container(
// //       width: double.infinity,
// //       height: 54,
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFF6C63FF), Color(0xFF448AFF)],
// //           begin: Alignment.centerLeft,
// //           end: Alignment.centerRight,
// //         ),
// //         borderRadius: BorderRadius.circular(50),
// //         boxShadow: [
// //           BoxShadow(
// //             color: _purple.withOpacity(0.45),
// //             blurRadius: 20,
// //             offset: const Offset(0, 8),
// //           ),
// //         ],
// //       ),
// //       child: ElevatedButton(
// //         onPressed: onPressed,
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: Colors.transparent,
// //           shadowColor: Colors.transparent,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(50),
// //           ),
// //         ),
// //         child: isLoading
// //             ? const SizedBox(
// //                 height: 20,
// //                 width: 20,
// //                 child: CircularProgressIndicator(
// //                   color: Colors.white,
// //                   strokeWidth: 2,
// //                 ),
// //               )
// //             : Text(
// //                 label,
// //                 style: const TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.w700,
// //                   color: Colors.white,
// //                   letterSpacing: 0.8,
// //                 ),
// //               ),
// //       ),
// //     );
// //   }

// //   Widget _socialBtn(String label, Color bg, Color fg, {VoidCallback? onTap}) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         width: 56,
// //         height: 56,
// //         decoration: BoxDecoration(
// //           color: bg,
// //           shape: BoxShape.circle,
// //           boxShadow: [
// //             BoxShadow(
// //               color: bg.withOpacity(0.4),
// //               blurRadius: 12,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         alignment: Alignment.center,
// //         child: Text(
// //           label,
// //           style: TextStyle(
// //             color: fg,
// //             fontSize: 22,
// //             fontWeight: FontWeight.w900,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─── Background Diagonal Shapes ──────────────────────────────────────────────
// // class _DiagonalShapes extends StatelessWidget {
// //   const _DiagonalShapes();

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //     final size = MediaQuery.of(context).size;

// //     return SizedBox(
// //       width: size.width,
// //       height: size.height,
// //       child: CustomPaint(painter: _DiagonalPainter(isDarkMode: isDarkMode)),
// //     );
// //   }
// // }

// // class _DiagonalPainter extends CustomPainter {
// //   final bool isDarkMode;

// //   _DiagonalPainter({required this.isDarkMode});

// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final opacity1 = isDarkMode ? 0.12 : 0.06;
// //     final opacity2 = isDarkMode ? 0.08 : 0.04;
// //     final opacity3 = isDarkMode ? 0.06 : 0.03;

// //     final paint1 = Paint()
// //       ..color = const Color(0xFF6C63FF).withOpacity(opacity1)
// //       ..style = PaintingStyle.fill;

// //     final paint2 = Paint()
// //       ..color = const Color(0xFF448AFF).withOpacity(opacity2)
// //       ..style = PaintingStyle.fill;

// //     final paint3 = Paint()
// //       ..color = const Color(0xFF6C63FF).withOpacity(opacity3)
// //       ..style = PaintingStyle.fill;

// //     final path1 = Path()
// //       ..moveTo(size.width * 0.3, 0)
// //       ..lineTo(size.width, 0)
// //       ..lineTo(size.width, size.height * 0.45)
// //       ..lineTo(size.width * 0.1, size.height * 0.15)
// //       ..close();
// //     canvas.drawPath(path1, paint1);

// //     final path2 = Path()
// //       ..moveTo(0, size.height * 0.75)
// //       ..lineTo(size.width * 0.6, size.height * 0.9)
// //       ..lineTo(size.width * 0.4, size.height)
// //       ..lineTo(0, size.height)
// //       ..close();
// //     canvas.drawPath(path2, paint2);

// //     final path3 = Path()
// //       ..moveTo(0, 0)
// //       ..lineTo(size.width * 0.25, 0)
// //       ..lineTo(0, size.height * 0.18)
// //       ..close();
// //     canvas.drawPath(path3, paint3);
// //   }

// //   @override
// //   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// // }

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:posternova/models/register_model.dart';
// import 'package:posternova/providers/auth/google_provider.dart';
// import 'package:posternova/providers/auth/login_provider.dart';
// import 'package:posternova/providers/auth/otp_provider.dart';
// import 'package:posternova/providers/auth/register_provider.dart';
// import 'package:posternova/views/NavBar/navbar_screen.dart';
// import 'package:provider/provider.dart';

// // ─── Auth Steps Enum ─────────────────────────────────────────────────────────
// enum AuthStep { mobile, otp, signup }

// // ─── Auth Screen ─────────────────────────────────────────────────────────────
// class AuthScreen extends StatefulWidget {
//   const AuthScreen({Key? key}) : super(key: key);

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
//   // ── Theme Colors ──────────────────────────────────────────────────────────
//   bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

//   Color get _bg1 =>
//       _isDarkMode ? const Color(0xFF0A0E21) : const Color(0xFFF5F5F5);
//   Color get _bg2 =>
//       _isDarkMode ? const Color(0xFF1D1E33) : const Color(0xFFFFFFFF);
//   Color get _purple => const Color(0xFF6C63FF);
//   Color get _blue => const Color(0xFF448AFF);
//   Color get _textPrimary =>
//       _isDarkMode ? Colors.white : const Color(0xFF1A1A1A);
//   Color get _textSecondary =>
//       _isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
//   Color get _cardBg =>
//       _isDarkMode ? const Color(0xFF12132A) : Colors.grey.shade50;
//   Color get _inputBg =>
//       _isDarkMode ? const Color(0xFF0A0E21) : Colors.grey.shade100;

//   // ── OTP Length (6 digits) ───────────────────────────────────────────────
//   static const int _otpLength = 4;

//   // ── State ────────────────────────────────────────────────────────────────
//   AuthStep _step = AuthStep.mobile;

//   // Mobile step
//   final _mobileCtrl = TextEditingController();

//   // OTP step - Single field approach
//   final TextEditingController _otpController = TextEditingController();
//   final FocusNode _otpFocusNode = FocusNode();
//   int _resendSeconds = 30;
//   late final AnimationController _resendTimer;

//   // Signup step
//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _brandCtrl = TextEditingController();
//   final _referralCtrl = TextEditingController();
//   String? _gender;
//   DateTime? _dob;
//   DateTime? _anniversary;
//   bool _isMobileLocked = false;

//   // ── Animations ───────────────────────────────────────────────────────────
//   late final AnimationController _floatCtrl;
//   late final Animation<double> _floatAnim;

//   late final AnimationController _shimmerCtrl;
//   late final Animation<double> _shimmerAnim;

//   late final AnimationController _slideCtrl;
//   late final Animation<Offset> _slideAnim;
//   late final Animation<double> _fadeAnim;

//   // ── Bypass Numbers (for testing/playstore) ───────────────────────────────
//   static const List<String> _bypassNumbers = ['9849008143', '9744037599'];

//   // ── Helpers ───────────────────────────────────────────────────────────────
//   bool get _isBypassNumber => _bypassNumbers.contains(_mobileCtrl.text.trim());

//   @override
//   void initState() {
//     super.initState();

//     _floatCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat(reverse: true);
//     _floatAnim = Tween<double>(
//       begin: -8,
//       end: 8,
//     ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

//     _shimmerCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();
//     _shimmerAnim = Tween<double>(
//       begin: -1,
//       end: 2,
//     ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear));

//     _slideCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     )..forward();
//     _slideAnim = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
//     _fadeAnim = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);

//     _resendTimer = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 30),
//     );
//   }

//   @override
//   void dispose() {
//     _floatCtrl.dispose();
//     _shimmerCtrl.dispose();
//     _slideCtrl.dispose();
//     _resendTimer.dispose();
//     _mobileCtrl.dispose();
//     _emailCtrl.dispose();
//     _brandCtrl.dispose();
//     _referralCtrl.dispose();
//     _otpController.dispose();
//     _otpFocusNode.dispose();
//     _nameCtrl.dispose();
//     super.dispose();
//   }

//   // ── Navigation ───────────────────────────────────────────────────────────
//   void _goTo(AuthStep step) {
//     _slideCtrl.reset();
//     setState(() => _step = step);
//     _slideCtrl.forward();
//   }

//   void _startResendTimer() {
//     _resendSeconds = 30;
//     _resendTimer.reset();
//     _resendTimer.forward();
//     Future.doWhile(() async {
//       await Future.delayed(const Duration(seconds: 1));
//       if (!mounted) return false;
//       setState(() => _resendSeconds--);
//       return _resendSeconds > 0;
//     });
//   }

//   // ── Backend Logic ─────────────────────────────────────────────────

//   Future<void> _handleSendOtp() async {
//     final mobile = _mobileCtrl.text.trim();

//     if (mobile.length != 10) {
//       _snack('Please enter a valid 10-digit mobile number');
//       return;
//     }

//     final smsProvider = Provider.of<SmsProvider>(context, listen: false);

//     if (_isBypassNumber) {
//       _snack('OTP sent successfully!');
//       _goTo(AuthStep.otp);
//       _startResendTimer();
//       return;
//     }

//     final res = await smsProvider.login(mobile);

//     if (res) {
//       _snack('OTP sent successfully!');
//       _goTo(AuthStep.otp);
//       _startResendTimer();
//     } else {
//       _snack(smsProvider.errorMessage ?? 'Failed to send OTP');
//     }
//   }

//   // Future<void> _handleVerifyOtp() async {
//   //   final mobile = _mobileCtrl.text.trim();
//   //   final enteredOtp = _otpController.text.trim();

//   //   if (enteredOtp.length < _otpLength) {
//   //     _snack('Please enter the complete $_otpLength-digit OTP');
//   //     return;
//   //   }

//   //   final smsProvider = Provider.of<SmsProvider>(context, listen: false);
//   //   final authProvider = Provider.of<AuthProvider>(context, listen: false);

//   //   if (_isBypassNumber) {
//   //     await smsProvider.verifyOtp(enteredOtp, mobile, context);

//   //     if (smsProvider.otpResponse?.statusCode == 200) {
//   //       final userData = jsonDecode(smsProvider.otpResponse!.body);
//   //       final user = userData['user'];

//   //       final hasName =
//   //           user['name'] != null && user['name'].toString().isNotEmpty;
//   //       final hasEmail =
//   //           user['email'] != null && user['email'].toString().isNotEmpty;

//   //       if (!hasName || !hasEmail) {
//   //         setState(() => _isMobileLocked = true);
//   //         _goTo(AuthStep.signup);
//   //         return;
//   //       }

//   //       final success = await authProvider.login(mobile);
//   //       if (success) {
//   //         Navigator.pushReplacement(
//   //           context,
//   //           MaterialPageRoute(builder: (_) => MainNavigationScreen()),
//   //         );
//   //       }
//   //     } else {
//   //       _snack("Invalid OTP");
//   //     }
//   //     return;
//   //   }

//   //   await smsProvider.verifyOtp(enteredOtp, mobile, context);

//   //   if (smsProvider.otpResponse?.statusCode == 200) {
//   //     final userData = jsonDecode(smsProvider.otpResponse!.body);
//   //     final user = userData['user'];

//   //     final hasName =
//   //         user['name'] != null && user['name'].toString().isNotEmpty;
//   //     final hasEmail =
//   //         user['email'] != null && user['email'].toString().isNotEmpty;

//   //     if (!hasName || !hasEmail) {
//   //       setState(() => _isMobileLocked = true);
//   //       _goTo(AuthStep.signup);
//   //       return;
//   //     }

//   //     final success = await authProvider.login(mobile);
//   //     if (success) {
//   //       Navigator.pushReplacement(
//   //         context,
//   //         MaterialPageRoute(builder: (_) => MainNavigationScreen()),
//   //       );
//   //     }
//   //   } else {
//   //     _snack(smsProvider.errorMessage ?? "Invalid OTP");
//   //   }
//   // }

//   Future<void> _handleVerifyOtp() async {
//     final mobile = _mobileCtrl.text.trim();
//     final enteredOtp = _otpController.text.trim();

//     if (enteredOtp.length < _otpLength) {
//       _snack('Please enter the complete $_otpLength-digit OTP');
//       return;
//     }

//     final smsProvider = Provider.of<SmsProvider>(context, listen: false);

//     if (_isBypassNumber) {
//       await smsProvider.verifyOtp(enteredOtp, mobile, context);

//       if (smsProvider.otpResponse?.statusCode == 200) {
//         final userData = jsonDecode(smsProvider.otpResponse!.body);
//         final user = userData['user'];

//         final hasName =
//             user['name'] != null && user['name'].toString().isNotEmpty;
//         final hasEmail =
//             user['email'] != null && user['email'].toString().isNotEmpty;

//         if (!hasName || !hasEmail) {
//           setState(() => _isMobileLocked = true);
//           _goTo(AuthStep.signup);
//           return;
//         }

//         // ✅ Remove authProvider.login(mobile) — verifyOtp already calls setUser()
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => MainNavigationScreen()),
//         );
//       } else {
//         _snack("Invalid OTP");
//       }
//       return;
//     }

//     await smsProvider.verifyOtp(enteredOtp, mobile, context);

//     if (smsProvider.otpResponse?.statusCode == 200) {
//       final userData = jsonDecode(smsProvider.otpResponse!.body);
//       final user = userData['user'];

//       final hasName =
//           user['name'] != null && user['name'].toString().isNotEmpty;
//       final hasEmail =
//           user['email'] != null && user['email'].toString().isNotEmpty;

//       if (!hasName || !hasEmail) {
//         setState(() => _isMobileLocked = true);
//         _goTo(AuthStep.signup);
//         return;
//       }

//       // ✅ Remove authProvider.login(mobile) — verifyOtp already calls setUser()
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => MainNavigationScreen()),
//       );
//     } else {
//       _snack(smsProvider.errorMessage ?? "Invalid OTP");
//     }
//   }

//   Future<void> _handleResendOtp() async {
//     final mobile = _mobileCtrl.text.trim();
//     final smsProvider = Provider.of<SmsProvider>(context, listen: false);

//     // Clear OTP field
//     _otpController.clear();

//     if (_isBypassNumber) {
//       _startResendTimer();
//       _snack('OTP resent successfully!');
//       return;
//     }

//     final res = await smsProvider.resendOtp(mobile);

//     if (res) {
//       _snack('OTP resent successfully!');
//     } else {
//       _snack(smsProvider.errorMessage ?? 'Failed to resend OTP');
//     }
//   }

//   Future<void> _handleSignup() async {
//     if (_nameCtrl.text.trim().isEmpty) {
//       _snack('Please enter your name');
//       return;
//     }
//     if (_emailCtrl.text.trim().isEmpty) {
//       _snack('Please enter your email');
//       return;
//     }
//     if (_mobileCtrl.text.trim().isEmpty ||
//         _mobileCtrl.text.trim().length != 10) {
//       _snack('Please enter a valid 10-digit mobile number');
//       return;
//     }

//     final signupProvider = Provider.of<SignupProvider>(context, listen: false);

//     final signupModel = SignupModel(
//       id: '',
//       name: _nameCtrl.text.trim(),
//       email: _emailCtrl.text.trim(),
//       mobile: _mobileCtrl.text.trim(),
//       dob: _dob != null
//           ? '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}'
//           : null,
//       marriageAnniversary: _anniversary != null
//           ? '${_anniversary!.year}-${_anniversary!.month.toString().padLeft(2, '0')}-${_anniversary!.day.toString().padLeft(2, '0')}'
//           : null,
//       referralCode: _referralCtrl.text.trim().isEmpty
//           ? null
//           : _referralCtrl.text.trim(),
//     );

//     final success = await signupProvider.registerUser(signupModel);

//     if (success) {
//       _snack('Registration successful! 🎉');
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//       );
//     } else {
//       _snack(signupProvider.errorMessage ?? 'Registration failed');
//     }
//   }

//   // ── Helpers ───────────────────────────────────────────────────────────────
//   void _snack(String msg) {
//     final isDarkMode = _isDarkMode;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           msg,
//           style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
//         ),
//         backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Future<void> _pickDate(bool isDob) async {
//     final isDarkMode = _isDarkMode;

//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime(isDob ? 1995 : 2020),
//       firstDate: DateTime(1950),
//       lastDate: DateTime.now(),
//       builder: (ctx, child) => Theme(
//         data: isDarkMode
//             ? ThemeData.dark().copyWith(
//                 colorScheme: ColorScheme.dark(primary: _purple, surface: _bg2),
//                 dialogBackgroundColor: _bg2,
//               )
//             : ThemeData.light().copyWith(
//                 colorScheme: ColorScheme.light(
//                   primary: _purple,
//                   surface: Colors.white,
//                 ),
//                 dialogBackgroundColor: Colors.white,
//               ),
//         child: child!,
//       ),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isDob) {
//           _dob = picked;
//         } else {
//           _anniversary = picked;
//         }
//       });
//     }
//   }

//   // ── Build ────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _bg1,
//       body: Stack(
//         children: [
//           const _DiagonalShapes(),
//           SafeArea(
//             child: Column(
//               children: [
//                 _buildHeroSection(),
//                 Expanded(
//                   child: SlideTransition(
//                     position: _slideAnim,
//                     child: FadeTransition(
//                       opacity: _fadeAnim,
//                       child: _buildStepContent(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Hero Section ─────────────────────────────────────────────────────────
//   Widget _buildHeroSection() {
//     final isDarkMode = _isDarkMode;

//     return SizedBox(
//       height: 260,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           AnimatedBuilder(
//             animation: _floatAnim,
//             builder: (_, __) => Transform.translate(
//               offset: Offset(0, _floatAnim.value),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 90,
//                     height: 90,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(22),
//                       boxShadow: [
//                         BoxShadow(
//                           color: _purple.withOpacity(0.5),
//                           blurRadius: 24,
//                           spreadRadius: 4,
//                         ),
//                       ],
//                     ),

//                     // child: ClipRRect(
//                     //   borderRadius: BorderRadius.circular(22),
//                     //   child: Image.asset(
//                     //     'assets/appstore.png',
//                     //     fit: BoxFit.cover,
//                     //   ),
//                     // ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(22),
//                       child: Image.asset(
//                         'assets/mainlogo.jpeg',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   AnimatedBuilder(
//                     animation: _shimmerAnim,
//                     builder: (_, __) => ShaderMask(
//                       shaderCallback: (bounds) => LinearGradient(
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                         stops: [
//                           (_shimmerAnim.value - 0.3).clamp(0.0, 1.0),
//                           _shimmerAnim.value.clamp(0.0, 1.0),
//                           (_shimmerAnim.value + 0.3).clamp(0.0, 1.0),
//                         ],
//                         colors: const [
//                           Color(0xFF9C8FFF),
//                           Colors.white,
//                           Color(0xFF6C63FF),
//                         ],
//                       ).createShader(bounds),
//                       child: const Text(
//                         'Edit Ezy',
//                         style: TextStyle(
//                           fontSize: 40,
//                           fontWeight: FontWeight.w900,
//                           color: Colors.white,
//                           letterSpacing: 2,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     'Create Amazing Posters',
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: isDarkMode
//                           ? Colors.grey.shade400
//                           : Colors.grey.shade600,
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Step Content Container ────────────────────────────────────────────────
//   Widget _buildStepContent() {
//     final isDarkMode = _isDarkMode;

//     return Container(
//       decoration: BoxDecoration(
//         color: _bg2.withOpacity(isDarkMode ? 0.95 : 0.98),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//         border: Border(
//           top: BorderSide(color: _purple.withOpacity(0.3), width: 1),
//         ),
//       ),
//       child: ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
//           child: switch (_step) {
//             AuthStep.mobile => _buildMobileStep(),
//             AuthStep.otp => _buildOtpStep(),
//             AuthStep.signup => _buildSignupStep(),
//           },
//         ),
//       ),
//     );
//   }

//   // ── Step 1: Mobile ───────────────────────────────────────────────────────
//   Widget _buildMobileStep() {
//     final isDarkMode = _isDarkMode;

//     return Consumer<SmsProvider>(
//       builder: (context, smsProvider, child) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 50),
//             Text(
//               'Register with Mobile Number',
//               style: TextStyle(
//                 fontSize: 23,
//                 fontWeight: FontWeight.w700,
//                 color: _textPrimary,
//                 letterSpacing: 0.3,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               'We will send you a verification code',
//               style: TextStyle(fontSize: 18, color: _textSecondary),
//             ),
//             const SizedBox(height: 80),
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 16,
//                   ),
//                   decoration: BoxDecoration(
//                     color: _inputBg,
//                     borderRadius: BorderRadius.circular(50),
//                     border: Border.all(color: _purple.withOpacity(0.4)),
//                   ),
//                   child: Row(
//                     children: [
//                       const Text('🇮🇳', style: TextStyle(fontSize: 18)),
//                       const SizedBox(width: 6),
//                       Text(
//                         '+91',
//                         style: TextStyle(
//                           color: _textSecondary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _inputField(
//                     controller: _mobileCtrl,
//                     hint: 'Mobile Number',
//                     keyboardType: TextInputType.phone,
//                     formatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(10),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 28),
//             _gradientButton(
//               'Continue',
//               smsProvider.isLoading ? null : _handleSendOtp,
//               isLoading: smsProvider.isLoading,
//             ),
//             const SizedBox(height: 24),
//             if (Platform.isAndroid)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Consumer<GoogleProvider>(
//                     builder: (context, googleProvider, child) {
//                       return _socialBtn(
//                         'G',
//                         const Color(0xFF4285F4),
//                         Colors.white,
//                         onTap: googleProvider.isLoading
//                             ? null
//                             : () async {
//                                 final success = await googleProvider
//                                     .signInWithGoogle(context);
//                                 if (success) {
//                                   if (googleProvider.googleSignInResponse !=
//                                       null) {
//                                     final data = jsonDecode(
//                                       googleProvider.googleSignInResponse!.body,
//                                     );
//                                     final user = data['user'];

//                                     final hasName =
//                                         user['name'] != null &&
//                                         user['name'] != '';
//                                     final hasEmail =
//                                         user['email'] != null &&
//                                         user['email'] != '';

//                                     if (!hasName || !hasEmail) {
//                                       if (user['mobile'] != null) {
//                                         _mobileCtrl.text = user['mobile'];
//                                         setState(() => _isMobileLocked = true);
//                                         _goTo(AuthStep.signup);
//                                       }
//                                     } else {
//                                       Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) =>
//                                               MainNavigationScreen(),
//                                         ),
//                                       );
//                                     }
//                                   }
//                                 } else if (googleProvider.error != null) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(googleProvider.error!),
//                                       backgroundColor: isDarkMode
//                                           ? const Color(0xFF1E293B)
//                                           : Colors.white,
//                                     ),
//                                   );
//                                 }
//                               },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//           ],
//         );
//       },
//     );
//   }

//   // ── Step 2: OTP (Single Field with Visual Boxes) ─────────────────────────
//   Widget _buildOtpStep() {
//     final isDarkMode = _isDarkMode;

//     return Consumer<SmsProvider>(
//       builder: (context, smsProvider, child) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             GestureDetector(
//               onTap: () => _goTo(AuthStep.mobile),
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: _inputBg,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: _purple.withOpacity(0.3)),
//                 ),
//                 child: Icon(
//                   Icons.arrow_back_ios_new,
//                   color: _textPrimary,
//                   size: 18,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Enter OTP',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w800,
//                 color: _textPrimary,
//               ),
//             ),
//             const SizedBox(height: 6),
//             RichText(
//               text: TextSpan(
//                 style: TextStyle(fontSize: 13, color: _textSecondary),
//                 children: [
//                   const TextSpan(text: 'Sent to +91 '),
//                   TextSpan(
//                     text: _mobileCtrl.text,
//                     style: const TextStyle(
//                       color: Color(0xFF6C63FF),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 32),
//             // Visual OTP boxes with hidden text field
//             _buildVisualOtpBoxes(),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   _resendSeconds > 0
//                       ? "Resend OTP in ${_resendSeconds}s"
//                       : "Didn't receive OTP? ",
//                   style: TextStyle(color: _textSecondary, fontSize: 13),
//                 ),
//                 if (_resendSeconds == 0)
//                   GestureDetector(
//                     onTap: smsProvider.isResending ? null : _handleResendOtp,
//                     child: Text(
//                       smsProvider.isResending ? 'Resending...' : 'Resend',
//                       style: const TextStyle(
//                         color: Color(0xFF6C63FF),
//                         fontWeight: FontWeight.w700,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 32),
//             _gradientButton(
//               'Verify OTP',
//               smsProvider.isLoading ? null : _handleVerifyOtp,
//               isLoading: smsProvider.isLoading,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Visual OTP boxes with hidden TextField
//   Widget _buildVisualOtpBoxes() {
//     return GestureDetector(
//       onTap: () {
//         // Focus on hidden text field when tapping on boxes
//         _otpFocusNode.requestFocus();
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         child: Stack(
//           children: [
//             // Hidden TextField
//             Positioned.fill(
//               child: Opacity(
//                 opacity: 0,
//                 child: TextField(
//                   controller: _otpController,
//                   focusNode: _otpFocusNode,
//                   keyboardType: TextInputType.number,
//                   maxLength: _otpLength,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(_otpLength),
//                   ],
//                   onChanged: (value) {
//                     setState(() {}); // Rebuild to update visual boxes
//                     // Auto verify when OTP is complete (optional)
//                     if (value.length == _otpLength) {
//                       // Uncomment below if you want auto-verification
//                       // Future.delayed(Duration(milliseconds: 100), () {
//                       //   _handleVerifyOtp();
//                       // });
//                     }
//                   },
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     counterText: '',
//                   ),
//                 ),
//               ),
//             ),
//             // Visual OTP Boxes
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(_otpLength, (index) {
//                 final digit = _otpController.text.length > index
//                     ? _otpController.text[index]
//                     : '';
//                 return Container(
//                   width: 50,
//                   height: 55,
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   decoration: BoxDecoration(
//                     color: _inputBg,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: _otpFocusNode.hasFocus
//                           ? _purple
//                           : _purple.withOpacity(0.4),
//                       width: _otpFocusNode.hasFocus ? 2 : 1.5,
//                     ),
//                     boxShadow: _otpFocusNode.hasFocus
//                         ? [
//                             BoxShadow(
//                               color: _purple.withOpacity(0.2),
//                               blurRadius: 8,
//                               spreadRadius: 1,
//                             ),
//                           ]
//                         : null,
//                   ),
//                   child: Center(
//                     child: Text(
//                       digit,
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w800,
//                         color: _textPrimary,
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Step 3: Signup ───────────────────────────────────────────────────────
//   Widget _buildSignupStep() {
//     final isDarkMode = _isDarkMode;

//     return Consumer<SignupProvider>(
//       builder: (context, signupProvider, child) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () => _goTo(AuthStep.otp),
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: _inputBg,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: _purple.withOpacity(0.3)),
//                 ),
//                 child: Icon(
//                   Icons.arrow_back_ios_new,
//                   color: _textPrimary,
//                   size: 18,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: _purple.withOpacity(isDarkMode ? 0.15 : 0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: _purple.withOpacity(0.4)),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.info_outline,
//                     color: Colors.purple.shade300,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     'Welcome! Please complete your profile',
//                     style: TextStyle(
//                       color: isDarkMode ? Colors.purple.shade100 : _purple,
//                       fontSize: 13.5,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             _labeledField('Full Name', _nameCtrl, Icons.person_outline),
//             const SizedBox(height: 16),
//             _labeledField(
//               'Email(Optional)',
//               _emailCtrl,
//               Icons.email_outlined,
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 16),
//             _labeledField('Brand Name', _brandCtrl, Icons.store_outlined),
//             const SizedBox(height: 16),
//             _lockedField(
//               'Mobile Number',
//               _mobileCtrl.text,
//               Icons.phone_android,
//             ),
//             const SizedBox(height: 16),
//             _genderDropdown(),
//             const SizedBox(height: 16),

//             // _datePicker(
//             //   'Date of Birth (Optional)',
//             //   Icons.cake_outlined,
//             //   _dob,
//             //   () => _pickDate(true),
//             // ),
//             // const SizedBox(height: 16),
//             // _datePicker(
//             //   'Anniversary Date (Optional)',
//             //   Icons.favorite_border,
//             //   _anniversary,
//             //   () => _pickDate(false),
//             // ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _datePicker(
//                     'Date of Birth',
//                     Icons.cake_outlined,
//                     _dob,
//                     () => _pickDate(true),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _datePicker(
//                     'Anniversary',
//                     Icons.favorite_border,
//                     _anniversary,
//                     () => _pickDate(false),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _labeledField(
//               'Referral Code (Optional)',
//               _referralCtrl,
//               Icons.card_giftcard,
//             ),
//             const SizedBox(height: 32),
//             _gradientButton(
//               'Complete Registration',
//               signupProvider.isLoading ? null : _handleSignup,
//               isLoading: signupProvider.isLoading,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ── Shared Widgets ───────────────────────────────────────────────────────
//   Widget _inputField({
//     required TextEditingController controller,
//     required String hint,
//     TextInputType? keyboardType,
//     List<TextInputFormatter>? formatters,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _inputBg,
//         borderRadius: BorderRadius.circular(50),
//         border: Border.all(color: _purple.withOpacity(0.4)),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         inputFormatters: formatters,
//         style: TextStyle(color: _textPrimary, fontSize: 15),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: TextStyle(color: _textSecondary),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 20,
//             vertical: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _labeledField(
//     String label,
//     TextEditingController ctrl,
//     IconData icon, {
//     TextInputType? keyboardType,
//   }) {
//     final isDarkMode = _isDarkMode;

//     return Container(
//       decoration: BoxDecoration(
//         color: _inputBg,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _purple.withOpacity(0.35)),
//         boxShadow: [
//           BoxShadow(
//             color: _purple.withOpacity(0.08),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: ctrl,
//         keyboardType: keyboardType,
//         style: TextStyle(color: _textPrimary, fontSize: 15),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(color: _textSecondary, fontSize: 13),
//           prefixIcon: Icon(icon, color: _purple.withOpacity(0.8), size: 20),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _lockedField(String label, String value, IconData icon) {
//     final isDarkMode = _isDarkMode;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       decoration: BoxDecoration(
//         color: _cardBg,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: isDarkMode
//               ? Colors.grey.withOpacity(0.2)
//               : Colors.grey.shade200,
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: _textSecondary, size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(color: _textSecondary, fontSize: 15),
//             ),
//           ),
//           Icon(Icons.lock, color: _textSecondary, size: 16),
//         ],
//       ),
//     );
//   }

//   Widget _genderDropdown() {
//     final isDarkMode = _isDarkMode;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: _inputBg,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _purple.withOpacity(0.35)),
//         boxShadow: [
//           BoxShadow(
//             color: _purple.withOpacity(0.08),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: DropdownButtonFormField<String>(
//         value: _gender,
//         hint: Text(
//           'Select Gender',
//           style: TextStyle(color: _textSecondary, fontSize: 13),
//         ),
//         dropdownColor: _bg2,
//         style: TextStyle(color: _textPrimary, fontSize: 15),
//         icon: Icon(Icons.keyboard_arrow_down, color: _textSecondary),
//         decoration: InputDecoration(
//           prefixIcon: Icon(Icons.wc, color: _purple.withOpacity(0.8), size: 20),
//           border: InputBorder.none,
//           labelText: 'Gender',
//           labelStyle: TextStyle(color: _textSecondary, fontSize: 13),
//         ),
//         items: const [
//           DropdownMenuItem(value: 'Male', child: Text('Male')),
//           DropdownMenuItem(value: 'Female', child: Text('Female')),
//           DropdownMenuItem(value: 'Other', child: Text('Other')),
//         ],
//         onChanged: (v) => setState(() => _gender = v),
//       ),
//     );
//   }

//   Widget _datePicker(
//     String label,
//     IconData icon,
//     DateTime? date,
//     VoidCallback onTap,
//   ) {
//     final isDarkMode = _isDarkMode;

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(14),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         decoration: BoxDecoration(
//           color: _inputBg,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _purple.withOpacity(0.35)),
//           boxShadow: [
//             BoxShadow(
//               color: _purple.withOpacity(0.08),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: _purple.withOpacity(0.8), size: 20),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 date != null
//                     ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
//                     : label,
//                 style: TextStyle(
//                   color: date != null ? _textPrimary : _textSecondary,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//             Icon(Icons.calendar_today, color: _textSecondary, size: 18),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _gradientButton(
//     String label,
//     VoidCallback? onPressed, {
//     bool isLoading = false,
//   }) {
//     return Container(
//       width: double.infinity,
//       height: 54,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF6C63FF), Color(0xFF448AFF)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(50),
//         boxShadow: [
//           BoxShadow(
//             color: _purple.withOpacity(0.45),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(50),
//           ),
//         ),
//         child: isLoading
//             ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2,
//                 ),
//               )
//             : Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                   letterSpacing: 0.8,
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _socialBtn(String label, Color bg, Color fg, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 56,
//         height: 56,
//         decoration: BoxDecoration(
//           color: bg,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: bg.withOpacity(0.4),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           label,
//           style: TextStyle(
//             color: fg,
//             fontSize: 22,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─── Background Diagonal Shapes ──────────────────────────────────────────────
// class _DiagonalShapes extends StatelessWidget {
//   const _DiagonalShapes();

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final size = MediaQuery.of(context).size;

//     return SizedBox(
//       width: size.width,
//       height: size.height,
//       child: CustomPaint(painter: _DiagonalPainter(isDarkMode: isDarkMode)),
//     );
//   }
// }

// class _DiagonalPainter extends CustomPainter {
//   final bool isDarkMode;

//   _DiagonalPainter({required this.isDarkMode});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final opacity1 = isDarkMode ? 0.12 : 0.06;
//     final opacity2 = isDarkMode ? 0.08 : 0.04;
//     final opacity3 = isDarkMode ? 0.06 : 0.03;

//     final paint1 = Paint()
//       ..color = const Color(0xFF6C63FF).withOpacity(opacity1)
//       ..style = PaintingStyle.fill;

//     final paint2 = Paint()
//       ..color = const Color(0xFF448AFF).withOpacity(opacity2)
//       ..style = PaintingStyle.fill;

//     final paint3 = Paint()
//       ..color = const Color(0xFF6C63FF).withOpacity(opacity3)
//       ..style = PaintingStyle.fill;

//     final path1 = Path()
//       ..moveTo(size.width * 0.3, 0)
//       ..lineTo(size.width, 0)
//       ..lineTo(size.width, size.height * 0.45)
//       ..lineTo(size.width * 0.1, size.height * 0.15)
//       ..close();
//     canvas.drawPath(path1, paint1);

//     final path2 = Path()
//       ..moveTo(0, size.height * 0.75)
//       ..lineTo(size.width * 0.6, size.height * 0.9)
//       ..lineTo(size.width * 0.4, size.height)
//       ..lineTo(0, size.height)
//       ..close();
//     canvas.drawPath(path2, paint2);

//     final path3 = Path()
//       ..moveTo(0, 0)
//       ..lineTo(size.width * 0.25, 0)
//       ..lineTo(0, size.height * 0.18)
//       ..close();
//     canvas.drawPath(path3, paint3);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

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
import 'package:url_launcher/url_launcher.dart';

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

  // ── OTP Length ──────────────────────────────────────────────────────────
  static const int _otpLength = 4;

  // ── State ────────────────────────────────────────────────────────────────
  AuthStep _step = AuthStep.mobile;

  // Mobile step
  final _mobileCtrl = TextEditingController();

  // OTP step
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
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

  // ── Logo Pulse Animation ─────────────────────────────────────────────────
  late final AnimationController _logoPulseCtrl;
  late final Animation<double> _logoPulseAnim;
  bool _isRegistering = false;

  // ── Animations ───────────────────────────────────────────────────────────
  late final AnimationController _floatCtrl;
  late final Animation<double> _floatAnim;

  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmerAnim;

  late final AnimationController _slideCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  // ── Bypass Numbers ───────────────────────────────────────────────────────
  static const List<String> _bypassNumbers = ['9849008143', '9744037599'];
  bool get _isBypassNumber => _bypassNumbers.contains(_mobileCtrl.text.trim());

  // ── Social Links ─────────────────────────────────────────────────────────
  static const String _instagramUrl = 'https://www.instagram.com/';
  static const String _facebookUrl = 'https://www.facebook.com/';

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

    // Logo pulse animation
    _logoPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _logoPulseAnim = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.9), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.05), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 1),
      ],
    ).animate(CurvedAnimation(parent: _logoPulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _shimmerCtrl.dispose();
    _slideCtrl.dispose();
    _resendTimer.dispose();
    _logoPulseCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _brandCtrl.dispose();
    _referralCtrl.dispose();
    _otpController.dispose();
    _otpFocusNode.dispose();
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _snack('Could not open link');
    }
  }

  // ── Backend Logic ─────────────────────────────────────────────────────────
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
    final enteredOtp = _otpController.text.trim();
    if (enteredOtp.length < _otpLength) {
      _snack('Please enter the complete $_otpLength-digit OTP');
      return;
    }
    final smsProvider = Provider.of<SmsProvider>(context, listen: false);
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainNavigationScreen()),
        );
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigationScreen()),
      );
    } else {
      _snack(smsProvider.errorMessage ?? "Invalid OTP");
    }
  }

  Future<void> _handleResendOtp() async {
    final mobile = _mobileCtrl.text.trim();
    final smsProvider = Provider.of<SmsProvider>(context, listen: false);
    _otpController.clear();
    if (_isBypassNumber) {
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

    // Trigger logo pulse animation
    setState(() => _isRegistering = true);
    await _logoPulseCtrl.forward();
    await _logoPulseCtrl.reverse();
    _logoPulseCtrl.reset();

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
    setState(() => _isRegistering = false);

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
        content: Text(
          msg,
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87),
        ),
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
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
        data: _isDarkMode
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
        if (isDob)
          _dob = picked;
        else
          _anniversary = picked;
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

  // ── Hero Section (compact, no wasted space) ───────────────────────────────
  Widget _buildHeroSection() {
    return SizedBox(
      height: 360,
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
                  // Logo with pulse animation
                  ScaleTransition(
                    scale: _logoPulseAnim,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: _purple.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/mainlogo.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create Amazing Posters',
                    style: TextStyle(
                      fontSize: 12,
                      color: _isDarkMode
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

  // ── Step Content Container ─────────────────────────────────────────────────
  Widget _buildStepContent() {
    return Container(
      decoration: BoxDecoration(
        color: _bg2.withOpacity(_isDarkMode ? 0.95 : 0.98),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: _purple.withOpacity(0.3), width: 1),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: switch (_step) {
            AuthStep.mobile => _buildMobileStep(),
            AuthStep.otp => _buildOtpStep(),
            AuthStep.signup => _buildSignupStep(),
          },
        ),
      ),
    );
  }

  // ── Step 1: Mobile ────────────────────────────────────────────────────────
  Widget _buildMobileStep() {
    return Consumer<SmsProvider>(
      builder: (context, smsProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign In',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: _textPrimary,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'We\'ll send you a verification code',
              style: TextStyle(fontSize: 13, color: _textSecondary),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: _inputBg,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: _purple.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        '+91',
                        style: TextStyle(
                          color: _textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
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
            const SizedBox(height: 16),
            _gradientButton(
              'Continue',
              smsProvider.isLoading ? null : _handleSendOtp,
              isLoading: smsProvider.isLoading,
            ),
            const SizedBox(height: 20),
            // Divider
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: _textSecondary.withOpacity(0.3),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or continue with',
                    style: TextStyle(color: _textSecondary, fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: _textSecondary.withOpacity(0.3),
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Social Buttons Row
            Row(
              children: [
                // Google (Android only)
                if (Platform.isAndroid)
                  Expanded(
                    child: Consumer<GoogleProvider>(
                      builder: (context, googleProvider, child) {
                        return _socialLoginBtn(
                          label: 'Google',
                          icon: _GoogleIcon(),
                          color: const Color(0xFF4285F4),
                          isLoading: googleProvider.isLoading,
                          onTap: googleProvider.isLoading
                              ? null
                              : () async {
                                  final success = await googleProvider
                                      .signInWithGoogle(context);
                                  if (success &&
                                      googleProvider.googleSignInResponse !=
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
                                          builder: (_) =>
                                              MainNavigationScreen(),
                                        ),
                                      );
                                    }
                                  } else if (googleProvider.error != null) {
                                    _snack(googleProvider.error!);
                                  }
                                },
                        );
                      },
                    ),
                  ),
                if (Platform.isAndroid) const SizedBox(width: 10),
                // Instagram
                // Expanded(
                //   child: _socialLoginBtn(
                //     label: 'Instagram',
                //     icon: _InstagramIcon(),
                //     color: const Color(0xFFE1306C),
                //     onTap: () => _launchUrl(_instagramUrl),
                //   ),
                // ),
                // const SizedBox(width: 10),
                // // Facebook
                // Expanded(
                //   child: _socialLoginBtn(
                //     label: 'Facebook',
                //     icon: _FacebookIcon(),
                //     color: const Color(0xFF1877F2),
                //     onTap: () => _launchUrl(_facebookUrl),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16),
            // Terms
            Center(
              child: Text(
                'By continuing, you agree to our Terms & Privacy Policy',
                style: TextStyle(fontSize: 11, color: _textSecondary),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: Text(
                'Follow Us',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Instagram
                GestureDetector(
                  onTap: () => _launchUrl(
                    'https://www.instagram.com/edit_ezy?igsh=MXF6bDhzYnYxcWQ5dg==',
                  ),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/2111/2111463.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFF58529),
                                Color(0xFFDD2A7B),
                                Color(0xFF8134AF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Facebook
                GestureDetector(
                  onTap: () => _launchUrl('https://www.facebook.com/share/17vjV8fvzW/'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/145/145802.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1877F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.facebook,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // YouTube
                GestureDetector(
                  onTap: () => _launchUrl('https://www.youtube.com/'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/1384/1384060.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF0000),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ── Step 2: OTP ────────────────────────────────────────────────────────────
  Widget _buildOtpStep() {
    return Consumer<SmsProvider>(
      builder: (context, smsProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 4),
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
            const SizedBox(height: 24),
            _buildVisualOtpBoxes(),
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
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

  Widget _buildVisualOtpBoxes() {
    return GestureDetector(
      onTap: () => _otpFocusNode.requestFocus(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                child: TextField(
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  keyboardType: TextInputType.number,
                  maxLength: _otpLength,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_otpLength),
                  ],
                  onChanged: (value) => setState(() {}),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_otpLength, (index) {
                final digit = _otpController.text.length > index
                    ? _otpController.text[index]
                    : '';
                return Container(
                  width: 56,
                  height: 58,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _inputBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _otpFocusNode.hasFocus
                          ? _purple
                          : _purple.withOpacity(0.4),
                      width: _otpFocusNode.hasFocus ? 2 : 1.5,
                    ),
                    boxShadow: _otpFocusNode.hasFocus
                        ? [
                            BoxShadow(
                              color: _purple.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      digit,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _textPrimary,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step 3: Signup ──────────────────────────────────────────────────────────
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
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _purple.withOpacity(0.3)),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: _textPrimary,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _purple.withOpacity(_isDarkMode ? 0.15 : 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _purple.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.purple.shade300,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Welcome! Please complete your profile',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.purple.shade100 : _purple,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _labeledField('Full Name', _nameCtrl, Icons.person_outline),
            const SizedBox(height: 12),
            _labeledField(
              'Email (Optional)',
              _emailCtrl,
              Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _labeledField('Brand Name', _brandCtrl, Icons.store_outlined),
            const SizedBox(height: 12),
            _lockedField(
              'Mobile Number',
              _mobileCtrl.text,
              Icons.phone_android,
            ),
            const SizedBox(height: 12),
            _genderDropdown(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _datePicker(
                    'Date of Birth',
                    Icons.cake_outlined,
                    _dob,
                    () => _pickDate(true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _datePicker(
                    'Anniversary',
                    Icons.favorite_border,
                    _anniversary,
                    () => _pickDate(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _labeledField(
              'Referral Code (Optional)',
              _referralCtrl,
              Icons.card_giftcard,
            ),
            const SizedBox(height: 24),
            _gradientButton(
              'Complete Registration',
              (signupProvider.isLoading || _isRegistering)
                  ? null
                  : _handleSignup,
              isLoading: false, // No spinner — logo pulses instead
            ),
          ],
        );
      },
    );
  }

  // ── Shared Widgets ────────────────────────────────────────────────────────
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
        style: TextStyle(color: _textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: _textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
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
        color: _inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _purple.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: TextStyle(color: _textPrimary, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: _textSecondary, fontSize: 12),
          prefixIcon: Icon(icon, color: _purple.withOpacity(0.8), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _lockedField(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isDarkMode
              ? Colors.grey.withOpacity(0.2)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: _textSecondary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: _textSecondary, fontSize: 14),
            ),
          ),
          Icon(Icons.lock, color: _textSecondary, size: 14),
        ],
      ),
    );
  }

  Widget _genderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: _inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _purple.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _gender,
        hint: Text(
          'Select Gender',
          style: TextStyle(color: _textSecondary, fontSize: 12),
        ),
        dropdownColor: _bg2,
        style: TextStyle(color: _textPrimary, fontSize: 14),
        icon: Icon(Icons.keyboard_arrow_down, color: _textSecondary),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.wc, color: _purple.withOpacity(0.8), size: 18),
          border: InputBorder.none,
          labelText: 'Gender',
          labelStyle: TextStyle(color: _textSecondary, fontSize: 12),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: _inputBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _purple.withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
              color: _purple.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: _purple.withOpacity(0.8), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date != null
                    ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
                    : label,
                style: TextStyle(
                  color: date != null ? _textPrimary : _textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
            Icon(Icons.calendar_today, color: _textSecondary, size: 14),
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
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: onPressed == null
              ? [
                  const Color(0xFF6C63FF).withOpacity(0.5),
                  const Color(0xFF448AFF).withOpacity(0.5),
                ]
              : [const Color(0xFF6C63FF), const Color(0xFF448AFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: _purple.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
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
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }

  /// Full-width social login button (Google / Instagram / Facebook)
  Widget _socialLoginBtn({
    required String label,
    required Widget icon,
    required Color color,
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: color.withOpacity(_isDarkMode ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20, height: 20, child: icon),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Social Icon Widgets ──────────────────────────────────────────────────────

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GoogleIconPainter());
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final redPaint = Paint()..color = const Color(0xFFEA4335);
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.0,
      2.0,
      false,
      redPaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.25,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      1.0,
      1.5,
      false,
      bluePaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.25,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.5,
      1.0,
      false,
      greenPaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.25,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.5,
      0.85,
      false,
      yellowPaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.25,
    );

    // Horizontal bar
    final barPaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.5,
        size.height * 0.35,
        size.width * 0.55,
        size.height * 0.3,
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InstagramIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _InstagramIconPainter());
  }
}

class _InstagramIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Gradient background
    final gradient = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        const Color(0xFFF58529),
        const Color(0xFFDD2A7B),
        const Color(0xFF8134AF),
        const Color(0xFF515BD4),
      ],
    ).createShader(rect);

    final bgPaint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(size.width * 0.25),
    );
    canvas.drawRRect(rrect, bgPaint);

    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1;

    // Camera outline
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.15,
          size.height * 0.15,
          size.width * 0.7,
          size.height * 0.7,
        ),
        Radius.circular(size.width * 0.18),
      ),
      white,
    );
    // Lens
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.18,
      white,
    );
    // Dot
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.28),
      size.width * 0.06,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FacebookIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _FacebookIconPainter());
  }
}

class _FacebookIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Blue background
    final bgPaint = Paint()..color = const Color(0xFF1877F2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(size.width * 0.25),
      ),
      bgPaint,
    );

    // "f" letter
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'f',
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.75,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2 + size.width * 0.05,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Background Diagonal Shapes ───────────────────────────────────────────────
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
    final o1 = isDarkMode ? 0.12 : 0.06;
    final o2 = isDarkMode ? 0.08 : 0.04;
    final o3 = isDarkMode ? 0.06 : 0.03;

    final p1 = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(o1)
      ..style = PaintingStyle.fill;
    final p2 = Paint()
      ..color = const Color(0xFF448AFF).withOpacity(o2)
      ..style = PaintingStyle.fill;
    final p3 = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(o3)
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.3, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height * 0.45)
        ..lineTo(size.width * 0.1, size.height * 0.15)
        ..close(),
      p1,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.75)
        ..lineTo(size.width * 0.6, size.height * 0.9)
        ..lineTo(size.width * 0.4, size.height)
        ..lineTo(0, size.height)
        ..close(),
      p2,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width * 0.25, 0)
        ..lineTo(0, size.height * 0.18)
        ..close(),
      p3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
