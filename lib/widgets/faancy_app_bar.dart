// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class FancyAppBar extends StatefulWidget implements PreferredSizeWidget {
//   const FancyAppBar({super.key});

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
//     _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
//       CurvedAnimation(parent: _iconController, curve: Curves.linear),
//     );
//   }

//   @override
//   void dispose() {
//     _borderController.dispose();
//     _shimmerController.dispose();
//     _pulseController.dispose();
//     _iconController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
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
//               child: Transform.rotate(
//                 angle: _rotationAnimation.value,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: RadialGradient(
//                       colors: [
//                         Colors.white.withOpacity(0.3),
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                   child: const Icon(Icons.stars, color: Colors.white),
//                 ),
//               ),
//             ),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Transform.scale(
//                   scale: _pulseAnimation.value,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.white.withOpacity(0.3),
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: const Icon(Icons.notifications_active),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//             ],
// title: Transform.scale(
//               scale: _pulseAnimation.value,
//               child: ShaderMask(
//                 shaderCallback: (bounds) {
//                   return LinearGradient(
//                     colors: const [
//                       Colors.white,
//                       Color(0xFFE0E7FF),
//                       Colors.white,
//                       Color(0xFFE0E7FF),
//                     ],
//                     stops: [
//                       0.0,
//                       _shimmerAnimation.value / 2,
//                       _shimmerAnimation.value,
//                       1.0,
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ).createShader(bounds);
//                 },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Text(
//                       'Welcome to',
//                       style: TextStyle(
//                         fontFamily: 'Serif',
//                         fontWeight: FontWeight.w300,
//                         fontSize: 16,
//                         letterSpacing: 2,
//                         color: Color.fromARGB(255, 60, 60, 60),
//                         shadows: [
//                           Shadow(
//                             color: Colors.black26,
//                             offset: Offset(1, 1),
//                             blurRadius: 3,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 2),
//                     Text(
//                       'PosterNova',
//                       style: TextStyle(
//                         fontFamily: 'Cursive',
//                         fontWeight: FontWeight.w900,
//                         fontSize: 32,
//                         letterSpacing: 2,
//                         color: Color.fromARGB(255, 0, 0, 0),
//                         shadows: [
//                           Shadow(
//                             color: Colors.black26,
//                             offset: Offset(2, 2),
//                             blurRadius: 4,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
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
//                   left: _shimmerAnimation.value * MediaQuery.of(context).size.width / 2,
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
// }













// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class FancyAppBar extends StatefulWidget implements PreferredSizeWidget {
//   final String? username;
//   final String? profileImageUrl;
//   final VoidCallback? onProfileTap;

//   const FancyAppBar({
//     super.key,
//     this.username,
//     this.profileImageUrl,
//     this.onProfileTap,
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
//     _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
//       CurvedAnimation(parent: _iconController, curve: Curves.linear),
//     );
//   }

//   @override
//   void dispose() {
//     _borderController.dispose();
//     _shimmerController.dispose();
//     _pulseController.dispose();
//     _iconController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
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
//                   onTap: widget.onProfileTap,
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
//                       radius: 50,
//                       backgroundColor: Colors.white,
//                       backgroundImage: widget.profileImageUrl != null && 
//                               widget.profileImageUrl!.isNotEmpty
//                           ? NetworkImage(widget.profileImageUrl!)
//                           : null,
//                       child: widget.profileImageUrl == null || 
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
//                 child: Transform.scale(
//                   scale: _pulseAnimation.value,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.white.withOpacity(0.3),
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: const Icon(Icons.notifications_active),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//             ],
//             title: Transform.scale(
//               scale: _pulseAnimation.value,
//               child: ShaderMask(
//                 shaderCallback: (bounds) {
//                   return LinearGradient(
//                     colors: const [
//                       Colors.white,
//                       Color(0xFFE0E7FF),
//                       Colors.white,
//                       Color(0xFFE0E7FF),
//                     ],
//                     stops: [
//                       0.0,
//                       _shimmerAnimation.value / 2,
//                       _shimmerAnimation.value,
//                       1.0,
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ).createShader(bounds);
//                 },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Welcome back!',
//                       style: TextStyle(
//                         fontFamily: 'Serif',
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14,
//                         letterSpacing: 1.5,
//                         color: Colors.white.withOpacity(0.9),
//                         shadows: const [
//                           Shadow(
//                             color: Colors.black26,
//                             offset: Offset(1, 1),
//                             blurRadius: 3,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       widget.username ?? 'User',
//                       style: const TextStyle(
//                         fontFamily: 'Cursive',
//                         fontWeight: FontWeight.w900,
//                         fontSize: 24,
//                         letterSpacing: 1.5,
//                         color: Colors.white,
//                         shadows: [
//                           Shadow(
//                             color: Colors.black26,
//                             offset: Offset(2, 2),
//                             blurRadius: 4,
//                           ),
//                         ],
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
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
//                   left: _shimmerAnimation.value * MediaQuery.of(context).size.width / 2,
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
// }









import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:posternova/views/ProfileScreen/profile_screen.dart';

class FancyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? username;
  final String? profileImageUrl;
  final VoidCallback? onProfileTap;

  const FancyAppBar({
    super.key,
    this.username,
    this.profileImageUrl,
    this.onProfileTap,
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

  @override
  void initState() {
    super.initState();
    
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
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _borderController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _navigateToProfile() {
    if (widget.onProfileTap != null) {
      widget.onProfileTap!();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>ProfileScreen()
        ),
      );
    }
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
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: widget.profileImageUrl != null && 
                              widget.profileImageUrl!.isNotEmpty
                          ? NetworkImage(widget.profileImageUrl!)
                          : null,
                      child: widget.profileImageUrl == null || 
                              widget.profileImageUrl!.isEmpty
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
                child: Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.notifications_active),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            title: Transform.scale(
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
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontFamily: 'Serif',
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
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.username ?? 'User',
                      style: const TextStyle(
                        fontFamily: 'Cursive',
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
                // Main gradient background
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
                // Animated overlay gradient
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
                // Floating particles effect
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
                // Shimmer line effect
                Positioned(
                  left: _shimmerAnimation.value * MediaQuery.of(context).size.width / 2,
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
}
