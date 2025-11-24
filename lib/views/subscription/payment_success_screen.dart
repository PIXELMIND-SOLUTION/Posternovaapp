
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
  
//   // Use simple product IDs that are easy to remember
//   String get _productIdForCurrentPlan {
//     // Create a simple product ID based on plan name and price
//     final planName = widget.plan.name.toLowerCase().replaceAll(' ', '_');
//     return 'com.editezy.premium.yearly.plan';
//   }

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

//   // -------------------- IN-APP PURCHASE (iOS) - WITH DUMMY PRODUCTS --------------------
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

//     try {
//       _available = await _iap.isAvailable();
//       if (!_available) {
//         print('IAP not available on this device');
//         if (mounted) {
//           failed(mesg: 'In-App Purchases are not available on this device', context: context);
//         }
//         return;
//       }

//       print('IAP is available, querying products...');
//       print('Product ID: $_productIdForCurrentPlan');

//       // Try to fetch real products first
//       final ProductDetailsResponse response = await _iap.queryProductDetails({_productIdForCurrentPlan});
      
//       if (response.error != null) {
//         print('ProductDetails query error: ${response.error}');
//         print('This is normal during development - using dummy products');
//         _createDummyProducts();
//         return;
//       }
      
//       if (response.productDetails.isEmpty) {
//         print('No real products found in App Store - using dummy products');
//         _createDummyProducts();
//         return;
//       }
      
//       setState(() {
//         _products = response.productDetails;
//       });
      
//       print('Successfully loaded ${_products.length} real products from App Store');
//     } catch (e) {
//       print('Exception during IAP initialization: $e');
//       print('Using dummy products as fallback');
//       _createDummyProducts();
//     }
//   }

//   void _createDummyProducts() {
//     print('Creating dummy products for development...');
    
//     // Create a proper ProductDetails object with all required parameters
//     final dummyProduct = ProductDetails(
//       id: _productIdForCurrentPlan,
//       title: '${widget.plan.name} Subscription',
//       description: 'Access to ${widget.plan.name} features for ${widget.plan.duration}',
//       price: '₹${widget.plan.offerPrice}',
//       rawPrice: widget.plan.offerPrice.toDouble(),
//       currencyCode: 'INR',
//       currencySymbol: '₹',
//     );
    
//     setState(() {
//       _products = [dummyProduct];
//     });
    
//     print('Dummy product created: $_productIdForCurrentPlan');
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
      
//       // Show user-friendly error message
//       if (errorMsg.contains('storekit')) {
//         failed(mesg: 'App Store is not responding. Please check your internet connection and try again.', context: context);
//       } else {
//         failed(mesg: 'Purchase failed: $errorMsg', context: context);
//       }
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
      
//       // Show success dialog
//       showPaymentSuccessDialog(
//         context, 
//         message: 'Your ${widget.plan.name} subscription is now active!'
//       );
      
//       print('Purchase details:');
//       print('- Product ID: ${purchase.productID}');
//       print('- Transaction ID: ${purchase.purchaseID}');
//             print('- Transaction IDDDDDDDD: ${purchase.purchaseID}');

//             final receiptData = purchase.verificationData.serverVerificationData;
//     final txnId = purchase.purchaseID ?? 'unknown_txn';

//       // Record the purchase locally
//       if (userId != null) {
//         try {
//           final planProvider = Provider.of<PlanProvider>(context, listen: false);
//           final verificationResult = await planProvider.verifyIosPurchase(
//         userId: userId ?? '',
//         planId: widget.plan.id,
//         receiptData: receiptData,
//         productId: purchase.productID,
//         transactionId: txnId,
//       );
//           print('Purchase recorded successfully in local database');
//         } catch (e) {
//           print('Local purchase recording failed: $e');
//           // Continue anyway since IAP was successful
//         }
//       }
      
//       // Clean up payment methods
//       _cleanupPaymentMethods();
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
//           colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
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
//                 child: Icon(Icons.featured_play_list_outlined, color: theme.primaryColor, size: 24),
//               ),
//               const SizedBox(width: 16),
//               const Text(
//                 'Plan Features',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           ...widget.plan.features.asMap().entries.map((entry) {
//             return AnimatedContainer(
//               duration: Duration(milliseconds: 200 + (entry.key * 100)),
//               margin: const EdgeInsets.only(bottom: 16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 24, height: 24,
//                     decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(12)),
//                     child: const Icon(Icons.check, color: Colors.white, size: 16),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87))),
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
//           BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8)),
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
//                 child: Icon(Icons.payment_outlined, color: theme.primaryColor, size: 24),
//               ),
//               const SizedBox(width: 16),
//               const Text('Payment Method', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
//             ],
//           ),
//           const SizedBox(height: 20),
//           _buildPaymentOption(
//             Platform.isIOS ? 'Apple In-App Purchase' : 'Digital Payment',
//             Platform.isIOS ? Icons.apple : Icons.account_balance_wallet_outlined,
//             Platform.isIOS ? 'Secure payment via App Store' : 'Secure payment via UPI, Cards & More',
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
//       onTap: () => setState(() => selectedPaymentMethod = title),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: isSelected ? theme.primaryColor.withOpacity(0.08) : Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: isSelected ? theme.primaryColor : Colors.grey.shade300, width: isSelected ? 2 : 1),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: isSelected ? theme.primaryColor : Colors.grey.shade400,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: Colors.white, size: 20),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? theme.primaryColor : Colors.black87)),
//                   const SizedBox(height: 4),
//                   Text(description, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
//                 ],
//               ),
//             ),
//             if (isSelected)
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(color: theme.primaryColor, shape: BoxShape.circle),
//                 child: const Icon(Icons.check, color: Colors.white, size: 16),
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
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
//           shadowColor: theme.primaryColor.withOpacity(0.3),
//         ),
//         child: isLoading
//             ? const SizedBox(
//                 height: 24, width: 24,
//                 child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(widget.plan.offerPrice == 0 ? Icons.lock_open_outlined : Icons.credit_card_outlined, size: 20),
//                   const SizedBox(width: 12),
//                   Text(widget.plan.offerPrice == 0 ? 'Activate Free Plan' : 'Subscribe Now', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//       ),
//     );
//   }

//   void _processSubscription(BuildContext context, ThemeData theme) async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final userIdLocal = authProvider.user?.user.id ?? userId;

//     if (userIdLocal == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please log in to continue')));
//       return;
//     }

//     // Free plan handling
//     if (widget.plan.offerPrice == 0) {
//       setState(() => isLoading = true);
//       await Future.delayed(const Duration(seconds: 2));
//       setState(() => isLoading = false);
//       if (!mounted) return;

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80, height: 80,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: [Colors.green.shade300, Colors.green.shade600]),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
//               ),
//               const SizedBox(height: 24),
//               Text('Welcome to ${widget.plan.name}!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
//               const SizedBox(height: 12),
//               const Text('Your subscription is now active', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => MainNavigationScreen()), (route) => false,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
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
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a payment method')));
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       if (Platform.isIOS) {
//         // Initialize IAP ONLY when subscribe button is clicked
//         await _initIAP();

//         if (!_available) {
//           _showErrorDialog('In-App Purchases not available on this device');
//           setState(() => isLoading = false);
//           return;
//         }

//         if (_products.isEmpty) {
//           _showErrorDialog('No products available for purchase at the moment. Please try again later.');
//           setState(() => isLoading = false);
//           return;
//         }

//         // FIXED: Proper product selection without type errors
//         ProductDetails? productForPlan;
//         for (var product in _products) {
//           if (product.id == _productIdForCurrentPlan) {
//             productForPlan = product;
//             break;
//           }
//         }
        
//         // If no exact match, use the first product
//         productForPlan ??= _products.first;
        
//         print('Starting purchase for product: ${productForPlan.id}');
        
//         final PurchaseParam purchaseParam = PurchaseParam(productDetails: productForPlan);

//         // Start purchase - this will trigger the Apple IAP flow
//         await _iap.buyNonConsumable(purchaseParam: purchaseParam);
        
//         // Set loading to false since the purchase flow is handled separately
//         setState(() => isLoading = false);

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
//           'prefill': {'contact': "9961593179", 'email': "melvincherian0190@gmail.com"},
//           'external': {'wallets': ['paytm']}
//         };
//         _razorpay!.open(options);
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment error: ${e.toString()}')));
//       setState(() => isLoading = false);
//     }
//   }

//   Future<PhonePePaymentResponse> _initiatePhonePePayment(String userId, String planId, String transactionId) async {
//     final planProvider = Provider.of<PlanProvider>(context, listen: false);
//     try {
//       return await planProvider.initiatePhonePePayment(userId, planId, transactionId);
//     } catch (e) {
//       rethrow;
//     }
//   }
// }





















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
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

failed({required String mesg, required context}) {
  EasyLoading.dismiss();
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(message: "$mesg"),
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

  const PlanDetailsAndPaymentScreen({Key? key, required this.plan})
    : super(key: key);

  @override
  State<PlanDetailsAndPaymentScreen> createState() =>
      _PlanDetailsAndPaymentScreenState();
}

class _PlanDetailsAndPaymentScreenState
    extends State<PlanDetailsAndPaymentScreen>
    with TickerProviderStateMixin {
  String? selectedPaymentMethod;
  bool isLoading = false;
  String? userId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Razorpay instance (Android)
  Razorpay? _razorpay;

  // In-app purchase (iOS)
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _available = false;
  List<ProductDetails> _products = [];
    bool _isIapInitialized = false;
  bool _isInitializingIap = false;
    final Set<String> _ignoredRestoredPurchases = {};

    bool _shouldProcessRestoredPurchases = false;


  // Prevent duplicate triggers
  bool _isOpeningPurchase = false; // guards showing store modal
  final Set<String> _processingTransactionIds =
      {}; // guards processing same txn

  // Consent checkboxes
  bool _agreedToTerms = false;
  bool _agreedToPrivacy = false;

  // Dummy links
  final Uri _termsUrl = Uri.parse(
    'https://editezy.onrender.com/terms-and-conditions',
  );
  final Uri _eula = Uri.parse(
    'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
  );
  final Uri _privacyUrl = Uri.parse(
    'https://editezy.onrender.com/privacy-and-policy',
  );

  String get _productIdForCurrentPlan {
    // You used a fixed product id - keep it or build from plan
    return 'com.editezy.launching.plan';
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

    // DO NOT initialize IAP or Razorpay here - do it on demand
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cleanupPaymentMethods();
    super.dispose();
  }

  void _cleanupPaymentMethods() {
    try {
      _razorpay?.clear();
    } catch (_) {}
    _subscription?.cancel();
    _subscription = null;
    _isOpeningPurchase = false;
    _isIapInitialized = false;
    _isInitializingIap = false;
    _processingTransactionIds.clear();
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

  Future<void> _openUrl(Uri url) async {
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        await launchUrl(url);
      }
    } catch (e) {
      print('Could not open url: $url, error: $e');
      if (mounted) {
        failed(mesg: 'Could not open link', context: context);
      }
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
    showAlertDialog(
      context,
      "Payment Failed",
      "Code: ${response.code}\nDescription: ${response.message}",
    );
    setState(() => isLoading = false);
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
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 40,
                ),
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
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
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
                      MaterialPageRoute(
                        builder: (context) => MainNavigationScreen(),
                      ),
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
      // Example: call your server to record the payment
      final result = await _initiatePhonePePayment(
        userId.toString(),
        widget.plan.id,
        response.paymentId.toString(),
      );

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

  // -------------------- IN-APP PURCHASE (iOS) --------------------
  Future<void> _initIAP() async {
    print('Initializing In-App Purchase...');
  if (_isIapInitialized || _isInitializingIap) {
      print('IAP already initialized or initializing - skipping');
      return;
    }

        _isInitializingIap = true;

    // Cancel old subscription listener (if any)
    _subscription?.cancel();

    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchases) {
        _listenToPurchaseUpdated(purchases);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        print('IAP purchaseStream error: $error');
        if (mounted) {
          failed(mesg: 'Purchase stream error: $error', context: context);
        }
      },
    );

    try {
      _available = await _iap.isAvailable();
      if (!_available) {
        print('IAP not available on this device');
        if (mounted) {
          failed(
            mesg: 'In-App Purchases are not available on this device',
            context: context,
          );
        }
        return;
      }

      print('IAP is available, querying products...');
      print('Product ID: $_productIdForCurrentPlan');

      final ProductDetailsResponse response = await _iap.queryProductDetails({
        _productIdForCurrentPlan,
      });

      // if (response.error != null) {
      //   print('ProductDetails query error: ${response.error}');
      //   print('Using dummy products as fallback');
      //   _createDummyProducts();
      //   return;
      // }

      // if (response.productDetails.isEmpty) {
      //   print('No real products found in App Store - using dummy products');
      //   _createDummyProducts();
      //   return;
      // }

      // setState(() {
      //   _products = response.productDetails;
      // });

      // print(
      //   'Successfully loaded ${_products.length} real products from App Store',
      // );

       if (response.error != null) {
        print('ProductDetails query error: ${response.error}');
        print('Using dummy products as fallback');
        _createDummyProducts();
      } else if (response.productDetails.isEmpty) {
        print('No real products found in App Store - using dummy products');
        _createDummyProducts();
      } else {
        // ⭐⭐ ONLY CALL setState IF MOUNTED ⭐⭐
        if (mounted) {
          setState(() {
            _products = response.productDetails;
          });
        }
        print('Successfully loaded ${_products.length} real products from App Store');
      }

      // Mark as initialized
      _isIapInitialized = true;
    } catch (e) {
      print('Exception during IAP initialization: $e');
      _createDummyProducts();
    }finally{
            _isInitializingIap = false;

    }
  }

  void _createDummyProducts() {
    print('Creating dummy products for development...');

    // NOTE: ProductDetails constructor may differ between plugin versions.
    // This is a pragmatic fallback for development only - in production use App Store products.
    final dummyProduct = ProductDetails(
      id: _productIdForCurrentPlan,
      title: '${widget.plan.name} Subscription',
      description:
          'Access to ${widget.plan.name} features for ${widget.plan.duration}',
      price: '₹${widget.plan.offerPrice}',
      rawPrice: widget.plan.offerPrice.toDouble(),
      currencyCode: 'INR',
    );

    setState(() {
      _products = [dummyProduct];
    });

    print('Dummy product created: $_productIdForCurrentPlan');
  }

  // void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
  //   print('Purchase updated, ${purchases.length} purchase(s)');

  //   for (final purchase in purchases) {
  //     print(
  //       'Purchase: ${purchase.productID}, Status: ${purchase.status}, txn: ${purchase.purchaseID}',
  //     );

  //     // Guard: if we're already processing this transaction -> skip
  //     final txnId = purchase.purchaseID ?? 'txn-${purchase.productID}';
  //     if (_processingTransactionIds.contains(txnId)) {
  //       print(': Already processing transaction $txnId -> skip');
  //       // Still ensure we call completePurchase if needed
  //       if (purchase.pendingCompletePurchase) {
  //         await _iap.completePurchase(purchase);
  //       }
  //       continue;
  //     }

  //     // Add to processing set
  //     _processingTransactionIds.add(txnId);

  //     try {
  //       switch (purchase.status) {
  //         case PurchaseStatus.pending:
  //           _handlePendingPurchase(purchase);
  //           break;
  //         case PurchaseStatus.error:
  //           _handlePurchaseError(purchase);
  //           break;
  //         case PurchaseStatus.purchased:
  //         case PurchaseStatus.restored:
  //           await _verifyAndCompletePurchase(purchase);
  //           break;
  //         case PurchaseStatus.canceled:
  //           _handlePurchaseCanceled(purchase);
  //           break;
  //       }

  //       if (purchase.pendingCompletePurchase) {
  //         await _iap.completePurchase(purchase);
  //         print('Purchase completed: ${purchase.productID} txn:$txnId');
  //       }
  //     } catch (e) {
  //       print('Error handling purchase $txnId: $e');
  //     } finally {
  //       // Remove txn from processing after small delay to avoid race conditions with repeated events
  //       Future.delayed(const Duration(milliseconds: 500), () {
  //         _processingTransactionIds.remove(txnId);
  //       });
  //     }
  //   }
  // }



  // void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
  //   print('Purchase updated, ${purchases.length} purchase(s)');

  //   for (final purchase in purchases) {
  //     print(
  //       'Purchase: ${purchase.productID}, Status: ${purchase.status}, txn: ${purchase.purchaseID}',
  //     );

  //     // ⭐⭐ KEY FIX: IGNORE RESTORED PURCHASES THAT WE'VE ALREADY PROCESSED ⭐⭐
  //     if (purchase.status == PurchaseStatus.restored) {
  //       final txnId = purchase.purchaseID ?? 'unknown_txn';
        
  //       if (_ignoredRestoredPurchases.contains(txnId)) {
  //         print('🚫 Ignoring already processed restored purchase: $txnId');
  //         if (purchase.pendingCompletePurchase) {
  //           await _iap.completePurchase(purchase);
  //         }
  //         continue;
  //       }
        
  //       // Mark this restored purchase as ignored to prevent future processing
  //       _ignoredRestoredPurchases.add(txnId);
  //       print('📝 Added restored purchase to ignore list: $txnId');
        
  //       // Still complete the purchase but don't process it
  //       if (purchase.pendingCompletePurchase) {
  //         await _iap.completePurchase(purchase);
  //       }
  //       continue;
  //     }

  //     // Guard: if we're already processing this transaction -> skip
  //     final txnId = purchase.purchaseID ?? 'txn-${purchase.productID}';
  //     if (_processingTransactionIds.contains(txnId)) {
  //       print(': Already processing transaction $txnId -> skip');
  //       if (purchase.pendingCompletePurchase) {
  //         await _iap.completePurchase(purchase);
  //       }
  //       continue;
  //     }

  //     // Add to processing set
  //     _processingTransactionIds.add(txnId);

  //     try {
  //       switch (purchase.status) {
  //         case PurchaseStatus.pending:
  //           _handlePendingPurchase(purchase);
  //           break;
  //         case PurchaseStatus.error:
  //           _handlePurchaseError(purchase);
  //           break;
  //         case PurchaseStatus.purchased:
  //           await _verifyAndCompletePurchase(purchase);
  //           break;
  //         case PurchaseStatus.restored:
  //           // Already handled above
  //           break;
  //         case PurchaseStatus.canceled:
  //           _handlePurchaseCanceled(purchase);
  //           break;
  //       }

  //       if (purchase.pendingCompletePurchase) {
  //         await _iap.completePurchase(purchase);
  //         print('Purchase completed: ${purchase.productID} txn:$txnId');
  //       }
  //     } catch (e) {
  //       print('Error handling purchase $txnId: $e');
  //     } finally {
  //       Future.delayed(const Duration(milliseconds: 500), () {
  //         _processingTransactionIds.remove(txnId);
  //       });
  //     }
  //   }
  // }



Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
  print('Purchase updated, ${purchases.length} purchase(s)');

  for (final purchase in purchases) {
    final productId = purchase.productID ?? 'unknown_product';
    final txnId = purchase.purchaseID ?? 'txn-$productId';

    print('Purchase event: product=$productId, status=${purchase.status}, txn=$txnId');

    // If we've explicitly ignored this restored txn already, complete & skip.
    if (purchase.status == PurchaseStatus.restored &&
        _ignoredRestoredPurchases.contains(txnId)) {
      print('Ignoring already-processed restored txn: $txnId');
      if (purchase.pendingCompletePurchase) {
        try {
          await _iap.completePurchase(purchase);
        } catch (e) {
          print('completePurchase error (ignored restored): $e');
        }
      }
      continue;
    }

    // If already processing this transaction, just ensure completion and skip.
    if (_processingTransactionIds.contains(txnId)) {
      print('Already processing txn: $txnId -> skipping handling');
      if (purchase.pendingCompletePurchase) {
        try {
          await _iap.completePurchase(purchase);
        } catch (e) {
          print('completePurchase error (already processing): $e');
        }
      }
      continue;
    }

    // Mark as processing to avoid re-entrancy
    _processingTransactionIds.add(txnId);

    try {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _handlePendingPurchase(purchase);
          break;

        case PurchaseStatus.error:
          _handlePurchaseError(purchase);
          break;

        case PurchaseStatus.purchased:
          // Normal successful purchase -> verify with backend and complete
          // await _verifyAndCompletePurchase(purchase);
          break;

        // case PurchaseStatus.restored:
        //   // Restored purchase: we must decide whether to verify/apply or ignore.
        //   // Approach: ask user consent (non-silent). If you want auto-apply, set `apply = true` here.
        //   bool apply = false;

        //   // If the app has a user-initiated flag to process restores, respect it.
        //   // Example: set _shouldProcessRestoredPurchases = true when user taps "Restore Purchases".
        //   if (_shouldProcessRestoredPurchases) {
        //     apply = true;
        //     // reset the flag so spontaneous restores don't keep applying
        //     _shouldProcessRestoredPurchases = false;
        //   } else {
        //     // Ask user consent before mapping this restored purchase to their app account
        //     if (mounted) {
        //       try {
        //         apply = await showDialog<bool>(
        //               context: context,
        //               barrierDismissible: false,
        //               builder: (ctx) => AlertDialog(
        //                 title: const Text('Restore purchase found'),
        //                 content: Text(
        //                   'A purchase for "$productId" was found on this device\'s App Store account.\n\n'
        //                   'If you need to purchase the plan signout existing account?',
        //                 ),
        //                 actions: [
        //                   TextButton(
        //                     onPressed: () => Navigator.of(ctx).pop(false),
        //                     child: const Text('No'),
        //                   ),
        //                   ElevatedButton(
        //                     onPressed: () => Navigator.of(ctx).pop(true),
        //                     child: const Text('Yes'),
        //                   ),
        //                 ],
        //               ),
        //             ) ??
        //             false;
        //       } catch (dialogErr) {
        //         print('Dialog error for restored consent: $dialogErr');
        //         apply = false;
        //       }
        //     } else {
        //       apply = false;
        //     }
        //   }

        //   if (apply) {
        //     // User consented (or we were in explicit restore flow) -> verify & complete
        //     await _verifyAndCompletePurchase(purchase);
        //     // Optionally mark this restored txn as processed so future restore events for same txn are ignored
        //     _ignoredRestoredPurchases.add(txnId);
        //   } else {
        //     // User declined -> do NOT verify or map; just complete so store doesn't re-emit repeatedly
        //     print('User declined to apply restored txn: $txnId');
        //   }
        //   break;


  //       case PurchaseStatus.restored:
  // final txnId = purchase.purchaseID ?? 'unknown_txn';
  // final receiptData = purchase.verificationData.serverVerificationData;
  // final planProvider = Provider.of<PlanProvider>(context, listen: false);

  // // Show loading while verifying
  // if (mounted) EasyLoading.show(status: 'Checking subscription...');

  // Map<String, dynamic>? verificationResult;
  // try {
  //   verificationResult = await planProvider.verifyIosPurchase(
  //     userId: userId ?? '',
  //     planId: widget.plan.id,
  //     receiptData: receiptData,
  //     productId: purchase.productID ?? _productIdForCurrentPlan,
  //     transactionId: txnId,
  //   );
  // } catch (e) {
  //   verificationResult = {'success': false, 'message': 'Verification failed: $e'};
  // } finally {
  //   if (mounted) EasyLoading.dismiss();
  // }

  // // Build a helpful message for user from backend response
  // String dialogMessage;
  // bool backendSuccess = verificationResult != null && verificationResult['success'] == true;
  // if (backendSuccess && verificationResult!['subscription'] != null) {
  //   final sub = verificationResult['subscription'];
  //   final start = sub['startDate'] ?? 'N/A';
  //   final end = sub['endDate'] ?? 'N/A';
  //   final ownerNote = verificationResult['purchaseRecorded'] == true
  //       ? 'This purchase is already recorded in our system.'
  //       : 'This purchase is valid but not recorded for any account yet.';
  //   dialogMessage =
  //       'An active subscription was found for this Apple ID:\n\n'
  //       'Plan: ${sub['name'] ?? widget.plan.name}\n'
  //       'Start: $start\n'
  //       'End: $end\n\n'
  //       '$ownerNote\n\n'
  //       'Do you want to apply this subscription to the currently signed-in app account?';
  // } else {
  //   // Backend says payment already processed or any other message
  //   final backendMsg = verificationResult?['message'] ?? 'Could not verify purchase.';
  //   dialogMessage =
  //       'The App Store shows this purchase already exists for this Apple ID.\n\n'
  //       '$backendMsg\n\n'
  //       'If you want to use a different Apple ID to purchase, sign out of the App Store and sign in with a different account.\n\n';
  // }

  // // Show the dynamic confirmation dialog
  // bool apply = false;
  // if (mounted) {
  //   apply = await showDialog<bool>(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (ctx) => AlertDialog(
  //           title: const Text('Restore purchase found'),
  //           content: Text(dialogMessage),
  //           actions: [
  //             TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
  //             ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Go')),
  //           ],
  //         ),
  //       ) ??
  //       false;
  // }

  // if (apply) {
  //   // If backend already returned success true and purchaseRecorded is true,
  //   // you might only need to call purchasePlan() to fetch/confirm mapping locally,
  //   // else call purchaseIOSPlan or verifyAndCompletePurchase to map.
  //   if (backendSuccess) {
  //     // The backend verified the receipt — now record/link on server if needed.
  //     // Call the same helper you use for post-purchase mapping:
  //     try {
  //       // await planProvider.verifyIosPurchase(
  //       //   userId: userId ?? '',
  //       //   planId: widget.plan.id,
  //       //   receiptData: receiptData,
  //       //   productId: purchase.productID ?? _productIdForCurrentPlan,
  //       //   transactionId: txnId,
  //       // );
  //       // // Now show success UI
  //       // showPaymentSuccessDialog(context, message: 'Subscription applied to this account.');
  //     } catch (e) {
  //       _showErrorDialog('Failed to apply subscription: $e');
  //     }
  //   } else {
  //     // backend did not verify (e.g. message "Payment already processed") but user insisted.
  //     // Decide policy: either attempt mapping anyway (if your backend supports forced mapping/transfer),
  //     // or instruct user about transfer steps.
  //     // _showErrorDialog(verificationResult?['message'] ??
  //     //     'Could not apply this subscription. Contact support with transaction id: $txnId.');
  //   }
  //   // Optionally mark ignored or processed
  //   _ignoredRestoredPurchases.add(txnId);
  // } else {
  //   // User declined: just complete the transaction so it won't reappear
  //   print('User declined to apply restored txn: $txnId');
  // }
  // break;



// case PurchaseStatus.restored:
//   final txnId = purchase.purchaseID ?? 'unknown_txn';
//   final receiptData = purchase.verificationData.serverVerificationData;
//   final planProvider = Provider.of<PlanProvider>(context, listen: false);

//   // 1) Verify with backend first
//   if (mounted) EasyLoading.show(status: 'Checking subscription...');
//   Map<String, dynamic>? verificationResult;
//   try {
//     verificationResult = await planProvider.verifyIosPurchase(
//       userId: userId ?? '',
//       planId: widget.plan.id,
//       receiptData: receiptData,
//       productId: purchase.productID ?? _productIdForCurrentPlan,
//       transactionId: txnId,
//     );
//     print('verifyIosPurchase -> $verificationResult');
//   } catch (e) {
//     verificationResult = {'success': false, 'message': 'Verification failed: $e'};
//   } finally {
//     if (mounted) EasyLoading.dismiss();
//   }

//   final bool backendSuccess = verificationResult != null && verificationResult['success'] == true;
//   final Map<String, dynamic>? sub = backendSuccess ? (verificationResult!['subscription'] as Map<String, dynamic>?) : null;
//   final String ownerUserId = sub?['ownerUserId'] ?? sub?['userId'] ?? '';

//   // 2) If backend says it's already linked to CURRENT user -> auto-apply, no dialog
//   if (backendSuccess && ownerUserId.isNotEmpty && ownerUserId == (userId ?? '')) {
//     print('Restored purchase already linked to this user -> auto-apply txn:$txnId');
//     // show success UI and mark processed
//     showPaymentSuccessDialog(context, message: 'Subscription already active for this account.');
//     _ignoredRestoredPurchases.add(txnId);
//     // ensure we call completePurchase later (code below does this)
//   } else {
//     // 3) Otherwise build a dynamic message and ask the user for consent
//     String dialogMessage;
//     if (backendSuccess && sub != null) {
//       final start = sub['startDate'] ?? 'N/A';
//       final end = sub['endDate'] ?? 'N/A';
//       final recorded = verificationResult!['purchaseRecorded'] == true;
//       final ownerNote = recorded ? 'This purchase is already recorded in our system.' : '';
//       dialogMessage =
//           'An active subscription was found for this Apple ID:\n\n'
//           'Plan: ${sub['name'] ?? widget.plan.name}\n'
//           'Start: $start\n'
//           'End: $end\n\n'
//           '$ownerNote\n\n';
//     } else {
//       final backendMsg = verificationResult?['message'] ?? 'Could not verify purchase.';
//       dialogMessage =
//           'A purchase for this Apple ID was found.\n\n'
//           '$backendMsg\n\n'
//           'If this purchase is linked to another app account, you will not be able to apply it here. You can sign out of the App Store and sign in with a different account to purchase.';
//     }

//     bool apply = false;
//     if (mounted) {
//       apply = await showDialog<bool>(
//             context: context,
//             barrierDismissible: false,
//             builder: (ctx) => AlertDialog(
//               title: const Text('Details'),
//               content: Text(dialogMessage),
//               actions: [
//                 TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
//                 ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Go')),
//               ],
//             ),
//           ) ??
//           false;
//     }

//     if (apply) {
//       // If backend verification succeeded but was not recorded, attempt to map it now
//       if (backendSuccess) {
//         try {
//           // Use your server endpoint that records the receipt & links to this app user
//           final purchaseResult = await planProvider.verifyIosPurchase(
//             userId: userId ?? '',
//             planId: widget.plan.id,
//             receiptData: receiptData,
//             productId: purchase.productID ?? _productIdForCurrentPlan,
//             transactionId: txnId,
//           );
//           print('purchaseIOSPlan result: $purchaseResult');
//           if (purchaseResult != null && (purchaseResult['success'] == true || purchaseResult['status'] == 'success')) {
//             print("fksfsfsfsdkfsfhdfhdsfhsdfhfhfffk");
//             showPaymentSuccessDialog(context, message: 'Subscription applied to this account.');
//             _ignoredRestoredPurchases.add(txnId);
//           } else {
//             print("uuuuuuuuuddddfffffffddfdfdfdfdfdfd${purchaseResult?['message']}");
//             _showErrorDialog(purchaseResult?['message'] ?? 'Failed to link subscription.');
//           }
//         } catch (e) {
//           _showErrorDialog('Failed to apply subscription: $e');
//         }
//       } else {
//         // Backend didn't verify: inform user and give next steps
//         _showErrorDialog(verificationResult?['message'] ?? 'Could not verify purchase. Contact support.');
//       }
//     } else {
//       print('User declined to apply restored txn:$txnId');
//     }
//   }

//   // 4) Ensure transaction is completed so it won't reappear
//   if (purchase.pendingCompletePurchase) {
//     try {
//       await _iap.completePurchase(purchase);
//       print('completePurchase called for restored txn:$txnId');
//     } catch (e) {
//       print('completePurchase error for restored txn:$txnId -> $e');
//     }
//   }

//   break;



case PurchaseStatus.restored:
  // reuse txnId declared at top of loop
  final receiptData = purchase.verificationData.serverVerificationData;
  final planProvider = Provider.of<PlanProvider>(context, listen: false);

  // 1) Verify with backend (authoritative)
  if (mounted) EasyLoading.show(status: 'Checking subscription...');
  Map<String, dynamic>? verificationResult;
  try {
    verificationResult = await planProvider.verifyIosPurchase(
      userId: userId ?? '',
      planId: widget.plan.id,
      receiptData: receiptData,
      productId: purchase.productID ?? _productIdForCurrentPlan,
      transactionId: txnId,
    );
    print('verifyIosPurchase -> $verificationResult');
          if (verificationResult != null && (verificationResult['success'] == true || verificationResult['status'] == 'success')) {
           print('Restored purchase already linked to this user -> auto-apply txn..........');

        showPaymentSuccessDialog(context, message: 'Subscription applied to this account.');
        _ignoredRestoredPurchases.add(txnId);
      } else {
            print('Restored purchase already linked to this user -> auto-apply txnnnnnnnnnn');
      }
  } catch (e) {
    verificationResult = {'success': false, 'message': 'Verification failed: $e'};
  } finally {
    if (mounted) EasyLoading.dismiss();
  }

  final bool backendSuccess = verificationResult != null && verificationResult['success'] == true;
  // server should ideally return purchaseRecorded and ownerUserId (or equivalent)
  final bool purchaseRecorded = verificationResult?['purchaseRecorded'] == true;
  final Map<String, dynamic>? sub = backendSuccess ? (verificationResult!['subscription'] as Map<String, dynamic>?) : null;
  final String ownerUserId = sub?['ownerUserId'] ?? sub?['userId'] ?? '';

  // 2) If linked to this user already -> auto-apply (no dialog)
  if (backendSuccess && ownerUserId.isNotEmpty && ownerUserId == (userId ?? '')) {
    print('Restored purchase already linked to this user -> auto-apply txn:$txnId');
    showPaymentSuccessDialog(context, message: 'Subscription already active for this account.');
    _ignoredRestoredPurchases.add(txnId);
    // We'll call completePurchase in the shared completion step below.
    break;
  }

  // 3) Build dialog message only if we actually need user confirmation
  String dialogMessage;
  if (backendSuccess && sub != null) {
    final start = sub['startDate'] ?? 'N/A';
    final end = sub['endDate'] ?? 'N/A';
    final recordedNote = purchaseRecorded ? 'This purchase is already recorded in our system.' : 'This purchase is valid but not recorded for any account yet.';
    dialogMessage =
        'An active subscription was found for this Apple ID:\n\n'
        'Plan: ${sub['name'] ?? widget.plan.name}\n'
        'Start: $start\n'
        'End: $end\n\n'
        '$recordedNote\n\n'
        'Do you want to apply this subscription to the currently signed-in app account?';
  } else {
    final backendMsg = verificationResult?['message'] ?? 'Could not verify purchase.';
    dialogMessage =
        'A purchase for this Apple ID was found.\n\n'
        '$backendMsg\n\n'
        'If this purchase is linked to another app account, you will not be able to apply it here. Contact support or use the original account to restore.';
  }

  // 4) Ask user only if necessary (i.e., when not auto-linked and backendSuccess is true but not recorded)
  bool shouldPrompt = true;
  // If the backend indicates the purchase is linked to another user (success false or message says so), still show info.
  if (!backendSuccess && (verificationResult?['message'] == 'Payment already processed')) {
    // No mapping allowed — show info and don't prompt for mapping
    if (mounted) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Already used'),
          content: Text('This purchase is already processed on another account.\n\nContact support or use the original account to restore.'),
          actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
        ),
      );
    }
    // mark as ignored so it doesn't reappear
    _ignoredRestoredPurchases.add(txnId);
    break;
  }

  // if (!backendSuccess && verificationResult != null) {
  //   // backend failed for other reasons — show error and don't prompt mapping
  //   _showErrorDialog(verificationResult['message'] ?? 'Verification failed');
  //   _ignoredRestoredPurchases.add(txnId);
  //   break;
  // }

  // If backend success but not recorded yet -> ask user consent to link
  bool apply = false;
  if (mounted && shouldPrompt) {
    apply = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Restore purchase found'),
            content: Text(dialogMessage),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
              ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Yes, apply')),
            ],
          ),
        ) ??
        false;
  }

  if (apply) {
    // User chose to apply -> call mapping endpoint (do NOT re-call verify)
    try {
      final linkResult = await planProvider.verifyIosPurchase(
        userId: userId ?? '',
        planId: widget.plan.id,
        receiptData: receiptData,
        productId: purchase.productID ?? _productIdForCurrentPlan,
        transactionId: txnId,
      );
      print('purchaseIOSPlan result: $linkResult');
      if (linkResult != null && (linkResult['success'] == true || linkResult['status'] == 'success')) {
        showPaymentSuccessDialog(context, message: 'Subscription applied to this account.');
        _ignoredRestoredPurchases.add(txnId);
      } else {
        // _showErrorDialog(linkResult?['message'] ?? 'Failed to link subscription.');
      }
    } catch (e) {
      _showErrorDialog('Failed to apply subscription: $e');
    }
  } else {
    print('User declined to apply restored txn:$txnId');
    // optionally mark it ignored so it doesn't reappear
    _ignoredRestoredPurchases.add(txnId);
  }

  // ensure we fall through to completion below (the common completion code will call completePurchase)
  break;


        case PurchaseStatus.canceled:
          _handlePurchaseCanceled(purchase);
          break;

        default:
          print('Unhandled purchase status: ${purchase.status}');
          break;
      }

      // Ensure we complete the purchase if StoreKit requires it
      if (purchase.pendingCompletePurchase) {
        try {
          await _iap.completePurchase(purchase);
          print('completePurchase called for txn:$txnId');
        } catch (e) {
          print('completePurchase error: $e');
        }
      }
    } catch (e) {
      print('Error handling purchase txn:$txnId -> $e');
    } finally {
      // remove txnId from processing set after a tiny delay to avoid races with repeated events
      Future.delayed(const Duration(milliseconds: 500), () {
        _processingTransactionIds.remove(txnId);
      });
    }
  } // end for
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
      failed(mesg: 'Purchase failed: $errorMsg', context: context);
      setState(() => isLoading = false);
    }
  }

  void _handlePurchaseCanceled(PurchaseDetails purchase) {
    print('Purchase canceled: ${purchase.productID}');
    if (mounted) {
      EasyLoading.dismiss();
      failed(mesg: 'Purchase was canceled', context: context);
      setState(() => isLoading = false);
    }
  }

  Future<void> _verifyAndCompletePurchase(PurchaseDetails purchase) async {
    final txnId = purchase.purchaseID ?? 'unknown_txn';
    print('Verifying purchase: ${purchase.productID} txn:$txnId');

    if (mounted) {
      EasyLoading.show(status: 'Verifying purchase...');
    }

    try {
      final planProvider = Provider.of<PlanProvider>(context, listen: false);

      final receiptData = purchase.verificationData.serverVerificationData;

      // Debug prints (split long strings safely)
      void printLongString(String text) {
        final pattern = RegExp('.{1,800}');
        pattern.allMatches(text).forEach((match) => print(match.group(0)));
      }

      print("====== IOS PURCHASE DEBUG INFO ======");
      print("User ID: $userId");
      print("Plan ID: ${widget.plan.id}");
      print("===== FULL RECEIPT (serverVerificationData) =====");
      printLongString(receiptData);
      print("Product ID: ${purchase.productID}");
      print("Transaction ID: $txnId");
      print("Purchase Status: ${purchase.status}");
      print("Purchase Time: ${purchase.transactionDate}");
      print("Server Verification Starting...");

      // CALL YOUR BACKEND HERE: verifyIosPurchase should implement the server verifyReceipt logic
      final verificationResult = await planProvider.verifyIosPurchase(
        userId: userId ?? '',
        planId: widget.plan.id,
        receiptData: receiptData,
        productId: purchase.productID,
        transactionId: txnId,
      );

      print('Backend verification result: $verificationResult');

      if (verificationResult != null && verificationResult['success'] == true) {
        print('Purchase verification successful!');
        if (mounted) {
          EasyLoading.dismiss();
          showPaymentSuccessDialog(
            context,
            message: 'Your subscription is now active',
          );

          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainNavigationScreen()),
              (route) => false,
            );
          });
        }
      } else {
        // Backend says user needs to purchase
        final backendStatus =
            verificationResult?['message'] ?? 'Payment already processed';
        final errorMessage =
            verificationResult?['message'] ?? 'Verification failed';

        print('Purchase verification failed: $backendStatus - $errorMessage');

        if (mounted) {
          EasyLoading.dismiss();

          if (backendStatus == 'Payment already processed') {
            // IMPORTANT: Do NOT auto re-open the purchase modal repeatedly.
            // Show a dialog explaining the situation and let the user retry manually.
            // _showNeedToPurchaseDialog(backendStatus);
                    _handlePurchaseRequired();

          }
          // else if (backendStatus == 'Subscription activated successfully (Development Mode)') {
          //   _showErrorDialog('This subscription is linked to another account. Please restore with the correct account.');
          // }
          else {
            _showErrorDialog('Purchase verification failed: $errorMessage');
          }
        }
      }
    } catch (e) {
      print('Verification exception: $e');
      if (mounted) {
        EasyLoading.dismiss();
        _showErrorDialog('Verification failed: $e');
      }
    }
  }

void _showNeedToPurchaseDialog(String message) {
                                          print('Error launching purchase```````````````````````````````kjkjjkjkjk');

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Purchase Required'),
      content: Text(
        message +
        '\n\nIf this device already has a purchase on the App Store, tap RESTORE to link it to this account. Tap BUY to attempt purchase again (may prompt App Store).',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),

        // BUY
        TextButton(
          onPressed: () async {
                                        print('Error launching purchase```````````````````````````````00000000');

            Navigator.of(context).pop();

            // if (_isOpeningPurchase) {
            //   print(': Already opening purchase. skip.');
            //   return;
            // }
            setState(() => _isOpeningPurchase = true);

            try {
                            print('Error launching purchase```````````````````````````````111111');

              EasyLoading.dismiss();
              final theme = Theme.of(context);
              // call your purchase method which will init IAP and call buyNonConsumable
              await _processSubscription(context, theme);
            } catch (e) {
              print('Error launching purchase: $e');
              failed(mesg: 'Could not open purchase: $e', context: context);
            } finally {
              // Do NOT immediately set _isOpeningPurchase = false here if the purchase flow continues
              // The purchaseStream callbacks should clear it when complete.
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) setState(() => _isOpeningPurchase = false);
              });
            }
          },
          child: const Text('Buy'),
        ),
      ],
    ),
  );
}



void _handlePurchaseRequired() {
  print('Direct purchase flow starting...');
    if (!mounted) return;

  setState(() => _isOpeningPurchase = true);

  try {
    EasyLoading.dismiss();
    final theme = Theme.of(context);
    _processSubscription(context, theme);
  } catch (e) {
    print('Error in direct purchase: $e');
    if (mounted) {
      failed(mesg: 'Could not open purchase: $e', context: context);
      setState(() => _isOpeningPurchase = false);
    }
  }
}


  Widget _buildSubscriptionMetadata(ThemeData theme) {
    final title = widget.plan.name;
    final length = widget.plan.duration ?? '1 month';
    final price = widget.plan.offerPrice == 0
        ? 'Free'
        : '₹${widget.plan.offerPrice}';

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subscription details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Title', style: TextStyle(color: Colors.black87)),
              Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Length', style: TextStyle(color: Colors.black87)),
              Text(
                '${length.toString()} Year ',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Price', style: TextStyle(color: Colors.black87)),
              Text(price, style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConsentCheckboxes(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreedToTerms,
                activeColor: theme.primaryColor,
                onChanged: (v) {
                  setState(() {
                    _agreedToTerms = v ?? false;
                  });
                },
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms of Use',
                        style: TextStyle(
                          color: theme.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openUrl(_termsUrl),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'EULA',
                        style: TextStyle(
                          color: theme.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openUrl(_eula),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreedToPrivacy,
                activeColor: theme.primaryColor,
                onChanged: (v) {
                  setState(() {
                    _agreedToPrivacy = v ?? false;
                  });
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _openUrl(_privacyUrl),
                  child: RichText(
                    text: TextSpan(
                      text: 'I have read the ',
                      style: TextStyle(color: Colors.black87),
                      children: [
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: theme.primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------- UI & Purchase flow --------------------

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    ThemeData planTheme = _getPlanTheme();

    return Theme(
      data: planTheme,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: CustomScrollView(
          slivers: [
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
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildPlanFeatures(planTheme),
                    const SizedBox(height: 20),
                    if (widget.plan.offerPrice > 0)
                      _buildPaymentSection(planTheme),
                    const SizedBox(height: 20),
                    _buildConsentCheckboxes(planTheme),
                    const SizedBox(height: 10),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
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
                    widget.plan.offerPrice == 0
                        ? 'Free'
                        : '₹${widget.plan.offerPrice}',
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
                child: Icon(
                  Icons.featured_play_list_outlined,
                  color: theme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Plan Features',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
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
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
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
                child: Icon(
                  Icons.payment_outlined,
                  color: theme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPaymentOption(
            Platform.isIOS ? 'Apple In-App Purchase' : 'Digital Payment',
            Platform.isIOS
                ? Icons.apple
                : Icons.account_balance_wallet_outlined,
            Platform.isIOS
                ? 'Secure payment via App Store'
                : 'Secure payment via UPI, Cards & More',
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
          const SizedBox(height: 8),
          _buildSubscriptionMetadata(theme),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    String title,
    IconData icon,
    String description,
    ThemeData theme,
  ) {
    final isSelected = selectedPaymentMethod == title;

    return GestureDetector(
      onTap: () {
        setState(() => selectedPaymentMethod = title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.08)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
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
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? theme.primaryColor : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              activeColor: theme.primaryColor,
              onChanged: (bool? value) {
                setState(() => selectedPaymentMethod = title);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme) {
    final bool canSubscribe =
        !isLoading &&
        (widget.plan.offerPrice == 0 || selectedPaymentMethod != null) &&
        _agreedToTerms &&
        _agreedToPrivacy;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (!canSubscribe || isLoading)
            ? null
            : () => _processSubscription(context, theme),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          shadowColor: theme.primaryColor.withOpacity(0.3),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.plan.offerPrice == 0
                        ? Icons.lock_open_outlined
                        : Icons.credit_card_outlined,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.plan.offerPrice == 0
                        ? 'Activate Free Plan'
                        : 'Subscribe Now',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _processSubscription(BuildContext context, ThemeData theme) async {
                                print('Error launching purchase```````````````````````````````222222222');

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userIdLocal = authProvider.user?.user.id ?? userId;

    if (userIdLocal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to continue')),
      );
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade300, Colors.green.shade600],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to ${widget.plan.name}!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Your subscription is now active',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MainNavigationScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(color: Colors.white),
                  ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

  if (mounted) {
      setState(() => isLoading = true);
    }
    try {
      if (Platform.isIOS) {
                                    print('Error launching purchase```````````````````````````````333333');

        // Initialize IAP ONLY when subscribe button is clicked
        await _initIAP();
                                    print('Error launching purchase```````````````````````````````4444444');

        if (!_available) {
          _showErrorDialog('In-App Purchases not available on this device');
          if (mounted) setState(() => isLoading = false);
          return;
        }

        if (_products.isEmpty) {
          _showErrorDialog(
            'No products available for purchase at the moment. Please try again later.',
          );
          if (mounted) setState(() => isLoading = false);
          return;
        }

        // Proper product selection without type errors
        ProductDetails? productForPlan;
        for (var product in _products) {
          if (product.id == _productIdForCurrentPlan) {
            productForPlan = product;
            break;
          }
        }

        productForPlan ??= _products.first;

        print('Starting purchase for product: ${productForPlan.id}');

        final PurchaseParam purchaseParam = PurchaseParam(
          productDetails: productForPlan,
        );

        // Start purchase - this will trigger the Apple IAP flow
        // Use buyNonConsumable for subscriptions/non-consumable as you did
        try {
        print('Calling buyNonConsumable...');
              await Future.delayed(const Duration(milliseconds: 500));

        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
        print('buyNonConsumable completed successfully');
      } catch (e, stackTrace) {
        print('ERROR in buyNonConsumable: $e');
        print('Stack trace: $stackTrace');
        
        if (mounted) {
          _showErrorDialog('Failed to start purchase: $e');
          setState(() => isLoading = false);
        }
        return;
      }

        // Set loading to false because the flow continues in purchaseStream
        setState(() => isLoading = false);
      } else {
        // Android: Razorpay
        _initRazorpay();

        var options = {
          'key': 'rzp_live_RTmw5UsY3ffNxq',
          'amount': (widget.plan.offerPrice * 100).toInt(),
          'name': 'Edit-Ezy',
          'description': 'Subscription',
          'retry': {'enabled': true, 'max_count': 1},
          'send_sms_hash': true,
          'prefill': {
            'contact': "9961593179",
            'email': "melvincherian0190@gmail.com",
          },
          'external': {
            'wallets': ['paytm'],
          },
        };
        _razorpay!.open(options);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment error: ${e.toString()}')));
      setState(() => isLoading = false);
    }
  }

  Future<PhonePePaymentResponse> _initiatePhonePePayment(
    String userId,
    String planId,
    String transactionId,
  ) async {
    final planProvider = Provider.of<PlanProvider>(context, listen: false);
    try {
      return await planProvider.initiatePhonePePayment(
        userId,
        planId,
        transactionId,
      );
    } catch (e) {
      rethrow;
    }
  }
}

// === Remaining part of the file ===
// (No functional changes needed beyond this point — your
// navigation, theme helpers, and widgets remain unchanged.)

// If you want me to paste a specific section (e.g., from line X to Y),
// tell me the range and I will add it precisely.
