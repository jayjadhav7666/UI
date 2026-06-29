import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class OnboardingDialog extends StatelessWidget {
  const OnboardingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const AnimatedMeshBackground(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                        'Learn\ndesign\n& code',
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Don\'t skip design. Learn design and code, by building real apps with React and Swift. Complete courses about the best tools.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      const Spacer(),
                      // Subscription button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Subscribe',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                'course',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Purchase includes access to 30+ courses, 240+ premium tutorials, 120+ hours of videos, source files and certificates.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class AnimatedMeshBackground extends StatefulWidget {
  const AnimatedMeshBackground({super.key});

  @override
  State<AnimatedMeshBackground> createState() => _AnimatedMeshBackgroundState();
}

class _AnimatedMeshBackgroundState extends State<AnimatedMeshBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
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
        return Stack(
          children: [
            // Base background
            Container(color: const Color(0xFFF0F4FF)),
            // Cyan circle
            Positioned(
              top: 100 + 200 * math.sin(_controller.value * 2 * math.pi),
              left: 50 + 150 * math.cos(_controller.value * 2 * math.pi),
              child: _buildGlow(const Color(0xFF00E5FF)),
            ),
            // Pink circle
            Positioned(
              bottom: 50 + 150 * math.cos(_controller.value * 2 * math.pi),
              right: 50 + 100 * math.sin(_controller.value * 2 * math.pi),
              child: _buildGlow(const Color(0xFFFF5252)),
            ),
            // Purple circle
            Positioned(
              top: 300 + 150 * math.sin(_controller.value * 2 * math.pi + math.pi),
              left: 150 + 100 * math.cos(_controller.value * 2 * math.pi + math.pi),
              child: _buildGlow(const Color(0xFFE040FB)),
            ),
            // Light blue circle
            Positioned(
              bottom: 200 + 150 * math.cos(_controller.value * 2 * math.pi + math.pi/2),
              left: 100 + 150 * math.sin(_controller.value * 2 * math.pi + math.pi/2),
              child: _buildGlow(const Color(0xFF2972FE)),
            ),
            // Orange circle
            Positioned(
              top: 200 + 100 * math.cos(_controller.value * 2 * math.pi + math.pi*1.5),
              right: 50 + 100 * math.sin(_controller.value * 2 * math.pi + math.pi*1.5),
              child: _buildGlow(const Color(0xFFFFAB40)),
            ),
            // Heavy blur overlay
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.white.withOpacity(0.1)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGlow(Color color) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.8),
      ),
    );
  }
}
