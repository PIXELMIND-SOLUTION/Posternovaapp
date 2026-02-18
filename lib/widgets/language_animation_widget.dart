// lib/views/language_transition/language_transition_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class LanguageTransitionScreen extends StatefulWidget {
  final String languageName;
  final String languageCode;
  final VoidCallback onComplete;

  const LanguageTransitionScreen({
    Key? key,
    required this.languageName,
    required this.languageCode,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<LanguageTransitionScreen> createState() =>
      _LanguageTransitionScreenState();
}

class _LanguageTransitionScreenState extends State<LanguageTransitionScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late AnimationController _rippleController;
  late AnimationController _exitController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _exitAnimation;

  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _generateParticles();
    _setupAnimations();
    _startSequence();
  }

  void _generateParticles() {
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 6 + 2,
        speed: _random.nextDouble() * 0.8 + 0.3,
        opacity: _random.nextDouble() * 0.6 + 0.2,
        angle: _random.nextDouble() * 2 * math.pi,
      ));
    }
  }

  void _setupAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.0),
        weight: 40,
      ),
    ]).animate(_mainController);

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    _textSlideAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeInOut),
    );

    _exitAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInCubic),
    );
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _mainController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1800));
    // Exit animation
    _rippleController.stop();
    _particleController.stop();
    await _exitController.forward();
    widget.onComplete();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _textController.dispose();
    _rippleController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _mainController,
        _particleController,
        _textController,
        _rippleController,
        _exitController,
      ]),
      builder: (context, _) {
        return Opacity(
          opacity: _exitController.isAnimating
              ? _exitAnimation.value
              : _fadeInAnimation.value,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                    Color(0xFF0F3460),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Animated particles
                  ..._particles.map((particle) {
                    final progress = _particleAnimation.value;
                    final dx = math.cos(particle.angle) *
                        particle.speed *
                        progress *
                        size.width *
                        0.3;
                    final dy = math.sin(particle.angle) *
                        particle.speed *
                        progress *
                        size.height *
                        0.3;
                    return Positioned(
                      left: particle.x * size.width +
                          dx % size.width -
                          particle.size / 2,
                      top: particle.y * size.height +
                          dy % size.height -
                          particle.size / 2,
                      child: Opacity(
                        opacity: particle.opacity *
                            (1 - (progress % 1.0) * 0.3),
                        child: Container(
                          width: particle.size,
                          height: particle.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF818CF8).withOpacity(0.8),
                                blurRadius: particle.size * 2,
                                spreadRadius: particle.size * 0.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  // Ripple rings
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: List.generate(3, (i) {
                        final delay = i / 3.0;
                        final progress =
                            ((_rippleAnimation.value + delay) % 1.0);
                        return Opacity(
                          opacity: (1 - progress) * 0.3,
                          child: Container(
                            width: 80 + progress * 260,
                            height: 80 + progress * 260,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF818CF8),
                                width: 1.5,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Center logo + icon
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF6366F1),
                                  Color(0xFF8B5CF6),
                                  Color(0xFFEC4899),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6366F1).withOpacity(
                                      _glowAnimation.value * 0.8),
                                  blurRadius: 40 * _glowAnimation.value,
                                  spreadRadius: 10 * _glowAnimation.value,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.language_rounded,
                              color: Colors.white,
                              size: 52,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Switching text
                        Transform.translate(
                          offset: Offset(0, _textSlideAnimation.value),
                          child: Opacity(
                            opacity: _textController.value,
                            child: Column(
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      Color(0xFF818CF8),
                                      Color(0xFFEC4899),
                                      Color(0xFF818CF8),
                                    ],
                                  ).createShader(bounds),
                                  child: const Text(
                                    'Switching Language',
                                    style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 3,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  widget.languageName,
                                  style: const TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                    shadows: [
                                      Shadow(
                                        color: Color(0xFF6366F1),
                                        blurRadius: 20,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildLoadingDots(),
                              ],
                            ),
                          ),
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

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final progress = (_particleAnimation.value * 3 - i) % 1.0;
        final scale = progress < 0.5
            ? 0.6 + progress * 0.8
            : 1.0 - (progress - 0.5) * 0.8;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Transform.scale(
            scale: scale.clamp(0.6, 1.0),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.6),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Particle {
  final double x, y, size, speed, opacity, angle;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.angle,
  });
}