import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  bool isSignUp = false;

  void toggleView() {
    setState(() {
      isSignUp = !isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Colors
    final Color bgColor = const Color(0xFFdde1f5);
    final Color containerColor = const Color(0xFFf0f2fa);
    
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(0.05)
            ..rotateY(-0.1)
            ..rotateZ(0.01),
          child: Container(
            width: 820,
            height: 500,
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.98),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 90,
                  spreadRadius: 15,
                  offset: const Offset(30, 40),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 25,
                  offset: const Offset(10, 15),
                ),
              ],
            ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final double height = constraints.maxHeight;
                final double panelWidth = width * 0.5;

                // Duration and Curve from CSS: transition: left 0.75s cubic-bezier(.77,0,.18,1);
                const duration = Duration(milliseconds: 750);
                const curve = Cubic(0.77, 0.0, 0.18, 1.0);

                return Stack(
                  children: [
                    // --- Z-Index 1 Panels ---
                    
                    // Blue Welcome Back (starts off-screen LEFT, enters LEFT on active)
                    AnimatedPositioned(
                      duration: duration,
                      curve: curve,
                      top: 0,
                      bottom: 0,
                      left: isSignUp ? 0 : -panelWidth,
                      width: panelWidth,
                      child: buildBluePanel(
                        title: 'Welcome Back!',
                        subtitle: 'Stay connected by logging in with your\ncredentials and continue your experience.',
                        buttonText: 'Sign In',
                        onButtonPressed: toggleView,
                      ),
                    ),

                    // White Sign-Up (starts off-screen RIGHT, enters RIGHT on active)
                    AnimatedPositioned(
                      duration: duration,
                      curve: curve,
                      top: 0,
                      bottom: 0,
                      left: isSignUp ? panelWidth : width,
                      width: panelWidth,
                      child: buildSignUpPanel(),
                    ),

                    // --- Z-Index 2 Panels ---

                    // White Sign-In (starts LEFT, exits RIGHT on active)
                    AnimatedPositioned(
                      duration: duration,
                      curve: curve,
                      top: 0,
                      bottom: 0,
                      left: isSignUp ? width : 0,
                      width: panelWidth,
                      child: buildSignInPanel(),
                    ),

                    // Blue Hey There (starts RIGHT, exits LEFT on active)
                    AnimatedPositioned(
                      duration: duration,
                      curve: curve,
                      top: 0,
                      bottom: 0,
                      left: isSignUp ? -panelWidth : panelWidth,
                      width: panelWidth,
                      child: buildBluePanel(
                        title: 'Hey There!',
                        subtitle: 'Begin your amazing journey by creating\nan account with us today.',
                        buttonText: 'Sign Up',
                        onButtonPressed: toggleView,
                      ),
                    ),
                  ],
                );
              },
            ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSignInPanel() {
    return Container(
      color: const Color(0xFFf0f2fa),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sign In',
            style: GoogleFonts.nunito(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1a1a2e),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SocialIcon(icon: 'f'),
              SizedBox(width: 10),
              SocialIcon(icon: 'G'),
              SizedBox(width: 10),
              SocialIcon(icon: 'in'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'or use your account',
            style: GoogleFonts.nunito(
              fontSize: 11.52,
              color: const Color(0xFFAAAAAA),
            ),
          ),
          const SizedBox(height: 14),
          const CustomTextField(hint: 'Email Address', isPassword: false),
          const SizedBox(height: 11),
          const CustomTextField(hint: 'Password', isPassword: true),
          const SizedBox(height: 11),
          Align(
            alignment: Alignment.centerRight,
            child: HoverTextLink(
              text: 'Forgot your password?',
              onTap: () {},
            ),
          ),
          const SizedBox(height: 18),
          HoverButton(
            text: 'Sign In',
            isMain: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget buildSignUpPanel() {
    return Container(
      color: const Color(0xFFf0f2fa),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Create Account',
            style: GoogleFonts.nunito(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1a1a2e),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SocialIcon(icon: 'f'),
              SizedBox(width: 10),
              SocialIcon(icon: 'G'),
              SizedBox(width: 10),
              SocialIcon(icon: 'in'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'or use your email for registration',
            style: GoogleFonts.nunito(
              fontSize: 11.52,
              color: const Color(0xFFAAAAAA),
            ),
          ),
          const SizedBox(height: 14),
          const CustomTextField(hint: 'Full Name', isPassword: false),
          const SizedBox(height: 11),
          const CustomTextField(hint: 'Email Address', isPassword: false),
          const SizedBox(height: 11),
          const CustomTextField(hint: 'Password', isPassword: true),
          const SizedBox(height: 18),
          HoverButton(
            text: 'Sign Up',
            isMain: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget buildBluePanel({
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF4361ee), Color(0xFF3a0ca3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            style: GoogleFonts.nunito(
              fontSize: 13.6,
              height: 1.65,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          HoverButton(
            text: buttonText,
            isMain: false,
            onPressed: onButtonPressed,
          ),
        ],
      ),
    );
  }
}

class SocialIcon extends StatefulWidget {
  final String icon;
  const SocialIcon({super.key, required this.icon});

  @override
  State<SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<SocialIcon> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isHovered ? const Color(0xFF4361ee) : Colors.white,
            border: Border.all(
              color: isHovered ? const Color(0xFF4361ee) : const Color(0xFFd0d0d0),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()..scale(isHovered ? 1.1 : 1.0),
          child: Text(
            widget.icon,
            style: GoogleFonts.nunito(
              fontSize: 12.8,
              fontWeight: FontWeight.w700,
              color: isHovered ? Colors.white : const Color(0xFF555555),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String hint;
  final bool isPassword;
  
  const CustomTextField({super.key, required this.hint, required this.isPassword});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
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
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isFocused ? const Color(0xFFd8dff7) : const Color(0xFFe4e8f5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        focusNode: _focusNode,
        obscureText: widget.isPassword,
        style: GoogleFonts.nunito(
          fontSize: 14.08,
          color: const Color(0xFF333333),
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: GoogleFonts.nunito(color: const Color(0xFFAAAAAA)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}

class HoverButton extends StatefulWidget {
  final String text;
  final bool isMain;
  final VoidCallback onPressed;
  
  const HoverButton({super.key, required this.text, required this.isMain, required this.onPressed});

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMain ? 40 : 36, 
            vertical: widget.isMain ? 11 : 10,
          ),
          decoration: BoxDecoration(
            color: widget.isMain 
              ? (isHovered ? const Color(0xFF3a0ca3) : const Color(0xFF4361ee))
              : (isHovered ? Colors.white.withOpacity(0.15) : Colors.transparent),
            borderRadius: BorderRadius.circular(30),
            border: widget.isMain ? null : Border.all(color: Colors.white, width: 2),
          ),
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()..scale(isHovered ? 1.04 : 1.0),
          child: Text(
            widget.text.toUpperCase(),
            style: GoogleFonts.nunito(
              fontSize: widget.isMain ? 14.08 : 13.6,
              fontWeight: FontWeight.w700,
              letterSpacing: widget.isMain ? 1.0 : 1.5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class HoverTextLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const HoverTextLink({super.key, required this.text, required this.onTap});

  @override
  State<HoverTextLink> createState() => _HoverTextLinkState();
}

class _HoverTextLinkState extends State<HoverTextLink> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: GoogleFonts.nunito(
            fontSize: 12,
            color: isHovered ? const Color(0xFF4361ee) : const Color(0xFF888888),
            decoration: isHovered ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
