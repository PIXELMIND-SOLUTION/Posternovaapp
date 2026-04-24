// // // import 'package:flutter/material.dart';
// // // import 'dart:math' as math;

// // // class FancyAppBar extends StatefulWidget implements PreferredSizeWidget {
// // //   const FancyAppBar({super.key});

// // //   @override
// // //   State<FancyAppBar> createState() => _FancyAppBarState();

// // //   @override
// // //   Size get preferredSize => const Size.fromHeight(120);
// // // }

// // // class _FancyAppBarState extends State<FancyAppBar>
// // //     with TickerProviderStateMixin {
// // //   late AnimationController _borderController;
// // //   late AnimationController _shimmerController;
// // //   late AnimationController _pulseController;
// // //   late AnimationController _iconController;

// // //   late Animation<double> _borderAnimation;
// // //   late Animation<double> _shimmerAnimation;
// // //   late Animation<double> _pulseAnimation;
// // //   late Animation<double> _rotationAnimation;

// // //   @override
// // //   void initState() {
// // //     super.initState();

// // //     // Border radius animation
// // //     _borderController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(seconds: 3),
// // //     )..repeat(reverse: true);
// // //     _borderAnimation = Tween<double>(begin: 0, end: 15).animate(
// // //       CurvedAnimation(parent: _borderController, curve: Curves.easeInOutSine),
// // //     );

// // //     // Shimmer effect animation
// // //     _shimmerController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(seconds: 2),
// // //     )..repeat();
// // //     _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
// // //       CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
// // //     );

// // //     // Pulse animation
// // //     _pulseController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(milliseconds: 1500),
// // //     )..repeat(reverse: true);
// // //     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
// // //       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
// // //     );

// // //     // Icon rotation animation
// // //     _iconController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(seconds: 4),
// // //     )..repeat();
// // //     _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
// // //       CurvedAnimation(parent: _iconController, curve: Curves.linear),
// // //     );
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _borderController.dispose();
// // //     _shimmerController.dispose();
// // //     _pulseController.dispose();
// // //     _iconController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return AnimatedBuilder(
// // //       animation: Listenable.merge([
// // //         _borderAnimation,
// // //         _shimmerAnimation,
// // //         _pulseAnimation,
// // //         _rotationAnimation,
// // //       ]),
// // //       builder: (context, child) {
// // //         return ClipRRect(
// // //           borderRadius: BorderRadius.vertical(
// // //             bottom: Radius.circular(30 + _borderAnimation.value),
// // //           ),
// // //           child: AppBar(
// // //             elevation: 8,
// // //             shadowColor: Colors.deepPurple.withOpacity(0.5),
// // //             backgroundColor: Colors.transparent,
// // //             centerTitle: true,
// // //             leading: Padding(
// // //               padding: const EdgeInsets.all(8.0),
// // //               child: Transform.rotate(
// // //                 angle: _rotationAnimation.value,
// // //                 child: Container(
// // //                   decoration: BoxDecoration(
// // //                     shape: BoxShape.circle,
// // //                     gradient: RadialGradient(
// // //                       colors: [
// // //                         Colors.white.withOpacity(0.3),
// // //                         Colors.transparent,
// // //                       ],
// // //                     ),
// // //                   ),
// // //                   child: const Icon(Icons.stars, color: Colors.white),
// // //                 ),
// // //               ),
// // //             ),
// // //             actions: [
// // //               Padding(
// // //                 padding: const EdgeInsets.all(8.0),
// // //                 child: Transform.scale(
// // //                   scale: _pulseAnimation.value,
// // //                   child: Container(
// // //                     decoration: BoxDecoration(
// // //                       shape: BoxShape.circle,
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.white.withOpacity(0.3),
// // //                           blurRadius: 10,
// // //                           spreadRadius: 2,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     child: const Icon(Icons.notifications_active),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 8),
// // //             ],
// // // title: Transform.scale(
// // //               scale: _pulseAnimation.value,
// // //               child: ShaderMask(
// // //                 shaderCallback: (bounds) {
// // //                   return LinearGradient(
// // //                     colors: const [
// // //                       Colors.white,
// // //                       Color(0xFFE0E7FF),
// // //                       Colors.white,
// // //                       Color(0xFFE0E7FF),
// // //                     ],
// // //                     stops: [
// // //                       0.0,
// // //                       _shimmerAnimation.value / 2,
// // //                       _shimmerAnimation.value,
// // //                       1.0,
// // //                     ],
// // //                     begin: Alignment.topLeft,
// // //                     end: Alignment.bottomRight,
// // //                   ).createShader(bounds);
// // //                 },
// // //                 child: Column(
// // //                   mainAxisAlignment: MainAxisAlignment.center,
// // //                   children: const [
// // //                     Text(
// // //                       'Welcome to',
// // //                       style: TextStyle(
// // //                         fontFamily: 'Serif',
// // //                         fontWeight: FontWeight.w300,
// // //                         fontSize: 16,
// // //                         letterSpacing: 2,
// // //                         color: Color.fromARGB(255, 60, 60, 60),
// // //                         shadows: [
// // //                           Shadow(
// // //                             color: Colors.black26,
// // //                             offset: Offset(1, 1),
// // //                             blurRadius: 3,
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                     SizedBox(height: 2),
// // //                     Text(
// // //                       'PosterNova',
// // //                       style: TextStyle(
// // //                         fontFamily: 'Cursive',
// // //                         fontWeight: FontWeight.w900,
// // //                         fontSize: 32,
// // //                         letterSpacing: 2,
// // //                         color: Color.fromARGB(255, 0, 0, 0),
// // //                         shadows: [
// // //                           Shadow(
// // //                             color: Colors.black26,
// // //                             offset: Offset(2, 2),
// // //                             blurRadius: 4,
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //             flexibleSpace: Stack(
// // //               children: [
// // //                 // Main gradient background
// // //                 Container(
// // //                   decoration: const BoxDecoration(
// // //                     gradient: LinearGradient(
// // //                       colors: [
// // //                         Color(0xFF6366F1),
// // //                         Color(0xFF818CF8),
// // //                         Color(0xFF8B5CF6),
// // //                       ],
// // //                       begin: Alignment.topLeft,
// // //                       end: Alignment.bottomRight,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 // Animated overlay gradient
// // //                 Container(
// // //                   decoration: BoxDecoration(
// // //                     gradient: LinearGradient(
// // //                       colors: [
// // //                         Colors.white.withOpacity(0.1 * _pulseAnimation.value),
// // //                         Colors.transparent,
// // //                         Colors.white.withOpacity(0.05 * _pulseAnimation.value),
// // //                       ],
// // //                       begin: Alignment.topLeft,
// // //                       end: Alignment.bottomRight,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 // Floating particles effect
// // //                 Positioned(
// // //                   top: 20 + (_borderAnimation.value * 2),
// // //                   right: 30,
// // //                   child: Container(
// // //                     width: 60,
// // //                     height: 60,
// // //                     decoration: BoxDecoration(
// // //                       shape: BoxShape.circle,
// // //                       color: Colors.white.withOpacity(0.1),
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.white.withOpacity(0.2),
// // //                           blurRadius: 20,
// // //                           spreadRadius: 5,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 Positioned(
// // //                   bottom: 10 + (_borderAnimation.value * -1),
// // //                   left: 40,
// // //                   child: Container(
// // //                     width: 40,
// // //                     height: 40,
// // //                     decoration: BoxDecoration(
// // //                       shape: BoxShape.circle,
// // //                       color: Colors.white.withOpacity(0.08),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 // Shimmer line effect
// // //                 Positioned(
// // //                   left: _shimmerAnimation.value * MediaQuery.of(context).size.width / 2,
// // //                   top: 0,
// // //                   bottom: 0,
// // //                   child: Container(
// // //                     width: 100,
// // //                     decoration: BoxDecoration(
// // //                       gradient: LinearGradient(
// // //                         colors: [
// // //                           Colors.transparent,
// // //                           Colors.white.withOpacity(0.15),
// // //                           Colors.transparent,
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }

// // // import 'package:flutter/material.dart';
// // // import 'dart:math' as math;

// // // class FancyAppBar extends StatefulWidget implements PreferredSizeWidget {
// // //   final String? username;
// // //   final String? profileImageUrl;
// // //   final VoidCallback? onProfileTap;

// // //   const FancyAppBar({
// // //     super.key,
// // //     this.username,
// // //     this.profileImageUrl,
// // //     this.onProfileTap,
// // //   });

// // //   @override
// // //   State<FancyAppBar> createState() => _FancyAppBarState();

// // //   @override
// // //   Size get preferredSize => const Size.fromHeight(120);
// // // }

// // // class _FancyAppBarState extends State<FancyAppBar>
// // //     with TickerProviderStateMixin {
// // //   late AnimationController _borderController;
// // //   late AnimationController _shimmerController;
// // //   late AnimationController _pulseController;
// // //   late AnimationController _iconController;

// // //   late Animation<double> _borderAnimation;
// // //   late Animation<double> _shimmerAnimation;
// // //   late Animation<double> _pulseAnimation;
// // //   late Animation<double> _rotationAnimation;

// // //   @override
// // //   void initState() {
// // //     super.initState();

// // //     // Border radius animation
// // //     _borderController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(seconds: 3),
// // //     )..repeat(reverse: true);
// // //     _borderAnimation = Tween<double>(begin: 0, end: 15).animate(
// // //       CurvedAnimation(parent: _borderController, curve: Curves.easeInOutSine),
// // //     );

// // //     // Shimmer effect animation
// // //     _shimmerController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(seconds: 2),
// // //     )..repeat();
// // //     _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
// // //       CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
// // //     );

// // //     // Pulse animation
// // //     _pulseController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(milliseconds: 1500),
// // //     )..repeat(reverse: true);
// // //     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
// // //       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
// // //     );

// // //     // Icon rotation animation
// // //     _iconController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(seconds: 4),
// // //     )..repeat();
// // //     _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
// // //       CurvedAnimation(parent: _iconController, curve: Curves.linear),
// // //     );
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _borderController.dispose();
// // //     _shimmerController.dispose();
// // //     _pulseController.dispose();
// // //     _iconController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return AnimatedBuilder(
// // //       animation: Listenable.merge([
// // //         _borderAnimation,
// // //         _shimmerAnimation,
// // //         _pulseAnimation,
// // //         _rotationAnimation,
// // //       ]),
// // //       builder: (context, child) {
// // //         return ClipRRect(
// // //           borderRadius: BorderRadius.vertical(
// // //             bottom: Radius.circular(30 + _borderAnimation.value),
// // //           ),
// // //           child: AppBar(
// // //             elevation: 8,
// // //             shadowColor: Colors.deepPurple.withOpacity(0.5),
// // //             backgroundColor: Colors.transparent,
// // //             centerTitle: true,
// // //             leading: Padding(
// // //               padding: const EdgeInsets.all(8.0),
// // //               child: Hero(
// // //                 tag: 'profile_avatar',
// // //                 child: GestureDetector(
// // //                   onTap: widget.onProfileTap,
// // //                   child: Container(
// // //                     padding: const EdgeInsets.all(3),
// // //                     decoration: BoxDecoration(
// // //                       shape: BoxShape.circle,
// // //                       border: Border.all(color: Colors.white, width: 2),
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.white.withOpacity(0.3),
// // //                           blurRadius: 8,
// // //                           spreadRadius: 1,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     child: CircleAvatar(
// // //                       radius: 50,
// // //                       backgroundColor: Colors.white,
// // //                       backgroundImage: widget.profileImageUrl != null &&
// // //                               widget.profileImageUrl!.isNotEmpty
// // //                           ? NetworkImage(widget.profileImageUrl!)
// // //                           : null,
// // //                       child: widget.profileImageUrl == null ||
// // //                               widget.profileImageUrl!.isEmpty
// // //                           ? const Icon(
// // //                               Icons.person,
// // //                               color: Color(0xFF667EEA),
// // //                               size: 24,
// // //                             )
// // //                           : null,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //             actions: [
// // //               Padding(
// // //                 padding: const EdgeInsets.all(8.0),
// // //                 child: Transform.scale(
// // //                   scale: _pulseAnimation.value,
// // //                   child: Container(
// // //                     decoration: BoxDecoration(
// // //                       shape: BoxShape.circle,
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.white.withOpacity(0.3),
// // //                           blurRadius: 10,
// // //                           spreadRadius: 2,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     child: const Icon(Icons.notifications_active),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 8),
// // //             ],
// // //             title: Transform.scale(
// // //               scale: _pulseAnimation.value,
// // //               child: ShaderMask(
// // //                 shaderCallback: (bounds) {
// // //                   return LinearGradient(
// // //                     colors: const [
// // //                       Colors.white,
// // //                       Color(0xFFE0E7FF),
// // //                       Colors.white,
// // //                       Color(0xFFE0E7FF),
// // //                     ],
// // //                     stops: [
// // //                       0.0,
// // //                       _shimmerAnimation.value / 2,
// // //                       _shimmerAnimation.value,
// // //                       1.0,
// // //                     ],
// // //                     begin: Alignment.topLeft,
// // //                     end: Alignment.bottomRight,
// // //                   ).createShader(bounds);
// // //                 },
// // //                 child: Column(
// // //                   mainAxisAlignment: MainAxisAlignment.center,
// // //                   children: [
// // //                     Text(
// // //                       'Welcome back!',
// // //                       style: TextStyle(
// // //                         fontFamily: 'Serif',
// // //                         fontWeight: FontWeight.w400,
// // //                         fontSize: 14,
// // //                         letterSpacing: 1.5,
// // //                         color: Colors.white.withOpacity(0.9),
// // //                         shadows: const [
// // //                           Shadow(
// // //                             color: Colors.black26,
// // //                             offset: Offset(1, 1),
// // //                             blurRadius: 3,
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 2),
// // //                     Text(
// // //                       widget.username ?? 'User',
// // //                       style: const TextStyle(
// // //                         fontFamily: 'Cursive',
// // //                         fontWeight: FontWeight.w900,
// // //                         fontSize: 24,
// // //                         letterSpacing: 1.5,
// // //                         color: Colors.white,
// // //                         shadows: [
// // //                           Shadow(
// // //                             color: Colors.black26,
// // //                             offset: Offset(2, 2),
// // //                             blurRadius: 4,
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       overflow: TextOverflow.ellipsis,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //             flexibleSpace: Stack(
// // //               children: [
// // //                 // Main gradient background
// // //                 Container(
// // //                   decoration: const BoxDecoration(
// // //                     gradient: LinearGradient(
// // //                       colors: [
// // //                         Color(0xFF6366F1),
// // //                         Color(0xFF818CF8),
// // //                         Color(0xFF8B5CF6),
// // //                       ],
// // //                       begin: Alignment.topLeft,
// // //                       end: Alignment.bottomRight,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 // Animated overlay gradient
// // //                 Container(
// // //                   decoration: BoxDecoration(
// // //                     gradient: LinearGradient(
// // //                       colors: [
// // //                         Colors.white.withOpacity(0.1 * _pulseAnimation.value),
// // //                         Colors.transparent,
// // //                         Colors.white.withOpacity(0.05 * _pulseAnimation.value),
// // //                       ],
// // //                       begin: Alignment.topLeft,
// // //                       end: Alignment.bottomRight,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 // Floating particles effect
// // //                 Positioned(
// // //                   top: 20 + (_borderAnimation.value * 2),
// // //                   right: 30,
// // //                   child: Container(
// // //                     width: 60,
// // //                     height: 60,
// // //                     decoration: BoxDecoration(
// // //                       shape: BoxShape.circle,
// // //                       color: Colors.white.withOpacity(0.1),
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.white.withOpacity(0.2),
// // //                           blurRadius: 20,
// // //                           spreadRadius: 5,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 Positioned(
// // //                   bottom: 10 + (_borderAnimation.value * -1),
// // //                   left: 40,
// // //                   child: Container(
// // //                     width: 40,
// // //                     height: 40,
// // //                     decoration: BoxDecoration(
// // //                       shape: BoxShape.circle,
// // //                       color: Colors.white.withOpacity(0.08),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 // Shimmer line effect
// // //                 Positioned(
// // //                   left: _shimmerAnimation.value * MediaQuery.of(context).size.width / 2,
// // //                   top: 0,
// // //                   bottom: 0,
// // //                   child: Container(
// // //                     width: 100,
// // //                     decoration: BoxDecoration(
// // //                       gradient: LinearGradient(
// // //                         colors: [
// // //                           Colors.transparent,
// // //                           Colors.white.withOpacity(0.15),
// // //                           Colors.transparent,
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }

// // // import 'package:flutter/material.dart';
// // // import 'dart:math' as math;

// // // import 'package:posternova/views/ProfileScreen/profile_screen.dart';

// // // class FancyAppBar extends StatefulWidget implements PreferredSizeWidget {
// // //   final String? username;
// // //   final String? profileImageUrl;
// // //   final VoidCallback? onProfileTap;

// // //   const FancyAppBar({
// // //     super.key,
// // //     this.username,
// // //     this.profileImageUrl,
// // //     this.onProfileTap,
// // //   });

// // //   @override
// // //   State<FancyAppBar> createState() => _FancyAppBarState();

// // //   @override
// // //   Size get preferredSize => const Size.fromHeight(120);
// // // }

// // // class _FancyAppBarState extends State<FancyAppBar>
// // //     with TickerProviderStateMixin {
// // //   late AnimationController _borderController;
// // //   late AnimationController _shimmerController;
// // //   late AnimationController _pulseController;
// // //   late AnimationController _iconController;

// // //   late Animation<double> _borderAnimation;
// // //   late Animation<double> _shimmerAnimation;
// // //   late Animation<double> _pulseAnimation;
// // //   late Animation<double> _rotationAnimation;

// // //   @override
// // //   void initState() {
// // //     super.initState();

// // //     // Border radius animation
// // //     _borderController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(seconds: 3),
// // //     )..repeat(reverse: true);
// // //     _borderAnimation = Tween<double>(begin: 0, end: 15).animate(
// // //       CurvedAnimation(parent: _borderController, curve: Curves.easeInOutSine),
// // //     );

// // //     // Shimmer effect animation
// // //     _shimmerController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(seconds: 2),
// // //     )..repeat();
// // //     _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
// // //       CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
// // //     );

// // //     // Pulse animation
// // //     _pulseController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(milliseconds: 1500),
// // //     )..repeat(reverse: true);
// // //     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
// // //       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
// // //     );

// // //     // Icon rotation animation
// // //     _iconController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(seconds: 4),
// // //     )..repeat();
// // //     _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
// // //       CurvedAnimation(parent: _iconController, curve: Curves.linear),
// // //     );
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _borderController.dispose();
// // //     _shimmerController.dispose();
// // //     _pulseController.dispose();
// // //     _iconController.dispose();
// // //     super.dispose();
// // //   }

// // //   void _navigateToProfile() {
// // //     if (widget.onProfileTap != null) {
// // //       widget.onProfileTap!();
// // //     } else {
// // //       Navigator.push(
// // //         context,
// // //         MaterialPageRoute(
// // //           builder: (context) =>ProfileScreen()
// // //         ),
// // //       );
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     print('userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrnaaaaaaaaaaaaaaaaaaaaaame${widget.username}');
// // //     return AnimatedBuilder(
// // //       animation: Listenable.merge([
// // //         _borderAnimation,
// // //         _shimmerAnimation,
// // //         _pulseAnimation,
// // //         _rotationAnimation,
// // //       ]),
// // //       builder: (context, child) {
// // //         return ClipRRect(
// // //           borderRadius: BorderRadius.vertical(
// // //             bottom: Radius.circular(30 + _borderAnimation.value),
// // //           ),
// // //           child: AppBar(
// // //             elevation: 8,
// // //             shadowColor: Colors.deepPurple.withOpacity(0.5),
// // //             backgroundColor: Colors.transparent,
// // //             centerTitle: true,
// // //             leading: Padding(
// // //               padding: const EdgeInsets.all(8.0),
// // //               child: Hero(
// // //                 tag: 'profile_avatar',
// // //                 child: GestureDetector(
// // //                   onTap: _navigateToProfile,
// // //                   child: Container(
// // //                     padding: const EdgeInsets.all(3),
// // //                     decoration: BoxDecoration(
// // //                       shape: BoxShape.circle,
// // //                       border: Border.all(color: Colors.white, width: 2),
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.white.withOpacity(0.3),
// // //                           blurRadius: 8,
// // //                           spreadRadius: 1,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     child: CircleAvatar(
// // //                       radius: 65,
// // //                       backgroundColor: Colors.white,
// // //                       backgroundImage: widget.profileImageUrl != null &&
// // //                               widget.profileImageUrl!.isNotEmpty
// // //                           ? NetworkImage(widget.profileImageUrl!)
// // //                           : null,
// // //                       child: widget.profileImageUrl == null ||
// // //                               widget.profileImageUrl!.isEmpty
// // //                           ? const Icon(
// // //                               Icons.person,
// // //                               color: Color(0xFF667EEA),
// // //                               size: 24,
// // //                             )
// // //                           : null,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //             actions: [
// // //               Padding(
// // //                 padding: const EdgeInsets.all(8.0),
// // //                 child: Transform.scale(
// // //                   scale: _pulseAnimation.value,
// // //                   child: Container(
// // //                     decoration: BoxDecoration(
// // //                       shape: BoxShape.circle,
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.white.withOpacity(0.3),
// // //                           blurRadius: 10,
// // //                           spreadRadius: 2,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     // child: const Icon(Icons.notifications_active),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 8),
// // //             ],
// // //             title: Transform.scale(
// // //               scale: _pulseAnimation.value,
// // //               child: ShaderMask(
// // //                 shaderCallback: (bounds) {
// // //                   return LinearGradient(
// // //                     colors: const [
// // //                       Colors.white,
// // //                       Color(0xFFE0E7FF),
// // //                       Colors.white,
// // //                       Color(0xFFE0E7FF),
// // //                     ],
// // //                     stops: [
// // //                       0.0,
// // //                       _shimmerAnimation.value / 2,
// // //                       _shimmerAnimation.value,
// // //                       1.0,
// // //                     ],
// // //                     begin: Alignment.topLeft,
// // //                     end: Alignment.bottomRight,
// // //                   ).createShader(bounds);
// // //                 },
// // //                 child: Column(
// // //                   mainAxisAlignment: MainAxisAlignment.center,
// // //                   children: [
// // //                     Text(
// // //                       'Welcome back!',
// // //                       style: TextStyle(
// // //                         fontFamily: 'Serif',
// // //                         fontWeight: FontWeight.w400,
// // //                         fontSize: 14,
// // //                         letterSpacing: 1.5,
// // //                         color: Colors.white.withOpacity(0.9),
// // //                         shadows: const [
// // //                           Shadow(
// // //                             color: Colors.black26,
// // //                             offset: Offset(1, 1),
// // //                             blurRadius: 3,
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 2),
// // //                     Text(
// // //                       widget.username ?? 'User',
// // //                       style: const TextStyle(
// // //                         fontFamily: 'Cursive',
// // //                         fontWeight: FontWeight.w900,
// // //                         fontSize: 24,
// // //                         letterSpacing: 1.5,
// // //                         color: Colors.white,
// // //                         shadows: [
// // //                           Shadow(
// // //                             color: Colors.black26,
// // //                             offset: Offset(2, 2),
// // //                             blurRadius: 4,
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       overflow: TextOverflow.ellipsis,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //             flexibleSpace: Stack(
// // //               children: [
// // //                 // Main gradient background
// // //                 Container(
// // //                   decoration: const BoxDecoration(
// // //                     gradient: LinearGradient(
// // //                       colors: [
// // //                         Color(0xFF6366F1),
// // //                         Color(0xFF818CF8),
// // //                         Color(0xFF8B5CF6),
// // //                       ],
// // //                       begin: Alignment.topLeft,
// // //                       end: Alignment.bottomRight,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 // Animated overlay gradient
// // //                 Container(
// // //                   decoration: BoxDecoration(
// // //                     gradient: LinearGradient(
// // //                       colors: [
// // //                         Colors.white.withOpacity(0.1 * _pulseAnimation.value),
// // //                         Colors.transparent,
// // //                         Colors.white.withOpacity(0.05 * _pulseAnimation.value),
// // //                       ],
// // //                       begin: Alignment.topLeft,
// // //                       end: Alignment.bottomRight,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 // Floating particles effect
// // //                 Positioned(
// // //                   top: 20 + (_borderAnimation.value * 2),
// // //                   right: 30,
// // //                   child: Container(
// // //                     width: 60,
// // //                     height: 60,
// // //                     decoration: BoxDecoration(
// // //                       shape: BoxShape.circle,
// // //                       color: Colors.white.withOpacity(0.1),
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.white.withOpacity(0.2),
// // //                           blurRadius: 20,
// // //                           spreadRadius: 5,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 Positioned(
// // //                   bottom: 10 + (_borderAnimation.value * -1),
// // //                   left: 40,
// // //                   child: Container(
// // //                     width: 40,
// // //                     height: 40,
// // //                     decoration: BoxDecoration(
// // //                       shape: BoxShape.circle,
// // //                       color: Colors.white.withOpacity(0.08),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 // Shimmer line effect
// // //                 Positioned(
// // //                   left: _shimmerAnimation.value * MediaQuery.of(context).size.width / 2,
// // //                   top: 0,
// // //                   bottom: 0,
// // //                   child: Container(
// // //                     width: 100,
// // //                     decoration: BoxDecoration(
// // //                       gradient: LinearGradient(
// // //                         colors: [
// // //                           Colors.transparent,
// // //                           Colors.white.withOpacity(0.15),
// // //                           Colors.transparent,
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:posternova/views/AI/chat_ai.dart';
// // import 'dart:math' as math;

// // import 'package:posternova/views/ProfileScreen/profile_screen.dart';
// // import 'package:posternova/views/referearn/referearn_screen.dart';

// // class FancyAppBar extends StatefulWidget implements PreferredSizeWidget {
// //   final String? username;
// //   final String? profileImageUrl;
// //   final VoidCallback? onProfileTap;
// //   final VoidCallback? onAITap;
// //    final VoidCallback? onReferTap;

// //   const FancyAppBar({
// //     super.key,
// //     this.username,
// //     this.profileImageUrl,
// //     this.onProfileTap,
// //     this.onAITap,
// //     this.onReferTap
// //   });

// //   @override
// //   State<FancyAppBar> createState() => _FancyAppBarState();

// //   @override
// //   Size get preferredSize => const Size.fromHeight(120);
// // }

// // class _FancyAppBarState extends State<FancyAppBar>
// //     with TickerProviderStateMixin {
// //   late AnimationController _borderController;
// //   late AnimationController _shimmerController;
// //   late AnimationController _pulseController;
// //   late AnimationController _iconController;

// //   late Animation<double> _borderAnimation;
// //   late Animation<double> _shimmerAnimation;
// //   late Animation<double> _pulseAnimation;
// //   late Animation<double> _rotationAnimation;

// //   @override
// //   void initState() {
// //     super.initState();

// //     // Border radius animation
// //     _borderController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 3),
// //     )..repeat(reverse: true);
// //     _borderAnimation = Tween<double>(begin: 0, end: 15).animate(
// //       CurvedAnimation(parent: _borderController, curve: Curves.easeInOutSine),
// //     );

// //     // Shimmer effect animation
// //     _shimmerController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 2),
// //     )..repeat();
// //     _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
// //       CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
// //     );

// //     // Pulse animation
// //     _pulseController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1500),
// //     )..repeat(reverse: true);
// //     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
// //       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
// //     );

// //     // Icon rotation animation
// //     _iconController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 4),
// //     )..repeat();
// //     _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
// //       CurvedAnimation(parent: _iconController, curve: Curves.linear),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _borderController.dispose();
// //     _shimmerController.dispose();
// //     _pulseController.dispose();
// //     _iconController.dispose();
// //     super.dispose();
// //   }

// //   void _navigateToProfile() {
// //     if (widget.onProfileTap != null) {
// //       widget.onProfileTap!();
// //     } else {
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => ProfileScreen()
// //         ),
// //       );
// //     }
// //   }

// //   void _navigateToAI() {
// //     if (widget.onAITap != null) {
// //       widget.onAITap!();
// //     } else {
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => AiScreen() // Replace with your AI screen
// //         ),
// //       );
// //     }
// //   }

// //     void _navigateRedeem() {
// //     if (widget.onReferTap != null) {
// //       widget.onReferTap!();
// //     } else {
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => ReferEarnScreen() // Replace with your AI screen
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     print('userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrnaaaaaaaaaaaaaaaaaaaaaame  ${widget.username}');
// //     return AnimatedBuilder(
// //       animation: Listenable.merge([
// //         _borderAnimation,
// //         _shimmerAnimation,
// //         _pulseAnimation,
// //         _rotationAnimation,
// //       ]),
// //       builder: (context, child) {
// //         return ClipRRect(
// //           borderRadius: BorderRadius.vertical(
// //             bottom: Radius.circular(30 + _borderAnimation.value),
// //           ),
// //           child: AppBar(
// //             elevation: 8,
// //             shadowColor: Colors.deepPurple.withOpacity(0.5),
// //             backgroundColor: Colors.transparent,
// //             centerTitle: true,
// //             leading: Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: Hero(
// //                 tag: 'profile_avatar',
// //                 child: GestureDetector(
// //                   onTap: _navigateToProfile,
// //                   child: Container(
// //                     padding: const EdgeInsets.all(3),
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       border: Border.all(color: Colors.white, width: 2),
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.white.withOpacity(0.3),
// //                           blurRadius: 8,
// //                           spreadRadius: 1,
// //                         ),
// //                       ],
// //                     ),
// //                     child: CircleAvatar(
// //                       radius: 65,
// //                       backgroundColor: Colors.white,
// //                       backgroundImage: widget.profileImageUrl != null &&
// //                               widget.profileImageUrl!.isNotEmpty
// //                           ? NetworkImage(widget.profileImageUrl!)
// //                           : null,
// //                       child: widget.profileImageUrl == null ||
// //                               widget.profileImageUrl!.isEmpty
// //                           ? const Icon(
// //                               Icons.person,
// //                               color: Color(0xFF667EEA),
// //                               size: 24,
// //                             )
// //                           : null,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             actions: [
// //               Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: GestureDetector(
// //                   onTap: _navigateToAI,
// //                   child: Transform.scale(
// //                     scale: _pulseAnimation.value,
// //                     child: Container(
// //                       padding: const EdgeInsets.all(8),
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         gradient: LinearGradient(
// //                           colors: [
// //                             Colors.white.withOpacity(0.3),
// //                             Colors.white.withOpacity(0.1),
// //                           ],
// //                           begin: Alignment.topLeft,
// //                           end: Alignment.bottomRight,
// //                         ),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.white.withOpacity(0.3),
// //                             blurRadius: 10,
// //                             spreadRadius: 2,
// //                           ),
// //                         ],
// //                       ),
// //                       child: Transform.rotate(
// //                         angle: _rotationAnimation.value,
// //                         child: const Icon(
// //                           Icons.psychology, // AI brain icon
// //                           color: Colors.white,
// //                           size: 24,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(width: 8),
// //             ],
// //             title: Transform.scale(
// //               scale: _pulseAnimation.value,
// //               child: ShaderMask(
// //                 shaderCallback: (bounds) {
// //                   return LinearGradient(
// //                     colors: const [
// //                       Colors.white,
// //                       Color(0xFFE0E7FF),
// //                       Colors.white,
// //                       Color(0xFFE0E7FF),
// //                     ],
// //                     stops: [
// //                       0.0,
// //                       _shimmerAnimation.value / 2,
// //                       _shimmerAnimation.value,
// //                       1.0,
// //                     ],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                   ).createShader(bounds);
// //                 },
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       'Welcome back!',
// //                       style: TextStyle(
// //                         fontFamily: 'Serif',
// //                         fontWeight: FontWeight.w400,
// //                         fontSize: 14,
// //                         letterSpacing: 1.5,
// //                         color: Colors.white.withOpacity(0.9),
// //                         shadows: const [
// //                           Shadow(
// //                             color: Colors.black26,
// //                             offset: Offset(1, 1),
// //                             blurRadius: 3,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 2),
// //                     Text(
// //                       widget.username ?? 'User',
// //                       style: const TextStyle(
// //                         fontFamily: 'Cursive',
// //                         fontWeight: FontWeight.w900,
// //                         fontSize: 24,
// //                         letterSpacing: 1.5,
// //                         color: Colors.white,
// //                         shadows: [
// //                           Shadow(
// //                             color: Colors.black26,
// //                             offset: Offset(2, 2),
// //                             blurRadius: 4,
// //                           ),
// //                         ],
// //                       ),
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             flexibleSpace: Stack(
// //               children: [
// //                 // Main gradient background
// //                 Container(
// //                   decoration: const BoxDecoration(
// //                     gradient: LinearGradient(
// //                       colors: [
// //                         Color(0xFF6366F1),
// //                         Color(0xFF818CF8),
// //                         Color(0xFF8B5CF6),
// //                       ],
// //                       begin: Alignment.topLeft,
// //                       end: Alignment.bottomRight,
// //                     ),
// //                   ),
// //                 ),
// //                 // Animated overlay gradient
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     gradient: LinearGradient(
// //                       colors: [
// //                         Colors.white.withOpacity(0.1 * _pulseAnimation.value),
// //                         Colors.transparent,
// //                         Colors.white.withOpacity(0.05 * _pulseAnimation.value),
// //                       ],
// //                       begin: Alignment.topLeft,
// //                       end: Alignment.bottomRight,
// //                     ),
// //                   ),
// //                 ),
// //                 // Floating particles effect
// //                 Positioned(
// //                   top: 20 + (_borderAnimation.value * 2),
// //                   right: 30,
// //                   child: Container(
// //                     width: 60,
// //                     height: 60,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       color: Colors.white.withOpacity(0.1),
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.white.withOpacity(0.2),
// //                           blurRadius: 20,
// //                           spreadRadius: 5,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 Positioned(
// //                   bottom: 10 + (_borderAnimation.value * -1),
// //                   left: 40,
// //                   child: Container(
// //                     width: 40,
// //                     height: 40,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       color: Colors.white.withOpacity(0.08),
// //                     ),
// //                   ),
// //                 ),
// //                 // Shimmer line effect
// //                 Positioned(
// //                   left: _shimmerAnimation.value * MediaQuery.of(context).size.width / 2,
// //                   top: 0,
// //                   bottom: 0,
// //                   child: Container(
// //                     width: 100,
// //                     decoration: BoxDecoration(
// //                       gradient: LinearGradient(
// //                         colors: [
// //                           Colors.transparent,
// //                           Colors.white.withOpacity(0.15),
// //                           Colors.transparent,
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }





// import 'package:flutter/material.dart';
// import 'package:posternova/services/language/language_service.dart';
// import 'package:posternova/views/AI/chat_ai.dart';
// import 'dart:math' as math;
// import 'package:posternova/views/ProfileScreen/profile_screen.dart';
// import 'package:posternova/views/referearn/referearn_screen.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';

// class FancyAppBar extends StatefulWidget implements PreferredSizeWidget {
//   final String? username;
//   final String?userId;
//   final String? profileImageUrl;
//   final VoidCallback? onProfileTap;
//   final VoidCallback? onAITap;
//   final VoidCallback? onReferEarnTap;

//   const FancyAppBar({
//     super.key,
//     this.username,
//     this.profileImageUrl,
//     this.onProfileTap,
//     this.onAITap,
//     this.onReferEarnTap,
//     this.userId,
//   });

//   @override
//   State<FancyAppBar> createState() => _FancyAppBarState();

//   @override
//   Size get preferredSize => const Size.fromHeight(120);
// }

// class _FancyAppBarState extends State<FancyAppBar>
//     with TickerProviderStateMixin {
//   late AnimationController _borderController;
//   late AnimationController _shimmerController;
//   late AnimationController _pulseController;
//   late AnimationController _iconController;

//   late Animation<double> _borderAnimation;
//   late Animation<double> _shimmerAnimation;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _rotationAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Border radius animation
//     _borderController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat(reverse: true);
//     _borderAnimation = Tween<double>(begin: 0, end: 15).animate(
//       CurvedAnimation(parent: _borderController, curve: Curves.easeInOutSine),
//     );

//     // Shimmer effect animation
//     _shimmerController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();
//     _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
//       CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
//     );

//     // Pulse animation
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat(reverse: true);
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );

//     // Icon rotation animation
//     _iconController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4),
//     )..repeat();
//     _rotationAnimation = Tween<double>(
//       begin: 0,
//       end: 2 * math.pi,
//     ).animate(CurvedAnimation(parent: _iconController, curve: Curves.linear));
//   }

//   @override
//   void dispose() {
//     _borderController.dispose();
//     _shimmerController.dispose();
//     _pulseController.dispose();
//     _iconController.dispose();
//     super.dispose();
//   }

//   void _navigateToProfile() {
//     if (widget.onProfileTap != null) {
//       widget.onProfileTap!();
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ProfileScreen()),
//       );
//     }
//   }

//   void _navigateToAI() {
//     if (widget.onAITap != null) {
//       widget.onAITap!();
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => AiScreen(), // Replace with your AI screen
//         ),
//       );
//     }
//   }

//   void _navigateToReferEarn() {
//     if (widget.onReferEarnTap != null) {
//       widget.onReferEarnTap!();
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               ReferEarnScreen(), // Replace with your Refer & Earn screen
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(
//       'userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrnaaaaaaaaaaaaaaaaaaaaaame ${widget.username}',
//     );
//     return AnimatedBuilder(
//       animation: Listenable.merge([
//         _borderAnimation,
//         _shimmerAnimation,
//         _pulseAnimation,
//         _rotationAnimation,
//       ]),
//       builder: (context, child) {
//         return ClipRRect(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(30 + _borderAnimation.value),
//           ),
//           child: AppBar(
//             elevation: 8,
//             shadowColor: Colors.deepPurple.withOpacity(0.5),
//             backgroundColor: Colors.transparent,
//             centerTitle: true,
//             leading: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Hero(
//                 tag: 'profile_avatar',
//                 child: GestureDetector(
//                   onTap: _navigateToProfile,
//                   child: Container(
//                     padding: const EdgeInsets.all(3),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 2),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.white.withOpacity(0.3),
//                           blurRadius: 8,
//                           spreadRadius: 1,
//                         ),
//                       ],
//                     ),
//                     child: CircleAvatar(
//                       radius: 65,
//                       backgroundColor: Colors.white,
//                       backgroundImage:
//                           widget.profileImageUrl != null &&
//                               widget.profileImageUrl!.isNotEmpty
//                           ? NetworkImage(widget.profileImageUrl!)
//                           : null,
//                       child:
//                           widget.profileImageUrl == null ||
//                               widget.profileImageUrl!.isEmpty
//                           ? const Icon(
//                               Icons.person,
//                               color: Color(0xFF667EEA),
//                               size: 24,
//                             )
//                           : null,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: _navigateToReferEarn,
//                   child: Transform.scale(
//                     scale: _pulseAnimation.value,
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.amber.withOpacity(0.4),
//                             Colors.orange.withOpacity(0.2),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.amber.withOpacity(0.4),
//                             blurRadius: 10,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.card_giftcard, // Gift/Refer icon
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: _navigateToAI,
//                   child: Transform.scale(
//                     scale: _pulseAnimation.value,
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: [
//                             const Color.fromARGB(
//                               255,
//                               201,
//                               30,
//                               161,
//                             ).withOpacity(0.3),
//                             const Color.fromARGB(
//                               255,
//                               201,
//                               30,
//                               161,
//                             ).withOpacity(0.3),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.white.withOpacity(0.3),
//                             blurRadius: 10,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Transform.rotate(
//                         angle: _rotationAnimation.value,
//                         child: const Icon(
//                           Icons.psychology, // AI brain icon
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               // Add this widget to your FancyAppBar actions (before the AI and Refer & Earn icons)

// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: GestureDetector(
//     onTap: () => _showLanguageSelector(context),
//     child: Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: LinearGradient(
//           colors: [
//             Colors.blue.withOpacity(0.4),
//             Colors.lightBlue.withOpacity(0.2),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.4),
//             blurRadius: 10,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: const Icon(
//         Icons.language,
//         color: Colors.white,
//         size: 24,
//       ),
//     ),
//   ),
// ),
//               const SizedBox(width: 8),
//             ],


// //             title: Transform.scale(
// //   scale: _pulseAnimation.value,
// //   child: ShaderMask(
// //     shaderCallback: (bounds) {
// //       return LinearGradient(
// //         colors: const [
// //           Colors.white,
// //           Color(0xFFE0E7FF),
// //           Colors.white,
// //           Color(0xFFE0E7FF),
// //         ],
// //         stops: [
// //           0.0,
// //           _shimmerAnimation.value / 2,
// //           _shimmerAnimation.value,
// //           1.0,
// //         ],
// //         begin: Alignment.topLeft,
// //         end: Alignment.bottomRight,
// //       ).createShader(bounds);
// //     },
// //     child: Column(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         // OLD CODE - REPLACE THIS:
// //         // Text(
// //         //   'Welcome back!',
// //         //   style: TextStyle(
// //         //     fontFamily: 'Serif',
// //         //     fontWeight: FontWeight.w400,
// //         //     fontSize: 14,
// //         //     letterSpacing: 1.5,
// //         //     color: Colors.white.withOpacity(0.9),
// //         //     shadows: const [
// //         //       Shadow(
// //         //         color: Colors.black26,
// //         //         offset: Offset(1, 1),
// //         //         blurRadius: 3,
// //         //       ),
// //         //     ],
// //         //   ),
// //         // ),
        
// //         // NEW CODE - WITH THIS:
// //         Consumer<LanguageProvider>(
// //           builder: (context, languageProvider, child) {
// //             return Text(
// //               LocalizationService.translate('welcome_back', languageProvider.locale.languageCode),
// //               style: TextStyle(
// //                 fontFamily: 'Serif',
// //                 fontWeight: FontWeight.w400,
// //                 fontSize: 14,
// //                 letterSpacing: 1.5,
// //                 color: Colors.white.withOpacity(0.9),
// //                 shadows: const [
// //                   Shadow(
// //                     color: Colors.black26,
// //                     offset: Offset(1, 1),
// //                     blurRadius: 3,
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         ),
// //         const SizedBox(height: 2),
// //         Text(
// //           widget.username ?? 'User',
// //           style: const TextStyle(
// //             fontFamily: 'Cursive',
// //             fontWeight: FontWeight.w900,
// //             fontSize: 24,
// //             letterSpacing: 1.5,
// //             color: Colors.white,
// //             shadows: [
// //               Shadow(
// //                 color: Colors.black26,
// //                 offset: Offset(2, 2),
// //                 blurRadius: 4,
// //               ),
// //             ],
// //           ),
// //           overflow: TextOverflow.ellipsis,
// //         ),
// //       ],
// //     ),
// //   ),
// // ),



// title: Transform.scale(
//   scale: _pulseAnimation.value,
//   child: ShaderMask(
//     shaderCallback: (bounds) {
//       return LinearGradient(
//         colors: const [
//           Colors.white,
//           Color(0xFFE0E7FF),
//           Colors.white,
//           Color(0xFFE0E7FF),
//         ],
//         stops: [
//           0.0,
//           _shimmerAnimation.value / 2,
//           _shimmerAnimation.value,
//           1.0,
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ).createShader(bounds);
//     },
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Consumer<LanguageProvider>(
//           builder: (context, languageProvider, child) {
//             return Text(
//               LocalizationService.translate('welcome_back', languageProvider.locale.languageCode),
//               style: TextStyle(
//                 fontFamily: 'Serif',
//                 fontWeight: FontWeight.w400,
//                 fontSize: 14,
//                 letterSpacing: 1.5,
//                 color: Colors.white.withOpacity(0.9),
//                 shadows: const [
//                   Shadow(
//                     color: Colors.black26,
//                     offset: Offset(1, 1),
//                     blurRadius: 3,
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//         const SizedBox(height: 2),
//         // USERNAME - This should NOT be translated as it's a proper name
//         Text(
//           widget.username ?? 'User',
//           style: const TextStyle(
//             fontFamily: 'Cursive',
//             fontWeight: FontWeight.w900,
//             fontSize: 24,
//             letterSpacing: 1.5,
//             color: Colors.white,
//             shadows: [
//               Shadow(
//                 color: Colors.black26,
//                 offset: Offset(2, 2),
//                 blurRadius: 4,
//               ),
//             ],
//           ),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     ),
//   ),
// ),
//             // title: Transform.scale(
//             //   scale: _pulseAnimation.value,
//             //   child: ShaderMask(
//             //     shaderCallback: (bounds) {
//             //       return LinearGradient(
//             //         colors: const [
//             //           Colors.white,
//             //           Color(0xFFE0E7FF),
//             //           Colors.white,
//             //           Color(0xFFE0E7FF),
//             //         ],
//             //         stops: [
//             //           0.0,
//             //           _shimmerAnimation.value / 2,
//             //           _shimmerAnimation.value,
//             //           1.0,
//             //         ],
//             //         begin: Alignment.topLeft,
//             //         end: Alignment.bottomRight,
//             //       ).createShader(bounds);
//             //     },
//             //     child: Column(
//             //       mainAxisAlignment: MainAxisAlignment.center,
//             //       children: [
//             //         Text(
//             //           'Welcome back!',
//             //           style: TextStyle(
//             //             fontFamily: 'Serif',
//             //             fontWeight: FontWeight.w400,
//             //             fontSize: 14,
//             //             letterSpacing: 1.5,
//             //             color: Colors.white.withOpacity(0.9),
//             //             shadows: const [
//             //               Shadow(
//             //                 color: Colors.black26,
//             //                 offset: Offset(1, 1),
//             //                 blurRadius: 3,
//             //               ),
//             //             ],
//             //           ),
//             //         ),
//             //         const SizedBox(height: 2),
//             //         Text(
//             //           widget.username ?? 'User',
//             //           style: const TextStyle(
//             //             fontFamily: 'Cursive',
//             //             fontWeight: FontWeight.w900,
//             //             fontSize: 24,
//             //             letterSpacing: 1.5,
//             //             color: Colors.white,
//             //             shadows: [
//             //               Shadow(
//             //                 color: Colors.black26,
//             //                 offset: Offset(2, 2),
//             //                 blurRadius: 4,
//             //               ),
//             //             ],
//             //           ),
//             //           overflow: TextOverflow.ellipsis,
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             flexibleSpace: Stack(
//               children: [
//                 // Main gradient background
//                 Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xFF6366F1),
//                         Color(0xFF818CF8),
//                         Color(0xFF8B5CF6),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                 ),
//                 // Animated overlay gradient
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.white.withOpacity(0.1 * _pulseAnimation.value),
//                         Colors.transparent,
//                         Colors.white.withOpacity(0.05 * _pulseAnimation.value),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                 ),
//                 // Floating particles effect
//                 Positioned(
//                   top: 20 + (_borderAnimation.value * 2),
//                   right: 30,
//                   child: Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white.withOpacity(0.1),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.white.withOpacity(0.2),
//                           blurRadius: 20,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 10 + (_borderAnimation.value * -1),
//                   left: 40,
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white.withOpacity(0.08),
//                     ),
//                   ),
//                 ),
//                 // Shimmer line effect
//                 Positioned(
//                   left:
//                       _shimmerAnimation.value *
//                       MediaQuery.of(context).size.width /
//                       2,
//                   top: 0,
//                   bottom: 0,
//                   child: Container(
//                     width: 100,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.transparent,
//                           Colors.white.withOpacity(0.15),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

// void _showLanguageSelector(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext dialogContext) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Select Language',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               _buildLanguageOption(
//                 context,
//                 dialogContext,
//                 'English',
//                 'en',
//                 Icons.language,
//               ),
//               const SizedBox(height: 12),
//               _buildLanguageOption(
//                 context,
//                 dialogContext,
//                 'हिंदी',
//                 'hi',
//                 Icons.translate,
//               ),
//               const SizedBox(height: 12),
//               _buildLanguageOption(
//                 context,
//                 dialogContext,
//                 'తెలుగు',
//                 'te',
//                 Icons.g_translate,
//               ),
//               const SizedBox(height: 12),
//               _buildLanguageOption(
//                 context,
//                 dialogContext,
//                 'தமிழ்',
//                 'ta',
//                 Icons.language_rounded,
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// // Widget _buildLanguageOption(
// //   BuildContext context,
// //   BuildContext dialogContext,
// //   String languageName,
// //   String languageCode,
// //   IconData icon,
// // ) {
// //   final languageProvider = Provider.of<LanguageProvider>(
// //     context,
// //     listen: true, // Changed to true to rebuild when language changes
// //   );
// //   final isSelected = languageProvider.locale.languageCode == languageCode;

// //   return InkWell(
// //     onTap: () async {
// //       // Change the language
// //       await languageProvider.setLocale(Locale(languageCode));
      
// //       // Close the dialog
// //       Navigator.pop(dialogContext);
      
// //       // Show confirmation
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(
// //             LocalizationService.translate('language_switched', languageCode),
// //           ),
// //           duration: const Duration(seconds: 2),
// //           backgroundColor: const Color(0xFF10B981),
// //         ),
// //       );
      
// //       // Force rebuild of the entire app
// //       // This ensures all widgets update with the new language
// //     },
// //     borderRadius: BorderRadius.circular(12),
// //     child: Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //       decoration: BoxDecoration(
// //         color: isSelected
// //             ? Colors.white.withOpacity(0.3)
// //             : Colors.white.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(
// //           color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
// //           width: isSelected ? 2 : 1,
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(
// //             icon,
// //             color: Colors.white,
// //             size: 24,
// //           ),
// //           const SizedBox(width: 12),
// //           Text(
// //             languageName,
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
// //               color: Colors.white,
// //             ),
// //           ),
// //           const Spacer(),
// //           if (isSelected)
// //             const Icon(
// //               Icons.check_circle,
// //               color: Colors.white,
// //               size: 20,
// //             ),
// //         ],
// //       ),
// //     ),
// //   );
// // }


// // Widget _buildLanguageOption(
// //   BuildContext context,
// //   BuildContext dialogContext,
// //   String languageName,
// //   String languageCode,
// //   IconData icon,
// // ) {
// //   final languageProvider = Provider.of<LanguageProvider>(
// //     context,
// //     listen: true,
// //   );
// //   final isSelected = languageProvider.locale.languageCode == languageCode;

// //   return InkWell(
// //     onTap: () async {
// //       // Change the language locally
// //       await languageProvider.setLocale(Locale(languageCode));
      
// //       // Call API to update language on server
// //       if (widget.userId != null) {
// //         final success = await ApiService.updateUserLanguage(
// //           widget.userId!,
// //           languageCode,
// //         );
        
// //         if (!success) {
// //           print('Failed to update language on server');
// //         }
// //       }
      
// //       // Close the dialog
// //       Navigator.pop(dialogContext);
      
// //       // Show confirmation
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(
// //             LocalizationService.translate('language_switched', languageCode),
// //           ),
// //           duration: const Duration(seconds: 2),
// //           backgroundColor: const Color(0xFF10B981),
// //         ),
// //       );
// //     },
// //     borderRadius: BorderRadius.circular(12),
// //     child: Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //       decoration: BoxDecoration(
// //         color: isSelected
// //             ? Colors.white.withOpacity(0.3)
// //             : Colors.white.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(
// //           color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
// //           width: isSelected ? 2 : 1,
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(icon, color: Colors.white, size: 24),
// //           const SizedBox(width: 12),
// //           Text(
// //             languageName,
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
// //               color: Colors.white,
// //             ),
// //           ),
// //           const Spacer(),
// //           if (isSelected)
// //             const Icon(Icons.check_circle, color: Colors.white, size: 20),
// //         ],
// //       ),
// //     ),
// //   );
// // }



// // Widget _buildLanguageOption(
// //   BuildContext context,
// //   BuildContext dialogContext,
// //   String languageName,
// //   String languageCode,
// //   IconData icon,
// // ) {
// //   final languageProvider = Provider.of<LanguageProvider>(
// //     context,
// //     listen: true,
// //   );
// //   final isSelected = languageProvider.locale.languageCode == languageCode;

// //   return InkWell(
// //     onTap: () async {
// //       // Close the dialog first
// //       Navigator.pop(dialogContext);
      
// //       // Call API to update language on server FIRST
// //       if (widget.userId != null) {
// //         final success = await ApiService.updateUserLanguage(
// //           widget.userId!,
// //           languageCode,
// //         );
        
// //         if (!success) {
// //           // Show error if API call failed
// //           if (context.mounted) {
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               SnackBar(
// //                 content: Text('Failed to update language on server'),
// //                 duration: const Duration(seconds: 2),
// //                 backgroundColor: Colors.red,
// //               ),
// //             );
// //           }
// //           return; // Don't change language locally if server update failed
// //         }
// //       }
      
// //       // Only change the language locally AFTER successful server update
// //       await languageProvider.setLocale(Locale(languageCode));
      
// //       // Show confirmation
// //       if (context.mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(
// //               LocalizationService.translate('language_switched', languageCode),
// //             ),
// //             duration: const Duration(seconds: 2),
// //             backgroundColor: const Color(0xFF10B981),
// //           ),
// //         );
// //       }
// //     },
// //     borderRadius: BorderRadius.circular(12),
// //     child: Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //       decoration: BoxDecoration(
// //         color: isSelected
// //             ? Colors.white.withOpacity(0.3)
// //             : Colors.white.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(
// //           color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
// //           width: isSelected ? 2 : 1,
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(icon, color: Colors.white, size: 24),
// //           const SizedBox(width: 12),
// //           Text(
// //             languageName,
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
// //               color: Colors.white,
// //             ),
// //           ),
// //           const Spacer(),
// //           if (isSelected)
// //             const Icon(Icons.check_circle, color: Colors.white, size: 20),
// //         ],
// //       ),
// //     ),
// //   );
// // }




// Widget _buildLanguageOption(
//   BuildContext context,
//   BuildContext dialogContext,
//   String languageName,
//   String languageCode,
//   IconData icon,
// ) {
//   final languageProvider = Provider.of<LanguageProvider>(
//     context,
//     listen: true,
//   );
//   final isSelected = languageProvider.locale.languageCode == languageCode;

//   return InkWell(
//     onTap: () async {
//       // Close the dialog first
//       Navigator.pop(dialogContext);
      
//       // Set userId in provider if not already set
//       if (widget.userId != null) {
//         languageProvider.setUserId(widget.userId);
//       }
      
//       // Change language (this will call API internally)
//       final success = await languageProvider.setLocale(Locale(languageCode));
      
//       // Show appropriate message
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               success 
//                 ? LocalizationService.translate('language_switched', languageCode)
//                 : 'Failed to update language',
//             ),
//             duration: const Duration(seconds: 2),
//             backgroundColor: success ? const Color(0xFF10B981) : Colors.red,
//           ),
//         );
//       }
//     },
//     borderRadius: BorderRadius.circular(12),
//     child: Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: isSelected
//             ? Colors.white.withOpacity(0.3)
//             : Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
//           width: isSelected ? 2 : 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.white, size: 24),
//           const SizedBox(width: 12),
//           Text(
//             languageName,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//           const Spacer(),
//           if (isSelected)
//             const Icon(Icons.check_circle, color: Colors.white, size: 20),
//         ],
//       ),
//     ),
//   );
// }
// }


















import 'package:flutter/material.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/services/language/language_service.dart';
import 'package:posternova/services/language/restart_lan_service.dart';
import 'package:posternova/views/AI/chat_ai.dart';
import 'dart:math' as math;
import 'package:posternova/views/ProfileScreen/profile_screen.dart';
import 'package:posternova/views/referearn/referearn_screen.dart';
import 'package:posternova/widgets/language_animation_widget.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FancyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? userId;

  const FancyAppBar({
    super.key,
    this.userId,
  });

  @override
  State<FancyAppBar> createState() => _FancyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _FancyAppBarState extends State<FancyAppBar>
    with TickerProviderStateMixin {
  late AnimationController _borderController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late AnimationController _iconController;

  late Animation<double> _borderAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  String? _username;
  String? _profileImageUrl;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();

    // Fetch user profile
    _fetchUserProfile();


      WidgetsBinding.instance.addPostFrameCallback((_) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    languageProvider.addListener(_onLanguageChanged);
  });


    // Border radius animation
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _borderAnimation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _borderController, curve: Curves.easeInOutSine),
    );

    // Shimmer effect animation
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Icon rotation animation
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _iconController, curve: Curves.linear));
  }


void _onLanguageChanged() {
  // Refetch profile when language changes to get updated name
  _fetchUserProfile();
}
  // Future<void> _fetchUserProfile() async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   final userId = widget.userId ?? authProvider.user?.user.id;

  //   if (userId == null) {
  //     setState(() => _isLoadingProfile = false);
  //     return;
  //   }

  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://31.97.206.144:4061/api/users/get-profile/$userId'),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       setState(() {
  //         _username = data['name'] ?? 'User';
  //         _profileImageUrl = data['profileImage'];
  //         _isLoadingProfile = false;
  //       });

  //       // Update language provider with userId
  //       final languageProvider = Provider.of<LanguageProvider>(
  //         context,
  //         listen: false,
  //       );
  //       languageProvider.setUserId(userId);
  //     } else {
  //       setState(() => _isLoadingProfile = false);
  //     }
  //   } catch (e) {
  //     print('Error fetching user profile: $e');
  //     setState(() => _isLoadingProfile = false);
  //   }
  // }



  Future<void> _fetchUserProfile() async {
  try {
    // Load directly from storage — don't depend on widget.userId
    final userData = await AuthPreferences.getUserData();
    final userId = userData?.user.id ?? widget.userId;

    if (userId == null) {
      setState(() => _isLoadingProfile = false);
      return;
    }

    final response = await http.get(
      Uri.parse('http://31.97.228.17:4061/api/users/get-profile/$userId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _username = data['name'] ?? userData?.user.name ?? 'User';
        _profileImageUrl = data['profileImage'];
        _isLoadingProfile = false;
      });

      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );
      languageProvider.setUserId(userId);
    } else {
      // Fallback: use locally stored name if API fails
      setState(() {
        _username = userData?.user.name ?? 'User';
        _isLoadingProfile = false;
      });
    }
  } catch (e) {
    print('Error fetching user profile: $e');
    // Fallback to stored name on error
    try {
      final userData = await AuthPreferences.getUserData();
      setState(() {
        _username = userData?.user.name ?? 'User';
        _isLoadingProfile = false;
      });
    } catch (_) {
      setState(() => _isLoadingProfile = false);
    }
  }
}

  @override
  void dispose() {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
  languageProvider.removeListener(_onLanguageChanged);
    _borderController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _navigateToProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );

    // Refresh profile data if profile was updated
    if (result == true) {
      _fetchUserProfile();
    }
  }

  void _navigateToAI() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiScreen(),
      ),
    );
  }

  void _navigateToReferEarn() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReferEarnScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _borderAnimation,
        _shimmerAnimation,
        _pulseAnimation,
        _rotationAnimation,
      ]),
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30 + _borderAnimation.value),
          ),
          child: AppBar(
            elevation: 8,
            shadowColor: Colors.deepPurple.withOpacity(0.5),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: 'profile_avatar',
                child: GestureDetector(
                  onTap: _navigateToProfile,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.white,
                      backgroundImage: _profileImageUrl != null &&
                              _profileImageUrl!.isNotEmpty
                          ? NetworkImage(_profileImageUrl!)
                          : null,
                      child: _profileImageUrl == null ||
                              _profileImageUrl!.isEmpty
                          ? const Icon(
                              Icons.person,
                              color: Color(0xFF667EEA),
                              size: 24,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: _navigateToReferEarn,
                  child: Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.withOpacity(0.4),
                            Colors.orange.withOpacity(0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: _navigateToAI,
                  child: Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(255, 201, 30, 161)
                                .withOpacity(0.3),
                            const Color.fromARGB(255, 201, 30, 161)
                                .withOpacity(0.3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: const Icon(
                          Icons.psychology,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _showLanguageSelector(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.4),
                          Colors.lightBlue.withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.language,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            title: _isLoadingProfile
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Transform.scale(
                    scale: _pulseAnimation.value,
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: const [
                            Colors.white,
                            Color(0xFFE0E7FF),
                            Colors.white,
                            Color(0xFFE0E7FF),
                          ],
                          stops: [
                            0.0,
                            _shimmerAnimation.value / 2,
                            _shimmerAnimation.value,
                            1.0,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<LanguageProvider>(
                            builder: (context, languageProvider, child) {
                              return Text(
                                LocalizationService.translate(
                                  'welcome_back',
                                  languageProvider.locale.languageCode,
                                ),
                                style: TextStyle(
                                  fontFamily: 'Calibri',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  letterSpacing: 1.5,
                                  color: Colors.white.withOpacity(0.9),
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _username ?? 'User',
                            style: const TextStyle(
                               fontFamily: 'Calibri', 
                              // fontFamily: 'Cursive',
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              letterSpacing: 1.5,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
            flexibleSpace: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF818CF8),
                        Color(0xFF8B5CF6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1 * _pulseAnimation.value),
                        Colors.transparent,
                        Colors.white.withOpacity(0.05 * _pulseAnimation.value),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Positioned(
                  top: 20 + (_borderAnimation.value * 2),
                  right: 30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10 + (_borderAnimation.value * -1),
                  left: 40,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                Positioned(
                  left: _shimmerAnimation.value *
                      MediaQuery.of(context).size.width /
                      2,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                _buildLanguageOption(
                  context,
                  dialogContext,
                  'English',
                  'en',
                  Icons.language,
                ),
                const SizedBox(height: 12),
                _buildLanguageOption(
                  context,
                  dialogContext,
                  'हिंदी',
                  'hi',
                  Icons.translate,
                ),
                // const SizedBox(height: 12),
                // _buildLanguageOption(
                //   context,
                //   dialogContext,
                //   'తెలుగు',
                //   'te',
                //   Icons.g_translate,
                // ),
                // const SizedBox(height: 12),
                // _buildLanguageOption(
                //   context,
                //   dialogContext,
                //   'தமிழ்',
                //   'ta',
                //   Icons.language_rounded,
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    BuildContext dialogContext,
    String languageName,
    String languageCode,
    IconData icon,
  ) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: true,
    );
    final isSelected = languageProvider.locale.languageCode == languageCode;

    return InkWell(
      // onTap: () async {
      //   Navigator.pop(dialogContext);

      //   final success = await languageProvider.setLocale(Locale(languageCode));

      //   if (context.mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(
      //           success
      //               ? LocalizationService.translate(
      //                   'language_switched',
      //                   languageCode,
      //                 )
      //               : 'Failed to update language',
      //         ),
      //         duration: const Duration(seconds: 2),
      //         backgroundColor: success ? const Color(0xFF10B981) : Colors.red,
      //       ),
      //     );
      //   }
      // },

      onTap: () async {
  Navigator.pop(dialogContext);

  // Show transition overlay
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (overlayContext) => LanguageTransitionScreen(
      languageName: languageName,
      languageCode: languageCode,
      onComplete: () async {
        // Save locale first
        final lp = Provider.of<LanguageProvider>(context, listen: false);
        await lp.setLocale(Locale(languageCode));
        // Remove overlay
        overlayEntry.remove();
        // Restart the entire app widget tree
        AppRestartService.restartApp(context);
      },
    ),
  );

  Overlay.of(context).insert(overlayEntry);
},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              languageName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}