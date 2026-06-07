import 'package:flutter/material.dart';

class AnimatedCarBackgroundText extends StatelessWidget {
  final String text;
  final double fontSize;
  
  const AnimatedCarBackgroundText({
    super.key,
    required this.text,
    this.fontSize = 120,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Text animates from bottom to top
        final inAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.5),
          end: Offset.zero,
        ).animate(animation);
        
        final outAnimation = Tween<Offset>(
          begin: const Offset(0.0, -0.5),
          end: Offset.zero,
        ).animate(animation);

        if (child.key == ValueKey(text)) {
          return SlideTransition(
            position: inAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        } else {
           return SlideTransition(
            position: outAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        }
      },
      child: Text(
        text,
        key: ValueKey<String>(text),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: Colors.grey.withValues(alpha: 0.5), // large text, gray color
          height: 1.0,
          letterSpacing: 4.0,
        ),
      ),
    );
  }
}
