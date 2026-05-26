// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:posternova/views/backgroundremover/background_remover.dart';
// import 'package:posternova/views/business/business_card_screen.dart';
// import 'package:posternova/views/category/category_screen.dart';
// import 'package:posternova/views/createposter/create_poster_screen.dart';
// import 'package:posternova/views/invoices/add_invoice_data.dart';
// import 'package:posternova/views/logo/logo_category.dart';
// import 'package:posternova/views/onlinepunchang/online_punchang_screen.dart';
// import 'package:posternova/views/textremover/textremover.dart';

// class CategoryItem {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final List<Color> gradient;
//   final Widget destination;
//   final String emoji;

//   const CategoryItem({
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.gradient,
//     required this.destination,
//     required this.emoji,
//   });
// }

// // ─── Main Screen ──────────────────────────────────────────────────────────────

// class SpecialCategory extends StatefulWidget {
//   const SpecialCategory({super.key});

//   @override
//   State<SpecialCategory> createState() => _SpecialCategoryState();
// }

// class _SpecialCategoryState extends State<SpecialCategory>
//     with TickerProviderStateMixin {
//   late AnimationController _headerController;
//   late AnimationController _floatingController;
//   late Animation<double> _headerFade;
//   late Animation<Offset> _headerSlide;
//   late Animation<double> _floatingAnim;

//   static final List<CategoryItem> categories = [
//     CategoryItem(
//       title: 'Online Panchang',
//       subtitle: 'Daily almanac & astro',
//       icon: Icons.auto_awesome,
//       emoji: '🌙',
//       gradient: [const Color(0xFFFF6B6B), const Color(0xFFFF4E50)],
//       destination: OnlinePunchangScreen(),
//     ),
//     CategoryItem(
//       title: 'Poster Template',
//       subtitle: 'Browse all topics',
//       icon: Icons.grid_view_rounded,
//       emoji: '🗂️',
//       gradient: [const Color(0xFF059669), const Color(0xFF0D9488)],
//       destination: const CategoryScreen(),
//     ),
//     CategoryItem(
//       title: 'Create Template',
//       subtitle: 'Design your own poster',
//       icon: Icons.design_services_rounded,
//       emoji: '🎨',
//       gradient: [const Color(0xFF8B5CF6), const Color(0xFFEC4899)],
//       destination: const CreatePost(),
//     ),

//     CategoryItem(
//       title: 'Logo Maker',
//       subtitle: 'Create your brand logo',
//       icon: Icons.workspace_premium_rounded,
//       emoji: '🏷️',
//       gradient: [const Color(0xFF2563EB), const Color(0xFF06B6D4)],
//       destination: const LogoCategory(),
//     ),

//     CategoryItem(
//       title: 'BG Remover',
//       subtitle: 'AI-powered editing',
//       icon: Icons.auto_fix_high,
//       emoji: '✨',
//       gradient: [const Color(0xFF7C3AED), const Color(0xFF4F46E5)],
//       destination: const BackgroundRemoverScreen(),
//     ),

//     CategoryItem(
//       title: 'Text Remover',
//       subtitle: 'Create your brand logo',
//       icon: Icons.text_format,
//       emoji: '🏷️',
//       gradient: [const Color(0xFF2563EB), const Color(0xFF06B6D4)],
//       destination: const WebViewScreen(),
//     ),

//     CategoryItem(
//       title: 'Sticker',
//       subtitle: 'Create your brand logo',
//       icon: Icons.workspace_premium_rounded,
//       emoji: '🏷️',
//       gradient: [const Color(0xFF2563EB), const Color(0xFF06B6D4)],
//       destination: const LogoCategory(),
//     ),

//     CategoryItem(
//       title: 'Business Card',
//       subtitle: 'Create your brand logo',
//       icon: Icons.workspace_premium_rounded,
//       emoji: '🏷️',
//       gradient: [const Color(0xFF2563EB), const Color(0xFF06B6D4)],
//       destination: const BusinessCardScreen(),
//     ),

//     // CategoryItem(
//     //   title: 'Invoices',
//     //   subtitle: 'Manage & track bills',
//     //   icon: Icons.receipt_long_rounded,
//     //   emoji: '🧾',
//     //   gradient: [const Color(0xFFEA580C), const Color(0xFFF59E0B)],
//     //   destination: const AddInvoiceData(),
//     // ),
//   ];

//   @override
//   void initState() {
//     super.initState();

//     _headerController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//     _floatingController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat(reverse: true);

//     _headerFade = CurvedAnimation(
//       parent: _headerController,
//       curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
//     );
//     _headerSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _headerController,
//             curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
//           ),
//         );
//     _floatingAnim = Tween<double>(begin: -6, end: 6).animate(
//       CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
//     );

//     _headerController.forward();
//   }

//   @override
//   void dispose() {
//     _headerController.dispose();
//     _floatingController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0F),
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // ── Animated App Bar ──────────────────────────────────────────
//           SliverAppBar(
//             expandedHeight: 240,
//             pinned: true,
//             stretch: true,
//             backgroundColor: const Color(0xFF0A0A0F),
//             elevation: 0,
//             flexibleSpace: FlexibleSpaceBar(
//               stretchModes: const [StretchMode.zoomBackground],
//               background: _buildHeader(),
//             ),
//           ),

//           // ── Section Label ─────────────────────────────────────────────
//           SliverToBoxAdapter(
//             child: FadeTransition(
//               opacity: _headerFade,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 4,
//                       height: 18,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(2),
//                         gradient: const LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     const Text(
//                       'Quick Access',
//                       style: TextStyle(
//                         color: Color(0xFF94A3B8),
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // ── Grid ─────────────────────────────────────────────────────
//           SliverPadding(
//             padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
//             sliver: SliverGrid(
//               delegate: SliverChildBuilderDelegate((context, index) {
//                 return _AnimatedCard(
//                   item: categories[index],
//                   index: index,
//                   floatingAnim: _floatingAnim,
//                   parentController: _headerController,
//                 );
//               }, childCount: categories.length),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 14,
//                 mainAxisSpacing: 14,
//                 childAspectRatio: 0.79,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return AnimatedBuilder(
//       animation: _floatingAnim,
//       builder: (context, _) {
//         return Container(
//           decoration: const BoxDecoration(color: Color(0xFF0A0A0F)),
//           child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               // Glowing background orbs
//               Positioned(
//                 top: 20,
//                 right: -40,
//                 child: Transform.translate(
//                   offset: Offset(0, _floatingAnim.value * 0.5),
//                   child: Container(
//                     width: 200,
//                     height: 200,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           const Color(0xFF7C3AED).withOpacity(0.35),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 60,
//                 left: -30,
//                 child: Transform.translate(
//                   offset: Offset(0, -_floatingAnim.value * 0.3),
//                   child: Container(
//                     width: 140,
//                     height: 140,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           const Color(0xFFEC4899).withOpacity(0.25),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 10,
//                 right: 60,
//                 child: Transform.translate(
//                   offset: Offset(0, _floatingAnim.value * 0.7),
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           const Color(0xFF0EA5E9).withOpacity(0.3),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               // Floating stars / sparkles
//               ..._buildSparkles(),

//               // Header text
//               Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
//                   child: SlideTransition(
//                     position: _headerSlide,
//                     child: FadeTransition(
//                       opacity: _headerFade,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Badge
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 5,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
//                               ),
//                             ),
//                             child: const Text(
//                               '⚡ SPECIAL',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: 1.5,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           const Text(
//                             'Explore\nCategories',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 34,
//                               fontWeight: FontWeight.w900,
//                               letterSpacing: -1.0,
//                               height: 1.1,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Tap any card to unlock features',
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.5),
//                               fontSize: 13,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
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

//   List<Widget> _buildSparkles() {
//     final positions = [
//       [0.75, 0.15],
//       [0.85, 0.50],
//       [0.60, 0.70],
//       [0.40, 0.10],
//     ];
//     return List.generate(positions.length, (i) {
//       return AnimatedBuilder(
//         animation: _floatingController,
//         builder: (context, _) {
//           final t = (_floatingController.value + i * 0.25) % 1.0;
//           final opacity = (math.sin(t * math.pi * 2) * 0.5 + 0.5).clamp(
//             0.2,
//             1.0,
//           );
//           return Positioned(
//             right: MediaQuery.of(context).size.width * (1 - positions[i][0]),
//             top: 240 * positions[i][1],
//             child: Opacity(
//               opacity: opacity,
//               child: Text(
//                 i.isEven ? '✦' : '·',
//                 style: TextStyle(
//                   color: i.isEven
//                       ? const Color(0xFFEC4899)
//                       : const Color(0xFF7C3AED),
//                   fontSize: i.isEven ? 14 : 20,
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
// }

// // ─── Animated Card ────────────────────────────────────────────────────────────

// class _AnimatedCard extends StatefulWidget {
//   final CategoryItem item;
//   final int index;
//   final Animation<double> floatingAnim;
//   final AnimationController parentController;

//   const _AnimatedCard({
//     required this.item,
//     required this.index,
//     required this.floatingAnim,
//     required this.parentController,
//   });

//   @override
//   State<_AnimatedCard> createState() => _AnimatedCardState();
// }

// class _AnimatedCardState extends State<_AnimatedCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _pressController;
//   late Animation<double> _scaleAnim;
//   late Animation<double> _entryAnim;
//   bool _isPressed = false;

//   @override
//   void initState() {
//     super.initState();

//     _pressController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 130),
//     );
//     _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
//       CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
//     );

//     // Staggered entry animation
//     final delay = widget.index * 0.12;
//     _entryAnim = CurvedAnimation(
//       parent: widget.parentController,
//       curve: Interval(
//         (0.2 + delay).clamp(0.0, 0.9),
//         (0.7 + delay).clamp(0.1, 1.0),
//         curve: Curves.easeOutBack,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _pressController.dispose();
//     super.dispose();
//   }

//   void _onTapDown(TapDownDetails _) {
//     setState(() => _isPressed = true);
//     _pressController.forward();
//   }

//   void _onTapUp(TapUpDetails _) {
//     setState(() => _isPressed = false);
//     _pressController.reverse();
//   }

//   void _onTapCancel() {
//     setState(() => _isPressed = false);
//     _pressController.reverse();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final item = widget.item;
//     final isEven = widget.index.isEven;

//     return AnimatedBuilder(
//       animation: Listenable.merge([
//         _scaleAnim,
//         _entryAnim,
//         widget.floatingAnim,
//       ]),
//       builder: (_, child) {
//         final floatOffset = isEven
//             ? widget.floatingAnim.value * 0.4
//             : -widget.floatingAnim.value * 0.4;

//         return Transform.translate(
//           offset: Offset(0, floatOffset),
//           child: Transform.scale(
//             scale: _scaleAnim.value,
//             child: ScaleTransition(scale: _entryAnim, child: child),
//           ),
//         );
//       },
//       child: GestureDetector(
//         onTapDown: _onTapDown,
//         onTapUp: _onTapUp,
//         onTapCancel: _onTapCancel,
//         onTap: () {
//           Navigator.push(
//             context,
//             PageRouteBuilder(
//               pageBuilder: (_, animation, __) => item.destination,
//               transitionsBuilder: (_, animation, __, child) {
//                 return FadeTransition(
//                   opacity: animation,
//                   child: SlideTransition(
//                     position:
//                         Tween<Offset>(
//                           begin: const Offset(0, 0.06),
//                           end: Offset.zero,
//                         ).animate(
//                           CurvedAnimation(
//                             parent: animation,
//                             curve: Curves.easeOutCubic,
//                           ),
//                         ),
//                     child: child,
//                   ),
//                 );
//               },
//               transitionDuration: const Duration(milliseconds: 380),
//             ),
//           );
//         },
//         child: _CardContent(item: item, isPressed: _isPressed),
//       ),
//     );
//   }
// }

// // ─── Card Content ─────────────────────────────────────────────────────────────

// class _CardContent extends StatelessWidget {
//   final CategoryItem item;
//   final bool isPressed;

//   const _CardContent({required this.item, required this.isPressed});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(28),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             item.gradient[0].withOpacity(0.15),
//             item.gradient[1].withOpacity(0.08),
//           ],
//         ),
//         border: Border.all(
//           color: item.gradient[0].withOpacity(isPressed ? 0.6 : 0.3),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: item.gradient[0].withOpacity(isPressed ? 0.35 : 0.2),
//             blurRadius: isPressed ? 24 : 16,
//             spreadRadius: isPressed ? 2 : 0,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(28),
//         child: Stack(
//           children: [
//             // Mesh gradient background
//             Positioned(
//               top: -30,
//               right: -30,
//               child: Container(
//                 width: 110,
//                 height: 110,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       item.gradient[0].withOpacity(0.4),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: -20,
//               left: -20,
//               child: Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       item.gradient[1].withOpacity(0.3),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Card content
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Icon + emoji row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Gradient icon container
//                       Container(
//                         width: 54,
//                         height: 54,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: item.gradient,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: item.gradient[0].withOpacity(0.5),
//                               blurRadius: 12,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Icon(item.icon, color: Colors.white, size: 26),
//                       ),
//                       // Arrow badge
//                       Container(
//                         width: 28,
//                         height: 28,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white.withOpacity(0.07),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.12),
//                           ),
//                         ),
//                         child: Icon(
//                           Icons.arrow_forward_rounded,
//                           color: Colors.white.withOpacity(0.6),
//                           size: 14,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const Spacer(),

//                   // Emoji
//                   Text(item.emoji, style: const TextStyle(fontSize: 26)),
//                   const SizedBox(height: 6),

//                   // Title
//                   Text(
//                     item.title,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w800,
//                       letterSpacing: -0.4,
//                       height: 1.2,
//                     ),
//                   ),
//                   const SizedBox(height: 4),

//                   // Subtitle
//                   Text(
//                     item.subtitle,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.5),
//                       fontSize: 11.5,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),

//                   // const SizedBox(height: 14),

//                   // Gradient bottom bar
//                   // Container(
//                   //   height: 3,
//                   //   decoration: BoxDecoration(
//                   //     borderRadius: BorderRadius.circular(2),
//                   //     gradient: LinearGradient(colors: item.gradient),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:posternova/providers/chat/chat_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/views/AI/chat_ai.dart';
import 'package:posternova/views/NavBar/navbar_screen.dart';
import 'package:posternova/views/backgroundremover/background_remover.dart';
import 'package:posternova/views/business/business_card_screen.dart';
import 'package:posternova/views/category/category_screen.dart';
import 'package:posternova/views/createposter/create_poster_screen.dart';
import 'package:posternova/views/invoices/add_invoice_data.dart';
import 'package:posternova/views/logo/logo_category.dart';
import 'package:posternova/views/onlinepunchang/online_punchang_screen.dart';
import 'package:posternova/views/textremover/textremover.dart';
import 'package:posternova/views/whatsppstickers/stickers_screen.dart';
import 'package:posternova/widgets/common_modal.dart';
import 'package:posternova/widgets/premium_widget.dart';
import 'package:provider/provider.dart';

class CategoryItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final Widget destination;
  final String emoji;

  const CategoryItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.destination,
    required this.emoji,
  });
}

// ─── Main Screen ──────────────────────────────────────────────────────────────

class SpecialCategory extends StatefulWidget {
  const SpecialCategory({super.key});

  @override
  State<SpecialCategory> createState() => _SpecialCategoryState();
}

class _SpecialCategoryState extends State<SpecialCategory>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _floatingController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _floatingAnim;

  static final List<CategoryItem> categories = [
    // CategoryItem(
    //   title: 'Online Panchang',
    //   subtitle: 'Daily almanac & astro',
    //   icon: Icons.auto_awesome,
    //   emoji: '🌙',
    //   gradient: [const Color(0xFFFF6B6B), const Color(0xFFFF4E50)],
    //   destination: const OnlinePunchangScreen(),
    // ),
    CategoryItem(
      title: 'Poster Template',
      subtitle: 'Browse all topics',
      icon: Icons.grid_view_rounded,
      emoji: '🗂️',
      gradient: [const Color(0xFF059669), const Color(0xFF0D9488)],
      destination: const CategoryScreen(),
    ),
    CategoryItem(
      title: 'Create Template',
      subtitle: 'Design your own poster',
      icon: Icons.design_services_rounded,
      emoji: '🎨',
      gradient: [const Color(0xFF8B5CF6), const Color(0xFFEC4899)],
      destination: const CreatePost(),
    ),
    CategoryItem(
      title: 'Logo Maker',
      subtitle: 'Create your brand logo',
      icon: Icons.workspace_premium_rounded,
      emoji: '🏷️',
      gradient: [const Color(0xFF2563EB), const Color(0xFF06B6D4)],
      destination: const LogoCategory(),
    ),
    CategoryItem(
      title: 'BG Remover',
      subtitle: 'AI-powered editing',
      icon: Icons.auto_fix_high,
      emoji: '✨',
      gradient: [const Color(0xFF7C3AED), const Color(0xFF4F46E5)],
      destination: const BackgroundRemoverScreen(),
    ),
    CategoryItem(
      title: 'Text Remover',
      subtitle: 'Remove text from images',
      icon: Icons.text_format,
      emoji: '🔤',
      gradient: [const Color(0xFF2563EB), const Color(0xFF06B6D4)],
      destination: const WebViewScreen(),
    ),

    CategoryItem(
      title: 'Chicha AI',
      subtitle: 'AI-powered visual magic',
      icon: Icons.auto_awesome,
      emoji: '✨',
      gradient: [const Color(0xFF2563EB), const Color(0xFF06B6D4)],
      destination: const AiScreen(),
    ),
    // CategoryItem(
    //   title: 'Stickers',
    //   subtitle: 'Fun stickers & graphics',
    //   icon: Icons.emoji_emotions,
    //   emoji: '🎯',
    //   gradient: [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
    //   destination: const WhatsAppStickerScreen(),
    // ),
    CategoryItem(
      title: 'Business Card',
      subtitle: 'Professional cards',
      icon: Icons.credit_card,
      emoji: '💳',
      gradient: [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
      destination: const BusinessCardScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _headerFade = CurvedAnimation(
      parent: _headerController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _headerController,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
          ),
        );
    _floatingAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF1A1A24), const Color(0xFF0A0A0F)],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEC4899).withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.exit_to_app_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'Exit App?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Message
                    Text(
                      'Are you sure you want to exit the app?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Buttons
                    Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Exit button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7C3AED),
                                    Color(0xFFEC4899),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFEC4899,
                                    ).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Exit',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Animated App Bar ──────────────────────────────────────────
            // SliverAppBar(
            //   expandedHeight: 240,
            //   pinned: true,
            //   stretch: true,
            //   backgroundColor: const Color(0xFF0A0A0F),
            //   elevation: 0,
            //   flexibleSpace: FlexibleSpaceBar(
            //     stretchModes: const [StretchMode.zoomBackground],
            //     background: _buildHeader(),
            //   ),
            // ),
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              stretch: true,
              backgroundColor: const Color(0xFF0A0A0F),
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainNavigationScreen(),
                      ), // Replace with your Navbar widget
                      (route) => false,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 1.2,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: _buildHeader(),
              ),
            ),

            // ── Section Label ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _headerFade,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Quick Access',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Grid ─────────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _AnimatedCard(
                    item: categories[index],
                    index: index,
                    floatingAnim: _floatingAnim,
                    parentController: _headerController,
                  );
                }, childCount: categories.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.85, // Increased from 0.79 to 0.85
                ),
              ),
            ),

            // Extra bottom padding to ensure last items are visible
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _floatingAnim,
      builder: (context, _) {
        return Container(
          decoration: const BoxDecoration(color: Color(0xFF0A0A0F)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Glowing background orbs
              Positioned(
                top: 20,
                right: -40,
                child: Transform.translate(
                  offset: Offset(0, _floatingAnim.value * 0.5),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF7C3AED).withOpacity(0.35),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: -30,
                child: Transform.translate(
                  offset: Offset(0, -_floatingAnim.value * 0.3),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFEC4899).withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 60,
                child: Transform.translate(
                  offset: Offset(0, _floatingAnim.value * 0.7),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF0EA5E9).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Floating stars / sparkles
              ..._buildSparkles(),

              // Header text
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
                  child: SlideTransition(
                    position: _headerSlide,
                    child: FadeTransition(
                      opacity: _headerFade,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                              ),
                            ),
                            child: const Text(
                              '⚡ SPECIAL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Explore\nCategories',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.0,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap any card to unlock features',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
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

  List<Widget> _buildSparkles() {
    final positions = [
      [0.75, 0.15],
      [0.85, 0.50],
      [0.60, 0.70],
      [0.40, 0.10],
    ];
    return List.generate(positions.length, (i) {
      return AnimatedBuilder(
        animation: _floatingController,
        builder: (context, _) {
          final t = (_floatingController.value + i * 0.25) % 1.0;
          final opacity = (math.sin(t * math.pi * 2) * 0.5 + 0.5).clamp(
            0.2,
            1.0,
          );
          return Positioned(
            right: MediaQuery.of(context).size.width * (1 - positions[i][0]),
            top: 240 * positions[i][1],
            child: Opacity(
              opacity: opacity,
              child: Text(
                i.isEven ? '✦' : '·',
                style: TextStyle(
                  color: i.isEven
                      ? const Color(0xFFEC4899)
                      : const Color(0xFF7C3AED),
                  fontSize: i.isEven ? 14 : 20,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

// ─── Animated Card ────────────────────────────────────────────────────────────

class _AnimatedCard extends StatefulWidget {
  final CategoryItem item;
  final int index;
  final Animation<double> floatingAnim;
  final AnimationController parentController;

  const _AnimatedCard({
    required this.item,
    required this.index,
    required this.floatingAnim,
    required this.parentController,
  });

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;
  late Animation<double> _entryAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );

    // Staggered entry animation
    final delay = widget.index * 0.12;
    _entryAnim = CurvedAnimation(
      parent: widget.parentController,
      curve: Interval(
        (0.2 + delay).clamp(0.0, 0.9),
        (0.7 + delay).clamp(0.1, 1.0),
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isEven = widget.index.isEven;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnim,
        _entryAnim,
        widget.floatingAnim,
      ]),
      builder: (_, child) {
        final floatOffset = isEven
            ? widget.floatingAnim.value * 0.4
            : -widget.floatingAnim.value * 0.4;

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Transform.scale(
            scale: _scaleAnim.value,
            child: ScaleTransition(scale: _entryAnim, child: child),
          ),
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,

        onTap: () {
  // Check plan before navigating
  final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);
  
  if (myPlanProvider.isPurchase == true) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => item.destination,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 380),
      ),
    );
  } else {
    CommonModal.showWarning(
      context: context,
      title: "Premium Feature",
      message:
          "This feature is available for premium users only. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
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
        // onTap: () {
        //   Navigator.push(
        //     context,
        //     PageRouteBuilder(
        //       pageBuilder: (_, animation, __) => item.destination,
        //       transitionsBuilder: (_, animation, __, child) {
        //         return FadeTransition(
        //           opacity: animation,
        //           child: SlideTransition(
        //             position:
        //                 Tween<Offset>(
        //                   begin: const Offset(0, 0.06),
        //                   end: Offset.zero,
        //                 ).animate(
        //                   CurvedAnimation(
        //                     parent: animation,
        //                     curve: Curves.easeOutCubic,
        //                   ),
        //                 ),
        //             child: child,
        //           ),
        //         );
        //       },
        //       transitionDuration: const Duration(milliseconds: 380),
        //     ),
        //   );
        // },
        child: _CardContent(item: item, isPressed: _isPressed),
      ),
    );
  }
}

// ─── Card Content ─────────────────────────────────────────────────────────────

class _CardContent extends StatelessWidget {
  final CategoryItem item;
  final bool isPressed;

  const _CardContent({required this.item, required this.isPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            item.gradient[0].withOpacity(0.15),
            item.gradient[1].withOpacity(0.08),
          ],
        ),
        border: Border.all(
          color: item.gradient[0].withOpacity(isPressed ? 0.6 : 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: item.gradient[0].withOpacity(isPressed ? 0.35 : 0.2),
            blurRadius: isPressed ? 24 : 16,
            spreadRadius: isPressed ? 2 : 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Mesh gradient background
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      item.gradient[0].withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      item.gradient[1].withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Card content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon + emoji row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Gradient icon container
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: item.gradient,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: item.gradient[0].withOpacity(0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(item.icon, color: Colors.white, size: 26),
                      ),
                      // Arrow badge
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.07),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white.withOpacity(0.6),
                          size: 14,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Emoji
                  Text(item.emoji, style: const TextStyle(fontSize: 26)),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
