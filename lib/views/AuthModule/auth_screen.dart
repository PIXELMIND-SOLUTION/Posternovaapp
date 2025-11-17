// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:posternova/views/NavBar/navbar_screen.dart';
// import 'package:posternova/views/PosterModule/home.dart';


// class AuthScreen extends StatefulWidget {
//   const AuthScreen({Key? key}) : super(key: key);

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   // Login Controllers
//   final _loginMobileController = TextEditingController();
//   final _loginPasswordController = TextEditingController();

//   // Signup Controllers
//   final _signupNameController = TextEditingController();
//   final _signupEmailController = TextEditingController();
//   final _signupPasswordController = TextEditingController();
//   final _signupConfirmPasswordController = TextEditingController();
//   DateTime? _selectedDob;
//   DateTime? _selectedMarriageDate;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _loginMobileController.dispose();
//     _loginPasswordController.dispose();
//     _signupNameController.dispose();
//     _signupEmailController.dispose();
//     _signupPasswordController.dispose();
//     _signupConfirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDate(BuildContext context, bool isDob) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1950),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.dark().copyWith(
//             colorScheme: const ColorScheme.dark(
//               primary: Color(0xFF6C63FF),
//               surface: Color(0xFF1D1E33),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         if (isDob) {
//           _selectedDob = picked;
//         } else {
//           _selectedMarriageDate = picked;
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF0A0E21),
//               Color(0xFF1D1E33),
//               Color(0xFF0A0E21),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               const SizedBox(height: 40),
//               // Logo and Title
//               _buildHeader(),
//               const SizedBox(height: 40),
//               // Tab Bar
//               _buildTabBar(),
//               const SizedBox(height: 30),
//               // Tab Views
//               Expanded(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     _buildLoginForm(),
//                     _buildSignupForm(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: LinearGradient(
//               colors: [
//                 Colors.purple.shade400,
//                 Colors.blue.shade400,
//               ],
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.purple.withOpacity(0.5),
//                 blurRadius: 20,
//                 spreadRadius: 5,
//               ),
//             ],
//           ),
//           child: const Icon(
//             Icons.auto_awesome,
//             size: 50,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 20),
//         ShaderMask(
//           shaderCallback: (bounds) => LinearGradient(
//             colors: [Colors.purple.shade300, Colors.blue.shade300],
//           ).createShader(bounds),
//           child: const Text(
//             'PosterNova',
//             style: TextStyle(
//               fontSize: 36,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               letterSpacing: 2,
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Create Amazing Posters',
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey.shade400,
//             letterSpacing: 1,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTabBar() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 40),
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1D1E33),
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(color: Colors.purple.withOpacity(0.3)),
//       ),
//       child: TabBar(
//         controller: _tabController,
//         indicator: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.purple.shade400, Colors.blue.shade400],
//           ),
//           borderRadius: BorderRadius.circular(25),
//         ),
//                indicatorSize: TabBarIndicatorSize.tab,
//         dividerColor: Colors.transparent,
//         labelColor: Colors.white,
//         unselectedLabelColor: Colors.grey.shade400,
//         labelStyle: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//         ),
//         tabs: const [
//           Tab(text: 'Login'),
//           Tab(text: 'Sign Up'),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoginForm() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 30),
//       child: Column(
//         children: [
//           _buildTextField(
//             controller: _loginMobileController,
//             label: 'Mobile Number',
//             icon: Icons.phone_android,
//             keyboardType: TextInputType.phone,
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//           ),
//           const SizedBox(height: 20),
//           _buildTextField(
//             controller: _loginPasswordController,
//             label: 'Password',
//             icon: Icons.lock_outline,
//             isPassword: true,
//             isPasswordVisible: _isPasswordVisible,
//             onTogglePassword: () {
//               setState(() {
//                 _isPasswordVisible = !_isPasswordVisible;
//               });
//             },
//           ),
//           // const SizedBox(height: 15),
//           // Align(
//           //   alignment: Alignment.centerRight,
//           //   child: TextButton(
//           //     onPressed: () {},
//           //     child: Text(
//           //       'Forgot Password?',
//           //       style: TextStyle(
//           //         color: Colors.purple.shade300,
//           //         fontWeight: FontWeight.w500,
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           const SizedBox(height: 30),
//           _buildActionButton('Login', () {
//             // Handle login
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>MainNavigationScreen()));
//           }),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   Widget _buildSignupForm() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 30),
//       child: Column(
//         children: [
//           _buildTextField(
//             controller: _signupNameController,
//             label: 'Full Name',
//             icon: Icons.person_outline,
//           ),
//           const SizedBox(height: 20),
//           _buildTextField(
//             controller: _signupEmailController,
//             label: 'Email',
//             icon: Icons.email_outlined,
//             keyboardType: TextInputType.emailAddress,
//           ),
//           const SizedBox(height: 20),
//           _buildDateField(
//             label: 'Date of Birth',
//             icon: Icons.cake_outlined,
//             selectedDate: _selectedDob,
//             onTap: () => _selectDate(context, true),
//           ),
//           const SizedBox(height: 20),
//           _buildDateField(
//             label: 'Marriage Date (Optional)',
//             icon: Icons.favorite_border,
//             selectedDate: _selectedMarriageDate,
//             onTap: () => _selectDate(context, false),
//             isOptional: true,
//           ),
//           const SizedBox(height: 20),
//           _buildTextField(
//             controller: _signupPasswordController,
//             label: 'Password',
//             icon: Icons.lock_outline,
//             isPassword: true,
//             isPasswordVisible: _isPasswordVisible,
//             onTogglePassword: () {
//               setState(() {
//                 _isPasswordVisible = !_isPasswordVisible;
//               });
//             },
//           ),
//           const SizedBox(height: 20),
//           _buildTextField(
//             controller: _signupConfirmPasswordController,
//             label: 'Confirm Password',
//             icon: Icons.lock_outline,
//             isPassword: true,
//             isPasswordVisible: _isConfirmPasswordVisible,
//             onTogglePassword: () {
//               setState(() {
//                 _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
//               });
//             },
//           ),
//           const SizedBox(height: 30),
//           _buildActionButton('Sign Up', () {
//             // Handle signup
//            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainNavigationScreen()));
//           }),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool isPassword = false,
//     bool isPasswordVisible = false,
//     VoidCallback? onTogglePassword,
//     TextInputType? keyboardType,
//     List<TextInputFormatter>? inputFormatters,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF1D1E33),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.purple.withOpacity(0.3)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.purple.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword && !isPasswordVisible,
//         keyboardType: keyboardType,
//         inputFormatters: inputFormatters,
//         style: const TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(color: Colors.grey.shade400),
//           prefixIcon: Icon(icon, color: Colors.purple.shade300),
//           suffixIcon: isPassword
//               ? IconButton(
//                   icon: Icon(
//                     isPasswordVisible ? Icons.visibility_off : Icons.visibility,
//                     color: Colors.grey.shade400,
//                   ),
//                   onPressed: onTogglePassword,
//                 )
//               : null,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//         ),
//       ),
//     );
//   }

//   Widget _buildDateField({
//     required String label,
//     required IconData icon,
//     required DateTime? selectedDate,
//     required VoidCallback onTap,
//     bool isOptional = false,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1D1E33),
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(color: Colors.purple.withOpacity(0.3)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.purple.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.purple.shade300),
//             const SizedBox(width: 15),
//             Expanded(
//               child: Text(
//                 selectedDate != null
//                     ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
//                     : label,
//                 style: TextStyle(
//                   color: selectedDate != null ? Colors.white : Colors.grey.shade400,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             Icon(Icons.calendar_today, color: Colors.grey.shade400, size: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton(String text, VoidCallback onPressed) {
//     return Container(
//       width: double.infinity,
//       height: 55,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.purple.shade400, Colors.blue.shade400],
//         ),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.purple.withOpacity(0.4),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         child: Text(
//           text,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             letterSpacing: 1,
//           ),
//         ),
//       ),
//     );
//   }
// }













import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posternova/models/register_model.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:posternova/providers/auth/otp_provider.dart';
import 'package:posternova/providers/auth/register_provider.dart';
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

  Future<void> _handleLogin() async {
    final mobile = _loginMobileController.text.trim();
    
    if (mobile.isEmpty || mobile.length != 10) {
      _showSnackBar('Please enter a valid 10-digit mobile number');
      return;
    }

    final smsProvider = Provider.of<SmsProvider>(context, listen: false);
    await smsProvider.login(mobile);

    if (smsProvider.loginResponse?.statusCode == 200) {
      setState(() {
        _showOtpField = true;
        _pendingMobile = mobile;
      });
      _showSnackBar('OTP sent successfully!');
    } else {
      _showSnackBar(smsProvider.errorMessage ?? 'Login failed');
    }
  }

  Future<void> _handleVerifyOtp() async {
    final otp = _otpController.text.trim();
    
    if (otp.isEmpty) {
      _showSnackBar('Please enter OTP');
      return;
    }

    final smsProvider = Provider.of<SmsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    await smsProvider.verifyOtp(otp);


   

    if (smsProvider.otpResponse?.statusCode == 200) {
      // Login successful, now authenticate
      final success = await authProvider.login(_pendingMobile!);
      
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainNavigationScreen()),
        );
      } else {
        _showSnackBar('Authentication failed');
      }
    } else {
      _showSnackBar(smsProvider.errorMessage ?? 'OTP verification failed');
    }
  }

  Future<void> _handleResendOtp() async {
    if (_pendingMobile == null) return;

    final smsProvider = Provider.of<SmsProvider>(context, listen: false);
    await smsProvider.resendOtp(_pendingMobile!);

    if (smsProvider.resendOtpResponse?.statusCode == 200) {
      _showSnackBar('OTP resent successfully!');
    } else {
      // _showSnackBar(smsProvider.errorMessage ?? 'Failed to resend OTP');
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
    
    // final signupModel = SignupModel(
    //   id: '', // Will be generated by backend
    //   name: _signupNameController.text.trim(),
    //   email: _signupEmailController.text.trim(),
    //   mobile: _signupMobileController.text.trim(),
    //   dob: '${_selectedDob!.year}-${_selectedDob!.month.toString().padLeft(2, '0')}-${_selectedDob!.day.toString().padLeft(2, '0')}',
    //   marriageAnniversary: _selectedMarriageDate != null
    //       ? '${_selectedMarriageDate!.year}-${_selectedMarriageDate!.month.toString().padLeft(2, '0')}-${_selectedMarriageDate!.day.toString().padLeft(2, '0')}'
    //       : '',
    //   referralCode: _signupReferralCodeController.text.trim().isEmpty 
    //       ? null 
    //       : _signupReferralCodeController.text.trim(),
    // );


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
);


    final success = await signupProvider.registerUser(signupModel);

    if (success) {
      _showSnackBar('Registration successful! Please login.');
      // Clear form and switch to login tab
      _signupNameController.clear();
      _signupEmailController.clear();
      _signupMobileController.clear();
      _signupReferralCodeController.clear();
      setState(() {
        _selectedDob = null;
        _selectedMarriageDate = null;
      });
      _tabController.animateTo(0);
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
                      smsProvider.isResending ? 'Resending...' : 'Resend OTP',
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
  }) {
    return Container(
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
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: Colors.purple.shade300),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
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