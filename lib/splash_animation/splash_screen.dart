import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TogoSplashScreen extends StatefulWidget {
  const TogoSplashScreen({super.key});

  @override
  State<TogoSplashScreen> createState() => _TogoSplashScreenState();
}

class _TogoSplashScreenState extends State<TogoSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  late Animation<double> _houseXAnimation;
  late Animation<double> _bikeXAnimation;
  late Animation<double> _bikeYAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoYAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // 8 second master timeline
    );

    // 0.0 to 0.6 (0s to 4.8s) - Drive in slowly
    _houseXAnimation = Tween<double>(begin: 0, end: -1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _bikeXAnimation = Tween<double>(begin: -1.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.linear), // Changed to linear for smooth continuous driving
      ),
    );

    // 0.6 to 0.8 (4.8s to 6.4s) - Bike goes UP
    _bikeYAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 60.0), // 0 to 0.6
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -1.5).chain(CurveTween(curve: Curves.easeInBack)),
        weight: 20.0, // 0.6 to 0.8
      ),
      TweenSequenceItem(tween: ConstantTween(-1.5), weight: 20.0), // 0.8 to 1.0
    ]).animate(_controller);

    // 0.8 to 1.0 (6.4s to 8.0s) - Logo appears
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );

    _logoYAnimation = Tween<double>(begin: 0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Start the animation immediately for the reel
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC64F38), // Warm orange/red background
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Background Clouds
              Positioned.fill(
                child: CustomPaint(
                  painter: CloudPainter(),
                ),
              ),
              
              // The House / Church (Slides Left)
              Positioned(
                bottom: 150, // Right above the road
                left: 0,
                right: 0,
                child: FractionalTranslation(
                  translation: Offset(_houseXAnimation.value, 0),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(300, 250),
                      painter: ChurchPainter(),
                    ),
                  ),
                ),
              ),

              // The Road (Static at bottom, or fades out)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 150,
                child: Opacity(
                  opacity: _controller.value < 0.8 ? 1.0 : (1.0 - ((_controller.value - 0.8) / 0.1)).clamp(0.0, 1.0),
                  child: CustomPaint(
                    painter: RoadPainter(),
                  ),
                ),
              ),

              // The Bike (Slides Right, then UP)
              Positioned(
                bottom: 120, // Driving on the road
                left: 0,
                right: 0,
                child: FractionalTranslation(
                  translation: Offset(_bikeXAnimation.value, _bikeYAnimation.value),
                  child: Center(
                    child: SizedBox(
                      height: 180,
                      width: 180,
                      child: Lottie.asset(
                        'asset/Order Status for Food Delivery.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              // The Logo (Slides UP and Fades In)
              if (_controller.value > 0.6) // Optimization, only build when needed
                Positioned.fill(
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        
                        Opacity(
                          opacity: _logoOpacityAnimation.value,
                          child: FractionalTranslation(
                            translation: Offset(0, _logoYAnimation.value),
                            child: const TogoLogo(),
                          ),
                        ),
                        
                        const Spacer(flex: 1),
                        const SizedBox(height: 180), // Space for where bike was
                        const Spacer(flex: 2),
                        
                        // Loading Dots (appear with logo)
                        Opacity(
                          opacity: _logoOpacityAnimation.value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: index == 0 ? 8 : 4,
                                height: index == 0 ? 8 : 4,
                                decoration: BoxDecoration(
                                  color: index == 0 ? Colors.white : Colors.white.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              );
                            }),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// Draws the minimalist road
class RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Dark grey road
    final roadPaint = Paint()..color = const Color(0xFF4A4A4A);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), roadPaint);

    // Dashed line
    final dashPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
      
    double dashWidth = 15;
    double dashSpace = 20;
    double startX = 0;
    
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Draws the custom church vector mimicking the image
class ChurchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = const Color(0xFFF9F6F6) // Off-white building
      ..style = PaintingStyle.fill;
      
    final borderPaint = Paint()
      ..color = const Color(0xFFB0432E) // Darker red/orange border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final windowFillPaint = Paint()
      ..color = const Color(0xFFE2CCCC) // Pinkish windows
      ..style = PaintingStyle.fill;

    // Helper to draw a rect with border
    void drawBlock(Rect rect, {bool fill = true}) {
      if (fill) canvas.drawRect(rect, fillPaint);
      canvas.drawRect(rect, borderPaint);
    }
    
    // Helper to draw an arched window
    void drawWindow(Rect rect) {
      final path = Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top + rect.width / 2)
        ..arcToPoint(
          Offset(rect.right, rect.top + rect.width / 2),
          radius: Radius.circular(rect.width / 2),
        )
        ..lineTo(rect.right, rect.bottom)
        ..close();
        
      canvas.drawPath(path, windowFillPaint);
      canvas.drawPath(path, borderPaint);
    }

    // Helper to draw a cross
    void drawCross(Offset center, double size) {
      canvas.drawLine(Offset(center.dx, center.dy - size), Offset(center.dx, center.dy + size), borderPaint);
      canvas.drawLine(Offset(center.dx - size/1.5, center.dy - size/3), Offset(center.dx + size/1.5, center.dy - size/3), borderPaint);
    }

    // Center Building
    double centerW = 120;
    double centerH = 100;
    double centerX = size.width / 2;
    double baseY = size.height;

    // Main center block
    drawBlock(Rect.fromLTWH(centerX - centerW/2, baseY - centerH, centerW, centerH));
    
    // Triangle Roof
    final roofPath = Path()
      ..moveTo(centerX - centerW/2 - 10, baseY - centerH)
      ..lineTo(centerX, baseY - centerH - 60)
      ..lineTo(centerX + centerW/2 + 10, baseY - centerH)
      ..close();
    canvas.drawPath(roofPath, fillPaint);
    canvas.drawPath(roofPath, borderPaint);
    
    drawCross(Offset(centerX, baseY - centerH - 70), 8);

    // Center Door
    drawWindow(Rect.fromLTWH(centerX - 15, baseY - 40, 30, 40));

    // Left Tower
    double towerW = 40;
    double towerH = 160;
    double leftTowerX = centerX - centerW/2 - towerW + 10;
    
    drawBlock(Rect.fromLTWH(leftTowerX, baseY - towerH, towerW, towerH));
    drawWindow(Rect.fromLTWH(leftTowerX + 10, baseY - towerH + 20, 20, 40));
    drawWindow(Rect.fromLTWH(leftTowerX + 10, baseY - 50, 20, 40));
    
    // Left Dome
    final leftDomeRect = Rect.fromLTWH(leftTowerX, baseY - towerH - 30, towerW, 30);
    final leftDomePath = Path()
      ..moveTo(leftDomeRect.left, leftDomeRect.bottom)
      ..arcToPoint(
        Offset(leftDomeRect.right, leftDomeRect.bottom),
        radius: Radius.circular(towerW / 2),
      )
      ..close();
    canvas.drawPath(leftDomePath, fillPaint);
    canvas.drawPath(leftDomePath, borderPaint);
    drawCross(Offset(leftTowerX + towerW/2, baseY - towerH - 35), 6);

    // Right Tower
    double rightTowerX = centerX + centerW/2 - 10;
    drawBlock(Rect.fromLTWH(rightTowerX, baseY - towerH, towerW, towerH));
    drawWindow(Rect.fromLTWH(rightTowerX + 10, baseY - towerH + 20, 20, 40));
    drawWindow(Rect.fromLTWH(rightTowerX + 10, baseY - 50, 20, 40));
    
    // Right Dome
    final rightDomeRect = Rect.fromLTWH(rightTowerX, baseY - towerH - 30, towerW, 30);
    final rightDomePath = Path()
      ..moveTo(rightDomeRect.left, rightDomeRect.bottom)
      ..arcToPoint(
        Offset(rightDomeRect.right, rightDomeRect.bottom),
        radius: Radius.circular(towerW / 2),
      )
      ..close();
    canvas.drawPath(rightDomePath, fillPaint);
    canvas.drawPath(rightDomePath, borderPaint);
    drawCross(Offset(rightTowerX + towerW/2, baseY - towerH - 35), 6);
    
    // Background City Silhouettes (simple rectangles)
    final cityPaint = Paint()..color = const Color(0xFFA63C26);
    canvas.drawRect(Rect.fromLTWH(0, baseY - 120, 40, 120), cityPaint);
    canvas.drawRect(Rect.fromLTWH(45, baseY - 80, 50, 80), cityPaint);
    canvas.drawRect(Rect.fromLTWH(size.width - 50, baseY - 140, 50, 140), cityPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom widget to build the precise "togo" logo
class TogoLogo extends StatelessWidget {
  const TogoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // "t"
        const Text(
          't',
          style: TextStyle(
            color: Colors.white,
            fontSize: 80,
            fontWeight: FontWeight.bold,
            height: 1,
            letterSpacing: -2,
          ),
        ),
        // "o" with teal dot
        Stack(
          alignment: Alignment.center,
          children: [
            const Text(
              'o',
              style: TextStyle(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            Positioned(
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF13A689), // Teal color
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        // "g" with flag
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Text(
              'g',
              style: TextStyle(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            // Flag pole
            Positioned(
              top: -10,
              left: 20,
              child: Container(
                width: 3,
                height: 40,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            // Flag pennant
            Positioned(
              top: -10,
              left: 20,
              child: CustomPaint(
                size: const Size(20, 14),
                painter: FlagPainter(),
              ),
            ),
          ],
        ),
        // Final "o" (simplified)
        Stack(
          alignment: Alignment.center,
          children: [
            const Text(
              'o',
              style: TextStyle(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFC64F38), // Match background to create the gap effect
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Draws the minimalist flag pennant
class FlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF13A689)
      ..style = PaintingStyle.fill;
      
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height)
      ..close();
      
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Draws the minimalist background clouds
class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    void drawCloud(double x, double y, double scale) {
      canvas.save();
      canvas.translate(x, y);
      canvas.scale(scale);
      
      final path = Path();
      // Draw horizontal line
      path.moveTo(-20, 0);
      path.lineTo(60, 0);
      
      // Draw bumps
      path.addArc(Rect.fromLTWH(0, -10, 20, 20), 3.14, 3.14); // Left bump
      path.addArc(Rect.fromLTWH(15, -20, 40, 40), 3.14, 3.14); // Center bump
      
      canvas.drawPath(path, paint);
      canvas.restore();
    }

    // Draw a few scattered clouds
    drawCloud(size.width * 0.2, size.height * 0.15, 1.0);
    drawCloud(size.width * 0.7, size.height * 0.25, 0.8);
    drawCloud(size.width * 0.1, size.height * 0.6, 0.9);
    drawCloud(size.width * 0.8, size.height * 0.8, 1.2);
    
    // Draw horizontal background lines
    canvas.drawLine(Offset(0, size.height * 0.2), Offset(size.width * 0.4, size.height * 0.2), paint);
    canvas.drawLine(Offset(size.width * 0.6, size.height * 0.4), Offset(size.width, size.height * 0.4), paint);
    canvas.drawLine(Offset(size.width * 0.1, size.height * 0.9), Offset(size.width * 0.5, size.height * 0.9), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
