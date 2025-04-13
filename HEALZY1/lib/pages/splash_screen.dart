import 'package:flutter/material.dart';
import 'package:healzy/pages/login.dart';
import 'dart:async';
import 'dart:math' as Math;

void main() {
  runApp(MaterialApp(
    home: HealzySplashScreen(nextScreen: LoginScreen()),
  ));
}

class HealzySplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const HealzySplashScreen({Key? key, required this.nextScreen}) : super(key: key);

  @override
  _HealzySplashScreenState createState() => _HealzySplashScreenState();
}

class _HealzySplashScreenState extends State<HealzySplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _particleController;
  late Timer _navigationTimer;
  bool _showSlogan = false;
  bool _showLoadingDots = false;
  final List<BackgroundGlow> _backgroundGlows = [];
  bool _isInitialized = false;
  bool _imageLoaded = false;

  // Mental health color palette
  final Color _primaryColor = const Color(0xFFD5B06D);
  final Color _secondaryColor = const Color(0xFF9F6C0C);
  final Color _tertiaryColor = const Color(0xFFF1C309);
  final Color _textPrimaryColor = const Color(0xFFB5660D);
  final Color _textSecondaryColor = const Color(0xFFE88608);
  // This variable was referenced but not defined in the original code - adding it here
  final Color _calmingColor = const Color(0xFFB8D9E3);

  @override
  void initState() {
    super.initState();

    // Improved animation timings for a more cohesive experience
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showSlogan = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _showLoadingDots = true;
        });
      }
    });

    // Animation controller for background elements
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // Navigate to next screen after splash duration
    _navigationTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Preload the GIF image
    if (!_imageLoaded) {
      precacheImage(const AssetImage('animations/logo_anime.gif'), context)
          .then((_) {
        if (mounted) {
          setState(() {
            _imageLoaded = true;
          });
        }
      }).catchError((error) {
        print('Failed to load animation: $error');
        if (mounted) {
          setState(() {
            _imageLoaded = true;
          });
        }
      });
    }

    if (!_isInitialized) {
      _isInitialized = true;

      // Start animations with staggered delays
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _generateBackgroundGlows();
        }
      });
    }
  }

  void _generateBackgroundGlows() {
    if (!mounted) return;

    final screenSize = MediaQuery.of(context).size;
    List<BackgroundGlow> newGlows = [];

    // Create larger, calming background elements
    for (int i = 0; i < 6; i++) {
      final xPos = Math.Random().nextDouble() * screenSize.width;
      final yPos = Math.Random().nextDouble() * screenSize.height;
      final size = 100 + (Math.Random().nextDouble() * 180);
      final opacity = 0.05 + (Math.Random().nextDouble() * 0.12);

      // Choose a color from our mental health palette
      final colorIndex = Math.Random().nextInt(4);
      final Color glowColor = [
        _primaryColor,
        _secondaryColor,
        _tertiaryColor,
        _calmingColor,
      ][colorIndex];

      newGlows.add(BackgroundGlow(
        x: xPos,
        y: yPos,
        size: size,
        opacity: opacity,
        color: glowColor,
      ));
    }

    setState(() {
      _backgroundGlows.clear();
      _backgroundGlows.addAll(newGlows);
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    _navigationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              const Color(0xFFF8F2FF),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background glows - larger, softer elements
            ..._backgroundGlows.map((glow) {
              return Positioned(
                left: glow.x - (glow.size / 2),
                top: glow.y - (glow.size / 2),
                child: Opacity(
                  opacity: glow.opacity,
                  child: Container(
                    width: glow.size,
                    height: glow.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          glow.color,
                          glow.color.withOpacity(0.0),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),

            // Content Column - Consolidated layout with removed breathing indicator
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo with enhanced glow effect
                  Center(
                    child: Container(
                      width: size.width * 0.65,
                      height: size.width * 0.65,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.15),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: _imageLoaded
                          ? Image.asset(
                        'animations/logo_anime.gif',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: size.width * 0.5,
                            height: size.width * 0.5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _primaryColor.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.healing,
                              color: _primaryColor,
                              size: 80,
                            ),
                          );
                        },
                      )
                          : CircularProgressIndicator(
                        color: _primaryColor,
                      ),
                    ),
                  ),

                  // Slogan now positioned directly after the logo animation
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: AnimatedOpacity(
                      opacity: _showSlogan ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                        transform: Matrix4.translationValues(
                          0.0,
                          _showSlogan ? 0.0 : 15.0,
                          0.0,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "In a world full of noise—Healzy hears your silence.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _textPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                            height: 1.3,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Enhanced loading dots at bottom
                  AnimatedOpacity(
                    opacity: _showLoadingDots ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 3; i++)
                            LoadingDot(
                              delay: Duration(milliseconds: 160 * i),
                              primaryColor: _primaryColor,
                              secondaryColor: _secondaryColor,
                            ),
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
    );
  }
}

// Enhanced loading dot with better bounce animation
class LoadingDot extends StatefulWidget {
  final Duration delay;
  final Color primaryColor;
  final Color secondaryColor;

  const LoadingDot({
    Key? key,
    required this.delay,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  _LoadingDotState createState() => _LoadingDotState();
}

class _LoadingDotState extends State<LoadingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat();
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 12 * _scaleAnimation.value,
          height: 12 * _scaleAnimation.value,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.primaryColor, widget.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: widget.primaryColor.withOpacity(0.3 * _opacityAnimation.value),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Enhanced background glow class
class BackgroundGlow {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final Color color;

  BackgroundGlow({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.color,
  });
}