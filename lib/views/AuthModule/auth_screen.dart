import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posternova/models/register_model.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:posternova/providers/auth/otp_provider.dart';
import 'package:posternova/providers/auth/register_provider.dart';
import 'package:posternova/services/FCM/greet_service.dart';
import 'package:posternova/views/NavBar/navbar_screen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

String? _verificationId;

  // Login Controllers
  final _loginMobileController = TextEditingController();

  // Signup Controllers
  final _signupNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupMobileController = TextEditingController();
  final _signupReferralCodeController = TextEditingController();
  DateTime? _selectedDob;
  DateTime? _selectedMarriageDate;
  
  // OTP Controllers
  final _otpController = TextEditingController();
  bool _showOtpField = false;
  String? _pendingMobile;
  bool _isNewUser = false; // Track if user is new
  bool _isMobileLocked = false; // Track if mobile field should be locked

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginMobileController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupMobileController.dispose();
    _signupReferralCodeController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isDob) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6C63FF),
              surface: Color(0xFF1D1E33),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isDob) {
          _selectedDob = picked;
        } else {
          _selectedMarriageDate = picked;
        }
      });
    }
  }

  // Future<void> _handleLogin() async {
  //   final mobile = _loginMobileController.text.trim();

  //   if (mobile.isEmpty || mobile.length != 10) {
  //     _showSnackBar('Please enter a valid 10-digit mobile number');
  //     return;
  //   }

  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);

  //   final success = await authProvider.login(mobile);

  //   if (success) {
  //     setState(() {
  //       _showOtpField = true;
  //       _pendingMobile = mobile;

  //       // Auto-fill OTP from provider
  //       if (authProvider.otp != null && authProvider.otp!.isNotEmpty) {
  //         _otpController.text = authProvider.otp!;
  //       }
  //     });

  //     _showSnackBar('OTP sent successfully!');
  //   } else {
  //     _showSnackBar(authProvider.error ?? 'Login failed');
  //   }
  // }


// Future<void> _callBackendVerify(String firebaseToken) async {
//   final smsProvider =
//       Provider.of<SmsProvider>(context, listen: false);

//   await smsProvider.verifyWithFirebaseToken(firebaseToken);

//   if (smsProvider.otpResponse?.statusCode == 200) {
//     final data = jsonDecode(smsProvider.otpResponse!.body);

//     final user = data['user'];

//     final hasName =
//         user['name'] != null && user['name'] != '';

//     final hasEmail =
//         user['email'] != null && user['email'] != '';

//     if (!hasName || !hasEmail) {
//       setState(() {
//         _isNewUser = true;
//         _isMobileLocked = true;
//         _signupMobileController.text =
//             _loginMobileController.text;
//       });

//       _tabController.animateTo(1);
//       return;
//     }

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => MainNavigationScreen(),
//       ),
//     );
//   } else {
//     _showSnackBar("Backend verification failed");
//   }
// }



Future<void> _callBackendVerify(String firebaseToken) async {
  final smsProvider =
      Provider.of<SmsProvider>(context, listen: false);

  final authProvider =
      Provider.of<AuthProvider>(context, listen: false);

  await smsProvider.verifyWithFirebaseToken(firebaseToken);

  if (smsProvider.otpResponse?.statusCode == 200) {
    final data = jsonDecode(smsProvider.otpResponse!.body);
    final user = data['user'];

    // ✅ SAVE USER HERE (IMPORTANT)
    await authProvider.login(user['mobile']);

    final hasName =
        user['name'] != null && user['name'] != '';
    final hasEmail =
        user['email'] != null && user['email'] != '';

    if (!hasName || !hasEmail) {
      setState(() {
        _isNewUser = true;
        _isMobileLocked = true;
        _signupMobileController.text =
            _loginMobileController.text;
      });

      _tabController.animateTo(1);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigationScreen(),
      ),
    );
  } else {
    _showSnackBar("Backend verification failed");
  }
}




Future<void> _handleLogin() async {
  final mobile = _loginMobileController.text.trim();

  if (mobile.length != 10) {
    _showSnackBar('Enter valid mobile number');
    return;
  }

  final phone = "+91$mobile";

  try {
    // 🔥 IMPORTANT FOR IOS
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getToken();

    // Give iOS time to register APNs
    await Future.delayed(const Duration(seconds: 2));

    String? apnsToken =
        await FirebaseMessaging.instance.getAPNSToken();

    print("APNS TOKEN: $apnsToken");

    if (apnsToken == null) {
      _showSnackBar("Device not ready. Try again.");
      return;
    }

    // ✅ NOW call verifyPhoneNumber
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);

        final idToken =
            await _firebaseAuth.currentUser!.getIdToken();

        await _callBackendVerify(idToken.toString());
      },
      verificationFailed: (FirebaseAuthException e) {
        _showSnackBar(e.message ?? "Verification failed");
      },
      codeSent: (verificationId, resendToken) {
        setState(() {
          _verificationId = verificationId;
          _showOtpField = true;
        });

        _showSnackBar("OTP sent via Firebase");
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  } catch (e) {
    print("PhoneAuth Error: $e");
  }
}




// Future<void> _handleVerifyOtp() async {
//   final otp = _otpController.text.trim();
//   final mobile = _loginMobileController.text.trim();
  
//   if (otp.isEmpty) {
//     _showSnackBar('Please enter OTP');
//     return;
//   }

//   final smsProvider = Provider.of<SmsProvider>(context, listen: false);
//   final authProvider = Provider.of<AuthProvider>(context, listen: false);

//   // Verify OTP (FCM token is handled automatically inside the provider)
//   await smsProvider.verifyOtp(otp, mobile);

//   if (smsProvider.otpResponse?.statusCode == 200) {
//     final responseBody = smsProvider.otpResponse?.body;
    
//     // Check if user exists in the response
//     if (responseBody != null) {
//       final userData = jsonDecode(responseBody);
//       final user = userData['user'];
      
//       // Get user ID for greet API
//       final userId = user['_id'];
      
//       // Check if user has only basic fields (new user)
//       final hasName = user['name'] != null && user['name'].toString().isNotEmpty;
//       final hasEmail = user['email'] != null && user['email'].toString().isNotEmpty;
      
//       if (!hasName || !hasEmail) {
//         // New user - navigate to registration tab
//         setState(() {
//           _isNewUser = true;
//           _isMobileLocked = true;
//           _signupMobileController.text = mobile;
//           _showOtpField = false;
//           _otpController.clear();
//         });
        
//         _tabController.animateTo(1); // Switch to signup tab
//         _showSnackBar('Please complete your registration');
//         return;
//       }

//       // Existing user - authenticate
//       final success = await authProvider.login(_pendingMobile!);
      
//       if (success) {
//         // Fetch greet data
//         try {
//           final greetService = GreetService();
//           final greetResponse = await greetService.getGreet(userId);
          
//           if (greetResponse.success && greetResponse.data != null) {
//             print('Greeting Title: ${greetResponse.data!.title}');
//             print('Greeting Body: ${greetResponse.data!.body}');
            
//             // Show greeting message (using title)
//             if (greetResponse.data!.title != null) {
//               _showSnackBar(greetResponse.data!.title!);
//             }
//           }
//         } catch (e) {
//           print('Error fetching greet: $e');
//           // Continue even if greet fails
//         }

//         // Navigate to main screen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//         );
//       } else {
//         _showSnackBar('Authentication failed');
//       }
//     }
//   } else {
//     _showSnackBar(smsProvider.errorMessage ?? 'OTP verification failed');
//   }
// }


// Future<void> _handleVerifyOtp() async {
//   final otp = _otpController.text.trim();

//   if (_verificationId == null) {
//     _showSnackBar("Request OTP first");
//     return;
//   }

//   try {
//     final credential = PhoneAuthProvider.credential(
//       verificationId: _verificationId!,
//       smsCode: otp,
//     );

//     await _firebaseAuth.signInWithCredential(credential);

//     final idToken =
//         await _firebaseAuth.currentUser!.getIdToken();
//         print("lllllllllllllllllllllllll$idToken");

//     await _callBackendVerify(idToken.toString());

//   } catch (e) {
//     _showSnackBar("Invalid OTP");
//   }
// }


Future<void> _handleVerifyOtp() async {
  final otp = _otpController.text.trim();
  final mobile = _loginMobileController.text.trim();

  if (otp.isEmpty) {
    _showSnackBar('Please enter OTP');
    return;
  }

  final smsProvider = Provider.of<SmsProvider>(context, listen: false);
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  // ✅ BYPASS NUMBER
  if (mobile == "9849008143") {
    await smsProvider.verifyOtp(otp, mobile);

    if (smsProvider.otpResponse?.statusCode == 200) {
      final userData = jsonDecode(smsProvider.otpResponse!.body);
      final user = userData['user'];

      final hasName =
          user['name'] != null && user['name'].toString().isNotEmpty;
      final hasEmail =
          user['email'] != null && user['email'].toString().isNotEmpty;

      if (!hasName || !hasEmail) {
        setState(() {
          _isNewUser = true;
          _isMobileLocked = true;
          _signupMobileController.text = mobile;
          _showOtpField = false;
          _otpController.clear();
        });

        _tabController.animateTo(1);
        return;
      }

      // ✅ IMPORTANT: login call
      final success = await authProvider.login(mobile);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainNavigationScreen()),
        );
      }
    } else {
      _showSnackBar("Invalid OTP");
    }

    return;
  }

  // ✅ NORMAL FIREBASE FLOW
  if (_verificationId == null) {
    _showSnackBar("Request OTP first");
    return;
  }

  try {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    await _firebaseAuth.signInWithCredential(credential);

    final idToken =
        await _firebaseAuth.currentUser!.getIdToken();

    await _callBackendVerify(idToken.toString());

  } catch (e) {
    _showSnackBar("Invalid OTP");
  }
}




  Future<void> _handleResendOtp() async {
    if (_pendingMobile == null) return;

    final smsProvider = Provider.of<SmsProvider>(context, listen: false);
    final mobile = _loginMobileController.text.trim();

    final String? resOtp = await smsProvider.resendOtp(mobile);

    setState(() {
      if (resOtp != null && resOtp.isNotEmpty) {
        _otpController.text = resOtp;
      }
    });
    
    if (smsProvider.resendOtpResponse?.statusCode == 200) {
      _showSnackBar('OTP resent successfully!');
    } else {
      _showSnackBar('OTP resent successfully!');
    }
  }

Future<void> _handleSignup() async {
  // Validation
  if (_signupNameController.text.trim().isEmpty) {
    _showSnackBar('Please enter your name');
    return;
  }
  if (_signupEmailController.text.trim().isEmpty) {
    _showSnackBar('Please enter your email');
    return;
  }
  if (_signupMobileController.text.trim().isEmpty || 
      _signupMobileController.text.trim().length != 10) {
    _showSnackBar('Please enter a valid 10-digit mobile number');
    return;
  }

  final signupProvider = Provider.of<SignupProvider>(context, listen: false);
  
  // Create signup model WITHOUT fcmtoken - provider will handle it automatically
  final signupModel = SignupModel(
    id: '', // Will be generated by backend
    name: _signupNameController.text.trim(),
    email: _signupEmailController.text.trim(),
    mobile: _signupMobileController.text.trim(),
    dob: _selectedDob != null
        ? '${_selectedDob!.year}-${_selectedDob!.month.toString().padLeft(2, '0')}-${_selectedDob!.day.toString().padLeft(2, '0')}'
        : null,
    marriageAnniversary: _selectedMarriageDate != null
        ? '${_selectedMarriageDate!.year}-${_selectedMarriageDate!.month.toString().padLeft(2, '0')}-${_selectedMarriageDate!.day.toString().padLeft(2, '0')}'
        : null,
    referralCode: _signupReferralCodeController.text.trim().isEmpty
        ? null
        : _signupReferralCodeController.text.trim(),
    // fcmtoken will be automatically added by SignupProvider
  );

  final success = await signupProvider.registerUser(signupModel);

  if (success) {
    _showSnackBar('Registration successful!');
    
    // Navigate to main screen after successful registration
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainNavigationScreen()),
    );
  } else {
    _showSnackBar(signupProvider.errorMessage ?? 'Registration failed');
  }
}

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1D1E33),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E21),
              Color(0xFF1D1E33),
              Color(0xFF0A0E21),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildTabBar(),
              const SizedBox(height: 30),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: _isMobileLocked ? const NeverScrollableScrollPhysics() : null,
                  children: [
                    _buildLoginForm(),
                    _buildSignupForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade400,
                Colors.blue.shade400,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.purple.shade300, Colors.blue.shade300],
          ).createShader(bounds),
          child: const Text(
            'Editezy',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create Amazing Posters',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade400, Colors.blue.shade400],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade400,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Login'),
          Tab(text: 'Sign Up'),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Consumer<SmsProvider>(
      builder: (context, smsProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              _buildTextField(
                controller: _loginMobileController,
                label: 'Mobile Number',
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              if (_showOtpField) ...[
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _otpController,
                  label: 'Enter OTP',
                  icon: Icons.lock_outline,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: smsProvider.isResending ? null : _handleResendOtp,
                    child: Text(
                      smsProvider.isResending ? 'Resending...' : 'Refresh OTP',
                      style: TextStyle(
                        color: Colors.purple.shade300,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 30),
              _buildActionButton(
                _showOtpField ? 'Verify OTP' : 'Send OTP',
                smsProvider.isLoading
                    ? null
                    : (_showOtpField ? _handleVerifyOtp : _handleLogin),
                isLoading: smsProvider.isLoading,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignupForm() {
    return Consumer<SignupProvider>(
      builder: (context, signupProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              if (_isNewUser) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.purple.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.purple.shade300),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Welcome! Please complete your profile',
                          style: TextStyle(
                            color: Colors.purple.shade100,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              _buildTextField(
                controller: _signupNameController,
                label: 'Full Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _signupEmailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _signupMobileController,
                label: 'Mobile Number',
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                isEnabled: !_isMobileLocked, // Lock field if user came from OTP
              ),
              const SizedBox(height: 20),
              _buildDateField(
                label: 'Date of Birth (Optional)',
                icon: Icons.cake_outlined,
                selectedDate: _selectedDob,
                onTap: () => _selectDate(context, true),
                isOptional: true,
              ),
              const SizedBox(height: 20),
              _buildDateField(
                label: 'Marriage Date (Optional)',
                icon: Icons.favorite_border,
                selectedDate: _selectedMarriageDate,
                onTap: () => _selectDate(context, false),
                isOptional: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _signupReferralCodeController,
                label: 'Referral Code (Optional)',
                icon: Icons.card_giftcard,
              ),
              const SizedBox(height: 30),
              _buildActionButton(
                'Sign Up',
                signupProvider.isLoading ? null : _handleSignup,
                isLoading: signupProvider.isLoading,
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool isEnabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFF1D1E33) : const Color(0xFF15162A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isEnabled 
              ? Colors.purple.withOpacity(0.3) 
              : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: isEnabled,
        obscureText: isPassword && !isPasswordVisible,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: TextStyle(
          color: isEnabled ? Colors.white : Colors.grey.shade500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isEnabled ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          prefixIcon: Icon(
            icon,
            color: isEnabled ? Colors.purple.shade300 : Colors.grey.shade600,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: onTogglePassword,
                )
              : (isEnabled ? null : Icon(Icons.lock, color: Colors.grey.shade600, size: 20)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    bool isOptional = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF1D1E33),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.purple.shade300),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                selectedDate != null
                    ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                    : label,
                style: TextStyle(
                  color: selectedDate != null ? Colors.white : Colors.grey.shade400,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(Icons.calendar_today, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback? onPressed, {bool isLoading = false}) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.blue.shade400],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }
}
