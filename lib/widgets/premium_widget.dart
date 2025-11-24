// // import 'package:flutter/material.dart';
// // import 'package:posternova/helper/sub_modal_helper.dart';
// // import 'package:posternova/providers/plans/get_all_plan_provider.dart';
// // import 'package:posternova/providers/plans/my_plan_provider.dart';
// // import 'package:posternova/views/subscription/payment_success_screen.dart';
// // import 'package:provider/provider.dart';
// // import 'package:url_launcher/url_launcher.dart';

// // class SubscriptionPlansWidget extends StatelessWidget {
// //   final VoidCallback? onClose;
// //   final bool showCloseButton;

// //   const SubscriptionPlansWidget({
// //     Key? key,
// //     this.onClose,
// //     this.showCloseButton = true,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final planProvider = Provider.of<GetAllPlanProvider>(
// //       context,
// //       listen: false,
// //     );

// //     if (planProvider.plans.isEmpty && !planProvider.isLoading) {
// //       planProvider.fetchAllPlans();
// //     }

// //     return Container(
// //       width: MediaQuery.of(context).size.width,
// //       height: MediaQuery.of(context).size.height,
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //           colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
// //         ),
// //         borderRadius: BorderRadius.circular(32),
// //         boxShadow: [
// //           BoxShadow(
// //             color: const Color(0xFF6366F1).withOpacity(0.4),
// //             blurRadius: 40,
// //             offset: const Offset(0, 20),
// //           ),
// //         ],
// //       ),
// //       child: Stack(
// //         children: [
// //           // Decorative circles
// //           Positioned(
// //             top: -50,
// //             right: -50,
// //             child: Container(
// //               width: 150,
// //               height: 150,
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 color: Colors.white.withOpacity(0.1),
// //               ),
// //             ),
// //           ),
// //           Positioned(
// //             bottom: -30,
// //             left: -30,
// //             child: Container(
// //               width: 100,
// //               height: 100,
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 color: Colors.white.withOpacity(0.1),
// //               ),
// //             ),
// //           ),

// //           // Main content
// //           Column(
// //             children: [
// //               // Header with close button
// //               if (showCloseButton)
// //                 Padding(
// //                   padding: const EdgeInsets.all(16),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.end,
// //                     children: [
// //                       GestureDetector(
// //                         onTap: onClose ?? () => Navigator.pop(context),
// //                         child: Container(
// //                           padding: const EdgeInsets.all(8),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(0.2),
// //                             shape: BoxShape.circle,
// //                           ),
// //                           child: const Icon(
// //                             Icons.close,
// //                             color: Colors.white,
// //                             size: 20,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //               // Plans Container
// //               Expanded(
// //                 flex: 2,
// //                 child: Container(
// //                   margin: const EdgeInsets.symmetric(horizontal: 16),
// //                   padding: const EdgeInsets.all(16),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(24),
// //                   ),
// //                   child: Consumer<GetAllPlanProvider>(
// //                     builder: (context, provider, child) {
// //                       if (provider.isLoading) {
// //                         return const Center(
// //                           child: Column(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               CircularProgressIndicator(
// //                                 color: Color(0xFF6366F1),
// //                                 strokeWidth: 3,
// //                               ),
// //                               SizedBox(height: 16),
// //                               Text(
// //                                 'Loading premium plans...',
// //                                 style: TextStyle(
// //                                   color: Color(0xFF6B7280),
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.w500,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       }

// //                       if (provider.error != null) {
// //                         return Center(
// //                           child: Column(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               Container(
// //                                 padding: const EdgeInsets.all(16),
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.red.shade50,
// //                                   shape: BoxShape.circle,
// //                                 ),
// //                                 child: Icon(
// //                                   Icons.error_outline_rounded,
// //                                   color: Colors.red.shade400,
// //                                   size: 48,
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 16),
// //                               const Text(
// //                                 'Oops! Something went wrong',
// //                                 style: TextStyle(
// //                                   fontSize: 18,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: Color(0xFF1F2937),
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 8),
// //                               Text(
// //                                 'Unable to load plans. Please try again.',
// //                                 style: TextStyle(
// //                                   color: Colors.grey.shade600,
// //                                   fontSize: 14,
// //                                 ),
// //                                 textAlign: TextAlign.center,
// //                               ),
// //                               const SizedBox(height: 24),
// //                               ElevatedButton(
// //                                 onPressed: () => provider.fetchAllPlans(),
// //                                 style: ElevatedButton.styleFrom(
// //                                   backgroundColor: const Color(0xFF6366F1),
// //                                   foregroundColor: Colors.white,
// //                                   padding: const EdgeInsets.symmetric(
// //                                     horizontal: 32,
// //                                     vertical: 16,
// //                                   ),
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(12),
// //                                   ),
// //                                   elevation: 0,
// //                                 ),
// //                                 child: const Text(
// //                                   'Try Again',
// //                                   style: TextStyle(
// //                                     fontSize: 15,
// //                                     fontWeight: FontWeight.w600,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       }

// //                       if (provider.plans.isNotEmpty) {
// //                         return LayoutBuilder(
// //                           builder: (context, constraints) {
// //                             return Column(
// //                               children: provider.plans.asMap().entries.map((
// //                                 entry,
// //                               ) {
// //                                 final index = entry.key;
// //                                 final plan = entry.value;

// //                                 return Expanded(
// //                                   child: Container(
// //                                     margin: EdgeInsets.only(
// //                                       bottom: index < provider.plans.length - 1
// //                                           ? 12
// //                                           : 0,
// //                                     ),
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.white,
// //                                       borderRadius: BorderRadius.circular(16),
// //                                       border: Border.all(
// //                                         color: index == 0
// //                                             ? const Color(0xFF6366F1)
// //                                             : Colors.grey.shade200,
// //                                         width: index == 0 ? 2 : 1,
// //                                       ),
// //                                       boxShadow: [
// //                                         BoxShadow(
// //                                           color: Colors.black.withOpacity(0.05),
// //                                           blurRadius: 10,
// //                                           offset: const Offset(0, 5),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                     child: Material(
// //                                       color: Colors.transparent,
// //                                       child: InkWell(
// //                                         onTap: () {
// //                                           Navigator.push(
// //                                             context,
// //                                             MaterialPageRoute(
// //                                               builder: (context) =>
// //                                                   PlanDetailsAndPaymentScreen(
// //                                                 plan: plan,
// //                                               ),
// //                                             ),
// //                                           );
// //                                         },
// //                                         borderRadius: BorderRadius.circular(16),
// //                                         child: Padding(
// //                                           padding: const EdgeInsets.all(16),
// //                                           child: Column(
// //                                             crossAxisAlignment:
// //                                                 CrossAxisAlignment.start,
// //                                             mainAxisAlignment:
// //                                                 MainAxisAlignment.center,
// //                                             children: [
// //                                               // Plan name
// //                                               Text(
// //                                                 plan.name ?? 'Plan',
// //                                                 style: TextStyle(
// //                                                   fontSize: 20,
// //                                                   fontWeight: FontWeight.bold,
// //                                                   color: index == 0
// //                                                       ? const Color(0xFF6366F1)
// //                                                       : Colors.black87,
// //                                                 ),
// //                                               ),
// //                                               const SizedBox(height: 8),
// //                                               // Price
// //                                               Text(
// //                                                 '${plan.offerPrice?.toStringAsFixed(2) ?? '0.00'}/${(plan.duration ?? 'month') == 'month' ? 'mo' : 'yr'}',
// //                                                 style: TextStyle(
// //                                                   fontSize: 24,
// //                                                   fontWeight: FontWeight.bold,
// //                                                   color: index == 0
// //                                                       ? const Color(0xFF6366F1)
// //                                                       : Colors.black87,
// //                                                 ),
// //                                               ),
// //                                               const SizedBox(height: 12),
// //                                               // Features list
// //                                               Flexible(
// //                                                 child: ListView(
// //                                                   shrinkWrap: true,
// //                                                   physics:
// //                                                       const NeverScrollableScrollPhysics(),
// //                                                   children: plan.features
// //                                                           ?.take(4)
// //                                                           .map(
// //                                                             (feature) => Padding(
// //                                                               padding:
// //                                                                   const EdgeInsets
// //                                                                       .only(
// //                                                                 bottom: 4,
// //                                                               ),
// //                                                               child: Row(
// //                                                                 children: [
// //                                                                   Icon(
// //                                                                     Icons
// //                                                                         .check_circle,
// //                                                                     size: 14,
// //                                                                     color: index ==
// //                                                                             0
// //                                                                         ? const Color(
// //                                                                             0xFF6366F1)
// //                                                                         : Colors
// //                                                                             .green,
// //                                                                   ),
// //                                                                   const SizedBox(
// //                                                                       width: 6),
// //                                                                   Expanded(
// //                                                                     child: Text(
// //                                                                       feature,
// //                                                                       style:
// //                                                                           TextStyle(
// //                                                                         fontSize:
// //                                                                             10,
// //                                                                         color: Colors
// //                                                                             .grey
// //                                                                             .shade700,
// //                                                                       ),
// //                                                                       maxLines: 1,
// //                                                                       overflow:
// //                                                                           TextOverflow
// //                                                                               .ellipsis,
// //                                                                     ),
// //                                                                   ),
// //                                                                 ],
// //                                                               ),
// //                                                             ),
// //                                                           )
// //                                                           .toList() ??
// //                                                       [],
// //                                                 ),
// //                                               ),
// //                                               if ((plan.features?.length ?? 0) >
// //                                                   4)
// //                                                 Padding(
// //                                                   padding:
// //                                                       const EdgeInsets.only(
// //                                                           top: 4),
// //                                                   child: Text(
// //                                                     '+ ${(plan.features?.length ?? 0) - 4} more features',
// //                                                     style: TextStyle(
// //                                                       fontSize: 9,
// //                                                       color:
// //                                                           Colors.grey.shade600,
// //                                                     ),
// //                                                   ),
// //                                                 ),
// //                                             ],
// //                                           ),
// //                                         ),
// //                                       ),

// //                                     ),
// //                                   ),

// //                                 );
// //                               }).toList(),
// //                             );
// //                           },
// //                         );
// //                       }

// //                       return Center(
// //                         child: Column(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             Container(
// //                               padding: const EdgeInsets.all(16),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.grey.shade100,
// //                                 shape: BoxShape.circle,
// //                               ),
// //                               child: Icon(
// //                                 Icons.shopping_bag_outlined,
// //                                 size: 48,
// //                                 color: Colors.grey.shade400,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 16),
// //                             Text(
// //                               'No Plans Available',
// //                               style: TextStyle(
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colors.grey.shade700,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 8),
// //                             Text(
// //                               'Check back soon for premium options',
// //                               style: TextStyle(
// //                                 color: Colors.grey.shade500,
// //                                 fontSize: 12,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ),

// //               // Footer with subscription info
// //               Container(
// //                 margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
// //                 padding: const EdgeInsets.all(16),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white.withOpacity(0.15),
// //                   borderRadius: BorderRadius.circular(16),
// //                   border: Border.all(
// //                     color: Colors.white.withOpacity(0.3),
// //                     width: 1,
// //                   ),
// //                 ),
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Icon(
// //                           Icons.autorenew_rounded,
// //                           size: 14,
// //                           color: Colors.white.withOpacity(0.9),
// //                         ),
// //                         const SizedBox(width: 6),
// //                         Expanded(
// //                           child: Text(
// //                             'Auto-renews unless cancelled 24h before period ends',
// //                             style: TextStyle(
// //                               fontSize: 13,
// //                               color: Colors.white.withOpacity(0.95),
// //                               height: 1.3,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 10),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         GestureDetector(
// //                           onTap: () => _launchURL(
// //                             'https://editezy.onrender.com/privacy-and-policy',
// //                           ),
// //                           child: const Text(
// //                             'Privacy Policy',
// //                             style: TextStyle(
// //                               fontSize: 11,
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.w600,
// //                               decoration: TextDecoration.underline,
// //                               decorationColor: Colors.white,
// //                             ),
// //                           ),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 8),
// //                           child: Text(
// //                             '•',
// //                             style: TextStyle(
// //                               color: Colors.white.withOpacity(0.7),
// //                               fontSize: 11,
// //                             ),
// //                           ),
// //                         ),
// //                         GestureDetector(
// //                           onTap: () => _launchURL(
// //                             'https://editezy.onrender.com/terms-and-conditions',
// //                           ),
// //                           child: const Text(
// //                             'Terms of Use',
// //                             style: TextStyle(
// //                               fontSize: 11,
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.w600,
// //                               decoration: TextDecoration.underline,
// //                               decorationColor: Colors.white,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _launchURL(String url) async {
// //     final Uri uri = Uri.parse(url);
// //     if (await canLaunchUrl(uri)) {
// //       await launchUrl(uri, mode: LaunchMode.externalApplication);
// //     }
// //   }
// // }

// // // Usage examples:

// // // 1. As a full screen page:
// // class SubscriptionPlansPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Padding(
// //         padding: const EdgeInsets.all(30),
// //         child: SubscriptionPlansWidget(
// //           showCloseButton: true,
// //           onClose: () => Navigator.pop(context),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // 2. As a modal dialog (like your original):
// // void showSubscriptionModal(BuildContext context) async {
// //   final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

// //   if (myPlanProvider.isPurchase == true) {
// //     return;
// //   }

// //   final hasShownRecently = await ModalPreferences.hasShownSubscriptionModal();
// //   final shouldShowAgain =
// //       await ModalPreferences.shouldShowSubscriptionModalAgain(daysBetween: 7);

// //   if (hasShownRecently && !shouldShowAgain) {
// //     print('Subscription modal shown recently, skipping');
// //     return;
// //   }

// //   showDialog(
// //     context: context,
// //     barrierDismissible: true,
// //     builder: (context) => Dialog(
// //       backgroundColor: Colors.transparent,
// //       insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// //       child: SubscriptionPlansWidget(
// //         showCloseButton: true,
// //         onClose: () => Navigator.pop(context),
// //       ),
// //     ),
// //   );
// // }

// // // 3. Embedded in another screen:
// // class MyScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Column(
// //         children: [
// //           // Other widgets...
// //           Expanded(
// //             child: SubscriptionPlansWidget(
// //               showCloseButton: false,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:posternova/helper/sub_modal_helper.dart';
// import 'package:posternova/providers/plans/get_all_plan_provider.dart';
// import 'package:posternova/providers/plans/my_plan_provider.dart';
// import 'package:posternova/views/subscription/payment_success_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SubscriptionPlansWidget extends StatelessWidget {
//   final VoidCallback? onClose;
//   final bool showCloseButton;

//   const SubscriptionPlansWidget({
//     Key? key,
//     this.onClose,
//     this.showCloseButton = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final planProvider = Provider.of<GetAllPlanProvider>(
//       context,
//       listen: false,
//     );

//     if (planProvider.plans.isEmpty && !planProvider.isLoading) {
//       planProvider.fetchAllPlans();
//     }

//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
//         ),
//         borderRadius: BorderRadius.circular(32),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF6366F1).withOpacity(0.4),
//             blurRadius: 40,
//             offset: const Offset(0, 20),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           // Decorative circles
//           Positioned(
//             top: -50,
//             right: -50,
//             child: Container(
//               width: 150,
//               height: 150,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.1),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: -30,
//             left: -30,
//             child: Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.1),
//               ),
//             ),
//           ),

//           // Main content
//           Column(
//             children: [
//               // Header with close button
//               if (showCloseButton)
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       GestureDetector(
//                         onTap: onClose ?? () => Navigator.pop(context),
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.close,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//               // Plans Container
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 16),
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   child: Consumer<GetAllPlanProvider>(
//                     builder: (context, provider, child) {
//                       if (provider.isLoading) {
//                         return const Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CircularProgressIndicator(
//                                 color: Color(0xFF6366F1),
//                                 strokeWidth: 3,
//                               ),
//                               SizedBox(height: 16),
//                               Text(
//                                 'Loading premium plans...',
//                                 style: TextStyle(
//                                   color: Color(0xFF6B7280),
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }

//                       if (provider.error != null) {
//                         return Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.shade50,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.error_outline_rounded,
//                                   color: Colors.red.shade400,
//                                   size: 48,
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               const Text(
//                                 'Oops! Something went wrong',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF1F2937),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'Unable to load plans. Please try again.',
//                                 style: TextStyle(
//                                   color: Colors.grey.shade600,
//                                   fontSize: 14,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 24),
//                               ElevatedButton(
//                                 onPressed: () => provider.fetchAllPlans(),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFF6366F1),
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 32,
//                                     vertical: 16,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 0,
//                                 ),
//                                 child: const Text(
//                                   'Try Again',
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }

//                       if (provider.plans.isNotEmpty) {
//                         return LayoutBuilder(
//                           builder: (context, constraints) {
//                             return Column(
//                               children: provider.plans.asMap().entries.map((
//                                 entry,
//                               ) {
//                                 final index = entry.key;
//                                 final plan = entry.value;

//                                 return Expanded(
//                                   child: Container(
//                                     margin: EdgeInsets.only(
//                                       bottom: index < provider.plans.length - 1
//                                           ? 12
//                                           : 0,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(16),
//                                       border: Border.all(
//                                         color: index == 0
//                                             ? const Color(0xFF6366F1)
//                                             : Colors.grey.shade200,
//                                         width: index == 0 ? 2 : 1,
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withOpacity(0.05),
//                                           blurRadius: 10,
//                                           offset: const Offset(0, 5),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Material(
//                                       color: Colors.transparent,
//                                       child: InkWell(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   PlanDetailsAndPaymentScreen(
//                                                 plan: plan,
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         borderRadius: BorderRadius.circular(16),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(16),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               // Plan name
//                                               Text(
//                                                 plan.name ?? 'Plan',
//                                                 style: TextStyle(
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: index == 0
//                                                       ? const Color(0xFF6366F1)
//                                                       : Colors.black87,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 8),
//                                               // Price
//                                               Text(
//                                                 '${plan.offerPrice?.toStringAsFixed(2) ?? '0.00'}/${(plan.duration ?? 'month') == 'month' ? 'mo' : 'yr'}',
//                                                 style: TextStyle(
//                                                   fontSize: 24,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: index == 0
//                                                       ? const Color(0xFF6366F1)
//                                                       : Colors.black87,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 12),
//                                               // Features list
//                                               Flexible(
//                                                 child: ListView(
//                                                   shrinkWrap: true,
//                                                   physics:
//                                                       const NeverScrollableScrollPhysics(),
//                                                   children: plan.features
//                                                           ?.take(4)
//                                                           .map(
//                                                             (feature) => Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .only(
//                                                                 bottom: 4,
//                                                               ),
//                                                               child: Row(
//                                                                 children: [
//                                                                   Icon(
//                                                                     Icons
//                                                                         .check_circle,
//                                                                     size: 14,
//                                                                     color: index ==
//                                                                             0
//                                                                         ? const Color(
//                                                                             0xFF6366F1)
//                                                                         : Colors
//                                                                             .green,
//                                                                   ),
//                                                                   const SizedBox(
//                                                                       width: 6),
//                                                                   Expanded(
//                                                                     child: Text(
//                                                                       feature,
//                                                                       style:
//                                                                           TextStyle(
//                                                                         fontSize:
//                                                                             10,
//                                                                         color: Colors
//                                                                             .grey
//                                                                             .shade700,
//                                                                       ),
//                                                                       maxLines: 1,
//                                                                       overflow:
//                                                                           TextOverflow
//                                                                               .ellipsis,
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           )
//                                                           .toList() ??
//                                                       [],
//                                                 ),
//                                               ),
//                                               if ((plan.features?.length ?? 0) >
//                                                   4)
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 4),
//                                                   child: Text(
//                                                     '+ ${(plan.features?.length ?? 0) - 4} more features',
//                                                     style: TextStyle(
//                                                       fontSize: 9,
//                                                       color:
//                                                           Colors.grey.shade600,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               const SizedBox(height: 16),
//                                               // Purchase button
//                                               SizedBox(
//                                                 width: double.infinity,
//                                                 child: ElevatedButton(
//                                                   onPressed: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             PlanDetailsAndPaymentScreen(
//                                                           plan: plan,
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                   style: ElevatedButton.styleFrom(
//                                                     backgroundColor: index == 0
//                                                         ? const Color(0xFF6366F1)
//                                                         : const Color(0xFF8B5CF6),
//                                                     foregroundColor: Colors.white,
//                                                     padding: const EdgeInsets.symmetric(
//                                                       vertical: 12,
//                                                     ),
//                                                     shape: RoundedRectangleBorder(
//                                                       borderRadius: BorderRadius.circular(12),
//                                                     ),
//                                                     elevation: 0,
//                                                   ),
//                                                   child: const Text(
//                                                     'Purchase Plan',
//                                                     style: TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight: FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),

//                                     ),
//                                   ),

//                                 );
//                               }).toList(),
//                             );
//                           },
//                         );
//                       }

//                       return Center(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade100,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.shopping_bag_outlined,
//                                 size: 48,
//                                 color: Colors.grey.shade400,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               'No Plans Available',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey.shade700,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Check back soon for premium options',
//                               style: TextStyle(
//                                 color: Colors.grey.shade500,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               // Footer with subscription info
//               Container(
//                 margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.autorenew_rounded,
//                           size: 14,
//                           color: Colors.white.withOpacity(0.9),
//                         ),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Text(
//                             'Auto-renews unless cancelled 24h before period ends',
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.white.withOpacity(0.95),
//                               height: 1.3,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () => _launchURL(
//                             'https://editezy.onrender.com/privacy-and-policy',
//                           ),
//                           child: const Text(
//                             'Privacy Policy',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                               decoration: TextDecoration.underline,
//                               decorationColor: Colors.white,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           child: Text(
//                             '•',
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.7),
//                               fontSize: 11,
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () => _launchURL(
//                             'https://editezy.onrender.com/terms-and-conditions',
//                           ),
//                           child: const Text(
//                             'Terms of Use',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                               decoration: TextDecoration.underline,
//                               decorationColor: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
// }

// // Usage examples:

// // 1. As a full screen page:
// class SubscriptionPlansPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(30),
//         child: SubscriptionPlansWidget(
//           showCloseButton: true,
//           onClose: () => Navigator.pop(context),
//         ),
//       ),
//     );
//   }
// }

// // 2. As a modal dialog (like your original):
// void showSubscriptionModal(BuildContext context) async {
//   final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

//   if (myPlanProvider.isPurchase == true) {
//     return;
//   }

//   final hasShownRecently = await ModalPreferences.hasShownSubscriptionModal();
//   final shouldShowAgain =
//       await ModalPreferences.shouldShowSubscriptionModalAgain(daysBetween: 7);

//   if (hasShownRecently && !shouldShowAgain) {
//     print('Subscription modal shown recently, skipping');
//     return;
//   }

//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (context) => Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: SubscriptionPlansWidget(
//         showCloseButton: true,
//         onClose: () => Navigator.pop(context),
//       ),
//     ),
//   );
// }

// // 3. Embedded in another screen:
// class MyScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // Other widgets...
//           Expanded(
//             child: SubscriptionPlansWidget(
//               showCloseButton: false,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:posternova/helper/sub_modal_helper.dart';
import 'package:posternova/providers/plans/get_all_plan_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/views/subscription/payment_success_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionPlansWidget extends StatelessWidget {
  final VoidCallback? onClose;
  final bool showCloseButton;

  const SubscriptionPlansWidget({
    Key? key,
    this.onClose,
    this.showCloseButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<GetAllPlanProvider>(
      context,
      listen: false,
    );

    if (planProvider.plans.isEmpty && !planProvider.isLoading) {
      planProvider.fetchAllPlans();
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              // Header with close button
              if (showCloseButton)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: onClose ?? () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Plans Container
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Consumer<GetAllPlanProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF6366F1),
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Loading premium plans...',
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (provider.error != null) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.red.shade400,
                                  size: 48,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Oops! Something went wrong',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Unable to load plans. Please try again.',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () => provider.fetchAllPlans(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6366F1),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Try Again',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (provider.plans.isNotEmpty) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              children: provider.plans.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final plan = entry.value;

                                // Create a separate stateful widget for each plan card
                                return Expanded(
                                  child: PlanCard(
                                    plan: plan,
                                    index: index,
                                    isLast: index == provider.plans.length - 1,
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        );
                      }

                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Plans Available',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check back soon for premium options',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Footer with subscription info
              // Container(
              //   margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.15),
              //     borderRadius: BorderRadius.circular(16),
              //     border: Border.all(
              //       color: Colors.white.withOpacity(0.3),
              //       width: 1,
              //     ),
              //   ),
              //   child: Column(
              //     children: [
              //       Row(
              //         children: [
              //           Icon(
              //             Icons.autorenew_rounded,
              //             size: 14,
              //             color: Colors.white.withOpacity(0.9),
              //           ),
              //           const SizedBox(width: 6),
              //           Expanded(
              //             child: Text(
              //               'Auto-renews unless cancelled 24h before period ends',
              //               style: TextStyle(
              //                 fontSize: 13,
              //                 color: Colors.white.withOpacity(0.95),
              //                 height: 1.3,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 10),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           GestureDetector(
              //             onTap: () => _launchURL(
              //               'https://editezy.onrender.com/privacy-and-policy',
              //             ),
              //             child: const Text(
              //               'Privacy Policy',
              //               style: TextStyle(
              //                 fontSize: 11,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.w600,
              //                 decoration: TextDecoration.underline,
              //                 decorationColor: Colors.white,
              //               ),
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.symmetric(horizontal: 8),
              //             child: Text(
              //               '•',
              //               style: TextStyle(
              //                 color: Colors.white.withOpacity(0.7),
              //                 fontSize: 11,
              //               ),
              //             ),
              //           ),
              //           GestureDetector(
              //             onTap: () => _launchURL(
              //               'https://editezy.onrender.com/terms-and-conditions',
              //             ),
              //             child: const Text(
              //               'Terms of Use',
              //               style: TextStyle(
              //                 fontSize: 11,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.w600,
              //                 decoration: TextDecoration.underline,
              //                 decorationColor: Colors.white,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// Separate StatefulWidget for each plan card to manage checkbox state
class PlanCard extends StatefulWidget {
  final dynamic plan;
  final int index;
  final bool isLast;

  const PlanCard({
    Key? key,
    required this.plan,
    required this.index,
    required this.isLast,
  }) : super(key: key);

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.index == 0
              ? const Color(0xFF6366F1)
              : Colors.grey.shade200,
          width: widget.index == 0 ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Plan name
              Text(
                widget.plan.name ?? 'Plan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.index == 0
                      ? const Color(0xFF6366F1)
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              // Price
              Text(
                '${widget.plan.offerPrice?.toStringAsFixed(2) ?? '0.00'} INR/${(widget.plan.duration ?? 'month') == 'month' ? 'mo' : 'Year'}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.index == 0
                      ? const Color(0xFF6366F1)
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              // Features list
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children:
                      widget.plan.features
                          ?.take(4)
                          .map<Widget>(
                            (feature) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 14,
                                    color: widget.index == 0
                                        ? const Color(0xFF6366F1)
                                        : Colors.green,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList() ??
                      [],
                ),
              ),
              if ((widget.plan.features?.length ?? 0) > 4)
                // Padding(
                //   padding: const EdgeInsets.only(top: 4),
                //   child: Text(
                //     '+ ${(widget.plan.features?.length ?? 0) - 4} more features',
                //     style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                //   ),
                // ),
              const SizedBox(height: 16),
              // Checkbox with terms agreement
              Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        _agreedToTerms = value ?? false;
                      });
                    },
                    activeColor: widget.index == 0
                        ? const Color(0xFF6366F1)
                        : const Color(0xFF8B5CF6),
                  ),
                  // Expanded(
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       setState(() {
                  //         _agreedToTerms = !_agreedToTerms;
                  //       });
                  //     },
                  //     child: Text(
                  //       'I agree to the Terms of Service and Privacy Policy',
                  //       style: TextStyle(
                  //         fontSize: 12,
                  //         color: Colors.grey.shade700,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                        children: [
                          const TextSpan(text: 'I agree to the '),

                          // Terms and Conditions
                          TextSpan(
                            text: 'Terms of Service',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchURL(
                                  'https://editezy.onrender.com/terms-and-conditions',
                                );
                              },
                          ),

                          const TextSpan(text: ' and '),

                          // Privacy Policy
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchURL(
                                  'https://editezy.onrender.com/privacy-and-policy',
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Purchase button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _agreedToTerms
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlanDetailsAndPaymentScreen(
                                plan: widget.plan,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.index == 0
                        ? const Color(0xFF6366F1)
                        : const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Purchase Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Footer with subscription info and links
              // Container(
              //   padding: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: Colors.grey.shade50,
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Icon(
              //             Icons.autorenew_rounded,
              //             size: 12,
              //             color: Colors.grey.shade600,
              //           ),
              //           const SizedBox(width: 4),
              //           Expanded(
              //             child: Text(
              //               'Auto-renews unless cancelled 24h before period ends',
              //               style: TextStyle(
              //                 fontSize: 10,
              //                 color: Colors.grey.shade600,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 6),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           GestureDetector(
              //             onTap: () => _launchURL(
              //               'https://editezy.onrender.com/privacy-and-policy',
              //             ),
              //             child: const Text(
              //               'Privacy Policy',
              //               style: TextStyle(
              //                 fontSize: 10,
              //                 color: Color(0xFF6366F1),
              //                 fontWeight: FontWeight.w600,
              //                 decoration: TextDecoration.underline,
              //               ),
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.symmetric(horizontal: 6),
              //             child: Text(
              //               '•',
              //               style: TextStyle(
              //                 color: Colors.grey.shade600,
              //                 fontSize: 10,
              //               ),
              //             ),
              //           ),
              //           GestureDetector(
              //             onTap: () => _launchURL(
              //               'https://editezy.onrender.com/terms-and-conditions',
              //             ),
              //             child: const Text(
              //               'Terms of Use',
              //               style: TextStyle(
              //                 fontSize: 10,
              //                 color: Color(0xFF6366F1),
              //                 fontWeight: FontWeight.w600,
              //                 decoration: TextDecoration.underline,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// Usage examples remain the same:

// 1. As a full screen page:
class SubscriptionPlansPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SubscriptionPlansWidget(
          showCloseButton: true,
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

// 2. As a modal dialog:
void showSubscriptionModal(BuildContext context) async {
  final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

  if (myPlanProvider.isPurchase == true) {
    return;
  }

  final hasShownRecently = await ModalPreferences.hasShownSubscriptionModal();
  final shouldShowAgain =
      await ModalPreferences.shouldShowSubscriptionModalAgain(daysBetween: 7);

  if (hasShownRecently && !shouldShowAgain) {
    print('Subscription modal shown recently, skipping');
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SubscriptionPlansWidget(
        showCloseButton: true,
        onClose: () => Navigator.pop(context),
      ),
    ),
  );
}

// 3. Embedded in another screen:
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Other widgets...
          Expanded(child: SubscriptionPlansWidget(showCloseButton: false)),
        ],
      ),
    );
  }
}
