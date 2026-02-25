// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:posternova/helper/sub_modal_helper.dart';
// // import 'package:posternova/models/category_model.dart';
// // import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
// // import 'package:posternova/providers/plans/get_all_plan_provider.dart';
// // import 'package:posternova/providers/plans/my_plan_provider.dart';
// // import 'package:posternova/views/PosterModule/poster_making_screen.dart';
// // import 'package:posternova/views/category/category_detail_screen.dart';
// // import 'package:posternova/views/category/search_category.dart';
// // import 'package:posternova/views/subscription/payment_success_screen.dart';
// // import 'package:posternova/views/subscription/plan_detail_screen.dart';
// // import 'package:posternova/widgets/common_modal.dart';
// // import 'package:posternova/widgets/premium_widget.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shimmer/shimmer.dart';

// // class CategoryScreen extends StatefulWidget {
// //   const CategoryScreen({super.key});

// //   @override
// //   State<CategoryScreen> createState() => _CategoryScreenState();
// // }

// // class _CategoryScreenState extends State<CategoryScreen>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _animationController;
// //   late Animation<double> _fadeAnimation;
// //   final ScrollController _scrollController = ScrollController();
// //   bool _showElevation = false;

// //   @override
// //   void initState() {
// //     super.initState();

// //     _animationController = AnimationController(
// //       duration: const Duration(milliseconds: 600),
// //       vsync: this,
// //     );
// //     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// //       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
// //     );

// //     _scrollController.addListener(() {
// //       if (_scrollController.offset > 10 && !_showElevation) {
// //         setState(() => _showElevation = true);
// //       } else if (_scrollController.offset <= 10 && _showElevation) {
// //         setState(() => _showElevation = false);
// //       }
// //     });

// //     Future.microtask(() {
// //       Provider.of<PosterProvider>(context, listen: false).fetchPosters();
// //       _animationController.forward();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     _scrollController.dispose();
// //     super.dispose();
// //   }

// //   Future<bool> _onWillPop() async {
// //     if (Navigator.canPop(context)) {
// //       return true;
// //     }
// //     return await _showExitConfirmation();
// //   }

// //   Future<bool> _showExitConfirmation() async {
// //     return await showDialog<bool>(
// //           context: context,
// //           barrierDismissible: false,
// //           builder: (context) => AlertDialog(
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(16),
// //             ),
// //             title: const Text(
// //               'Exit App',
// //               style: TextStyle(fontWeight: FontWeight.w600),
// //             ),
// //             content: const Text('Are you sure you want to exit?'),
// //             actions: [
// //               TextButton(
// //                 onPressed: () => Navigator.of(context).pop(false),
// //                 child: const Text('Cancel'),
// //               ),
// //               TextButton(
// //                 onPressed: () => SystemNavigator.pop(),
// //                 style: TextButton.styleFrom(foregroundColor: Colors.red),
// //                 child: const Text('Exit'),
// //               ),
// //             ],
// //           ),
// //         ) ??
// //         false;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;
// //     final isTablet = size.width > 600;
// //     final padding = isTablet ? 24.0 : 16.0;

// //     return WillPopScope(
// //       onWillPop: _onWillPop,
// //       child: Scaffold(
// //         backgroundColor: const Color(0xFFF8F9FA),
// //         body: SafeArea(
// //           child: FadeTransition(
// //             opacity: _fadeAnimation,
// //             child: Column(
// //               children: [
// //                 _buildAppBar(padding, isTablet),
// //                 Expanded(
// //                   child: Consumer<PosterProvider>(
// //                     builder: (context, posterProvider, child) {
// //                       if (posterProvider.isLoading) {
// //                         return _buildLoadingState(padding, isTablet);
// //                       }

// //                       if (posterProvider.error != null) {
// //                         return _buildErrorState(posterProvider);
// //                       }

// //                       final categories = _extractUniqueCategories(
// //                         posterProvider.posters,
// //                       );

// //                       if (categories.isEmpty) {
// //                         return _buildEmptyState();
// //                       }

// //                       return _buildCategoryList(
// //                         categories,
// //                         posterProvider.posters,
// //                         padding,
// //                         isTablet,
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildAppBar(double padding, bool isTablet) {
// //     return AnimatedContainer(
// //       duration: const Duration(milliseconds: 200),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: _showElevation
// //             ? [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.05),
// //                   blurRadius: 8,
// //                   offset: const Offset(0, 2),
// //                 ),
// //               ]
// //             : [],
// //       ),
// //       child: Padding(
// //         padding: EdgeInsets.all(padding),
// //         child: Row(
// //           children: [
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Text(
// //                     'Explore Templates',
// //                     style: TextStyle(
// //                       fontSize: isTablet ? 28 : 24,
// //                       fontWeight: FontWeight.w700,
// //                       color: const Color(0xFF1A1A1A),
// //                       height: 1.2,
// //                     ),
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     'Browse categories',
// //                     style: TextStyle(
// //                       fontSize: isTablet ? 15 : 14,
// //                       color: const Color(0xFF6B7280),
// //                       fontWeight: FontWeight.w400,
// //                     ),
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             _buildSearchButton(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSearchButton() {
// //     return Consumer<MyPlanProvider>(
// //       builder: (context, myPlanprovider, child) {
// //         return Material(
// //           color: const Color(0xFF4F46E5),
// //           borderRadius: BorderRadius.circular(12),
// //           child: InkWell(
// //             onTap: () {
// //               if (myPlanprovider.isPurchase == true) {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => const SearchScreen()),
// //                 );
// //               } else {
// //                 CommonModal.showWarning(
// //                   context: context,
// //                   title: "Premium Category",
// //                   message:
// //                       "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
// //                   primaryButtonText: "Upgrade Now",
// //                   secondaryButtonText: "Cancel",
// //                   // onPrimaryPressed: () => showSubscriptionModal(context),
// //                   onPrimaryPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => SubscriptionPlansPage(),
// //                       ),
// //                     );
// //                   },

// //                   onSecondaryPressed: () => Navigator.of(context).pop(),
// //                 );
// //               }
// //             },
// //             borderRadius: BorderRadius.circular(12),
// //             child: Container(
// //               padding: const EdgeInsets.all(12),
// //               child: const Icon(
// //                 Icons.search_rounded,
// //                 color: Colors.white,
// //                 size: 22,
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildCategoryList(
// //     List<String> categories,
// //     List<dynamic> posters,
// //     double padding,
// //     bool isTablet,
// //   ) {
// //     final itemWidth = isTablet ? 200.0 : 160.0;
// //     final itemHeight = isTablet ? 220.0 : 180.0;

// //     return ListView.builder(
// //       controller: _scrollController,
// //       physics: const BouncingScrollPhysics(),
// //       padding: EdgeInsets.symmetric(vertical: padding),
// //       itemCount: categories.length,
// //       itemBuilder: (context, index) {
// //         final category = categories[index];
// //         final categoryPosters = _getPostersByCategory(category, posters);

// //         return Padding(
// //           padding: EdgeInsets.only(bottom: padding),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _buildCategoryHeader(category, padding, isTablet),
// //               const SizedBox(height: 12),
// //               SizedBox(
// //                 height: itemHeight + 20,
// //                 child: _buildHorizontalPosterList(
// //                   categoryPosters,
// //                   itemWidth,
// //                   itemHeight,
// //                   padding,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildCategoryHeader(String category, double padding, bool isTablet) {
// //     return Consumer<MyPlanProvider>(
// //       builder: (context, myplanprovider, child) {
// //         return Padding(
// //           padding: EdgeInsets.symmetric(horizontal: padding),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Expanded(
// //                 child: Row(
// //                   children: [
// //                     Container(
// //                       width: 4,
// //                       height: 20,
// //                       decoration: BoxDecoration(
// //                         color: const Color(0xFF4F46E5),
// //                         borderRadius: BorderRadius.circular(2),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: Text(
// //                         _capitalizeFirstLetter(category),
// //                         style: TextStyle(
// //                           fontSize: isTablet ? 22 : 18,
// //                           fontWeight: FontWeight.w700,
// //                           color: const Color(0xFF1A1A1A),
// //                         ),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               Material(
// //                 color: Colors.transparent,
// //                 child: InkWell(
// //                   onTap: () {
// //                     if (myplanprovider.isPurchase == true) {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) =>
// //                               DetailsScreen(category: category),
// //                         ),
// //                       );
// //                     } else {
// //                       CommonModal.showWarning(
// //                         context: context,
// //                         title: "Premium Category",
// //                         message:
// //                             "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
// //                         primaryButtonText: "Upgrade Now",
// //                         secondaryButtonText: "Cancel",
// //                         // onPrimaryPressed: () => showSubscriptionModal(context),
// //                         onPrimaryPressed: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => SubscriptionPlansPage(),
// //                             ),
// //                           );
// //                         },

// //                         onSecondaryPressed: () => Navigator.of(context).pop(),
// //                       );
// //                     }
// //                   },
// //                   borderRadius: BorderRadius.circular(20),
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 12,
// //                       vertical: 6,
// //                     ),
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFFF3F4F6),
// //                       borderRadius: BorderRadius.circular(20),
// //                     ),
// //                     child: Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         const Text(
// //                           'View All',
// //                           style: TextStyle(
// //                             fontSize: 13,
// //                             fontWeight: FontWeight.w600,
// //                             color: Color(0xFF4F46E5),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 4),
// //                         const Icon(
// //                           Icons.arrow_forward_ios_rounded,
// //                           size: 12,
// //                           color: Color(0xFF4F46E5),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   void showSubscriptionModal(BuildContext context) async {
// //     final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

// //     if (myPlanProvider.isPurchase == true) {
// //       return;
// //     }

// //     final hasShownRecently = await ModalPreferences.hasShownSubscriptionModal();
// //     final shouldShowAgain =
// //         await ModalPreferences.shouldShowSubscriptionModalAgain(daysBetween: 7);

// //     if (hasShownRecently && !shouldShowAgain) {
// //       print('Subscription modal shown recently, skipping');
// //       return;
// //     }

// //     final planProvider = Provider.of<GetAllPlanProvider>(
// //       context,
// //       listen: false,
// //     );
// //     if (planProvider.plans.isEmpty && !planProvider.isLoading) {
// //       planProvider.fetchAllPlans();
// //     }

// //     showDialog(
// //       context: context,
// //       barrierDismissible: true,
// //       builder: (context) => Dialog(
// //         backgroundColor: Colors.transparent,
// //         child: Container(
// //           constraints: const BoxConstraints(maxWidth: 400),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(24),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.15),
// //                 blurRadius: 30,
// //                 offset: const Offset(0, 10),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               // Header Section
// //               Container(
// //                 padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
// //                 child: Column(
// //                   children: [
// //                     // Close Button
// //                     Align(
// //                       alignment: Alignment.topRight,
// //                       child: GestureDetector(
// //                         onTap: () => Navigator.pop(context),
// //                         child: Container(
// //                           padding: const EdgeInsets.all(6),
// //                           decoration: BoxDecoration(
// //                             color: Colors.grey.shade100,
// //                             shape: BoxShape.circle,
// //                           ),
// //                           child: Icon(
// //                             Icons.close,
// //                             size: 18,
// //                             color: Colors.grey.shade600,
// //                           ),
// //                         ),
// //                       ),
// //                     ),

// //                     const SizedBox(height: 8),

// //                     // Premium Icon
// //                     Container(
// //                       width: 70,
// //                       height: 70,
// //                       decoration: BoxDecoration(
// //                         gradient: const LinearGradient(
// //                           begin: Alignment.topLeft,
// //                           end: Alignment.bottomRight,
// //                           colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
// //                         ),
// //                         borderRadius: BorderRadius.circular(18),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: const Color(0xFFFFA500).withOpacity(0.3),
// //                             blurRadius: 15,
// //                             offset: const Offset(0, 6),
// //                           ),
// //                         ],
// //                       ),
// //                       child: const Icon(
// //                         Icons.workspace_premium_rounded,
// //                         color: Colors.white,
// //                         size: 36,
// //                       ),
// //                     ),

// //                     const SizedBox(height: 16),

// //                     // Title
// //                     const Text(
// //                       'Unlock Premium',
// //                       style: TextStyle(
// //                         fontSize: 24,
// //                         fontWeight: FontWeight.bold,
// //                         color: Color(0xFF1F2937),
// //                         letterSpacing: -0.5,
// //                       ),
// //                       textAlign: TextAlign.center,
// //                     ),

// //                     const SizedBox(height: 6),

// //                     // Subtitle
// //                     Text(
// //                       'Get unlimited access to all features',
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         color: Colors.grey.shade600,
// //                         height: 1.3,
// //                       ),
// //                       textAlign: TextAlign.center,
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Features List
// //               // Container(
// //               //   margin: const EdgeInsets.symmetric(horizontal: 20),
// //               //   padding: const EdgeInsets.all(16),
// //               //   decoration: BoxDecoration(
// //               //     color: const Color(0xFFF8FAFC),
// //               //     borderRadius: BorderRadius.circular(14),
// //               //     border: Border.all(color: Colors.grey.shade200),
// //               //   ),
// //               //   child: Column(
// //               //     children: [
// //               //       // _buildCompactFeature('Unlimited Templates'),
// //               //       // const SizedBox(height: 12),
// //               //       // _buildCompactFeature('No Watermarks'),
// //               //       // const SizedBox(height: 12),
// //               //       // _buildCompactFeature('Priority Support'),
// //               //       // const SizedBox(height: 12),
// //               //       // _buildCompactFeature('Regular Updates'),
// //               //     ],
// //               //   ),
// //               // ),
// //               const SizedBox(height: 20),

// //               // Plans Section
// //               Container(
// //                 constraints: const BoxConstraints(maxHeight: 280),
// //                 child: Consumer<GetAllPlanProvider>(
// //                   builder: (context, provider, child) {
// //                     if (provider.isLoading) {
// //                       return const Padding(
// //                         padding: EdgeInsets.all(40.0),
// //                         child: Center(
// //                           child: Column(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               CircularProgressIndicator(
// //                                 color: Color(0xFF6366F1),
// //                                 strokeWidth: 3,
// //                               ),
// //                               SizedBox(height: 12),
// //                               Text(
// //                                 'Loading plans...',
// //                                 style: TextStyle(
// //                                   color: Color(0xFF6B7280),
// //                                   fontSize: 13,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     }

// //                     if (provider.error != null) {
// //                       return Padding(
// //                         padding: const EdgeInsets.all(24.0),
// //                         child: Column(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             Icon(
// //                               Icons.error_outline_rounded,
// //                               color: Colors.red.shade400,
// //                               size: 48,
// //                             ),
// //                             const SizedBox(height: 12),
// //                             const Text(
// //                               'Unable to Load Plans',
// //                               style: TextStyle(
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Color(0xFF1F2937),
// //                               ),
// //                             ),
// //                             const SizedBox(height: 6),
// //                             Text(
// //                               'Please try again',
// //                               style: TextStyle(
// //                                 color: Colors.grey.shade600,
// //                                 fontSize: 13,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 16),
// //                             ElevatedButton.icon(
// //                               onPressed: () => provider.fetchAllPlans(),
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor: const Color(0xFF6366F1),
// //                                 foregroundColor: Colors.white,
// //                                 padding: const EdgeInsets.symmetric(
// //                                   horizontal: 20,
// //                                   vertical: 12,
// //                                 ),
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(10),
// //                                 ),
// //                                 elevation: 0,
// //                               ),
// //                               icon: const Icon(Icons.refresh_rounded, size: 18),
// //                               label: const Text(
// //                                 'Try Again',
// //                                 style: TextStyle(
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.w600,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                     }

// //                     if (provider.plans.isNotEmpty) {
// //                       return SingleChildScrollView(
// //                         padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
// //                         child: AnimatedPlanList(
// //                           plans: provider.plans,
// //                           onPlanSelected: (plan) {
// //                             Navigator.of(context).pop();
// //                             Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) =>
// //                                     PlanDetailsAndPaymentScreen(plan: plan),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       );
// //                     }

// //                     return Padding(
// //                       padding: const EdgeInsets.all(24.0),
// //                       child: Column(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Icon(
// //                             Icons.shopping_bag_outlined,
// //                             size: 48,
// //                             color: Colors.grey.shade400,
// //                           ),
// //                           const SizedBox(height: 12),
// //                           Text(
// //                             'No Plans Available',
// //                             style: TextStyle(
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.grey.shade700,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 4),
// //                           Text(
// //                             'Please check back later',
// //                             style: TextStyle(
// //                               color: Colors.grey.shade500,
// //                               fontSize: 13,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildHorizontalPosterList(
// //     List<CategoryModel> posters,
// //     double itemWidth,
// //     double itemHeight,
// //     double padding,
// //   ) {
// //     if (posters.isEmpty) {
// //       return Padding(
// //         padding: EdgeInsets.symmetric(horizontal: padding),
// //         child: Center(
// //           child: Container(
// //             padding: const EdgeInsets.all(24),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(16),
// //               border: Border.all(color: const Color(0xFFE5E7EB)),
// //             ),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Icon(
// //                   Icons.image_not_supported_outlined,
// //                   color: Colors.grey.shade400,
// //                   size: 32,
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   "No items available",
// //                   style: TextStyle(
// //                     color: Colors.grey.shade600,
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       );
// //     }

// //     return ListView.builder(
// //       scrollDirection: Axis.horizontal,
// //       physics: const BouncingScrollPhysics(),
// //       padding: EdgeInsets.symmetric(horizontal: padding),
// //       itemCount: posters.length,
// //       itemBuilder: (context, index) {
// //         return Padding(
// //           padding: EdgeInsets.only(right: index == posters.length - 1 ? 0 : 12),
// //           child: _buildPosterCard(posters[index], itemWidth, itemHeight),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildPosterCard(CategoryModel poster, double width, double height) {
// //     return Consumer<MyPlanProvider>(
// //       builder: (context, myplanProvider, child) {
// //         return Material(
// //           color: Colors.transparent,
// //           child: InkWell(
// //             onTap: () {
// //               if (myplanProvider.isPurchase == true) {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) =>
// //                         SamplePosterScreen(posterId: poster.id),
// //                   ),
// //                 );
// //               } else {
// //                 CommonModal.showWarning(
// //                   context: context,
// //                   title: "Premium Category",
// //                   message:
// //                       "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
// //                   primaryButtonText: "Upgrade Now",
// //                   secondaryButtonText: "Cancel",
// //                   // onPrimaryPressed: () => showSubscriptionModal(context),
// //                   onPrimaryPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => SubscriptionPlansPage(),
// //                       ),
// //                     );
// //                   },
// //                   onSecondaryPressed: () => Navigator.of(context).pop(),
// //                 );
// //               }
// //             },
// //             borderRadius: BorderRadius.circular(16),
// //             child: Container(
// //               width: width,
// //               height: height,
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(16),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(0.06),
// //                     blurRadius: 12,
// //                     offset: const Offset(0, 4),
// //                   ),
// //                 ],
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.stretch,
// //                 children: [
// //                   Expanded(
// //                     child: ClipRRect(
// //                       borderRadius: const BorderRadius.vertical(
// //                         top: Radius.circular(16),
// //                       ),
// //                       child: poster.images.isNotEmpty
// //                           ? Image.network(
// //                               poster.images[0],
// //                               fit: BoxFit.cover,
// //                               loadingBuilder: (context, child, loadingProgress) {
// //                                 if (loadingProgress == null) return child;
// //                                 return Container(
// //                                   color: const Color(0xFFF3F4F6),
// //                                   child: Center(
// //                                     child: SizedBox(
// //                                       width: 24,
// //                                       height: 24,
// //                                       child: CircularProgressIndicator(
// //                                         strokeWidth: 2,
// //                                         color: const Color(0xFF4F46E5),
// //                                         value:
// //                                             loadingProgress
// //                                                     .expectedTotalBytes !=
// //                                                 null
// //                                             ? loadingProgress
// //                                                       .cumulativeBytesLoaded /
// //                                                   loadingProgress
// //                                                       .expectedTotalBytes!
// //                                             : null,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 );
// //                               },
// //                               errorBuilder: (context, error, stackTrace) =>
// //                                   _buildPlaceholder(),
// //                             )
// //                           : _buildPlaceholder(),
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.all(12),
// //                     child: Row(
// //                       children: [
// //                         Expanded(
// //                           child: Text(
// //                             poster.categoryName,
// //                             style: const TextStyle(
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.w600,
// //                               color: Color(0xFF1A1A1A),
// //                             ),
// //                             maxLines: 1,
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ),
// //                         const SizedBox(width: 8),
// //                         Icon(
// //                           Icons.arrow_forward_ios_rounded,
// //                           size: 12,
// //                           color: Colors.grey.shade400,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildPlaceholder() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //           colors: [
// //             const Color(0xFF4F46E5).withOpacity(0.1),
// //             const Color(0xFF7C3AED).withOpacity(0.1),
// //           ],
// //         ),
// //       ),
// //       child: const Center(
// //         child: Icon(Icons.image_outlined, size: 48, color: Color(0xFF9CA3AF)),
// //       ),
// //     );
// //   }

// //   Widget _buildLoadingState(double padding, bool isTablet) {
// //     final itemWidth = isTablet ? 200.0 : 160.0;
// //     final itemHeight = isTablet ? 220.0 : 180.0;

// //     return ListView.builder(
// //       physics: const NeverScrollableScrollPhysics(),
// //       padding: EdgeInsets.all(padding),
// //       itemCount: 3,
// //       itemBuilder: (context, categoryIndex) {
// //         return Padding(
// //           padding: EdgeInsets.only(bottom: padding),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Shimmer.fromColors(
// //                 baseColor: Colors.grey.shade200,
// //                 highlightColor: Colors.grey.shade50,
// //                 child: Container(
// //                   width: 150,
// //                   height: 24,
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //               SizedBox(
// //                 height: itemHeight + 20,
// //                 child: ListView.builder(
// //                   scrollDirection: Axis.horizontal,
// //                   physics: const NeverScrollableScrollPhysics(),
// //                   itemCount: 3,
// //                   itemBuilder: (context, index) {
// //                     return Padding(
// //                       padding: const EdgeInsets.only(right: 12),
// //                       child: Shimmer.fromColors(
// //                         baseColor: Colors.grey.shade200,
// //                         highlightColor: Colors.grey.shade50,
// //                         child: Container(
// //                           width: itemWidth,
// //                           height: itemHeight,
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.circular(16),
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildErrorState(PosterProvider posterProvider) {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.all(32),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(20),
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFFFEE2E2),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: const Icon(
// //                 Icons.error_outline_rounded,
// //                 color: Color(0xFFDC2626),
// //                 size: 48,
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             const Text(
// //               'Something went wrong',
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.w600,
// //                 color: Color(0xFF1A1A1A),
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 8),
// //             const Text(
// //               'Unable to load categories at this time',
// //               style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 32),
// //             ElevatedButton.icon(
// //               onPressed: () => posterProvider.fetchPosters(),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: const Color(0xFF4F46E5),
// //                 foregroundColor: Colors.white,
// //                 padding: const EdgeInsets.symmetric(
// //                   horizontal: 32,
// //                   vertical: 16,
// //                 ),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 elevation: 0,
// //               ),
// //               icon: const Icon(Icons.refresh_rounded),
// //               label: const Text(
// //                 'Try Again',
// //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.all(32),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(20),
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFFF3F4F6),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: const Icon(
// //                 Icons.category_outlined,
// //                 color: Color(0xFF9CA3AF),
// //                 size: 48,
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             const Text(
// //               'No Categories Available',
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.w600,
// //                 color: Color(0xFF1A1A1A),
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 8),
// //             const Text(
// //               'Check back later for new content',
// //               style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
// //               textAlign: TextAlign.center,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   List<String> _extractUniqueCategories(List<dynamic> posters) {
// //     final Set<String> categories = {};
// //     for (var poster in posters) {
// //       if (poster is CategoryModel && poster.categoryName.isNotEmpty) {
// //         categories.add(poster.categoryName);
// //       }
// //     }
// //     return categories.toList();
// //   }

// //   List<CategoryModel> _getPostersByCategory(
// //     String category,
// //     List<dynamic> allPosters,
// //   ) {
// //     return allPosters
// //         .where(
// //           (poster) =>
// //               poster is CategoryModel &&
// //               poster.categoryName.toLowerCase() == category.toLowerCase(),
// //         )
// //         .cast<CategoryModel>()
// //         .toList();
// //   }

// //   String _capitalizeFirstLetter(String text) {
// //     if (text.isEmpty) return '';
// //     return text[0].toUpperCase() + text.substring(1);
// //   }
// // }















// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:posternova/widgets/recent_search_helper.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:posternova/helper/sub_modal_helper.dart';
// import 'package:posternova/models/category_model.dart';
// import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
// import 'package:posternova/providers/plans/get_all_plan_provider.dart';
// import 'package:posternova/providers/plans/my_plan_provider.dart';
// import 'package:posternova/views/PosterModule/poster_making_screen.dart';
// import 'package:posternova/views/category/category_detail_screen.dart';
// import 'package:posternova/views/category/search_category.dart';
// import 'package:posternova/views/subscription/payment_success_screen.dart';
// import 'package:posternova/views/subscription/plan_detail_screen.dart';
// import 'package:posternova/widgets/common_modal.dart';
// import 'package:posternova/widgets/premium_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';

// class CategoryScreen extends StatefulWidget {
//   const CategoryScreen({super.key});

//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   final ScrollController _scrollController = ScrollController();
//   bool _showElevation = false;
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _lastWords = '';
//   bool _isMicButtonVisible = true;
//   List<String> _recentSearches = [];
//   bool _isLoadingRecent = true;
//   Timer? _speechTimer;

//   @override
//   void initState() {
//     super.initState();

//     _speech = stt.SpeechToText();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );

//     _scrollController.addListener(() {
//       if (_scrollController.offset > 10 && !_showElevation) {
//         setState(() => _showElevation = true);
//       } else if (_scrollController.offset <= 10 && _showElevation) {
//         setState(() => _showElevation = false);
//       }
//     });

//     Future.microtask(() {
//       Provider.of<PosterProvider>(context, listen: false).fetchPosters();
//       _animationController.forward();
//       _loadRecentSearches();
//     });
//   }

//   Future<void> _loadRecentSearches() async {
//     setState(() => _isLoadingRecent = true);
//     final searches = await RecentSearchHelper.getRecentSearches();
//     setState(() {
//       _recentSearches = searches;
//       _isLoadingRecent = false;
//     });
//   }

//   void _startListening() async {
//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         if (status == 'done') {
//           _stopListening();
//         }
//       },
//       onError: (error) {
//         _showSpeechError(error.errorMsg);
//       },
//     );

//     if (available) {
//       setState(() {
//         _isListening = true;
//         _isMicButtonVisible = false;
//       });
      
//       _speech.listen(
//         onResult: (result) {
//           setState(() {
//             _lastWords = result.recognizedWords;
//           });
          
//           // Start timer to stop listening after 3 seconds of silence
//           _speechTimer?.cancel();
//           _speechTimer = Timer(const Duration(seconds: 3), () {
//             if (_isListening) {
//               _stopListening();
//             }
//           });
//         },
//         listenFor: const Duration(seconds: 30),
//         pauseFor: const Duration(seconds: 5),
//         partialResults: true,
//         localeId: 'en_US',
//         cancelOnError: true,
//         listenMode: stt.ListenMode.confirmation,
//       );
//     } else {
//       _showSpeechError('Speech recognition not available');
//     }
//   }

//   void _stopListening() {
//     _speechTimer?.cancel();
//     _speech.stop();
//     setState(() {
//       _isListening = false;
//       _isMicButtonVisible = true;
//     });

//     if (_lastWords.trim().isNotEmpty) {
//       _performVoiceSearch(_lastWords);
//     }
//   }

//   void _performVoiceSearch(String query) async {
//     // Save to recent searches
//     await RecentSearchHelper.addRecentSearch(query);
//     await _loadRecentSearches();
    
//     // Navigate to search screen with voice query
//     if (mounted) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SearchScreen(initialQuery: query),
//         ),
//       );
//     }
    
//     // Clear last words
//     setState(() => _lastWords = '');
//   }

//   void _showSpeechError(String error) {
//     setState(() {
//       _isListening = false;
//       _isMicButtonVisible = true;
//     });
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Speech error: $error'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   Future<bool> _onWillPop() async {
//     if (_isListening) {
//       _stopListening();
//       return false;
//     }
    
//     if (Navigator.canPop(context)) {
//       return true;
//     }
//     return await _showExitConfirmation();
//   }

//   Future<bool> _showExitConfirmation() async {
//     return await showDialog<bool>(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             title: const Text(
//               'Exit App',
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//             content: const Text('Are you sure you want to exit?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () => SystemNavigator.pop(),
//                 style: TextButton.styleFrom(foregroundColor: Colors.red),
//                 child: const Text('Exit'),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }

//   @override
//   void dispose() {
//     _speechTimer?.cancel();
//     if (_isListening) {
//       _speech.stop();
//     }
//     _animationController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final padding = isTablet ? 24.0 : 16.0;

//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF8F9FA),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Column(
//                   children: [
//                     _buildAppBar(padding, isTablet),
//                     Expanded(
//                       child: Consumer<PosterProvider>(
//                         builder: (context, posterProvider, child) {
//                           if (posterProvider.isLoading) {
//                             return _buildLoadingState(padding, isTablet);
//                           }

//                           if (posterProvider.error != null) {
//                             return _buildErrorState(posterProvider);
//                           }

//                           final categories = _extractUniqueCategories(
//                             posterProvider.posters,
//                           );

//                           if (categories.isEmpty) {
//                             return _buildEmptyState();
//                           }

//                           return _buildCategoryList(
//                             categories,
//                             posterProvider.posters,
//                             padding,
//                             isTablet,
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Voice search overlay
//               if (_isListening) _buildVoiceSearchOverlay(),
              
//               // Mic button
//               if (_isMicButtonVisible) _buildFloatingMicButton(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildVoiceSearchOverlay() {
//     return Positioned.fill(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
//         child: Container(
//           color: Colors.black.withOpacity(0.3),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Listening animation
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.blue.withOpacity(0.3),
//                       blurRadius: 20,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Pulsing animation
//                     ...List.generate(3, (index) {
//                       return AnimatedContainer(
//                         duration: Duration(milliseconds: 1500),
//                         width: 80 + (index * 30),
//                         height: 80 + (index * 30),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Colors.blue.withOpacity(0.3 - (index * 0.1)),
//                             width: 2,
//                           ),
//                         ),
//                       );
//                     }),
                    
//                     // Mic icon
//                     Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.mic,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 40),
              
//               // Listening text
//               Text(
//                 'Listening...',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
              
//               const SizedBox(height: 16),
              
//               // Recognized text
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 margin: const EdgeInsets.symmetric(horizontal: 40),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   _lastWords.isNotEmpty ? _lastWords : 'Speak now...',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: _lastWords.isNotEmpty ? Colors.blue : Colors.grey,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
              
//               const SizedBox(height: 20),
              
//               // Hint text
//               Text(
//                 'Tap anywhere to stop',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFloatingMicButton(BuildContext context) {
//     return Positioned(
//       bottom: 20,
//       right: 20,
//       child: Consumer<MyPlanProvider>(
//         builder: (context, myPlanProvider, child) {
//           return FloatingActionButton(
//             onPressed: () {
//               if (myPlanProvider.isPurchase == true) {
//                 _startListening();
//               } else {
//                 CommonModal.showWarning(
//                   context: context,
//                   title: "Premium Feature",
//                   message: "Voice search is a premium feature. Upgrade to unlock voice commands and advanced search capabilities.",
//                   primaryButtonText: "Upgrade Now",
//                   secondaryButtonText: "Cancel",
//                   onPrimaryPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SubscriptionPlansPage(),
//                       ),
//                     );
//                   },
//                   onSecondaryPressed: () => Navigator.of(context).pop(),
//                 );
//               }
//             },
//             backgroundColor: const Color(0xFF4F46E5),
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             elevation: 8,
//             child: const Icon(Icons.mic, size: 28),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildAppBar(double padding, bool isTablet) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: _showElevation
//             ? [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ]
//             : [],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(padding),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   AppText(
//                     'explore_templates',
//                     style: TextStyle(
//                       fontSize: isTablet ? 28 : 24,
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xFF1A1A1A),
//                       height: 1.2,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   AppText(
//                     'browse_or_voice_search',
//                     style: TextStyle(
//                       fontSize: isTablet ? 15 : 14,
//                       color: const Color(0xFF6B7280),
//                       fontWeight: FontWeight.w400,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12),
//             _buildSearchButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchButton() {
//     return Consumer<MyPlanProvider>(
//       builder: (context, myPlanprovider, child) {
//         return Material(
//           color: const Color(0xFF4F46E5),
//           borderRadius: BorderRadius.circular(12),
//           child: InkWell(
//             onTap: () async {
//               if (myPlanprovider.isPurchase == true) {
//                 // Show search modal with recent searches
//                 await _showSearchModal();
//               } else {
//                 CommonModal.showWarning(
//                   context: context,
//                   title: "Premium Category",
//                   message:
//                       "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
//                   primaryButtonText: "Upgrade Now",
//                   secondaryButtonText: "Cancel",
//                   onPrimaryPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SubscriptionPlansPage(),
//                       ),
//                     );
//                   },
//                   onSecondaryPressed: () => Navigator.of(context).pop(),
//                 );
//               }
//             },
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               child: const Icon(
//                 Icons.search_rounded,
//                 color: Colors.white,
//                 size: 22,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _showSearchModal() async {
//     await _loadRecentSearches();
    
//     String? searchQuery = await showModalBottomSheet<String?>(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       backgroundColor: Colors.white,
//       builder: (context) {
//         final searchController = TextEditingController();
//         String currentQuery = '';
        
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Container(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Header
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: searchController,
//                             autofocus: true,
//                             decoration: InputDecoration(
//                               hintText: 'Search templates...',
//                               prefixIcon: const Icon(Icons.search,
//                                   color: Color(0xFF6B7280)),
//                               suffixIcon: currentQuery.isNotEmpty
//                                   ? IconButton(
//                                       icon: const Icon(Icons.close),
//                                       onPressed: () {
//                                         searchController.clear();
//                                         setState(() => currentQuery = '');
//                                       },
//                                     )
//                                   : null,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                               filled: true,
//                               fillColor: const Color(0xFFF3F4F6),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 12,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               setState(() => currentQuery = value);
//                             },
//                             onSubmitted: (value) {
//                               if (value.trim().isNotEmpty) {
//                                 Navigator.pop(context, value.trim());
//                               }
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Consumer<MyPlanProvider>(
//                           builder: (context, myPlanProvider, child) {
//                             return Material(
//                               color: const Color(0xFF4F46E5),
//                               borderRadius: BorderRadius.circular(12),
//                               child: InkWell(
//                                 onTap: () {
//                                   if (myPlanProvider.isPurchase == true) {
//                                     Navigator.pop(context);
//                                     _startListening();
//                                   } else {
//                                     CommonModal.showWarning(
//                                       context: context,
//                                       title: "Premium Feature",
//                                       message:
//                                           "Voice search is a premium feature. Upgrade to unlock voice commands.",
//                                       primaryButtonText: "Upgrade Now",
//                                       secondaryButtonText: "Cancel",
//                                       onPrimaryPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 SubscriptionPlansPage(),
//                                           ),
//                                         );
//                                       },
//                                       onSecondaryPressed: () =>
//                                           Navigator.of(context).pop(),
//                                     );
//                                   }
//                                 },
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(12),
//                                   child: const Icon(
//                                     Icons.mic,
//                                     color: Colors.white,
//                                     size: 22,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
                  
//                   // Recent Searches Section
//                   if (_recentSearches.isNotEmpty)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Recent Searches',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF1F2937),
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: () async {
//                                   await RecentSearchHelper.clearRecentSearches();
//                                   await _loadRecentSearches();
//                                   setState(() {});
//                                 },
//                                 style: TextButton.styleFrom(
//                                   foregroundColor: Colors.red,
//                                   padding: EdgeInsets.zero,
//                                   minimumSize: Size.zero,
//                                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                                 ),
//                                 child: const Text(
//                                   'Clear All',
//                                   style: TextStyle(fontSize: 13),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: _recentSearches.length,
//                           itemBuilder: (context, index) {
//                             final search = _recentSearches[index];
//                             return ListTile(
//                               leading: const Icon(
//                                 Icons.history_rounded,
//                                 color: Color(0xFF6B7280),
//                                 size: 20,
//                               ),
//                               title: Text(
//                                 search,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xFF1F2937),
//                                 ),
//                               ),
//                               trailing: IconButton(
//                                 icon: const Icon(
//                                   Icons.close,
//                                   size: 16,
//                                   color: Color(0xFF9CA3AF),
//                                 ),
//                                 onPressed: () async {
//                                   await RecentSearchHelper.removeRecentSearch(search);
//                                   await _loadRecentSearches();
//                                   setState(() {});
//                                 },
//                                 padding: EdgeInsets.zero,
//                                 constraints: const BoxConstraints(),
//                               ),
//                               onTap: () {
//                                 Navigator.pop(context, search);
//                               },
//                               contentPadding:
//                                   const EdgeInsets.symmetric(horizontal: 20),
//                               minLeadingWidth: 0,
//                             );
//                           },
//                         ),
//                       ],
//                     ),
                  
//                   if (_recentSearches.isEmpty && !_isLoadingRecent)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 40),
//                       child: Column(
//                         children: [
//                           Icon(
//                             Icons.search_off_rounded,
//                             size: 48,
//                             color: Colors.grey.shade400,
//                           ),
//                           const SizedBox(height: 12),
//                           const Text(
//                             'No recent searches',
//                             style: TextStyle(
//                               color: Color(0xFF6B7280),
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
                  
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );

//     if (searchQuery != null && searchQuery.isNotEmpty) {
//       await RecentSearchHelper.addRecentSearch(searchQuery);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SearchScreen(initialQuery: searchQuery),
//         ),
//       );
//     }
//   }

//   // Rest of the methods remain the same...
//   // _buildCategoryList, _buildCategoryHeader, showSubscriptionModal, 
//   // _buildHorizontalPosterList, _buildPosterCard, _buildPlaceholder,
//   // _buildLoadingState, _buildErrorState, _buildEmptyState,
//   // _extractUniqueCategories, _getPostersByCategory, _capitalizeFirstLetter

//   Widget _buildCategoryList(
//     List<String> categories,
//     List<dynamic> posters,
//     double padding,
//     bool isTablet,
//   ) {
//     final itemWidth = isTablet ? 200.0 : 160.0;
//     final itemHeight = isTablet ? 220.0 : 180.0;

//     return ListView.builder(
//       controller: _scrollController,
//       physics: const BouncingScrollPhysics(),
//       padding: EdgeInsets.symmetric(vertical: padding),
//       itemCount: categories.length,
//       itemBuilder: (context, index) {
//         final category = categories[index];
//         final categoryPosters = _getPostersByCategory(category, posters);

//         return Padding(
//           padding: EdgeInsets.only(bottom: padding),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildCategoryHeader(category, padding, isTablet),
//               const SizedBox(height: 12),
//               SizedBox(
//                 height: itemHeight + 20,
//                 child: _buildHorizontalPosterList(
//                   categoryPosters,
//                   itemWidth,
//                   itemHeight,
//                   padding,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCategoryHeader(String category, double padding, bool isTablet) {
//     return Consumer<MyPlanProvider>(
//       builder: (context, myplanprovider, child) {
//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: padding),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 4,
//                       height: 20,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF4F46E5),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         _capitalizeFirstLetter(category),
//                         style: TextStyle(
//                           fontSize: isTablet ? 22 : 18,
//                           fontWeight: FontWeight.w700,
//                           color: const Color(0xFF1A1A1A),
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: () {
//                     if (myplanprovider.isPurchase == true) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               DetailsScreen(category: category),
//                         ),
//                       );
//                     } else {
//                       CommonModal.showWarning(
//                         context: context,
//                         title: "Premium Category",
//                         message:
//                             "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
//                         primaryButtonText: "Upgrade Now",
//                         secondaryButtonText: "Cancel",
//                         onPrimaryPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SubscriptionPlansPage(),
//                             ),
//                           );
//                         },
//                         onSecondaryPressed: () => Navigator.of(context).pop(),
//                       );
//                     }
//                   },
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F4F6),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const AppText(
//                           'view_all',
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF4F46E5),
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         const Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           size: 12,
//                           color: Color(0xFF4F46E5),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void showSubscriptionModal(BuildContext context) async {
//     final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

//     if (myPlanProvider.isPurchase == true) {
//       return;
//     }

//     final hasShownRecently = await ModalPreferences.hasShownSubscriptionModal();
//     final shouldShowAgain =
//         await ModalPreferences.shouldShowSubscriptionModalAgain(daysBetween: 7);

//     if (hasShownRecently && !shouldShowAgain) {
//       print('Subscription modal shown recently, skipping');
//       return;
//     }

//     final planProvider = Provider.of<GetAllPlanProvider>(
//       context,
//       listen: false,
//     );
//     if (planProvider.plans.isEmpty && !planProvider.isLoading) {
//       planProvider.fetchAllPlans();
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 400),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 30,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Header Section
//               Container(
//                 padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
//                 child: Column(
//                   children: [
//                     // Close Button
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade100,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.close,
//                             size: 18,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     // Premium Icon
//                     Container(
//                       width: 70,
//                       height: 70,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//                         ),
//                         borderRadius: BorderRadius.circular(18),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFFFFA500).withOpacity(0.3),
//                             blurRadius: 15,
//                             offset: const Offset(0, 6),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.workspace_premium_rounded,
//                         color: Colors.white,
//                         size: 36,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Title
//                     const Text(
//                       'Unlock Premium',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1F2937),
//                         letterSpacing: -0.5,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),

//                     const SizedBox(height: 6),

//                     // Subtitle
//                     Text(
//                       'Get unlimited access to all features',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
//                         height: 1.3,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Plans Section
//               Container(
//                 constraints: const BoxConstraints(maxHeight: 280),
//                 child: Consumer<GetAllPlanProvider>(
//                   builder: (context, provider, child) {
//                     if (provider.isLoading) {
//                       return const Padding(
//                         padding: EdgeInsets.all(40.0),
//                         child: Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CircularProgressIndicator(
//                                 color: Color(0xFF6366F1),
//                                 strokeWidth: 3,
//                               ),
//                               SizedBox(height: 12),
//                               Text(
//                                 'Loading plans...',
//                                 style: TextStyle(
//                                   color: Color(0xFF6B7280),
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }

//                     if (provider.error != null) {
//                       return Padding(
//                         padding: const EdgeInsets.all(24.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.error_outline_rounded,
//                               color: Colors.red.shade400,
//                               size: 48,
//                             ),
//                             const SizedBox(height: 12),
//                             const Text(
//                               'Unable to Load Plans',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF1F2937),
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               'Please try again',
//                               style: TextStyle(
//                                 color: Colors.grey.shade600,
//                                 fontSize: 13,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             ElevatedButton.icon(
//                               onPressed: () => provider.fetchAllPlans(),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF6366F1),
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 12,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 elevation: 0,
//                               ),
//                               icon: const Icon(Icons.refresh_rounded, size: 18),
//                               label: const Text(
//                                 'Try Again',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     if (provider.plans.isNotEmpty) {
//                       return SingleChildScrollView(
//                         padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//                         child: AnimatedPlanList(
//                           plans: provider.plans,
//                           onPlanSelected: (plan) {
//                             Navigator.of(context).pop();
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     PlanDetailsAndPaymentScreen(plan: plan),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }

//                     return Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.shopping_bag_outlined,
//                             size: 48,
//                             color: Colors.grey.shade400,
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'No Plans Available',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Please check back later',
//                             style: TextStyle(
//                               color: Colors.grey.shade500,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHorizontalPosterList(
//     List<CategoryModel> posters,
//     double itemWidth,
//     double itemHeight,
//     double padding,
//   ) {
//     if (posters.isEmpty) {
//       return Padding(
//         padding: EdgeInsets.symmetric(horizontal: padding),
//         child: Center(
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: const Color(0xFFE5E7EB)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.image_not_supported_outlined,
//                   color: Colors.grey.shade400,
//                   size: 32,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "No items available",
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       physics: const BouncingScrollPhysics(),
//       padding: EdgeInsets.symmetric(horizontal: padding),
//       itemCount: posters.length,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: EdgeInsets.only(right: index == posters.length - 1 ? 0 : 12),
//           child: _buildPosterCard(posters[index], itemWidth, itemHeight),
//         );
//       },
//     );
//   }

//   Widget _buildPosterCard(CategoryModel poster, double width, double height) {
//     return Consumer<MyPlanProvider>(
//       builder: (context, myplanProvider, child) {
//         return Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () {
//               if (myplanProvider.isPurchase == true) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         SamplePosterScreen(posterId: poster.id),
//                   ),
//                 );
//               } else {
//                 CommonModal.showWarning(
//                   context: context,
//                   title: "Premium Category",
//                   message:
//                       "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
//                   primaryButtonText: "Upgrade Now",
//                   secondaryButtonText: "Cancel",
//                   onPrimaryPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SubscriptionPlansPage(),
//                       ),
//                     );
//                   },
//                   onSecondaryPressed: () => Navigator.of(context).pop(),
//                 );
//               }
//             },
//             borderRadius: BorderRadius.circular(16),
//             child: Container(
//               width: width,
//               height: height,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.06),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Expanded(
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(16),
//                       ),
//                       child: poster.images.isNotEmpty
//                           ? Image.network(
//                               poster.images[0],
//                               fit: BoxFit.cover,
//                               loadingBuilder: (context, child, loadingProgress) {
//                                 if (loadingProgress == null) return child;
//                                 return Container(
//                                   color: const Color(0xFFF3F4F6),
//                                   child: Center(
//                                     child: SizedBox(
//                                       width: 24,
//                                       height: 24,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         color: const Color(0xFF4F46E5),
//                                         value:
//                                             loadingProgress
//                                                     .expectedTotalBytes !=
//                                                 null
//                                             ? loadingProgress
//                                                       .cumulativeBytesLoaded /
//                                                   loadingProgress
//                                                       .expectedTotalBytes!
//                                             : null,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                               errorBuilder: (context, error, stackTrace) =>
//                                   _buildPlaceholder(),
//                             )
//                           : _buildPlaceholder(),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             poster.categoryName,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF1A1A1A),
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           size: 12,
//                           color: Colors.grey.shade400,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPlaceholder() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             const Color(0xFF4F46E5).withOpacity(0.1),
//             const Color(0xFF7C3AED).withOpacity(0.1),
//           ],
//         ),
//       ),
//       child: const Center(
//         child: Icon(Icons.image_outlined, size: 48, color: Color(0xFF9CA3AF)),
//       ),
//     );
//   }

//   Widget _buildLoadingState(double padding, bool isTablet) {
//     final itemWidth = isTablet ? 200.0 : 160.0;
//     final itemHeight = isTablet ? 220.0 : 180.0;

//     return ListView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.all(padding),
//       itemCount: 3,
//       itemBuilder: (context, categoryIndex) {
//         return Padding(
//           padding: EdgeInsets.only(bottom: padding),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Shimmer.fromColors(
//                 baseColor: Colors.grey.shade200,
//                 highlightColor: Colors.grey.shade50,
//                 child: Container(
//                   width: 150,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               SizedBox(
//                 height: itemHeight + 20,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: 3,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 12),
//                       child: Shimmer.fromColors(
//                         baseColor: Colors.grey.shade200,
//                         highlightColor: Colors.grey.shade50,
//                         child: Container(
//                           width: itemWidth,
//                           height: itemHeight,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildErrorState(PosterProvider posterProvider) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFEE2E2),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.error_outline_rounded,
//                 color: Color(0xFFDC2626),
//                 size: 48,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Something went wrong',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A1A1A),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Unable to load categories at this time',
//               style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton.icon(
//               onPressed: () => posterProvider.fetchPosters(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF4F46E5),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 32,
//                   vertical: 16,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 0,
//               ),
//               icon: const Icon(Icons.refresh_rounded),
//               label: const Text(
//                 'Try Again',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF3F4F6),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.category_outlined,
//                 color: Color(0xFF9CA3AF),
//                 size: 48,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'No Categories Available',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A1A1A),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Check back later for new content',
//               style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<String> _extractUniqueCategories(List<dynamic> posters) {
//     final Set<String> categories = {};
//     for (var poster in posters) {
//       if (poster is CategoryModel && poster.categoryName.isNotEmpty) {
//         categories.add(poster.categoryName);
//       }
//     }
//     return categories.toList();
//   }

//   List<CategoryModel> _getPostersByCategory(
//     String category,
//     List<dynamic> allPosters,
//   ) {
//     return allPosters
//         .where(
//           (poster) =>
//               poster is CategoryModel &&
//               poster.categoryName.toLowerCase() == category.toLowerCase(),
//         )
//         .cast<CategoryModel>()
//         .toList();
//   }

//   String _capitalizeFirstLetter(String text) {
//     if (text.isEmpty) return '';
//     return text[0].toUpperCase() + text.substring(1);
//   }
// }


















import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:posternova/widgets/recent_search_helper.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:posternova/helper/sub_modal_helper.dart';
import 'package:posternova/models/category_model.dart';
import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
import 'package:posternova/providers/plans/get_all_plan_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/views/PosterModule/poster_making_screen.dart';
import 'package:posternova/views/category/category_detail_screen.dart';
import 'package:posternova/views/category/search_category.dart';
import 'package:posternova/views/subscription/payment_success_screen.dart';
import 'package:posternova/views/subscription/plan_detail_screen.dart';
import 'package:posternova/widgets/common_modal.dart';
import 'package:posternova/widgets/premium_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showElevation = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = '';
  bool _isMicButtonVisible = true;
  List<String> _recentSearches = [];
  bool _isLoadingRecent = true;
  Timer? _speechTimer;


final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scrollController.addListener(() {
      if (!mounted) return; // Add mounted check
      if (_scrollController.offset > 10 && !_showElevation) {
        setState(() => _showElevation = true);
      } else if (_scrollController.offset <= 10 && _showElevation) {
        setState(() => _showElevation = false);
      }
    });

    Future.microtask(() {
      if (!mounted) return; // Add mounted check
      Provider.of<PosterProvider>(context, listen: false).fetchPosters();
      _animationController.forward();
      _loadRecentSearches();
    });
  }

  Future<void> _loadRecentSearches() async {
    if (!mounted) return; // Add mounted check
    setState(() => _isLoadingRecent = true);
    final searches = await RecentSearchHelper.getRecentSearches();
    if (!mounted) return; // Add mounted check before setState
    setState(() {
      _recentSearches = searches;
      _isLoadingRecent = false;
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          _stopListening();
        }
      },
      onError: (error) {
        _showSpeechError(error.errorMsg);
      },
    );

    if (available) {
      if (!mounted) return; // Add mounted check
      setState(() {
        _isListening = true;
        _isMicButtonVisible = false;
      });
      
      _speech.listen(
        onResult: (result) {
          if (!mounted) return; // Add mounted check
          setState(() {
            _lastWords = result.recognizedWords;
          });
          
          // Start timer to stop listening after 3 seconds of silence
          _speechTimer?.cancel();
          _speechTimer = Timer(const Duration(seconds: 3), () {
            if (_isListening && mounted) { // Add mounted check
              _stopListening();
            }
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: 'en_US',
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
    } else {
      _showSpeechError('Speech recognition not available');
    }
  }

  void _stopListening() {
    _speechTimer?.cancel();
    _speech.stop();
    if (!mounted) return; // Add mounted check
    setState(() {
      _isListening = false;
      _isMicButtonVisible = true;
    });

    if (_lastWords.trim().isNotEmpty) {
      _performVoiceSearch(_lastWords);
    }
  }

  void _performVoiceSearch(String query) async {
    // Save to recent searches
    await RecentSearchHelper.addRecentSearch(query);
    await _loadRecentSearches();
    
    // Navigate to search screen with voice query
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(initialQuery: query),
        ),
      );
    }
    
    // Clear last words
    if (!mounted) return; // Add mounted check
    setState(() => _lastWords = '');
  }

  void _showSpeechError(String error) {
    if (!mounted) return; // Add mounted check
    setState(() {
      _isListening = false;
      _isMicButtonVisible = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Speech error: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_isListening) {
      _stopListening();
      return false;
    }
    
    if (Navigator.canPop(context)) {
      return true;
    }
    return await _showExitConfirmation();
  }

  Future<bool> _showExitConfirmation() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Exit App',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Exit'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void dispose() {
    // Cancel timer first
    _speechTimer?.cancel();
    
    // Stop speech recognition
    if (_isListening) {
      _speech.stop();
    }
    
    // Dispose controllers
    _animationController.dispose();
    _scrollController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final padding = isTablet ? 24.0 : 16.0;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Stack(
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    _buildAppBar(padding, isTablet),
                    Expanded(
                      child: Consumer<PosterProvider>(
                        builder: (context, posterProvider, child) {
                          if (posterProvider.isLoading) {
                            return _buildLoadingState(padding, isTablet);
                          }

                          if (posterProvider.error != null) {
                            return _buildErrorState(posterProvider);
                          }

                          final categories = _extractUniqueCategories(
                            posterProvider.posters,
                          );

                          if (categories.isEmpty) {
                            return _buildEmptyState();
                          }

                          return _buildCategoryList(
                            categories,
                            posterProvider.posters,
                            padding,
                            isTablet,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Voice search overlay
              if (_isListening) _buildVoiceSearchOverlay(),
              
              // Mic button
              if (_isMicButtonVisible) _buildFloatingMicButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceSearchOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _stopListening, // Allow tap to stop
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Listening animation
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulsing animation
                      ...List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 1500),
                          width: 80 + (index * 30),
                          height: 80 + (index * 30),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3 - (index * 0.1)),
                              width: 2,
                            ),
                          ),
                        );
                      }),
                      
                      // Mic icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Listening text
                const Text(
                  'Listening...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Recognized text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _lastWords.isNotEmpty ? _lastWords : 'Speak now...',
                    style: TextStyle(
                      fontSize: 18,
                      color: _lastWords.isNotEmpty ? Colors.blue : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Hint text
                Text(
                  'Tap anywhere to stop',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingMicButton(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Consumer<MyPlanProvider>(
        builder: (context, myPlanProvider, child) {
          return FloatingActionButton(
            onPressed: () {
              if (myPlanProvider.isPurchase == true) {
                _startListening();
              } else {
                CommonModal.showWarning(
                  context: context,
                  title: "Premium Feature",
                  message: "Voice search is a premium feature. Upgrade to unlock voice commands and advanced search capabilities.",
                  primaryButtonText: "Upgrade Now",
                  secondaryButtonText: "Cancel",
                  onPrimaryPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionPlansPage(),
                      ),
                    );
                  },
                  onSecondaryPressed: () => Navigator.of(context).pop(),
                );
              }
            },
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: const Icon(Icons.mic, size: 28),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(double padding, bool isTablet) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: _showElevation
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    'explore_templates',
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    'browse_or_voice_search',
                    style: TextStyle(
                      fontSize: isTablet ? 15 : 14,
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Consumer<MyPlanProvider>(
      builder: (context, myPlanprovider, child) {
        return Material(
          color: const Color(0xFF4F46E5),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () async {
              if (myPlanprovider.isPurchase == true) {
                // Show search modal with recent searches
                await _showSearchModal();
              } else {
                CommonModal.showWarning(
                  context: context,
                  title: "Premium Category",
                  message:
                      "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
                  primaryButtonText: "Upgrade Now",
                  secondaryButtonText: "Cancel",
                  onPrimaryPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionPlansPage(),
                      ),
                    );
                  },
                  onSecondaryPressed: () => Navigator.of(context).pop(),
                );
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSearchModal() async {
    await _loadRecentSearches();
    
    if (!mounted) return; // Add mounted check before showing modal
    
    String? searchQuery = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        final searchController = TextEditingController();
        String currentQuery = '';
        
        return StatefulBuilder(
          builder: (context, setModalState) { // Renamed to avoid confusion
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Search templates...',
                              prefixIcon: const Icon(Icons.search,
                                  color: Color(0xFF6B7280)),
                              suffixIcon: currentQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        searchController.clear();
                                        setModalState(() => currentQuery = '');
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF3F4F6),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onChanged: (value) {
                              setModalState(() => currentQuery = value);
                            },
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                Navigator.pop(context, value.trim());
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Consumer<MyPlanProvider>(
                          builder: (context, myPlanProvider, child) {
                            return Material(
                              color: const Color(0xFF4F46E5),
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: () {
                                  if (myPlanProvider.isPurchase == true) {
                                    Navigator.pop(context);
                                    _startListening();
                                  } else {
                                    CommonModal.showWarning(
                                      context: context,
                                      title: "Premium Feature",
                                      message:
                                          "Voice search is a premium feature. Upgrade to unlock voice commands.",
                                      primaryButtonText: "Upgrade Now",
                                      secondaryButtonText: "Cancel",
                                      onPrimaryPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SubscriptionPlansPage(),
                                          ),
                                        );
                                      },
                                      onSecondaryPressed: () =>
                                          Navigator.of(context).pop(),
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: const Icon(
                                    Icons.mic,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  // Recent Searches Section
                  if (_recentSearches.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Searches',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await RecentSearchHelper.clearRecentSearches();
                                  await _loadRecentSearches();
                                  setModalState(() {});
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Clear All',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _recentSearches.length,
                          itemBuilder: (context, index) {
                            final search = _recentSearches[index];
                            return ListTile(
                              leading: const Icon(
                                Icons.history_rounded,
                                color: Color(0xFF6B7280),
                                size: 20,
                              ),
                              title: Text(
                                search,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Color(0xFF9CA3AF),
                                ),
                                onPressed: () async {
                                  await RecentSearchHelper.removeRecentSearch(search);
                                  await _loadRecentSearches();
                                  setModalState(() {});
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              onTap: () {
                                Navigator.pop(context, search);
                              },
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              minLeadingWidth: 0,
                            );
                          },
                        ),
                      ],
                    ),
                  
                  if (_recentSearches.isEmpty && !_isLoadingRecent)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No recent searches',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );

    if (searchQuery != null && searchQuery.isNotEmpty && mounted) {
      await RecentSearchHelper.addRecentSearch(searchQuery);
      if (!mounted) return; // Check again before navigation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(initialQuery: searchQuery),
        ),
      );
    }
  }

  Widget _buildCategoryList(
    List<String> categories,
    List<dynamic> posters,
    double padding,
    bool isTablet,
  ) {
    final itemWidth = isTablet ? 200.0 : 160.0;
    final itemHeight = isTablet ? 220.0 : 180.0;

    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: padding),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryPosters = _getPostersByCategory(category, posters);

        return Padding(
          padding: EdgeInsets.only(bottom: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryHeader(category, padding, isTablet),
              const SizedBox(height: 12),
              SizedBox(
                height: itemHeight + 20,
                child: _buildHorizontalPosterList(
                  categoryPosters,
                  itemWidth,
                  itemHeight,
                  padding,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryHeader(String category, double padding, bool isTablet) {
    return Consumer<MyPlanProvider>(
      builder: (context, myplanprovider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _capitalizeFirstLetter(category),
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (myplanprovider.isPurchase == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailsScreen(category: category),
                        ),
                      );
                    } else {
                      CommonModal.showWarning(
                        context: context,
                        title: "Premium Category",
                        message:
                            "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
                        primaryButtonText: "Upgrade Now",
                        secondaryButtonText: "Cancel",
                        onPrimaryPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubscriptionPlansPage(),
                            ),
                          );
                        },
                        onSecondaryPressed: () => Navigator.of(context).pop(),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppText(
                          'view_all',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: Color(0xFF4F46E5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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

    if (!mounted) return; // Add mounted check before using context

    final planProvider = Provider.of<GetAllPlanProvider>(
      context,
      listen: false,
    );
    if (planProvider.plans.isEmpty && !planProvider.isLoading) {
      planProvider.fetchAllPlans();
    }

    if (!mounted) return; // Add mounted check before showing dialog

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  children: [
                    // Close Button
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Premium Icon
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFA500).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Title
                    const Text(
                      'Unlock Premium',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 6),

                    // Subtitle
                    Text(
                      'Get unlimited access to all features',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Plans Section
              Container(
                constraints: const BoxConstraints(maxHeight: 280),
                child: Consumer<GetAllPlanProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF6366F1),
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Loading plans...',
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (provider.error != null) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: Colors.red.shade400,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Unable to Load Plans',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Please try again',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => provider.fetchAllPlans(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (provider.plans.isNotEmpty) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: AnimatedPlanList(
                          plans: provider.plans,
                          onPlanSelected: (plan) {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlanDetailsAndPaymentScreen(plan: plan),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Plans Available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Please check back later',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalPosterList(
    List<CategoryModel> posters,
    double itemWidth,
    double itemHeight,
    double padding,
  ) {
    if (posters.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey.shade400,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  "No items available",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding),
      itemCount: posters.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: index == posters.length - 1 ? 0 : 12),
          child: _buildPosterCard(posters[index], itemWidth, itemHeight),
        );
      },
    );
  }

  Widget _buildPosterCard(CategoryModel poster, double width, double height) {
    return Consumer<MyPlanProvider>(
      builder: (context, myplanProvider, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (myplanProvider.isPurchase == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SamplePosterScreen(posterId: poster.id),
                  ),
                );
              } else {
                CommonModal.showWarning(
                  context: context,
                  title: "Premium Category",
                  message:
                      "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
                  primaryButtonText: "Upgrade Now",
                  secondaryButtonText: "Cancel",
                  onPrimaryPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionPlansPage(),
                      ),
                    );
                  },
                  onSecondaryPressed: () => Navigator.of(context).pop(),
                );
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: poster.images.isNotEmpty
                          ? Image.network(
                              poster.images[0],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: const Color(0xFFF3F4F6),
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: const Color(0xFF4F46E5),
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            poster.categoryName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4F46E5).withOpacity(0.1),
            const Color(0xFF7C3AED).withOpacity(0.1),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 48, color: Color(0xFF9CA3AF)),
      ),
    );
  }

  Widget _buildLoadingState(double padding, bool isTablet) {
    final itemWidth = isTablet ? 200.0 : 160.0;
    final itemHeight = isTablet ? 220.0 : 180.0;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(padding),
      itemCount: 3,
      itemBuilder: (context, categoryIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade50,
                child: Container(
                  width: 150,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: itemHeight + 20,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade50,
                        child: Container(
                          width: itemWidth,
                          height: itemHeight,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState(PosterProvider posterProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFDC2626),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Unable to load categories at this time',
              style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => posterProvider.fetchPosters(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
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
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Try Again',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.category_outlined,
                color: Color(0xFF9CA3AF),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Categories Available',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Check back later for new content',
              style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<String> _extractUniqueCategories(List<dynamic> posters) {
    final Set<String> categories = {};
    for (var poster in posters) {
      if (poster is CategoryModel && poster.categoryName.isNotEmpty) {
        categories.add(poster.categoryName);
      }
    }
    return categories.toList();
  }

  List<CategoryModel> _getPostersByCategory(
    String category,
    List<dynamic> allPosters,
  ) {
    return allPosters
        .where(
          (poster) =>
              poster is CategoryModel &&
              poster.categoryName.toLowerCase() == category.toLowerCase(),
        )
        .cast<CategoryModel>()
        .toList();
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }
}