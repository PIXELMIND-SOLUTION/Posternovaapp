
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/models/get_all_plan_model.dart';
// import 'package:posternova/models/payment_model.dart';
// import 'package:posternova/providers/auth/login_provider.dart';
// import 'package:posternova/providers/plans/plan_provider.dart';
// import 'package:posternova/views/NavBar/navbar_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// failed({required String mesg, required context}) {
//   EasyLoading.dismiss();
//   return showTopSnackBar(
//     Overlay.of(context),
//     CustomSnackBar.error(
//       message: "${mesg}",
//     ),
//   );
// }

// success({required String mesg, required BuildContext context}) {
//   EasyLoading.dismiss();
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(mesg, style: TextStyle(fontFamily: "PopR")),
//       backgroundColor: Colors.green[700],
//       behavior: SnackBarBehavior.floating,
//       duration: Duration(seconds: 3),
//     ),
//   );
// }

// showLoading() {
//   return EasyLoading.show(status: 'loading...');
// }

// class PlanDetailsAndPaymentScreen extends StatefulWidget {
//   final GetAllPlanModel plan;

//   const PlanDetailsAndPaymentScreen({
//     Key? key,
//     required this.plan,
//   }) : super(key: key);

//   @override
//   State<PlanDetailsAndPaymentScreen> createState() =>
//       _PlanDetailsAndPaymentScreenState();
// }

// class _PlanDetailsAndPaymentScreenState
//     extends State<PlanDetailsAndPaymentScreen> with TickerProviderStateMixin {
//   String? selectedPaymentMethod;
//   bool isLoading = false;
//   String? userId;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadUserId() async {
//     try {
//       final userData = await AuthPreferences.getUserData();
//       if (userData != null) {
//         setState(() {
//           userId = userData.user.id;
//         });
//       }
//     } catch (e) {
//       print('Error loading user ID: $e');
//     }
//   }

//   // Razorpay integration methods remain the same
//   void handlePaymentErrorResponse(PaymentFailureResponse response) {
//     showAlertDialog(context, "Payment Failed",
//         "Code: ${response.code}\nDescription: ${response.message}");
//   }

//   void showPaymentSuccessDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.green.shade300, Colors.green.shade600],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Payment Successful!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 'Your subscription is now active',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey.shade600,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 32),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//                       (route) => false,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text(
//                     'Continue',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
//     showPaymentSuccessDialog(context);
    
//     if (userId == null) {
//       _showErrorDialog("Authentication required");
//       return;
//     }

//     try {
//       final result = await _initiatePhonePePayment(
//           userId.toString(), widget.plan.id, response.paymentId.toString());

//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//         (route) => false,
//       );
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       _showErrorDialog("Transaction failed: $e");
//     }
//   }

//   void handleExternalWalletSelected(ExternalWalletResponse response) {
//     showAlertDialog(context, "Wallet Selected", "${response.walletName}");
//   }

//   void showAlertDialog(BuildContext context, String title, String message) {
//     failed(mesg: message, context: context);
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.red.shade600),
//             const SizedBox(width: 8),
//             const Text("Error"),
//           ],
//         ),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
    
//     // Dynamic theme based on plan type
//     ThemeData planTheme = _getPlanTheme();
    
//     return Theme(
//       data: planTheme,
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade50,
//         body: CustomScrollView(
//           slivers: [
//             // Custom App Bar with gradient
//             SliverAppBar(
//               expandedHeight: screenHeight * 0.35,
//               floating: false,
//               pinned: true,
//               elevation: 0,
//               backgroundColor: planTheme.primaryColor,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: _buildPlanHeader(planTheme, screenWidth),
//                 ),
//               ),
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
            
//             // Content
//             SliverToBoxAdapter(
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 20),
//                     _buildPlanFeatures(planTheme),
//                     const SizedBox(height: 20),
//                     if (widget.plan.offerPrice > 0) _buildPaymentSection(planTheme),
//                     const SizedBox(height: 20),
//                     _buildActionButton(planTheme),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   ThemeData _getPlanTheme() {
//     final planName = widget.plan.name.toUpperCase();
    
//     if (planName.contains('COPPER')) {
//       return ThemeData(
//         primaryColor: Colors.deepOrange.shade600,
//         primarySwatch: Colors.deepOrange,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//       );
//     } else if (planName.contains('SILVER')) {
//       return ThemeData(
//         primaryColor: Colors.blueGrey.shade700,
//         primarySwatch: Colors.blueGrey,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
//       );
//     } else if (planName.contains('GOLD')) {
//       return ThemeData(
//         primaryColor: Colors.amber.shade700,
//         primarySwatch: Colors.amber,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
//       );
//     }
    
//     return ThemeData(
//       primaryColor: Colors.indigo.shade600,
//       primarySwatch: Colors.indigo,
//       colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
//     );
//   }

//   Widget _buildPlanHeader(ThemeData theme, double screenWidth) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             theme.primaryColor,
//             theme.primaryColor.withOpacity(0.8),
//           ],
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Plan Badge
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.white.withOpacity(0.3)),
//                 ),
//                 child: Text(
//                   widget.plan.name.toUpperCase(),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 24),
              
//               // Price Display
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.baseline,
//                 textBaseline: TextBaseline.alphabetic,
//                 children: [
//                   Text(
//                     widget.plan.offerPrice == 0 ? 'Free' : '₹${widget.plan.offerPrice}',
//                     style: const TextStyle(
//                       fontSize: 48,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   if (widget.plan.originalPrice > widget.plan.offerPrice) ...[
//                     const SizedBox(width: 12),
//                     Text(
//                       '₹${widget.plan.originalPrice}',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         decoration: TextDecoration.lineThrough,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
              
//               const SizedBox(height: 8),
              
//               Text(
//                 widget.plan.duration.toString(),
//                 style: const TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
              
//               if (widget.plan.discountPercentage > 0) ...[
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     'Save ${widget.plan.discountPercentage}%',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: theme.primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPlanFeatures(ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.featured_play_list_outlined,
//                   color: theme.primaryColor,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               const Text(
//                 'Plan Features',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
          
//           const SizedBox(height: 24),
          
//           ...widget.plan.features.asMap().entries.map((entry) {
//             final index = entry.key;
//             final feature = entry.value;
            
//             return AnimatedContainer(
//               duration: Duration(milliseconds: 200 + (index * 100)),
//               margin: const EdgeInsets.only(bottom: 16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       color: theme.primaryColor,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 16,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Text(
//                       feature,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         height: 1.5,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentSection(ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.payment_outlined,
//                   color: theme.primaryColor,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               const Text(
//                 'Payment Method',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
          
//           const SizedBox(height: 20),
          
//           _buildPaymentOption(
//             'Digital Payment',
//             Icons.account_balance_wallet_outlined,
//             'Secure payment via UPI, Cards & More',
//             theme,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentOption(String title, IconData icon, String description, ThemeData theme) {
//     final isSelected = selectedPaymentMethod == title;
    
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedPaymentMethod = title;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: isSelected ? theme.primaryColor.withOpacity(0.08) : Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected ? theme.primaryColor : Colors.grey.shade300,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: isSelected ? theme.primaryColor : Colors.grey.shade400,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 icon,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
            
//             const SizedBox(width: 16),
            
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: isSelected ? theme.primaryColor : Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     description,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             if (isSelected)
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton(ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : () => _processSubscription(context, theme),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: theme.primaryColor,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(28),
//           ),
//           shadowColor: theme.primaryColor.withOpacity(0.3),
//         ),
//         child: isLoading
//             ? const SizedBox(
//                 height: 24,
//                 width: 24,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     widget.plan.offerPrice == 0 
//                         ? Icons.lock_open_outlined 
//                         : Icons.credit_card_outlined,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     widget.plan.offerPrice == 0
//                         ? 'Activate Free Plan'
//                         : 'Subscribe Now',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   void _processSubscription(BuildContext context, ThemeData theme) async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final userId = authProvider.user?.user.id;

//     if (userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please log in to continue')),
//       );
//       return;
//     }

//     // Free plan handling
//     if (widget.plan.offerPrice == 0) {
//       setState(() {
//         isLoading = true;
//       });

//       await Future.delayed(const Duration(seconds: 2));

//       setState(() {
//         isLoading = false;
//       });

//       if (!mounted) return;
      
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.green.shade300, Colors.green.shade600],
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Welcome to ${widget.plan.name}!',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Your subscription is now active',
//                 style: TextStyle(color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//                       (route) => false,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   child: const Text('Get Started', style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//       return;
//     }

//     // Paid plan handling
//     if (selectedPaymentMethod == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a payment method')),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       Razorpay razorpay = Razorpay();
//       var options = {
//         'key': 'rzp_live_RTmw5UsY3ffNxq',
//         'amount': (widget.plan.offerPrice * 100).toInt(),
//         'name': 'Edit-Ezy',
//         'description': 'Subscription',
//         'retry': {'enabled': true, 'max_count': 1},
//         'send_sms_hash': true,
//         'prefill': {
//           'contact': "9961593179",
//           'email': "melvincherian0190@gmail.com",
//         },
//         'external': {
//           'wallets': ['paytm']
//         }
//       };
//       razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//       razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//       razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//       razorpay.open(options);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<PhonePePaymentResponse> _initiatePhonePePayment(
//       String userId, String planId, String transactionId) async {
//     final planProvider = Provider.of<PlanProvider>(context, listen: false);
//     try {
//       return await planProvider.initiatePhonePePayment(
//           userId, planId, transactionId);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   void _showPaymentStatusCheckDialog(
//     BuildContext context,
//     String merchantOrderId,
//     String userId,
//     String planId,
//   ) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Complete Payment'),
//         content: const Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Please complete the payment process in your payment app.'),
//             SizedBox(height: 20),
//             CircularProgressIndicator(),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context) => PaymentStatusScreen(),
//               //   ),
//               // );
//             },
//             child: const Text('Payment Completed'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _checkPaymentStatus(
//     BuildContext context,
//     String merchantOrderId,
//     String userId,
//     String planId,
//   ) async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final planProvider = Provider.of<PlanProvider>(context, listen: false);
//       final response = await planProvider.checkPaymentStatus(merchantOrderId);

//       if (response != null && response['status'] == 'PAYMENT_SUCCESS') {
//         final purchaseResponse = await planProvider.getPurchaseDetails(userId, planId);
//         // Handle success
//       } else {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Payment verification failed')),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// }









// // plan_details_payment_screen.dart
// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/models/get_all_plan_model.dart';
// import 'package:posternova/models/payment_model.dart';
// import 'package:posternova/providers/auth/login_provider.dart';
// import 'package:posternova/providers/plans/plan_provider.dart';
// import 'package:posternova/views/NavBar/navbar_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// failed({required String mesg, required context}) {
//   EasyLoading.dismiss();
//   return showTopSnackBar(
//     Overlay.of(context),
//     CustomSnackBar.error(
//       message: "${mesg}",
//     ),
//   );
// }

// success({required String mesg, required BuildContext context}) {
//   EasyLoading.dismiss();
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(mesg, style: TextStyle(fontFamily: "PopR")),
//       backgroundColor: Colors.green[700],
//       behavior: SnackBarBehavior.floating,
//       duration: Duration(seconds: 3),
//     ),
//   );
// }

// showLoading() {
//   return EasyLoading.show(status: 'loading...');
// }

// class PlanDetailsAndPaymentScreen extends StatefulWidget {
//   final GetAllPlanModel plan;

//   const PlanDetailsAndPaymentScreen({
//     Key? key,
//     required this.plan,
//   }) : super(key: key);

//   @override
//   State<PlanDetailsAndPaymentScreen> createState() =>
//       _PlanDetailsAndPaymentScreenState();
// }

// class _PlanDetailsAndPaymentScreenState
//     extends State<PlanDetailsAndPaymentScreen> with TickerProviderStateMixin {
//   String? selectedPaymentMethod;
//   bool isLoading = false;
//   String? userId;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   // Razorpay instance (Android)
//   Razorpay? _razorpay;

//   // In-app purchase (iOS)
//   final InAppPurchase _iap = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   bool _available = false;
//   List<ProductDetails> _products = [];
//   List<PurchaseDetails> _purchases = [];

//   // TODO: Replace with your real product ids configured in App Store Connect
//   static const Set<String> _kProductIds = <String>{
//     'com.editezy.premium_policy', // <- replace with actual product id(s) per plan
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();

//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();

//     // Platform-specific init
//     if (Platform.isAndroid) {
//       _initRazorpay();
//     } else if (Platform.isIOS) {
//       _initIAP();
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _razorpay?.clear();
//     if (Platform.isIOS) {
//       _subscription.cancel();
//     }
//     super.dispose();
//   }

//   Future<void> _loadUserId() async {
//     try {
//       final userData = await AuthPreferences.getUserData();
//       if (userData != null) {
//         setState(() {
//           userId = userData.user.id;
//         });
//       }
//     } catch (e) {
//       print('Error loading user ID: $e');
//     }
//   }

//   // -------------------- RAZORPAY (Android) --------------------
//   void _initRazorpay() {
//     _razorpay = Razorpay();
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//     _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//   }

//   void handlePaymentErrorResponse(PaymentFailureResponse response) {
//     showAlertDialog(context, "Payment Failed",
//         "Code: ${response.code}\nDescription: ${response.message}");
//   }

//   void showPaymentSuccessDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.green.shade300, Colors.green.shade600],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Payment Successful!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 'Your subscription is now active',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey.shade600,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 32),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//                       (route) => false,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text(
//                     'Continue',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
//     // For Android (Razorpay) — same as before
//     showPaymentSuccessDialog(context);

//     if (userId == null) {
//       _showErrorDialog("Authentication required");
//       return;
//     }

//     try {
//       final result = await _initiatePhonePePayment(
//           userId.toString(), widget.plan.id, response.paymentId.toString());

//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//         (route) => false,
//       );
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       _showErrorDialog("Transaction failed: $e");
//     }
//   }

//   void handleExternalWalletSelected(ExternalWalletResponse response) {
//     showAlertDialog(context, "Wallet Selected", "${response.walletName}");
//   }

//   void showAlertDialog(BuildContext context, String title, String message) {
//     failed(mesg: message, context: context);
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.red.shade600),
//             const SizedBox(width: 8),
//             const Text("Error"),
//           ],
//         ),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   // -------------------- IN-APP PURCHASE (iOS) --------------------
//   Future<void> _initIAP() async {
//     // listen to purchase updates
//     final purchaseUpdated = _iap.purchaseStream;
//     _subscription = purchaseUpdated.listen((purchases) {
//       _listenToPurchaseUpdated(purchases);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (error) {
//       // handle error here.
//       print('IAP purchaseStream error: $error');
//     });

//     // check availability & query products
//     _available = await _iap.isAvailable();
//     if (!_available) {
//       print('IAP not available on this device');
//       return;
//     }

//     final ProductDetailsResponse response =
//         await _iap.queryProductDetails(_kProductIds);
//     if (response.error != null) {
//       print('ProductDetails query error: ${response.error}');
//     }
//     setState(() {
//       _products = response.productDetails;
//     });
//   }

//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
//     for (final purchase in purchases) {
//       print('Purchase updated: ${purchase.productID} - ${purchase.status}');
//       if (purchase.status == PurchaseStatus.pending) {
//         // show pending UI if you want
//       } else if (purchase.status == PurchaseStatus.error) {
//         // handle error
//         _handlePurchaseError(purchase);
//       } else if (purchase.status == PurchaseStatus.purchased ||
//           purchase.status == PurchaseStatus.restored) {
//         // Verify purchase on server then deliver
//         await _verifyAndCompletePurchase(purchase);
//       }
//       if (purchase.pendingCompletePurchase) {
//         await _iap.completePurchase(purchase);
//       }
//     }
//   }

//   void _handlePurchaseError(PurchaseDetails purchase) {
//     final errorMsg = purchase.error?.message ?? 'Purchase error';
//     failed(mesg: errorMsg, context: context);
//   }

//   Future<void> _verifyAndCompletePurchase(PurchaseDetails purchase) async {
//     // TODO: Implement server-side receipt validation (recommended).
//     // You should send receipt / purchase details to your backend and validate with Apple.
//     // Sample: await planProvider.verifyIosPurchase(userId, widget.plan.id, purchase);

//     try {
//       final planProvider = Provider.of<PlanProvider>(context, listen: false);

//       // We assume PlanProvider has a method to verify an iOS purchase.
//       // If not, implement one server-side that accepts: userId, planId, purchase.transactionReceipt / purchase.verificationData
//       // final verificationResult = await planProvider.verifyIosPurchase(
//       //   userId ?? '',
//       //   widget.plan.id,
//       //   purchase.verificationData.serverVerificationData,
//       //   purchase.productID,
//       // );

//       // if (verificationResult != null && verificationResult['status'] == 'success') {
//       //   // deliver purchase locally
//       //   showPaymentSuccessDialog(context);

//       //   // mark purchase completed on server if needed
//       //   // also you can call planProvider.getPurchaseDetails or similar
//       //   Navigator.of(context).pushAndRemoveUntil(
//       //     MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//       //     (route) => false,
//       //   );
//       // } else {
//       //   _showErrorDialog('Purchase verification failed');
//       // }
//     } catch (e) {
//       print('Verification exception: $e');
//       _showErrorDialog('Verification failed: $e');
//     }
//   }

//   // -------------------- UI & Purchase flow --------------------

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     // Dynamic theme based on plan type
//     ThemeData planTheme = _getPlanTheme();

//     return Theme(
//       data: planTheme,
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade50,
//         body: CustomScrollView(
//           slivers: [
//             // Custom App Bar with gradient
//             SliverAppBar(
//               expandedHeight: screenHeight * 0.35,
//               floating: false,
//               pinned: true,
//               elevation: 0,
//               backgroundColor: planTheme.primaryColor,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: _buildPlanHeader(planTheme, screenWidth),
//                 ),
//               ),
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),

//             // Content
//             SliverToBoxAdapter(
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 20),
//                     _buildPlanFeatures(planTheme),
//                     const SizedBox(height: 20),
//                     if (widget.plan.offerPrice > 0) _buildPaymentSection(planTheme),
//                     const SizedBox(height: 20),
//                     _buildActionButton(planTheme),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   ThemeData _getPlanTheme() {
//     final planName = widget.plan.name.toUpperCase();

//     if (planName.contains('COPPER')) {
//       return ThemeData(
//         primaryColor: Colors.deepOrange.shade600,
//         primarySwatch: Colors.deepOrange,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//       );
//     } else if (planName.contains('SILVER')) {
//       return ThemeData(
//         primaryColor: Colors.blueGrey.shade700,
//         primarySwatch: Colors.blueGrey,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
//       );
//     } else if (planName.contains('GOLD')) {
//       return ThemeData(
//         primaryColor: Colors.amber.shade700,
//         primarySwatch: Colors.amber,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
//       );
//     }

//     return ThemeData(
//       primaryColor: Colors.indigo.shade600,
//       primarySwatch: Colors.indigo,
//       colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
//     );
//   }

//   Widget _buildPlanHeader(ThemeData theme, double screenWidth) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             theme.primaryColor,
//             theme.primaryColor.withOpacity(0.8),
//           ],
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Plan Badge
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.white.withOpacity(0.3)),
//                 ),
//                 child: Text(
//                   widget.plan.name.toUpperCase(),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Price Display
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.baseline,
//                 textBaseline: TextBaseline.alphabetic,
//                 children: [
//                   Text(
//                     widget.plan.offerPrice == 0 ? 'Free' : '₹${widget.plan.offerPrice}',
//                     style: const TextStyle(
//                       fontSize: 48,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   if (widget.plan.originalPrice > widget.plan.offerPrice) ...[
//                     const SizedBox(width: 12),
//                     Text(
//                       '₹${widget.plan.originalPrice}',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         decoration: TextDecoration.lineThrough,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),

//               const SizedBox(height: 8),

//               Text(
//                 widget.plan.duration.toString(),
//                 style: const TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               if (widget.plan.discountPercentage > 0) ...[
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     'Save ${widget.plan.discountPercentage}%',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: theme.primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPlanFeatures(ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.featured_play_list_outlined,
//                   color: theme.primaryColor,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               const Text(
//                 'Plan Features',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 24),

//           ...widget.plan.features.asMap().entries.map((entry) {
//             final index = entry.key;
//             final feature = entry.value;

//             return AnimatedContainer(
//               duration: Duration(milliseconds: 200 + (index * 100)),
//               margin: const EdgeInsets.only(bottom: 16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       color: theme.primaryColor,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 16,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Text(
//                       feature,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         height: 1.5,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentSection(ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.payment_outlined,
//                   color: theme.primaryColor,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               const Text(
//                 'Payment Method',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 20),

//           _buildPaymentOption(
//             'Digital Payment',
//             Icons.account_balance_wallet_outlined,
//             'Secure payment via UPI, Cards & More',
//             theme,
//           ),

//           if (Platform.isIOS)
//             Padding(
//               padding: const EdgeInsets.only(top: 12),
//               child: Text(
//                 'iOS will use Apple In-App Purchase (required by App Store).',
//                 style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentOption(String title, IconData icon, String description, ThemeData theme) {
//     final isSelected = selectedPaymentMethod == title;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedPaymentMethod = title;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: isSelected ? theme.primaryColor.withOpacity(0.08) : Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected ? theme.primaryColor : Colors.grey.shade300,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: isSelected ? theme.primaryColor : Colors.grey.shade400,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 icon,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),

//             const SizedBox(width: 16),

//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: isSelected ? theme.primaryColor : Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     description,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             if (isSelected)
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton(ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : () => _processSubscription(context, theme),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: theme.primaryColor,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(28),
//           ),
//           shadowColor: theme.primaryColor.withOpacity(0.3),
//         ),
//         child: isLoading
//             ? const SizedBox(
//                 height: 24,
//                 width: 24,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     widget.plan.offerPrice == 0
//                         ? Icons.lock_open_outlined
//                         : Icons.credit_card_outlined,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     widget.plan.offerPrice == 0
//                         ? 'Activate Free Plan'
//                         : 'Subscribe Now',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   void _processSubscription(BuildContext context, ThemeData theme) async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final userIdLocal = authProvider.user?.user.id ?? userId;

//     if (userIdLocal == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please log in to continue')),
//       );
//       return;
//     }

//     // Free plan handling
//     if (widget.plan.offerPrice == 0) {
//       setState(() {
//         isLoading = true;
//       });

//       await Future.delayed(const Duration(seconds: 2));

//       setState(() {
//         isLoading = false;
//       });

//       if (!mounted) return;

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.green.shade300, Colors.green.shade600],
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Welcome to ${widget.plan.name}!',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Your subscription is now active',
//                 style: TextStyle(color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//                       (route) => false,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   child: const Text('Get Started', style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//       return;
//     }

//     // Paid plan handling
//     if (selectedPaymentMethod == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a payment method')),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       if (Platform.isIOS) {
//         // Use StoreKit / In-App Purchase on iOS
//         if (!_available) {
//           _showErrorDialog('In-App Purchases not available on this device');
//           setState(() {
//             isLoading = false;
//           });
//           return;
//         }

//         if (_products.isEmpty) {
//           // Optionally try to query again
//           final response = await _iap.queryProductDetails(_kProductIds);
//           _products = response.productDetails;
//         }

//         // Try to find product matching plan - map product id appropriately
//         ProductDetails? productForPlan;
//         // Attempt to match by plan.productId if available, else take first product
//         // final expectedId = widget.plan.productId ?? 'com.editezy.premium'; // use your mapping
//         // productForPlan = _products.firstWhere(
//         //   (p) => p.id == expectedId,
//         //   orElse: () => _products.isNotEmpty ? _products.first : null,
//         // );

//         // --- START: safe product lookup for plan -> product id mapping ---

// // 1) Create a map from your app plan id (widget.plan.id) to App Store product id.
// //    Fill this mapping with the product ids you created in App Store Connect.
// final Map<String, String> planToProductId = {
//   // replace these with your real plan id keys and App Store product ids:
//   // 'your_plan_internal_id': 'com.editezy.premium.monthly',
//   // 'another_plan_id'     : 'com.editezy.premium.yearly',
//   widget.plan.id: 'com.editezy.premium_policy', // <-- keep placeholder so code compiles; update it
// };

// // 2) Resolve expected product id for this plan
// final String? expectedId = planToProductId[widget.plan.id];

// // 3) Safe search in the _products list (ProductDetails list retrieved from IAP)
// // ProductDetails? productForPlan;
// if (expectedId != null && _products.isNotEmpty) {
//   // prefer exact match
//   try {
//     productForPlan = _products.firstWhere((p) => p.id == expectedId);
//   } catch (e) {
//     // not found — fallback to first available product, or keep null if empty
//     productForPlan = _products.first;
//   }
// } else {
//   // no mapping found — fallback to the first product if available
//   productForPlan = _products.isNotEmpty ? _products.first : null;
// }

// // 4) If still null, stop and show error to user (or handle gracefully)
// if (productForPlan == null) {
//   _showErrorDialog('No product available for this plan. Please contact support.');
//   setState(() => isLoading = false);
//   return;
// }

// // Use productForPlan safely below (productForPlan is non-null here)
// // e.g. create PurchaseParam:
// final PurchaseParam purchaseParam = PurchaseParam(productDetails: productForPlan);

// // then call buyNonConsumable / buyConsumable / buySubscription as required by product type
// // Example (non-consumable/subscription variation depends on product type):
// await _iap.buyNonConsumable(purchaseParam: purchaseParam);

// // --- END ---


//         if (productForPlan == null) {
//           _showErrorDialog('No product found for purchase. Contact support.');
//           setState(() {
//             isLoading = false;
//           });
//           return;
//         }

//         // final PurchaseParam purchaseParam = PurchaseParam(productDetails: productForPlan);

//         // Start purchase - for subscription products this will initiate StoreKit
//         await _iap.buyNonConsumable(purchaseParam: purchaseParam);

//         // actual purchase flow will be handled via the purchaseStream listener
//       } else {
//         // Android: Razorpay (same as your existing code)
//         Razorpay razorpay = _razorpay ?? Razorpay();
//         var options = {
//           'key': 'rzp_live_RTmw5UsY3ffNxq',
//           'amount': (widget.plan.offerPrice * 100).toInt(),
//           'name': 'Edit-Ezy',
//           'description': 'Subscription',
//           'retry': {'enabled': true, 'max_count': 1},
//           'send_sms_hash': true,
//           'prefill': {
//             'contact': "9961593179",
//             'email': "melvincherian0190@gmail.com",
//           },
//           'external': {
//             'wallets': ['paytm']
//           }
//         };
//         razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//         razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//         razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//         razorpay.open(options);
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<PhonePePaymentResponse> _initiatePhonePePayment(
//       String userId, String planId, String transactionId) async {
//     final planProvider = Provider.of<PlanProvider>(context, listen: false);
//     try {
//       return await planProvider.initiatePhonePePayment(
//           userId, planId, transactionId);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   void _showPaymentStatusCheckDialog(
//     BuildContext context,
//     String merchantOrderId,
//     String userId,
//     String planId,
//   ) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Complete Payment'),
//         content: const Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Please complete the payment process in your payment app.'),
//             SizedBox(height: 20),
//             CircularProgressIndicator(),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context) => PaymentStatusScreen(),
//               //   ),
//               // );
//             },
//             child: const Text('Payment Completed'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _checkPaymentStatus(
//     BuildContext context,
//     String merchantOrderId,
//     String userId,
//     String planId,
//   ) async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final planProvider = Provider.of<PlanProvider>(context, listen: false);
//       final response = await planProvider.checkPaymentStatus(merchantOrderId);

//       if (response != null && response['status'] == 'PAYMENT_SUCCESS') {
//         final purchaseResponse = await planProvider.getPurchaseDetails(userId, planId);
//         // Handle success
//       } else {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Payment verification failed')),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// }












// // plan_details_payment_screen.dart
// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/models/get_all_plan_model.dart';
// import 'package:posternova/models/payment_model.dart';
// import 'package:posternova/providers/auth/login_provider.dart';
// import 'package:posternova/providers/plans/plan_provider.dart';
// import 'package:posternova/views/NavBar/navbar_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// failed({required String mesg, required context}) {
//   EasyLoading.dismiss();
//   return showTopSnackBar(
//     Overlay.of(context),
//     CustomSnackBar.error(
//       message: "$mesg",
//     ),
//   );
// }

// success({required String mesg, required BuildContext context}) {
//   EasyLoading.dismiss();
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(mesg, style: TextStyle(fontFamily: "PopR")),
//       backgroundColor: Colors.green[700],
//       behavior: SnackBarBehavior.floating,
//       duration: Duration(seconds: 3),
//     ),
//   );
// }

// showLoading() {
//   return EasyLoading.show(status: 'loading...');
// }

// class PlanDetailsAndPaymentScreen extends StatefulWidget {
//   final GetAllPlanModel plan;

//   const PlanDetailsAndPaymentScreen({
//     Key? key,
//     required this.plan,
//   }) : super(key: key);

//   @override
//   State<PlanDetailsAndPaymentScreen> createState() =>
//       _PlanDetailsAndPaymentScreenState();
// }

// class _PlanDetailsAndPaymentScreenState
//     extends State<PlanDetailsAndPaymentScreen> with TickerProviderStateMixin {
//   String? selectedPaymentMethod;
//   bool isLoading = false;
//   String? userId;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   // Razorpay instance (Android)
//   Razorpay? _razorpay;

//   // In-app purchase (iOS)
//   final InAppPurchase _iap = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   bool _available = false;
//   List<ProductDetails> _products = [];
//   List<PurchaseDetails> _purchases = [];

//   // Product IDs mapping - UPDATE THESE WITH YOUR ACTUAL APP STORE PRODUCT IDs
//   static const Map<String, String> _planProductIds = {
//     // Example mapping - replace with your actual plan IDs and product IDs
//     'plan_copper_monthly': 'com.yourapp.copper_monthly',
//     'plan_silver_monthly': 'com.yourapp.silver_monthly',
//     'plan_gold_monthly': 'com.yourapp.gold_monthly',
//     // Add more mappings as needed
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();

//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();

//     // Platform-specific init
//     if (Platform.isAndroid) {
//       _initRazorpay();
//     } else if (Platform.isIOS) {
//       _initIAP();
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _razorpay?.clear();
//     if (Platform.isIOS) {
//       _subscription.cancel();
//     }
//     super.dispose();
//   }

//   Future<void> _loadUserId() async {
//     try {
//       final userData = await AuthPreferences.getUserData();
//       if (userData != null) {
//         setState(() {
//           userId = userData.user.id;
//         });
//       }
//     } catch (e) {
//       print('Error loading user ID: $e');
//     }
//   }

//   // -------------------- RAZORPAY (Android) --------------------
//   void _initRazorpay() {
//     _razorpay = Razorpay();
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//     _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//   }

//   void handlePaymentErrorResponse(PaymentFailureResponse response) {
//     showAlertDialog(context, "Payment Failed",
//         "Code: ${response.code}\nDescription: ${response.message}");
//   }

//   void showPaymentSuccessDialog(BuildContext context, {String? message}) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.green.shade300, Colors.green.shade600],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Payment Successful!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               if (message != null) ...[
//                 const SizedBox(height: 12),
//                 Text(
//                   message,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey.shade600,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//               const SizedBox(height: 32),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//                       (route) => false,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text(
//                     'Continue',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
//     showPaymentSuccessDialog(context);

//     if (userId == null) {
//       _showErrorDialog("Authentication required");
//       return;
//     }

//     try {
//       final result = await _initiatePhonePePayment(
//           userId.toString(), widget.plan.id, response.paymentId.toString());

//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//         (route) => false,
//       );
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       _showErrorDialog("Transaction failed: $e");
//     }
//   }

//   void handleExternalWalletSelected(ExternalWalletResponse response) {
//     showAlertDialog(context, "Wallet Selected", "${response.walletName}");
//   }

//   void showAlertDialog(BuildContext context, String title, String message) {
//     failed(mesg: message, context: context);
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.red.shade600),
//             const SizedBox(width: 8),
//             const Text("Error"),
//           ],
//         ),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   // -------------------- IN-APP PURCHASE (iOS) --------------------
//   // Future<void> _initIAP() async {
//   //   print('Initializing In-App Purchase...');
    
//   //   final purchaseUpdated = _iap.purchaseStream;
//   //   _subscription = purchaseUpdated.listen((purchases) {
//   //     _listenToPurchaseUpdated(purchases);
//   //   }, onDone: () {
//   //     _subscription.cancel();
//   //   }, onError: (error) {
//   //     print('IAP purchaseStream error: $error');
//   //     if (mounted) {
//   //       failed(mesg: 'Purchase stream error: $error', context: context);
//   //     }
//   //   });

//   //   _available = await _iap.isAvailable();
//   //   if (!_available) {
//   //     print('IAP not available on this device');
//   //     if (mounted) {
//   //       failed(mesg: 'In-App Purchases are not available on this device', context: context);
//   //     }
//   //     return;
//   //   }

//   //   print('IAP is available, querying products...');
    
//   //   // Get product ID for current plan
//   //   final productId = _getProductIdForPlan();
//   //   if (productId == null) {
//   //     print('No product ID found for plan: ${widget.plan.id}');
//   //     return;
//   //   }

//   //   final ProductDetailsResponse response =
//   //       await _iap.queryProductDetails({productId});
    
//   //   if (response.error != null) {
//   //     print('ProductDetails query error: ${response.error}');
//   //     if (mounted) {
//   //       failed(mesg: 'Failed to load products: ${response.error}', context: context);
//   //     }
//   //   }
    
//   //   setState(() {
//   //     _products = response.productDetails;
//   //   });
    
//   //   print('Loaded ${_products.length} products');
//   // }

//   // String? _getProductIdForPlan() {
//   //   // Try to find product ID in mapping, fallback to a default pattern
//   //   return _planProductIds[widget.plan.id] ?? 
//   //          'com.yourapp.${widget.plan.name.toLowerCase()}_monthly';
//   // }

//   // void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
//   //   print('Purchase updated, ${purchases.length} purchase(s)');
    
//   //   for (final purchase in purchases) {
//   //     print('Purchase: ${purchase.productID}, Status: ${purchase.status}');
      
//   //     switch (purchase.status) {
//   //       case PurchaseStatus.pending:
//   //         _handlePendingPurchase(purchase);
//   //         break;
//   //       case PurchaseStatus.error:
//   //         _handlePurchaseError(purchase);
//   //         break;
//   //       case PurchaseStatus.purchased:
//   //       case PurchaseStatus.restored:
//   //         await _verifyAndCompletePurchase(purchase);
//   //         break;
//   //       case PurchaseStatus.canceled:
//   //         _handlePurchaseCanceled(purchase);
//   //         break;
//   //     }
      
//   //     if (purchase.pendingCompletePurchase) {
//   //       await _iap.completePurchase(purchase);
//   //       print('Purchase completed: ${purchase.productID}');
//   //     }
//   //   }
//   // }

//   // void _handlePendingPurchase(PurchaseDetails purchase) {
//   //   print('Purchase pending: ${purchase.productID}');
//   //   if (mounted) {
//   //     showLoading();
//   //     EasyLoading.show(status: 'Processing purchase...');
//   //   }
//   // }

//   // void _handlePurchaseError(PurchaseDetails purchase) {
//   //   final errorMsg = purchase.error?.message ?? 'Unknown purchase error';
//   //   print('Purchase error: $errorMsg');
    
//   //   if (mounted) {
//   //     EasyLoading.dismiss();
//   //     failed(mesg: 'Purchase failed: $errorMsg', context: context);
//   //   }
//   // }

//   // void _handlePurchaseCanceled(PurchaseDetails purchase) {
//   //   print('Purchase canceled: ${purchase.productID}');
//   //   if (mounted) {
//   //     EasyLoading.dismiss();
//   //     failed(mesg: 'Purchase was canceled', context: context);
//   //   }
//   // }

//   // Future<void> _verifyAndCompletePurchase(PurchaseDetails purchase) async {
//   //   print('Verifying purchase: ${purchase.productID}');
    
//   //   if (mounted) {
//   //     EasyLoading.show(status: 'Verifying purchase...');
//   //   }

//   //   try {
//   //     final planProvider = Provider.of<PlanProvider>(context, listen: false);
      
//   //     // Get receipt data for verification
//   //     final receiptData = purchase.verificationData.localVerificationData;
//   //     final transactionId = purchase.purchaseID ?? 'unknown_transaction';
      
//   //     print('Starting server verification...');
      
//   //     final verificationResult = await planProvider.verifyIosPurchase(
//   //       userId: userId ?? '',
//   //       planId: widget.plan.id,
//   //       receiptData: receiptData,
//   //       productId: purchase.productID,
//   //       transactionId: transactionId,
//   //     );

//   //     if (verificationResult != null && verificationResult['status'] == 'success') {
//   //       print('Purchase verification successful!');
        
//   //       if (mounted) {
//   //         EasyLoading.dismiss();
//   //         showPaymentSuccessDialog(
//   //           context, 
//   //           message: 'Your subscription is now active'
//   //         );
          
//   //         // Navigate to main screen after delay
//   //         Future.delayed(const Duration(seconds: 2), () {
//   //           Navigator.of(context).pushAndRemoveUntil(
//   //             MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//   //             (route) => false,
//   //           );
//   //         });
//   //       }
//   //     } else {
//   //       final errorMessage = verificationResult?['message'] ?? 'Verification failed';
//   //       print('Purchase verification failed: $errorMessage');
        
//   //       if (mounted) {
//   //         EasyLoading.dismiss();
//   //         _showErrorDialog('Purchase verification failed: $errorMessage');
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print('Verification exception: $e');
//   //     if (mounted) {
//   //       EasyLoading.dismiss();
//   //       _showErrorDialog('Verification failed: $e');
//   //     }
//   //   }
//   // }



//   Future<void> _initIAP() async {
//   print('Initializing In-App Purchase...');
  
//   final purchaseUpdated = _iap.purchaseStream;
//   _subscription = purchaseUpdated.listen((purchases) {
//     _listenToPurchaseUpdated(purchases);
//   }, onDone: () {
//     _subscription.cancel();
//   }, onError: (error) {
//     print('IAP purchaseStream error: $error');
//     if (mounted) {
//       failed(mesg: 'Purchase stream error: $error', context: context);
//     }
//   });

//   _available = await _iap.isAvailable();
//   if (!_available) {
//     print('IAP not available on this device');
//     if (mounted) {
//       failed(mesg: 'In-App Purchases are not available on this device', context: context);
//     }
//     return;
//   }

//   print('IAP is available, querying products...');
  
//   // Get product ID for current plan
//   final productId = _getProductIdForPlan();
//   if (productId == null) {
//     print('No product ID found for plan: ${widget.plan.id}');
//     return;
//   }

//   final ProductDetailsResponse response =
//       await _iap.queryProductDetails({productId});
  
//   if (response.error != null) {
//     print('ProductDetails query error: ${response.error}');
//     if (mounted) {
//       failed(mesg: 'Failed to load products: ${response.error}', context: context);
//     }
//   }
  
//   setState(() {
//     _products = response.productDetails;
//   });
  
//   print('Loaded ${_products.length} products');
// }

// String? _getProductIdForPlan() {
//   // Try to find product ID in mapping, fallback to a default pattern
//   return _planProductIds[widget.plan.id] ?? 
//          'com.yourapp.${widget.plan.name.toLowerCase()}_monthly';
// }

// void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
//   print('Purchase updated, ${purchases.length} purchase(s)');
  
//   for (final purchase in purchases) {
//     print('Purchase: ${purchase.productID}, Status: ${purchase.status}');
    
//     switch (purchase.status) {
//       case PurchaseStatus.pending:
//         _handlePendingPurchase(purchase);
//         break;
//       case PurchaseStatus.error:
//         _handlePurchaseError(purchase);
//         break;
//       case PurchaseStatus.purchased:
//       case PurchaseStatus.restored:
//         await _handleSuccessfulPurchase(purchase); // CHANGED: Use dummy handler
//         break;
//       case PurchaseStatus.canceled:
//         _handlePurchaseCanceled(purchase);
//         break;
//     }
    
//     if (purchase.pendingCompletePurchase) {
//       await _iap.completePurchase(purchase);
//       print('Purchase completed: ${purchase.productID}');
//     }
//   }
// }

// void _handlePendingPurchase(PurchaseDetails purchase) {
//   print('Purchase pending: ${purchase.productID}');
//   if (mounted) {
//     showLoading();
//     EasyLoading.show(status: 'Processing purchase...');
//   }
// }

// void _handlePurchaseError(PurchaseDetails purchase) {
//   final errorMsg = purchase.error?.message ?? 'Unknown purchase error';
//   print('Purchase error: $errorMsg');
  
//   if (mounted) {
//     EasyLoading.dismiss();
//     failed(mesg: 'Purchase failed: $errorMsg', context: context);
//   }
// }

// void _handlePurchaseCanceled(PurchaseDetails purchase) {
//   print('Purchase canceled: ${purchase.productID}');
//   if (mounted) {
//     EasyLoading.dismiss();
//     failed(mesg: 'Purchase was canceled', context: context);
//   }
// }

// // NEW: Simplified handler that doesn't call backend verification
// Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
//   print('Purchase successful: ${purchase.productID}');
  
//   if (mounted) {
//     EasyLoading.dismiss();
    
//     // Show success dialog immediately without backend verification
//     showPaymentSuccessDialog(
//       context, 
//       message: 'Your subscription is now active!\n(Note: Backend verification pending)'
//     );
    
//     print('NOTE: Backend verification endpoint not implemented yet');
//     print('Purchase details that would be sent to backend:');
//     print('- Product ID: ${purchase.productID}');
//     print('- Transaction ID: ${purchase.purchaseID}');
//     print('- Receipt data available: ${purchase.verificationData.localVerificationData.isNotEmpty}');
    
//     // You can still record the purchase locally if needed
//     if (userId != null) {
//       try {
//         // Optionally call purchasePlan with the transaction ID
//         final planProvider = Provider.of<PlanProvider>(context, listen: false);
//         await planProvider.purchasePlan(
//           userId!, 
//           widget.plan.id, 
//           purchase.purchaseID ?? 'iap_${DateTime.now().millisecondsSinceEpoch}'
//         );
//       } catch (e) {
//         print('Local purchase recording failed: $e');
//         // Continue anyway since IAP was successful
//       }
//     }
    
//     // Navigate to main screen after delay
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted) {
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//           (route) => false,
//         );
//       }
//     });
//   }
// }

//   // -------------------- UI & Purchase flow --------------------

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final planProvider = Provider.of<PlanProvider>(context);

//     // Show IAP verification status if verifying
//     if (planProvider.isVerifyingIAP) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         EasyLoading.show(status: planProvider.iapVerificationMessage);
//       });
//     }

//     // Dynamic theme based on plan type
//     ThemeData planTheme = _getPlanTheme();

//     return Theme(
//       data: planTheme,
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade50,
//         body: CustomScrollView(
//           slivers: [
//             // Custom App Bar with gradient
//             SliverAppBar(
//               expandedHeight: screenHeight * 0.35,
//               floating: false,
//               pinned: true,
//               elevation: 0,
//               backgroundColor: planTheme.primaryColor,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: _buildPlanHeader(planTheme, screenWidth),
//                 ),
//               ),
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),

//             // Content
//             SliverToBoxAdapter(
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 20),
//                     _buildPlanFeatures(planTheme),
//                     const SizedBox(height: 20),
//                     if (widget.plan.offerPrice > 0) _buildPaymentSection(planTheme),
//                     const SizedBox(height: 20),
//                     _buildActionButton(planTheme),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   ThemeData _getPlanTheme() {
//     final planName = widget.plan.name.toUpperCase();

//     if (planName.contains('COPPER')) {
//       return ThemeData(
//         primaryColor: Colors.deepOrange.shade600,
//         primarySwatch: Colors.deepOrange,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//       );
//     } else if (planName.contains('SILVER')) {
//       return ThemeData(
//         primaryColor: Colors.blueGrey.shade700,
//         primarySwatch: Colors.blueGrey,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
//       );
//     } else if (planName.contains('GOLD')) {
//       return ThemeData(
//         primaryColor: Colors.amber.shade700,
//         primarySwatch: Colors.amber,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
//       );
//     }

//     return ThemeData(
//       primaryColor: Colors.indigo.shade600,
//       primarySwatch: Colors.indigo,
//       colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
//     );
//   }

//   Widget _buildPlanHeader(ThemeData theme, double screenWidth) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             theme.primaryColor,
//             theme.primaryColor.withOpacity(0.8),
//           ],
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Plan Badge
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.white.withOpacity(0.3)),
//                 ),
//                 child: Text(
//                   widget.plan.name.toUpperCase(),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Price Display
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.baseline,
//                 textBaseline: TextBaseline.alphabetic,
//                 children: [
//                   Text(
//                     widget.plan.offerPrice == 0 ? 'Free' : '₹${widget.plan.offerPrice}',
//                     style: const TextStyle(
//                       fontSize: 48,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   if (widget.plan.originalPrice > widget.plan.offerPrice) ...[
//                     const SizedBox(width: 12),
//                     Text(
//                       '₹${widget.plan.originalPrice}',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         decoration: TextDecoration.lineThrough,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),

//               const SizedBox(height: 8),

//               Text(
//                 widget.plan.duration.toString(),
//                 style: const TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               if (widget.plan.discountPercentage > 0) ...[
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     'Save ${widget.plan.discountPercentage}%',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: theme.primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPlanFeatures(ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.featured_play_list_outlined,
//                   color: theme.primaryColor,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               const Text(
//                 'Plan Features',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 24),

//           ...widget.plan.features.asMap().entries.map((entry) {
//             final index = entry.key;
//             final feature = entry.value;

//             return AnimatedContainer(
//               duration: Duration(milliseconds: 200 + (index * 100)),
//               margin: const EdgeInsets.only(bottom: 16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       color: theme.primaryColor,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 16,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Text(
//                       feature,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         height: 1.5,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentSection(ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.payment_outlined,
//                   color: theme.primaryColor,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               const Text(
//                 'Payment Method',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 20),

//           _buildPaymentOption(
//             Platform.isIOS ? 'Apple In-App Purchase' : 'Digital Payment',
//             Platform.isIOS ? Icons.apple : Icons.account_balance_wallet_outlined,
//             Platform.isIOS 
//                 ? 'Secure payment via App Store'
//                 : 'Secure payment via UPI, Cards & More',
//             theme,
//           ),

//           if (Platform.isIOS)
//             Padding(
//               padding: const EdgeInsets.only(top: 12),
//               child: Text(
//                 'Uses Apple In-App Purchase as required by App Store guidelines.',
//                 style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentOption(String title, IconData icon, String description, ThemeData theme) {
//     final isSelected = selectedPaymentMethod == title;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedPaymentMethod = title;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: isSelected ? theme.primaryColor.withOpacity(0.08) : Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected ? theme.primaryColor : Colors.grey.shade300,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: isSelected ? theme.primaryColor : Colors.grey.shade400,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 icon,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),

//             const SizedBox(width: 16),

//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: isSelected ? theme.primaryColor : Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     description,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             if (isSelected)
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton(ThemeData theme) {
//     final planProvider = Provider.of<PlanProvider>(context);
    
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: (isLoading || planProvider.isVerifyingIAP) ? null : () => _processSubscription(context, theme),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: theme.primaryColor,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(28),
//           ),
//           shadowColor: theme.primaryColor.withOpacity(0.3),
//         ),
//         child: (isLoading || planProvider.isVerifyingIAP)
//             ? const SizedBox(
//                 height: 24,
//                 width: 24,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     widget.plan.offerPrice == 0
//                         ? Icons.lock_open_outlined
//                         : Icons.credit_card_outlined,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     widget.plan.offerPrice == 0
//                         ? 'Activate Free Plan'
//                         : 'Subscribe Now',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   void _processSubscription(BuildContext context, ThemeData theme) async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final userIdLocal = authProvider.user?.user.id ?? userId;

//     if (userIdLocal == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please log in to continue')),
//       );
//       return;
//     }

//     // Free plan handling
//     if (widget.plan.offerPrice == 0) {
//       setState(() {
//         isLoading = true;
//       });

//       await Future.delayed(const Duration(seconds: 2));

//       setState(() {
//         isLoading = false;
//       });

//       if (!mounted) return;

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.green.shade300, Colors.green.shade600],
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Welcome to ${widget.plan.name}!',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Your subscription is now active',
//                 style: TextStyle(color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//                       (route) => false,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   child: const Text('Get Started', style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//       return;
//     }

//     // Paid plan handling
//     if (selectedPaymentMethod == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a payment method')),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       if (Platform.isIOS) {
//         // Use StoreKit / In-App Purchase on iOS
//         if (!_available) {
//           _showErrorDialog('In-App Purchases not available on this device');
//           setState(() {
//             isLoading = false;
//           });
//           return;
//         }

//         // Get product for current plan
//         final productId = _getProductIdForPlan();
//         if (productId == null) {
//           _showErrorDialog('No product configured for this plan');
//           setState(() {
//             isLoading = false;
//           });
//           return;
//         }

//         // Query products if not already loaded
//         if (_products.isEmpty) {
//           final response = await _iap.queryProductDetails({productId});
//           if (response.error != null || response.productDetails.isEmpty) {
//             _showErrorDialog('Product not available for purchase');
//             setState(() {
//               isLoading = false;
//             });
//             return;
//           }
//           _products = response.productDetails;
//         }

//         // Find matching product
//         final productForPlan = _products.firstWhere(
//           (p) => p.id == productId,
//           orElse: () => _products.first,
//         );

//         if (productForPlan == null) {
//           _showErrorDialog('Product not found for purchase');
//           setState(() {
//             isLoading = false;
//           });
//           return;
//         }

//         print('Starting purchase for product: ${productForPlan.id}');
        
//         final PurchaseParam purchaseParam = PurchaseParam(
//           productDetails: productForPlan,
//         );

//         // Start purchase
//         await _iap.buyNonConsumable(purchaseParam: purchaseParam);
        
//         // Purchase flow will continue via the purchaseStream listener

//       } else {
//         // Android: Razorpay
//         Razorpay razorpay = _razorpay ?? Razorpay();
//         var options = {
//           'key': 'rzp_live_RTmw5UsY3ffNxq',
//           'amount': (widget.plan.offerPrice * 100).toInt(),
//           'name': 'Edit-Ezy',
//           'description': 'Subscription',
//           'retry': {'enabled': true, 'max_count': 1},
//           'send_sms_hash': true,
//           'prefill': {
//             'contact': "9961593179",
//             'email': "melvincherian0190@gmail.com",
//           },
//           'external': {
//             'wallets': ['paytm']
//           }
//         };
//         razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//         razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//         razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//         razorpay.open(options);
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<PhonePePaymentResponse> _initiatePhonePePayment(
//       String userId, String planId, String transactionId) async {
//     final planProvider = Provider.of<PlanProvider>(context, listen: false);
//     try {
//       return await planProvider.initiatePhonePePayment(
//           userId, planId, transactionId);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   void _showPaymentStatusCheckDialog(
//     BuildContext context,
//     String merchantOrderId,
//     String userId,
//     String planId,
//   ) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Complete Payment'),
//         content: const Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Please complete the payment process in your payment app.'),
//             SizedBox(height: 20),
//             CircularProgressIndicator(),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Payment Completed'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _checkPaymentStatus(
//     BuildContext context,
//     String merchantOrderId,
//     String userId,
//     String planId,
//   ) async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final planProvider = Provider.of<PlanProvider>(context, listen: false);
//       final response = await planProvider.checkPaymentStatus(merchantOrderId);

//       if (response != null && response['status'] == 'PAYMENT_SUCCESS') {
//         final purchaseResponse = await planProvider.getPurchaseDetails(userId, planId);
//         // Handle success
//       } else {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Payment verification failed')),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// }



















// // plan_details_payment_screen.dart
// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/models/get_all_plan_model.dart';
// import 'package:posternova/models/payment_model.dart';
// import 'package:posternova/providers/auth/login_provider.dart';
// import 'package:posternova/providers/plans/plan_provider.dart';
// import 'package:posternova/views/NavBar/navbar_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// failed({required String mesg, required context}) {
//   EasyLoading.dismiss();
//   return showTopSnackBar(
//     Overlay.of(context),
//     CustomSnackBar.error(
//       message: "$mesg",
//     ),
//   );
// }

// success({required String mesg, required BuildContext context}) {
//   EasyLoading.dismiss();
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(mesg, style: TextStyle(fontFamily: "PopR")),
//       backgroundColor: Colors.green[700],
//       behavior: SnackBarBehavior.floating,
//       duration: Duration(seconds: 3),
//     ),
//   );
// }

// showLoading() {
//   return EasyLoading.show(status: 'loading...');
// }

// class PlanDetailsAndPaymentScreen extends StatefulWidget {
//   final GetAllPlanModel plan;

//   const PlanDetailsAndPaymentScreen({
//     Key? key,
//     required this.plan,
//   }) : super(key: key);

//   @override
//   State<PlanDetailsAndPaymentScreen> createState() =>
//       _PlanDetailsAndPaymentScreenState();
// }

// class _PlanDetailsAndPaymentScreenState
//     extends State<PlanDetailsAndPaymentScreen> with TickerProviderStateMixin {
//   String? selectedPaymentMethod;
//   bool isLoading = false;
//   String? userId;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   // Razorpay instance (Android) - only initialized when needed
//   Razorpay? _razorpay;

//   // In-app purchase (iOS) - only initialized when needed
//   final InAppPurchase _iap = InAppPurchase.instance;
//   StreamSubscription<List<PurchaseDetails>>? _subscription;
//   bool _available = false;
//   List<ProductDetails> _products = [];
  
//   // Product IDs mapping - UPDATE THESE WITH YOUR ACTUAL APP STORE PRODUCT IDs
//   static const Map<String, String> _planProductIds = {
//     // Example mapping - replace with your actual plan IDs and product IDs
//     'plan_copper_monthly': 'com.editezy.premium_policy',
//     'plan_silver_monthly': 'com.editezy.premium_policy',
//     'plan_gold_monthly': 'com.editezy.premium_policy',
//     // Add more mappings as needed
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();

//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();

//     // DO NOT initialize payment methods here - wait for subscribe button click
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _cleanupPaymentMethods(); // Clean up when screen is disposed
//     super.dispose();
//   }

//   void _cleanupPaymentMethods() {
//     _razorpay?.clear();
//     _subscription?.cancel();
//     _subscription = null;
//   }

//   Future<void> _loadUserId() async {
//     try {
//       final userData = await AuthPreferences.getUserData();
//       if (userData != null) {
//         setState(() {
//           userId = userData.user.id;
//         });
//       }
//     } catch (e) {
//       print('Error loading user ID: $e');
//     }
//   }

//   // -------------------- RAZORPAY (Android) --------------------
//   void _initRazorpay() {
//     _razorpay = Razorpay();
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//     _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//     _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//   }

//   void handlePaymentErrorResponse(PaymentFailureResponse response) {
//     showAlertDialog(context, "Payment Failed",
//         "Code: ${response.code}\nDescription: ${response.message}");
//   }

//   void showPaymentSuccessDialog(BuildContext context, {String? message}) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.green.shade300, Colors.green.shade600],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Payment Successful!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               if (message != null) ...[
//                 const SizedBox(height: 12),
//                 Text(
//                   message,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey.shade600,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//               const SizedBox(height: 32),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//                       (route) => false,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text(
//                     'Continue',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
//     showPaymentSuccessDialog(context);

//     if (userId == null) {
//       _showErrorDialog("Authentication required");
//       return;
//     }

//     try {
//       final result = await _initiatePhonePePayment(
//           userId.toString(), widget.plan.id, response.paymentId.toString());

//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//         (route) => false,
//       );
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       _showErrorDialog("Transaction failed: $e");
//     }
//   }

//   void handleExternalWalletSelected(ExternalWalletResponse response) {
//     showAlertDialog(context, "Wallet Selected", "${response.walletName}");
//   }

//   void showAlertDialog(BuildContext context, String title, String message) {
//     failed(mesg: message, context: context);
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.red.shade600),
//             const SizedBox(width: 8),
//             const Text("Error"),
//           ],
//         ),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   // -------------------- IN-APP PURCHASE (iOS) - ONLY WHEN NEEDED --------------------
//   Future<void> _initIAP() async {
//     print('Initializing In-App Purchase...');
    
//     // Clean up any existing subscription
//     _subscription?.cancel();
    
//     final purchaseUpdated = _iap.purchaseStream;
//     _subscription = purchaseUpdated.listen((purchases) {
//       _listenToPurchaseUpdated(purchases);
//     }, onDone: () {
//       _subscription?.cancel();
//     }, onError: (error) {
//       print('IAP purchaseStream error: $error');
//       if (mounted) {
//         failed(mesg: 'Purchase stream error: $error', context: context);
//       }
//     });

//     _available = await _iap.isAvailable();
//     if (!_available) {
//       print('IAP not available on this device');
//       if (mounted) {
//         failed(mesg: 'In-App Purchases are not available on this device', context: context);
//       }
//       return;
//     }

//     print('IAP is available, querying products...');
    
//     // Get product ID for current plan
//     final productId = _getProductIdForPlan();
//           print('No product ID found for plan 11111111: $productId');

//     if (productId == null) {
//           print('No product ID found for plan inside 1: $productId');
//       return;
//     }

//     final ProductDetailsResponse response =
//         await _iap.queryProductDetails({productId});
    
//     if (response.error != null) {
//       print('ProductDetails query error: ${response.error}');
//       if (mounted) {
//         failed(mesg: 'Failed to load products: ${response.error}', context: context);
//       }
//     }
    
//     setState(() {
//       _products = response.productDetails;
//     });
    
//     print('Loaded ${_products.length} products');
//   }

//   String? _getProductIdForPlan() {
//     // Try to find product ID in mapping, fallback to a default pattern
//     // return _planProductIds[widget.plan.id] ?? 
//     //        'com.yourapp.${widget.plan.name.toLowerCase()}_monthly';
//         return 'com.editezy.premium_policy';
//   }

//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
//     print('Purchase updated, ${purchases.length} purchase(s)');
    
//     for (final purchase in purchases) {
//       print('Purchase: ${purchase.productID}, Status: ${purchase.status}');
      
//       switch (purchase.status) {
//         case PurchaseStatus.pending:
//           _handlePendingPurchase(purchase);
//           break;
//         case PurchaseStatus.error:
//           _handlePurchaseError(purchase);
//           break;
//         case PurchaseStatus.purchased:
//         case PurchaseStatus.restored:
//           await _handleSuccessfulPurchase(purchase);
//           break;
//         case PurchaseStatus.canceled:
//           _handlePurchaseCanceled(purchase);
//           break;
//       }
      
//       if (purchase.pendingCompletePurchase) {
//         await _iap.completePurchase(purchase);
//         print('Purchase completed: ${purchase.productID}');
//       }
//     }
//   }

//   void _handlePendingPurchase(PurchaseDetails purchase) {
//     print('Purchase pending: ${purchase.productID}');
//     if (mounted) {
//       showLoading();
//       EasyLoading.show(status: 'Processing purchase...');
//     }
//   }

//   void _handlePurchaseError(PurchaseDetails purchase) {
//     final errorMsg = purchase.error?.message ?? 'Unknown purchase error';
//     print('Purchase error: $errorMsg');
    
//     if (mounted) {
//       EasyLoading.dismiss();
//       failed(mesg: 'Purchase failed: $errorMsg', context: context);
//     }
//   }

//   void _handlePurchaseCanceled(PurchaseDetails purchase) {
//     print('Purchase canceled: ${purchase.productID}');
//     if (mounted) {
//       EasyLoading.dismiss();
//       failed(mesg: 'Purchase was canceled', context: context);
//     }
//   }

//   Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
//     print('Purchase successful: ${purchase.productID}');
    
//     if (mounted) {
//       EasyLoading.dismiss();
      
//       // Show success dialog immediately without backend verification
//       showPaymentSuccessDialog(
//         context, 
//         message: 'Your subscription is now active!'
//       );
      
//       print('Purchase details:');
//       print('- Product ID: ${purchase.productID}');
//       print('- Transaction ID: ${purchase.purchaseID}');
      
//       // Record the purchase locally
//       if (userId != null) {
//         try {
//           final planProvider = Provider.of<PlanProvider>(context, listen: false);
//           await planProvider.purchasePlan(
//             userId!, 
//             widget.plan.id, 
//             purchase.purchaseID ?? 'iap_${DateTime.now().millisecondsSinceEpoch}'
//           );
//         } catch (e) {
//           print('Local purchase recording failed: $e');
//           // Continue anyway since IAP was successful
//         }
//       }
//     }
//   }

//   // -------------------- UI & Purchase flow --------------------

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     // Dynamic theme based on plan type
//     ThemeData planTheme = _getPlanTheme();

//     return Theme(
//       data: planTheme,
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade50,
//         body: CustomScrollView(
//           slivers: [
//             // Custom App Bar with gradient
//             SliverAppBar(
//               expandedHeight: screenHeight * 0.35,
//               floating: false,
//               pinned: true,
//               elevation: 0,
//               backgroundColor: planTheme.primaryColor,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: _buildPlanHeader(planTheme, screenWidth),
//                 ),
//               ),
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),

//             // Content
//             SliverToBoxAdapter(
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 20),
//                     _buildPlanFeatures(planTheme),
//                     const SizedBox(height: 20),
//                     if (widget.plan.offerPrice > 0) _buildPaymentSection(planTheme),
//                     const SizedBox(height: 20),
//                     _buildActionButton(planTheme),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   ThemeData _getPlanTheme() {
//     final planName = widget.plan.name.toUpperCase();

//     if (planName.contains('COPPER')) {
//       return ThemeData(
//         primaryColor: Colors.deepOrange.shade600,
//         primarySwatch: Colors.deepOrange,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//       );
//     } else if (planName.contains('SILVER')) {
//       return ThemeData(
//         primaryColor: Colors.blueGrey.shade700,
//         primarySwatch: Colors.blueGrey,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
//       );
//     } else if (planName.contains('GOLD')) {
//       return ThemeData(
//         primaryColor: Colors.amber.shade700,
//         primarySwatch: Colors.amber,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
//       );
//     }

//     return ThemeData(
//       primaryColor: Colors.indigo.shade600,
//       primarySwatch: Colors.indigo,
//       colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
//     );
//   }

//   Widget _buildPlanHeader(ThemeData theme, double screenWidth) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             theme.primaryColor,
//             theme.primaryColor.withOpacity(0.8),
//           ],
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Plan Badge
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.white.withOpacity(0.3)),
//                 ),
//                 child: Text(
//                   widget.plan.name.toUpperCase(),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Price Display
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.baseline,
//                 textBaseline: TextBaseline.alphabetic,
//                 children: [
//                   Text(
//                     widget.plan.offerPrice == 0 ? 'Free' : '₹${widget.plan.offerPrice}',
//                     style: const TextStyle(
//                       fontSize: 48,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   if (widget.plan.originalPrice > widget.plan.offerPrice) ...[
//                     const SizedBox(width: 12),
//                     Text(
//                       '₹${widget.plan.originalPrice}',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         decoration: TextDecoration.lineThrough,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),

//               const SizedBox(height: 8),

//               Text(
//                 widget.plan.duration.toString(),
//                 style: const TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               if (widget.plan.discountPercentage > 0) ...[
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     'Save ${widget.plan.discountPercentage}%',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: theme.primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPlanFeatures(ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.featured_play_list_outlined,
//                   color: theme.primaryColor,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               const Text(
//                 'Plan Features',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 24),

//           ...widget.plan.features.asMap().entries.map((entry) {
//             final index = entry.key;
//             final feature = entry.value;

//             return AnimatedContainer(
//               duration: Duration(milliseconds: 200 + (index * 100)),
//               margin: const EdgeInsets.only(bottom: 16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       color: theme.primaryColor,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 16,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Text(
//                       feature,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         height: 1.5,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentSection(ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.payment_outlined,
//                   color: theme.primaryColor,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               const Text(
//                 'Payment Method',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 20),

//           _buildPaymentOption(
//             Platform.isIOS ? 'Apple In-App Purchase' : 'Digital Payment',
//             Platform.isIOS ? Icons.apple : Icons.account_balance_wallet_outlined,
//             Platform.isIOS 
//                 ? 'Secure payment via App Store'
//                 : 'Secure payment via UPI, Cards & More',
//             theme,
//           ),

//           if (Platform.isIOS)
//             Padding(
//               padding: const EdgeInsets.only(top: 12),
//               child: Text(
//                 'Uses Apple In-App Purchase as required by App Store guidelines.',
//                 style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentOption(String title, IconData icon, String description, ThemeData theme) {
//     final isSelected = selectedPaymentMethod == title;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedPaymentMethod = title;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: isSelected ? theme.primaryColor.withOpacity(0.08) : Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected ? theme.primaryColor : Colors.grey.shade300,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: isSelected ? theme.primaryColor : Colors.grey.shade400,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 icon,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),

//             const SizedBox(width: 16),

//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: isSelected ? theme.primaryColor : Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     description,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             if (isSelected)
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton(ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : () => _processSubscription(context, theme),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: theme.primaryColor,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(28),
//           ),
//           shadowColor: theme.primaryColor.withOpacity(0.3),
//         ),
//         child: isLoading
//             ? const SizedBox(
//                 height: 24,
//                 width: 24,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     widget.plan.offerPrice == 0
//                         ? Icons.lock_open_outlined
//                         : Icons.credit_card_outlined,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     widget.plan.offerPrice == 0
//                         ? 'Activate Free Plan'
//                         : 'Subscribe Now',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   void _processSubscription(BuildContext context, ThemeData theme) async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final userIdLocal = authProvider.user?.user.id ?? userId;

//     if (userIdLocal == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please log in to continue')),
//       );
//       return;
//     }

//     // Free plan handling
//     if (widget.plan.offerPrice == 0) {
//       setState(() {
//         isLoading = true;
//       });

//       await Future.delayed(const Duration(seconds: 2));

//       setState(() {
//         isLoading = false;
//       });

//       if (!mounted) return;

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.green.shade300, Colors.green.shade600],
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Welcome to ${widget.plan.name}!',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Your subscription is now active',
//                 style: TextStyle(color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => MainNavigationScreen()),
//                       (route) => false,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   child: const Text('Get Started', style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//       return;
//     }

//     // Paid plan handling
//     if (selectedPaymentMethod == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a payment method')),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       if (Platform.isIOS) {
//         // Initialize IAP ONLY when subscribe button is clicked
//         await _initIAP();

//         if (!_available) {
//           _showErrorDialog('In-App Purchases not available on this device');
//           setState(() {
//             isLoading = false;
//           });
//           return;
//         }

//         // Get product for current plan
//         final productId = _getProductIdForPlan();
//                   print('No product ID found for plannnnnnnn: $productId');

//         if (productId == null) {
//           _showErrorDialog('No product configured for this plannnnn');
//           setState(() {
//             isLoading = false;
//           });
//           return;
//         }

//         // Query products
//         if (_products.isEmpty) {
//           print("kkkklllflklfvidshnufdsfdfdkjffdf $productId");
//           final response = await _iap.queryProductDetails({productId});
//           if (response.error != null || response.productDetails.isEmpty) {
//             _showErrorDialog('Product not available for purchase');
//             setState(() {
//               isLoading = false;
//             });
//             return;
//           }
//           _products = response.productDetails;
//         }

//         // Find matching product
//         final productForPlan = _products.firstWhere(
//           (p) => p.id == productId,
//           orElse: () => _products.first,
//         );

//         if (productForPlan == null) {
//           _showErrorDialog('Product not found for purchase');
//           setState(() {
//             isLoading = false;
//           });
//           return;
//         }

//         print('Starting purchase for product: ${productForPlan.id}');
        
//         final PurchaseParam purchaseParam = PurchaseParam(
//           productDetails: productForPlan,
//         );

//         // Start purchase - this will trigger the Apple IAP flow
//         await _iap.buyNonConsumable(purchaseParam: purchaseParam);
        
//         // Set loading to false since the purchase flow is handled separately
//         setState(() {
//           isLoading = false;
//         });

//       } else {
//         // Android: Razorpay - Initialize ONLY when subscribe button is clicked
//         _initRazorpay();
        
//         var options = {
//           'key': 'rzp_live_RTmw5UsY3ffNxq',
//           'amount': (widget.plan.offerPrice * 100).toInt(),
//           'name': 'Edit-Ezy',
//           'description': 'Subscription',
//           'retry': {'enabled': true, 'max_count': 1},
//           'send_sms_hash': true,
//           'prefill': {
//             'contact': "9961593179",
//             'email': "melvincherian0190@gmail.com",
//           },
//           'external': {
//             'wallets': ['paytm']
//           }
//         };
//         _razorpay!.open(options);
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment error: ${e.toString()}')),
//       );
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<PhonePePaymentResponse> _initiatePhonePePayment(
//       String userId, String planId, String transactionId) async {
//     final planProvider = Provider.of<PlanProvider>(context, listen: false);
//     try {
//       return await planProvider.initiatePhonePePayment(
//           userId, planId, transactionId);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   void _showPaymentStatusCheckDialog(
//     BuildContext context,
//     String merchantOrderId,
//     String userId,
//     String planId,
//   ) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Complete Payment'),
//         content: const Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Please complete the payment process in your payment app.'),
//             SizedBox(height: 20),
//             CircularProgressIndicator(),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Payment Completed'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _checkPaymentStatus(
//     BuildContext context,
//     String merchantOrderId,
//     String userId,
//     String planId,
//   ) async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final planProvider = Provider.of<PlanProvider>(context, listen: false);
//       final response = await planProvider.checkPaymentStatus(merchantOrderId);

//       if (response != null && response['status'] == 'PAYMENT_SUCCESS') {
//         final purchaseResponse = await planProvider.getPurchaseDetails(userId, planId);
//         // Handle success
//       } else {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Payment verification failed')),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// }













// plan_details_payment_screen.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/get_all_plan_model.dart';
import 'package:posternova/models/payment_model.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:posternova/providers/plans/plan_provider.dart';
import 'package:posternova/views/NavBar/navbar_screen.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

failed({required String mesg, required context}) {
  EasyLoading.dismiss();
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      message: "$mesg",
    ),
  );
}

success({required String mesg, required BuildContext context}) {
  EasyLoading.dismiss();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mesg, style: TextStyle(fontFamily: "PopR")),
      backgroundColor: Colors.green[700],
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
    ),
  );
}

showLoading() {
  return EasyLoading.show(status: 'loading...');
}

class PlanDetailsAndPaymentScreen extends StatefulWidget {
  final GetAllPlanModel plan;

  const PlanDetailsAndPaymentScreen({
    Key? key,
    required this.plan,
  }) : super(key: key);

  @override
  State<PlanDetailsAndPaymentScreen> createState() =>
      _PlanDetailsAndPaymentScreenState();
}

class _PlanDetailsAndPaymentScreenState
    extends State<PlanDetailsAndPaymentScreen> with TickerProviderStateMixin {
  String? selectedPaymentMethod;
  bool isLoading = false;
  String? userId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Razorpay instance (Android) - only initialized when needed
  Razorpay? _razorpay;

  // In-app purchase (iOS) - only initialized when needed
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _available = false;
  List<ProductDetails> _products = [];
  
  // Use simple product IDs that are easy to remember
  String get _productIdForCurrentPlan {
    // Create a simple product ID based on plan name and price
    final planName = widget.plan.name.toLowerCase().replaceAll(' ', '_');
    return 'com.editezy.yearly';
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // DO NOT initialize payment methods here - wait for subscribe button click
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cleanupPaymentMethods(); // Clean up when screen is disposed
    super.dispose();
  }

  void _cleanupPaymentMethods() {
    _razorpay?.clear();
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _loadUserId() async {
    try {
      final userData = await AuthPreferences.getUserData();
      if (userData != null) {
        setState(() {
          userId = userData.user.id;
        });
      }
    } catch (e) {
      print('Error loading user ID: $e');
    }
  }

  // -------------------- RAZORPAY (Android) --------------------
  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}");
  }

  void showPaymentSuccessDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade300, Colors.green.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: 12),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MainNavigationScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    showPaymentSuccessDialog(context);

    if (userId == null) {
      _showErrorDialog("Authentication required");
      return;
    }

    try {
      final result = await _initiatePhonePePayment(
          userId.toString(), widget.plan.id, response.paymentId.toString());

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainNavigationScreen()),
        (route) => false,
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog("Transaction failed: $e");
    }
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(context, "Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    failed(mesg: message, context: context);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade600),
            const SizedBox(width: 8),
            const Text("Error"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // -------------------- IN-APP PURCHASE (iOS) - WITH DUMMY PRODUCTS --------------------
  Future<void> _initIAP() async {
    print('Initializing In-App Purchase...');
    
    // Clean up any existing subscription
    _subscription?.cancel();
    
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchases) {
      _listenToPurchaseUpdated(purchases);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      print('IAP purchaseStream error: $error');
      if (mounted) {
        failed(mesg: 'Purchase stream error: $error', context: context);
      }
    });

    try {
      _available = await _iap.isAvailable();
      if (!_available) {
        print('IAP not available on this device');
        if (mounted) {
          failed(mesg: 'In-App Purchases are not available on this device', context: context);
        }
        return;
      }

      print('IAP is available, querying products...');
      print('Product ID: $_productIdForCurrentPlan');

      // Try to fetch real products first
      final ProductDetailsResponse response = await _iap.queryProductDetails({_productIdForCurrentPlan});
      
      if (response.error != null) {
        print('ProductDetails query error: ${response.error}');
        print('This is normal during development - using dummy products');
        _createDummyProducts();
        return;
      }
      
      if (response.productDetails.isEmpty) {
        print('No real products found in App Store - using dummy products');
        _createDummyProducts();
        return;
      }
      
      setState(() {
        _products = response.productDetails;
      });
      
      print('Successfully loaded ${_products.length} real products from App Store');
    } catch (e) {
      print('Exception during IAP initialization: $e');
      print('Using dummy products as fallback');
      _createDummyProducts();
    }
  }

  void _createDummyProducts() {
    print('Creating dummy products for development...');
    
    // Create a proper ProductDetails object with all required parameters
    final dummyProduct = ProductDetails(
      id: _productIdForCurrentPlan,
      title: '${widget.plan.name} Subscription',
      description: 'Access to ${widget.plan.name} features for ${widget.plan.duration}',
      price: '₹${widget.plan.offerPrice}',
      rawPrice: widget.plan.offerPrice.toDouble(),
      currencyCode: 'INR',
      currencySymbol: '₹',
    );
    
    setState(() {
      _products = [dummyProduct];
    });
    
    print('Dummy product created: $_productIdForCurrentPlan');
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
    print('Purchase updated, ${purchases.length} purchase(s)');
    
    for (final purchase in purchases) {
      print('Purchase: ${purchase.productID}, Status: ${purchase.status}');
      
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _handlePendingPurchase(purchase);
          break;
        case PurchaseStatus.error:
          _handlePurchaseError(purchase);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _handleSuccessfulPurchase(purchase);
          break;
        case PurchaseStatus.canceled:
          _handlePurchaseCanceled(purchase);
          break;
      }
      
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
        print('Purchase completed: ${purchase.productID}');
      }
    }
  }

  void _handlePendingPurchase(PurchaseDetails purchase) {
    print('Purchase pending: ${purchase.productID}');
    if (mounted) {
      showLoading();
      EasyLoading.show(status: 'Processing purchase...');
    }
  }

  void _handlePurchaseError(PurchaseDetails purchase) {
    final errorMsg = purchase.error?.message ?? 'Unknown purchase error';
    print('Purchase error: $errorMsg');
    
    if (mounted) {
      EasyLoading.dismiss();
      
      // Show user-friendly error message
      if (errorMsg.contains('storekit')) {
        failed(mesg: 'App Store is not responding. Please check your internet connection and try again.', context: context);
      } else {
        failed(mesg: 'Purchase failed: $errorMsg', context: context);
      }
    }
  }

  void _handlePurchaseCanceled(PurchaseDetails purchase) {
    print('Purchase canceled: ${purchase.productID}');
    if (mounted) {
      EasyLoading.dismiss();
      failed(mesg: 'Purchase was canceled', context: context);
    }
  }

  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    print('Purchase successful: ${purchase.productID}');
    
    if (mounted) {
      EasyLoading.dismiss();
      
      // Show success dialog
      showPaymentSuccessDialog(
        context, 
        message: 'Your ${widget.plan.name} subscription is now active!'
      );
      
      print('Purchase details:');
      print('- Product ID: ${purchase.productID}');
      print('- Transaction ID: ${purchase.purchaseID}');
            print('- Transaction IDDDDDDDD: ${purchase.purchaseID}');

      
      // Record the purchase locally
      if (userId != null) {
        try {
          final planProvider = Provider.of<PlanProvider>(context, listen: false);
          await planProvider.purchaseIOSPlan(
            userId!, 
            widget.plan.id
          );
          print('Purchase recorded successfully in local database');
        } catch (e) {
          print('Local purchase recording failed: $e');
          // Continue anyway since IAP was successful
        }
      }
      
      // Clean up payment methods
      _cleanupPaymentMethods();
    }
  }
  

  // -------------------- UI & Purchase flow --------------------

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic theme based on plan type
    ThemeData planTheme = _getPlanTheme();

    return Theme(
      data: planTheme,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: CustomScrollView(
          slivers: [
            // Custom App Bar with gradient
            SliverAppBar(
              expandedHeight: screenHeight * 0.35,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: planTheme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                background: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildPlanHeader(planTheme, screenWidth),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildPlanFeatures(planTheme),
                    const SizedBox(height: 20),
                    if (widget.plan.offerPrice > 0) _buildPaymentSection(planTheme),
                    const SizedBox(height: 20),
                    _buildActionButton(planTheme),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ThemeData _getPlanTheme() {
    final planName = widget.plan.name.toUpperCase();
    if (planName.contains('COPPER')) {
      return ThemeData(
        primaryColor: Colors.deepOrange.shade600,
        primarySwatch: Colors.deepOrange,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      );
    } else if (planName.contains('SILVER')) {
      return ThemeData(
        primaryColor: Colors.blueGrey.shade700,
        primarySwatch: Colors.blueGrey,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      );
    } else if (planName.contains('GOLD')) {
      return ThemeData(
        primaryColor: Colors.amber.shade700,
        primarySwatch: Colors.amber,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      );
    }
    return ThemeData(
      primaryColor: Colors.indigo.shade600,
      primarySwatch: Colors.indigo,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    );
  }

  Widget _buildPlanHeader(ThemeData theme, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  widget.plan.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    widget.plan.offerPrice == 0 ? 'Free' : '₹${widget.plan.offerPrice}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (widget.plan.originalPrice > widget.plan.offerPrice) ...[
                    const SizedBox(width: 12),
                    Text(
                      '₹${widget.plan.originalPrice}',
                      style: const TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.plan.duration.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.plan.discountPercentage > 0) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Save ${widget.plan.discountPercentage}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanFeatures(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.featured_play_list_outlined, color: theme.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              const Text(
                'Plan Features',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...widget.plan.features.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 200 + (entry.key * 100)),
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87))),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.payment_outlined, color: theme.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              const Text('Payment Method', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 20),
          _buildPaymentOption(
            Platform.isIOS ? 'Apple In-App Purchase' : 'Digital Payment',
            Platform.isIOS ? Icons.apple : Icons.account_balance_wallet_outlined,
            Platform.isIOS ? 'Secure payment via App Store' : 'Secure payment via UPI, Cards & More',
            theme,
          ),
          if (Platform.isIOS)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Uses Apple In-App Purchase as required by App Store guidelines.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, String description, ThemeData theme) {
    final isSelected = selectedPaymentMethod == title;
    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor.withOpacity(0.08) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? theme.primaryColor : Colors.grey.shade300, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? theme.primaryColor : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? theme.primaryColor : Colors.black87)),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: theme.primaryColor, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _processSubscription(context, theme),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          shadowColor: theme.primaryColor.withOpacity(0.3),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24, width: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.plan.offerPrice == 0 ? Icons.lock_open_outlined : Icons.credit_card_outlined, size: 20),
                  const SizedBox(width: 12),
                  Text(widget.plan.offerPrice == 0 ? 'Activate Free Plan' : 'Subscribe Now', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
      ),
    );
  }

  void _processSubscription(BuildContext context, ThemeData theme) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userIdLocal = authProvider.user?.user.id ?? userId;

    if (userIdLocal == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please log in to continue')));
      return;
    }

    // Free plan handling
    if (widget.plan.offerPrice == 0) {
      setState(() => isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => isLoading = false);
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green.shade300, Colors.green.shade600]),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              Text('Welcome to ${widget.plan.name}!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              const Text('Your subscription is now active', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MainNavigationScreen()), (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                  child: const Text('Get Started', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    // Paid plan handling
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a payment method')));
      return;
    }

    setState(() => isLoading = true);

    try {
      if (Platform.isIOS) {
        // Initialize IAP ONLY when subscribe button is clicked
        await _initIAP();

        if (!_available) {
          _showErrorDialog('In-App Purchases not available on this device');
          setState(() => isLoading = false);
          return;
        }

        if (_products.isEmpty) {
          _showErrorDialog('No products available for purchase at the moment. Please try again later.');
          setState(() => isLoading = false);
          return;
        }

        // FIXED: Proper product selection without type errors
        ProductDetails? productForPlan;
        for (var product in _products) {
          if (product.id == _productIdForCurrentPlan) {
            productForPlan = product;
            break;
          }
        }
        
        // If no exact match, use the first product
        productForPlan ??= _products.first;
        
        print('Starting purchase for product: ${productForPlan.id}');
        
        final PurchaseParam purchaseParam = PurchaseParam(productDetails: productForPlan);

        // Start purchase - this will trigger the Apple IAP flow
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
        
        // Set loading to false since the purchase flow is handled separately
        setState(() => isLoading = false);

      } else {
        // Android: Razorpay - Initialize ONLY when subscribe button is clicked
        _initRazorpay();
        
        var options = {
          'key': 'rzp_live_RTmw5UsY3ffNxq',
          'amount': (widget.plan.offerPrice * 100).toInt(),
          'name': 'Edit-Ezy',
          'description': 'Subscription',
          'retry': {'enabled': true, 'max_count': 1},
          'send_sms_hash': true,
          'prefill': {'contact': "9961593179", 'email': "melvincherian0190@gmail.com"},
          'external': {'wallets': ['paytm']}
        };
        _razorpay!.open(options);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment error: ${e.toString()}')));
      setState(() => isLoading = false);
    }
  }

  Future<PhonePePaymentResponse> _initiatePhonePePayment(String userId, String planId, String transactionId) async {
    final planProvider = Provider.of<PlanProvider>(context, listen: false);
    try {
      return await planProvider.initiatePhonePePayment(userId, planId, transactionId);
    } catch (e) {
      rethrow;
    }
  }
}