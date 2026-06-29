import 'dart:ui';
import 'package:flutter/material.dart';

class GlassLoginScreen extends StatefulWidget {
  const GlassLoginScreen({super.key});

  @override
  State<GlassLoginScreen> createState() => _GlassLoginScreenState();
}

class _GlassLoginScreenState extends State<GlassLoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13), // Deep dark background
      body: Stack(
        children: [
          // Background Gradient Orbs
          Positioned(
            top: -100,
            left: -100,
            child: _buildGradientOrb(Colors.purpleAccent, 300),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: _buildGradientOrb(Colors.cyanAccent, 250),
          ),
          Positioned(
            top: 250,
            right: -150,
            child: _buildGradientOrb(Colors.blueAccent, 350),
          ),
          
          // Blur layer for the orbs to look like soft gradients
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: const SizedBox(),
            ),
          ),
          
          // Login Card with Floating Animation
          Center(
            child: AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.fingerprint,
                            size: 64,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to continue to your world',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Custom Glass Text Fields
                          const GlassTextField(
                            label: 'Email',
                            icon: Icons.email_outlined,
                            isEmail: true,
                          ),
                          const SizedBox(height: 20),
                          const GlassTextField(
                            label: 'Password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          const SizedBox(height: 16),
                          
                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white70,
                              ),
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Animated Login Button
                          const AnimatedLoginButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.5),
      ),
    );
  }
}

class GlassTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final bool isEmail;

  const GlassTextField({
    super.key,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.isEmail = false,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: _isFocused ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isFocused ? Colors.cyanAccent.withOpacity(0.6) : Colors.white.withOpacity(0.1),
          width: _isFocused ? 1.5 : 1.0,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: TextField(
        focusNode: _focusNode,
        obscureText: widget.isPassword,
        keyboardType: widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.icon,
            color: _isFocused ? Colors.cyanAccent : Colors.white60,
          ),
          labelText: widget.label,
          labelStyle: TextStyle(
            color: _isFocused ? Colors.cyanAccent : Colors.white60,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}

class AnimatedLoginButton extends StatefulWidget {
  const AnimatedLoginButton({super.key});

  @override
  State<AnimatedLoginButton> createState() => _AnimatedLoginButtonState();
}

enum ButtonState { idle, loading, success }

class _AnimatedLoginButtonState extends State<AnimatedLoginButton> {
  ButtonState _state = ButtonState.idle;

  void _handlePress() async {
    if (_state != ButtonState.idle) return;

    setState(() {
      _state = ButtonState.loading;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _state = ButtonState.success;
      });
    }

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _state = ButtonState.idle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = _state == ButtonState.idle;
    final isSuccess = _state == ButtonState.success;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: _handlePress,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: isIdle ? constraints.maxWidth : 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSuccess ? Colors.greenAccent.withOpacity(0.8) : Colors.cyanAccent.withOpacity(0.8),
              borderRadius: BorderRadius.circular(isIdle ? 20 : 30),
              boxShadow: [
                BoxShadow(
                  color: isSuccess ? Colors.greenAccent.withOpacity(0.4) : Colors.cyanAccent.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isIdle
                ? const Text(
                    'Sign In',
                    key: ValueKey('text'),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  )
                : isSuccess
                    ? const Icon(
                        Icons.check,
                        key: ValueKey('icon'),
                        color: Colors.black87,
                        size: 32,
                      )
                    : const SizedBox(
                        key: ValueKey('loading'),
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.black87,
                          strokeWidth: 3,
                        ),
                      ),
          ),
        ),
          ),
        );
      },
    );
  }
}
