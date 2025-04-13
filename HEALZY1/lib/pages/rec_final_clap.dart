import 'package:flutter/material.dart';
import 'dart:math' as math;


class MotivationalScreen extends StatefulWidget {
  const MotivationalScreen({Key? key}) : super(key: key);

  @override
  State<MotivationalScreen> createState() => _MotivationalScreenState();
}

class _MotivationalScreenState extends State<MotivationalScreen> with TickerProviderStateMixin {
  late AnimationController _sparkleController;
  late AnimationController _paperPlaneController;
  late List<Animation<double>> _sparkleAnimations;

  @override
  void initState() {
    super.initState();

    // Sparkle animation
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Create multiple sparkle animations with different timings
    _sparkleAnimations = List.generate(
      8,
          (index) => Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: _sparkleController,
          curve: Interval(
            (index / 8),
            math.min(0.2 + (index / 8), 1.0),  // Ensure end is never > 1.0
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );

    // Paper plane animation
    _paperPlaneController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    _paperPlaneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background elements
            ...buildPaperAirplanes(),
            ...buildColoredDots(),
            ...buildSparkles(),

            // Main content
            Column(
              children: [
                // Header with back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade400, width: 1.5),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: Color(0xFF404040),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                // Main motivational content
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: AnimatedBuilder(
                        animation: _sparkleController,
                        builder: (context, child) {
                          return RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 22,
                                color: Color(0xFF3E2723),
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                                letterSpacing: 0.3,
                              ),
                              children: [
                                const TextSpan(text: "That's the spirit! You're\nglowing "),
                                TextSpan(
                                  text: "✨",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Color(0xFFFFC107).withOpacity(_sparkleAnimations[0].value),
                                  ),
                                ),
                                const TextSpan(text: " Keep the vibe\ngoing! "),
                                TextSpan(
                                  text: "✨",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Color(0xFFFFC107).withOpacity(_sparkleAnimations[3].value),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Continue button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D4037),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
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
  }

  List<Widget> buildPaperAirplanes() {
    return [
      // Top right airplane
      AnimatedBuilder(
        animation: _paperPlaneController,
        builder: (context, child) {
          final animationValue = _paperPlaneController.value;
          final offset = math.sin(animationValue * math.pi * 2) * 8;

          return Positioned(
            top: 80 + offset,
            right: 30,
            child: Transform.rotate(
              angle: -0.2,
              child: CustomPaint(
                size: const Size(100, 100),
                painter: PaperAirplanePainter(color: Colors.grey.shade800.withOpacity(0.8)),
              ),
            ),
          );
        },
      ),

      // Bottom left airplane
      AnimatedBuilder(
        animation: _paperPlaneController,
        builder: (context, child) {
          final animationValue = _paperPlaneController.value;
          final offset = math.sin((animationValue + 0.3) * math.pi * 2) * 6;

          return Positioned(
            bottom: 120 + offset,
            left: 20,
            child: Transform.rotate(
              angle: 0.3,
              child: CustomPaint(
                size: const Size(80, 80),
                painter: PaperAirplanePainter(color: Colors.grey.shade800.withOpacity(0.8)),
              ),
            ),
          );
        },
      ),

      // Bottom right airplane
      AnimatedBuilder(
        animation: _paperPlaneController,
        builder: (context, child) {
          final animationValue = _paperPlaneController.value;
          final offset = math.sin((animationValue + 0.6) * math.pi * 2) * 5;

          return Positioned(
            bottom: 170 + offset,
            right: 40,
            child: Transform.rotate(
              angle: -0.4,
              child: CustomPaint(
                size: const Size(60, 60),
                painter: PaperAirplanePainter(color: Colors.grey.shade800.withOpacity(0.8)),
              ),
            ),
          );
        },
      ),
    ];
  }

  List<Widget> buildColoredDots() {
    return [
      // Orange dots
      Positioned(
        top: 220,
        left: 40,
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: const Color(0xFFF6A54C),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF6A54C).withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 200,
        right: 60,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFFF6A54C),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF6A54C).withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),

      // Green dots
      Positioned(
        bottom: 180,
        left: 50,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFFB5D99C),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB5D99C).withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 140,
        right: 100,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFFB5D99C),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB5D99C).withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> buildSparkles() {
    final List<Map<String, dynamic>> positions = [
      {'top': 140.0, 'left': 80.0, 'size': 16.0, 'index': 0},
      {'top': 180.0, 'right': 70.0, 'size': 20.0, 'index': 1},
      {'bottom': 240.0, 'left': 100.0, 'size': 16.0, 'index': 2},
      {'bottom': 220.0, 'right': 130.0, 'size': 14.0, 'index': 3},
      {'top': 240.0, 'left': 180.0, 'size': 18.0, 'index': 4},
      {'top': 260.0, 'right': 60.0, 'size': 12.0, 'index': 5},
      {'bottom': 300.0, 'right': 50.0, 'size': 16.0, 'index': 6},
      {'bottom': 260.0, 'left': 40.0, 'size': 14.0, 'index': 7},
    ];

    return positions.map((pos) {
      final index = pos['index'] as int;

      return AnimatedBuilder(
        animation: _sparkleAnimations[index],
        builder: (context, child) {
          return Positioned(
            top: pos['top'] as double?,
            left: pos['left'] as double?,
            right: pos['right'] as double?,
            bottom: pos['bottom'] as double?,
            child: Transform.scale(
              scale: _sparkleAnimations[index].value,
              child: Opacity(
                opacity: _sparkleAnimations[index].value,
                child: CustomPaint(
                  size: Size(pos['size'] as double, pos['size'] as double),
                  painter: SparkleStarPainter(color: const Color(0xFFFFC107)),
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }
}

class PaperAirplanePainter extends CustomPainter {
  final Color color;

  PaperAirplanePainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final double width = size.width;
    final double height = size.height;

    final Path path = Path();

    // Draw the paper airplane
    path.moveTo(0, height / 2);
    path.lineTo(width, 0);
    path.lineTo(width / 3, height / 2);
    path.lineTo(width, height);
    path.lineTo(0, height / 2);

    // Add fold line
    path.moveTo(width / 3, height / 2);
    path.lineTo(width / 2, height / 4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SparkleStarPainter extends CustomPainter {
  final Color color;

  SparkleStarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Main star rays
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final pathMain = Path();
    final pathSecondary = Path();

    // Draw a 4-point star
    // Main points (longer)
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        pathMain.moveTo(x, y);
      } else {
        pathMain.lineTo(x, y);
      }

      pathMain.lineTo(
        center.dx + (radius * 0.4) * math.cos(angle + math.pi / 4),
        center.dy + (radius * 0.4) * math.sin(angle + math.pi / 4),
      );
    }
    pathMain.close();

    // Secondary points (shorter, at 45 degree angles)
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) + (math.pi / 4);
      final x = center.dx + (radius * 0.6) * math.cos(angle);
      final y = center.dy + (radius * 0.6) * math.sin(angle);

      if (i == 0) {
        pathSecondary.moveTo(x, y);
      } else {
        pathSecondary.lineTo(x, y);
      }

      pathSecondary.lineTo(
        center.dx + (radius * 0.3) * math.cos(angle + math.pi / 4),
        center.dy + (radius * 0.3) * math.sin(angle + math.pi / 4),
      );
    }
    pathSecondary.close();

    // Add a center circle
    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius * 0.2));

    // Draw all paths
    canvas.drawPath(pathMain, paint);
    canvas.drawPath(pathSecondary, paint);
    canvas.drawPath(circlePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}