// // ignore_for_file: prefer_const_constructors_in_immutables, avoid_unnecessary_containers

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:posternova/views/createposter/create_poster_screen.dart';
// import 'package:posternova/views/createposter/logo_maker_screen.dart';
// import 'package:posternova/views/logo/logo_screen.dart';

// class PosterScreen extends StatefulWidget {
//   const PosterScreen({super.key});

//   @override
//   State<PosterScreen> createState() => _PosterScreenState();
// }

// class _PosterScreenState extends State<PosterScreen> with TickerProviderStateMixin {
//   late AnimationController _headerController;
//   late AnimationController _cardController;
//   late Animation<double> _headerFadeAnimation;
//   late Animation<Offset> _headerSlideAnimation;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();

//     _headerController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _cardController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );

//     _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _headerController,
//         curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
//       ),
//     );

//     _headerSlideAnimation = Tween<Offset>(
//       begin: const Offset(0, -0.5),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _headerController,
//         curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
//       ),
//     );

//     _headerController.forward();
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (mounted) _cardController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _headerController.dispose();
//     _cardController.dispose();
//     super.dispose();
//   }

//   Future<bool> _onWillPop() async {
//     if (Navigator.canPop(context)) {
//       return true;
//     } else {
//       return await _showExitConfirmation();
//     }
//   }

//   Future<bool> _showExitConfirmation() async {
//     return await showDialog<bool>(
//           context: context,
//           builder: (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             title: const Text(
//               'Exit App',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             content: const Text(
//               'Are you sure you want to exit?',
//               style: TextStyle(fontSize: 16),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   SystemNavigator.pop();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2563EB),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: const Text(
//                   'Exit',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF8FAFC),
//         body: SafeArea(
//           child: Column(
//             children: [
//               _buildModernHeader(),
//               Expanded(
//                 child: _buildContentSection(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildModernHeader() {
//     return SlideTransition(
//       position: _headerSlideAnimation,
//       child: FadeTransition(
//         opacity: _headerFadeAnimation,
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Color(0xFF2563EB),
//                             Color(0xFF3B82F6),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF2563EB).withOpacity(0.3),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.auto_awesome,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Design Studio',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF0F172A),
//                               height: 1.2,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'Create amazing content',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Color(0xFF64748B),
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 1,
//                 color: Colors.grey[200],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContentSection() {
//     return AnimatedBuilder(
//       animation: _cardController,
//       builder: (context, child) {
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 8),
//               const Text(
//                 'What do you want to create?',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF0F172A),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Choose a tool to get started',
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Color(0xFF64748B),
//                 ),
//               ),
//               const SizedBox(height: 28),
//               _buildToolsList(),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildToolsList() {
//     final tools = [
//       ToolData(
//         icon: Icons.collections,
//         title: 'Poster Maker',
//         subtitle: 'Design beautiful posters',
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
//         ),
//         screen: CreatePost(),
//       ),
//       ToolData(
//         icon: Icons.wb_sunny_outlined,
//         title: 'Logo Designer',
//         subtitle: 'Create professional logos',
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF10B981), Color(0xFF059669)],
//         ),
//         screen: const LogoMakingScreen(),
//       ),
//       // ToolData(
//       //   icon: Icons.video_library_outlined,
//       //   title: 'Photo to Video',
//       //   subtitle: 'Transform photos into videos',
//       //   gradient: const LinearGradient(
//       //     begin: Alignment.topLeft,
//       //     end: Alignment.bottomRight,
//       //     colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
//       //   ),
//       //   screen: const ComingSoonScreen(),
//       // ),
//     ];

//     return Column(
//       children: tools.asMap().entries.map((entry) {
//         final index = entry.key;
//         final tool = entry.value;
//         final delay = index * 150;

//         return AnimatedBuilder(
//           animation: _cardController,
//           builder: (context, child) {
//             final slideAnimation = Tween<Offset>(
//               begin: const Offset(0.3, 0),
//               end: Offset.zero,
//             ).animate(
//               CurvedAnimation(
//                 parent: _cardController,
//                 curve: Interval(
//                   (delay / 1200).clamp(0.0, 1.0),
//                   ((delay + 600) / 1200).clamp(0.0, 1.0),
//                   curve: Curves.easeOutCubic,
//                 ),
//               ),
//             );

//             final fadeAnimation = Tween<double>(
//               begin: 0.0,
//               end: 1.0,
//             ).animate(
//               CurvedAnimation(
//                 parent: _cardController,
//                 curve: Interval(
//                   (delay / 1200).clamp(0.0, 1.0),
//                   ((delay + 600) / 1200).clamp(0.0, 1.0),
//                   curve: Curves.easeOut,
//                 ),
//               ),
//             );

//             return SlideTransition(
//               position: slideAnimation,
//               child: FadeTransition(
//                 opacity: fadeAnimation,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: _buildToolCard(tool, index),
//                 ),
//               ),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildToolCard(ToolData tool, int index) {
//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.lightImpact();
//         setState(() => _selectedIndex = index);
//         Future.delayed(const Duration(milliseconds: 200), () {
//           Navigator.push(
//             context,
//             PageRouteBuilder(
//               pageBuilder: (context, animation, secondaryAnimation) => tool.screen,
//               transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                 final curvedAnimation = CurvedAnimation(
//                   parent: animation,
//                   curve: Curves.easeOutCubic,
//                 );

//                 return FadeTransition(
//                   opacity: curvedAnimation,
//                   child: SlideTransition(
//                     position: Tween<Offset>(
//                       begin: const Offset(0.05, 0),
//                       end: Offset.zero,
//                     ).animate(curvedAnimation),
//                     child: child,
//                   ),
//                 );
//               },
//               transitionDuration: const Duration(milliseconds: 400),
//             ),
//           ).then((_) {
//             if (mounted) setState(() => _selectedIndex = -1);
//           });
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         curve: Curves.easeOut,
//         transform: Matrix4.identity()
//           ..scale(_selectedIndex == index ? 0.97 : 1.0),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.06),
//                 blurRadius: 12,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 56,
//                 height: 56,
//                 decoration: BoxDecoration(
//                   gradient: tool.gradient,
//                   borderRadius: BorderRadius.circular(14),
//                   boxShadow: [
//                     BoxShadow(
//                       color: tool.gradient.colors.first.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   tool.icon,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       tool.title,
//                       style: const TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF0F172A),
//                         height: 1.3,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       tool.subtitle,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Color(0xFF64748B),
//                         height: 1.4,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF1F5F9),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(
//                   Icons.arrow_forward_ios,
//                   size: 16,
//                   color: Color(0xFF64748B),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ToolData {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final Gradient gradient;
//   final Widget screen;

//   const ToolData({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.gradient,
//     required this.screen,
//   });
// }

// ignore_for_file: prefer_const_constructors_in_immutables, avoid_unnecessary_containers

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posternova/helper/sub_modal_helper.dart';
import 'package:posternova/providers/plans/get_all_plan_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/views/createposter/create_poster_screen.dart';
import 'package:posternova/views/createposter/logo_maker_screen.dart';
import 'package:posternova/views/logo/logo_screen.dart';
import 'package:posternova/views/subscription/payment_success_screen.dart';
import 'package:posternova/views/subscription/plan_detail_screen.dart';
import 'package:posternova/widgets/common_modal.dart';
import 'package:posternova/widgets/premium_widget.dart';
import 'package:provider/provider.dart';

class PosterScreen extends StatefulWidget {
  const PosterScreen({super.key});

  @override
  State<PosterScreen> createState() => _PosterScreenState();
}

class _PosterScreenState extends State<PosterScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerController,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
          ),
        );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _cardController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (Navigator.canPop(context)) {
      return true;
    } else {
      return await _showExitConfirmation();
    }
  }

  Future<bool> _showExitConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Exit App',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            content: const Text(
              'Are you sure you want to exit?',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Exit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
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

    final planProvider = Provider.of<GetAllPlanProvider>(
      context,
      listen: false,
    );
    if (planProvider.plans.isEmpty && !planProvider.isLoading) {
      planProvider.fetchAllPlans();
    }

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
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  children: [
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
                        child: Column(
                          children: provider.plans.map((plan) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PlanDetailsAndPaymentScreen(
                                            plan: plan,
                                          ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6366F1),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  plan.name ?? 'Plan',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Column(
            children: [
              _buildModernHeader(),
              Expanded(child: _buildContentSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return SlideTransition(
      position: _headerSlideAnimation,
      child: FadeTransition(
        opacity: _headerFadeAnimation,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Design Studio',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Create amazing content',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: Colors.grey[200]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return AnimatedBuilder(
      animation: _cardController,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'What do you want to create?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose a tool to get started',
                style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 28),
              _buildToolsList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToolsList() {
    final tools = [
      ToolData(
        icon: Icons.collections,
        title: 'Poster Maker',
        subtitle: 'Design beautiful posters',
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
        ),
        screen: CreatePost(),
      ),
      ToolData(
        icon: Icons.wb_sunny_outlined,
        title: 'Logo Designer',
        subtitle: 'Create professional logos',
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        ),
        screen: const LogoMakingScreen(),
      ),
    ];

    return Column(
      children: tools.asMap().entries.map((entry) {
        final index = entry.key;
        final tool = entry.value;
        final delay = index * 150;

        return AnimatedBuilder(
          animation: _cardController,
          builder: (context, child) {
            final slideAnimation =
                Tween<Offset>(
                  begin: const Offset(0.3, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _cardController,
                    curve: Interval(
                      (delay / 1200).clamp(0.0, 1.0),
                      ((delay + 600) / 1200).clamp(0.0, 1.0),
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                );

            final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _cardController,
                curve: Interval(
                  (delay / 1200).clamp(0.0, 1.0),
                  ((delay + 600) / 1200).clamp(0.0, 1.0),
                  curve: Curves.easeOut,
                ),
              ),
            );

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildToolCard(tool, index),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildToolCard(ToolData tool, int index) {
    return Consumer<MyPlanProvider>(
      builder: (context, myPlanProvider, child) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() => _selectedIndex = index);

            // Check subscription status
            if (myPlanProvider.isPurchase == true) {
              // User has premium, allow access
              Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        tool.screen,
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          final curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          );

                          return FadeTransition(
                            opacity: curvedAnimation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.05, 0),
                                end: Offset.zero,
                              ).animate(curvedAnimation),
                              child: child,
                            ),
                          );
                        },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                ).then((_) {
                  if (mounted) setState(() => _selectedIndex = -1);
                });
              });
            } else {
              // User doesn't have premium, show upgrade modal
              setState(() => _selectedIndex = -1);
              CommonModal.showWarning(
                context: context,
                title: "Premium Feature",
                message:
                    "Unlock ${tool.title} and other premium features by upgrading to a premium plan.",
                primaryButtonText: "Upgrade Now",
                secondaryButtonText: "Cancel",
                onPrimaryPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubscriptionPlansPage(),
                    ),
                  );
                  // showSubscriptionModal(context);
                },
                onSecondaryPressed: () => Navigator.of(context).pop(),
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..scale(_selectedIndex == index ? 0.97 : 1.0),
            child: Container(
              padding: const EdgeInsets.all(20),
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
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: tool.gradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: tool.gradient.colors.first.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(tool.icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tool.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tool.subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFF64748B),
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
}

class ToolData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final Widget screen;

  const ToolData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.screen,
  });
}
