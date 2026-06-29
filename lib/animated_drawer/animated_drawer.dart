import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'side_menu.dart';

class AnimatedDrawer extends StatefulWidget {
  const AnimatedDrawer({super.key});

  @override
  State<AnimatedDrawer> createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateAnimation;
  
  bool isSideMenuClosed = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
        
    _scaleAnimation = Tween<double>(begin: 1, end: 0.85).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
        
    _translateAnimation = Tween<double>(begin: 0, end: 260).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleMenu() {
    if (isSideMenuClosed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    setState(() {
      isSideMenuClosed = !isSideMenuClosed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17203A),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClosed ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: SideMenu(
              onClosePress: toggleMenu,
            ),
          ),
          Transform.translate(
            offset: Offset(_translateAnimation.value, 0),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(isSideMenuClosed ? 0 : 32)),
                child: HomeScreen(
                  onMenuPress: toggleMenu,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
