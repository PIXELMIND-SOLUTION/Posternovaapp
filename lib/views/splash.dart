// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:posternova/views/AuthModule/auth_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late AnimationController _scaleController;
//   late AnimationController _rotateController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _rotateAnimation;

//   @override
//   void initState() {
//     super.initState();
    
//     // Fade animation
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
//     );

//     // Scale animation
//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
//     );

//     // Rotate animation
//     _rotateController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );
//     _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
//     );

//     // Start animations
//     _fadeController.forward();
//     _scaleController.forward();
//     _rotateController.repeat();

//     // Navigate to next screen after 3 seconds
//     Timer(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const AuthScreen()),
//       );
//       print('Navigate to Auth Screen');
//     });
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _scaleController.dispose();
//     _rotateController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF0A0E21),
//               Color(0xFF1D1E33),
//               Color(0xFF2D1B69),
//               Color(0xFF1D1E33),
//               Color(0xFF0A0E21),
//             ],
//             stops: [0.0, 0.25, 0.5, 0.75, 1.0],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Animated background particles
//             ...List.generate(20, (index) {
//               return AnimatedParticle(
//                 delay: index * 100,
//                 size: (index % 3 + 1) * 3.0,
//               );
//             }),
            
//             // Main content
//             Center(
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Animated Logo
//                     ScaleTransition(
//                       scale: _scaleAnimation,
//                       child: RotationTransition(
//                         turns: _rotateAnimation,
//                         child: Container(
//                           padding: const EdgeInsets.all(30),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.purple.shade400,
//                                 Colors.blue.shade400,
//                                 Colors.pink.shade400,
//                               ],
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.purple.withOpacity(0.6),
//                                 blurRadius: 40,
//                                 spreadRadius: 10,
//                               ),
//                               BoxShadow(
//                                 color: Colors.blue.withOpacity(0.4),
//                                 blurRadius: 60,
//                                 spreadRadius: 15,
//                               ),
//                             ],
//                           ),
//                           child: const Icon(
//                             Icons.auto_awesome,
//                             size: 80,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
                    
//                     const SizedBox(height: 40),
                    
//                     // App Name
//                     ShaderMask(
//                       shaderCallback: (bounds) => LinearGradient(
//                         colors: [
//                           Colors.purple.shade300,
//                           Colors.blue.shade300,
//                           Colors.pink.shade300,
//                         ],
//                       ).createShader(bounds),
//                       child: const Text(
//                         'PosterNova',
//                         style: TextStyle(
//                           fontSize: 48,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           letterSpacing: 3,
//                         ),
//                       ),
//                     ),
                    
//                     const SizedBox(height: 15),
                    
//                     // Tagline
//                     Text(
//                       'Create • Design • Inspire',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey.shade400,
//                         letterSpacing: 2,
//                         fontWeight: FontWeight.w300,
//                       ),
//                     ),
                    
//                     const SizedBox(height: 60),
                    
//                     // Loading indicator
//                     SizedBox(
//                       width: 200,
//                       child: TweenAnimationBuilder<double>(
//                         tween: Tween(begin: 0.0, end: 1.0),
//                         duration: const Duration(seconds: 3),
//                         builder: (context, value, child) {
//                           return Column(
//                             children: [
//                               LinearProgressIndicator(
//                                 value: value,
//                                 backgroundColor: Colors.grey.shade800,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Colors.purple.shade300,
//                                 ),
//                                 minHeight: 3,
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
            
//             // Bottom text
//             Positioned(
//               bottom: 40,
//               left: 0,
//               right: 0,
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Center(
//                   child: Text(
//                     'Powered by Innovation',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade600,
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Animated particle widget for background effect
// class AnimatedParticle extends StatefulWidget {
//   final int delay;
//   final double size;

//   const AnimatedParticle({
//     Key? key,
//     required this.delay,
//     required this.size,
//   }) : super(key: key);

//   @override
//   State<AnimatedParticle> createState() => _AnimatedParticleState();
// }

// class _AnimatedParticleState extends State<AnimatedParticle> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   late double left;
//   late double top;

//   @override
//   void initState() {
//     super.initState();
    
//     left = (widget.delay % 10) * 40.0;
//     top = (widget.delay % 15) * 50.0;
    
//     _controller = AnimationController(
//       duration: Duration(milliseconds: 3000 + widget.delay),
//       vsync: this,
//     );
    
//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    
//     Future.delayed(Duration(milliseconds: widget.delay), () {
//       if (mounted) {
//         _controller.repeat(reverse: true);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: left,
//       top: top,
//       child: FadeTransition(
//         opacity: _animation,
//         child: Container(
//           width: widget.size,
//           height: widget.size,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.purple.withOpacity(0.3),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.purple.withOpacity(0.4),
//                 blurRadius: 10,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'dart:async';
import 'package:posternova/views/AuthModule/auth_screen.dart';
import 'package:posternova/views/NavBar/navbar_screen.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Rotate animation
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    _rotateController.repeat();

    // Check login status and navigate
    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    // Wait for animations to complete
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;

    try {
      // Initialize auth provider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initialize();

      // Check if user is logged in
      final isLoggedIn = await AuthPreferences.isLoggedIn();
      final userData = await AuthPreferences.getUserData();

      if (!mounted) return;

      if (isLoggedIn && userData != null) {
        // User is logged in, navigate to main screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainNavigationScreen()),
        );
        print('Navigate to Main Navigation Screen - User is logged in');
      } else {
        // User is not logged in, navigate to auth screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
        print('Navigate to Auth Screen - User not logged in');
      }
    } catch (e) {
      print('Error checking login status: $e');
      // On error, navigate to auth screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E21),
              Color(0xFF1D1E33),
              Color(0xFF2D1B69),
              Color(0xFF1D1E33),
              Color(0xFF0A0E21),
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(20, (index) {
              return AnimatedParticle(
                delay: index * 100,
                size: (index % 3 + 1) * 3.0,
              );
            }),
            
            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: RotationTransition(
                        turns: _rotateAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade400,
                                Colors.blue.shade400,
                                Colors.pink.shade400,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.6),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 60,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // App Name
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Colors.purple.shade300,
                          Colors.blue.shade300,
                          Colors.pink.shade300,
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'Editezy',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // Tagline
                    Text(
                      'Create • Design • Inspire',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade400,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Loading indicator
                    SizedBox(
                      width: 200,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 3),
                        builder: (context, value, child) {
                          return Column(
                            children: [
                              LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors.grey.shade800,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.purple.shade300,
                                ),
                                minHeight: 3,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom text
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: Text(
                    'Powered by Innovation',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated particle widget for background effect
class AnimatedParticle extends StatefulWidget {
  final int delay;
  final double size;

  const AnimatedParticle({
    Key? key,
    required this.delay,
    required this.size,
  }) : super(key: key);

  @override
  State<AnimatedParticle> createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<AnimatedParticle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double left;
  late double top;

  @override
  void initState() {
    super.initState();
    
    left = (widget.delay % 10) * 40.0;
    top = (widget.delay % 15) * 50.0;
    
    _controller = AnimationController(
      duration: Duration(milliseconds: 3000 + widget.delay),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: FadeTransition(
        opacity: _animation,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.purple.withOpacity(0.3),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}