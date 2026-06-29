import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'screens/onboarding_dialog.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'screens/search_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onMenuPress;
  const HomeScreen({super.key, required this.onMenuPress});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF1F8), // light bg
      body: SafeArea(
        child: _getSelectedScreen(),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF17203A).withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBottomIcon(0, Icons.chat_bubble_outline),
              _buildBottomIcon(1, Icons.search),
              _buildBottomIcon(2, Icons.access_time),
              _buildBottomIcon(3, Icons.notifications_none),
              _buildBottomIcon(4, Icons.person_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: widget.onMenuPress,
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.menu, color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const OnboardingDialog(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -1),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            )),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 600),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_outline, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Courses',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCourseCard(
                  title: 'Animations in SwiftUI',
                  subtitle: 'Build and animate an iOS app from scratch',
                  sections: '20 SECTIONS - 3 HOURS',
                  color: const Color(0xFF805BFF),
                  iconBgColor: const Color(0xFFFFA1B2),
                  icon: Icons.apple,
                ),
                _buildCourseCard(
                  title: 'Build Quick Apps with SwiftUI',
                  subtitle: 'Apply your Swift and SwiftUI knowledge...',
                  sections: '47 SECTIONS - 11 HOURS',
                  color: const Color(0xFF2671FF),
                  iconBgColor: const Color(0xFF4C8DFF), // A lighter blue for icon bg
                  icon: Icons.code,
                ),
                _buildCourseCard(
                  title: 'Build a SwiftUI app for iOS 15',
                  subtitle: 'Design and code a SwiftUI 3 app with custom layouts, ...',
                  sections: '21 SECTIONS - 4 HOURS',
                  color: const Color(0xFF2671FF),
                  iconBgColor: const Color(0xFFFFA1B2),
                  icon: Icons.apple,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Recent',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _buildRecentCard(
                title: 'State Machine',
                subtitle: 'Watch video - 15 mins',
                color: const Color(0xFF9AC6FF),
                iconBgColor: const Color(0xFF2671FF),
                icon: Icons.code,
              ),
              _buildRecentCard(
                title: 'Animated Menu',
                subtitle: 'Watch video - 10 mins',
                color: const Color(0xFF805BFF),
                iconBgColor: const Color(0xFFFFA1B2),
                icon: Icons.apple,
              ),
              _buildRecentCard(
                title: 'Tab Bar',
                subtitle: 'Watch video - 8 mins',
                color: const Color(0xFF2671FF),
                iconBgColor: const Color(0xFF9AC6FF),
                icon: Icons.code,
              ),
              _buildRecentCard(
                title: 'Button',
                subtitle: 'Watch video - 5 mins',
                color: const Color(0xFFD2B5FF),
                iconBgColor: const Color(0xFFFFA1B2),
                icon: Icons.apple,
              ),
              _buildRecentCard(
                title: 'Avatar',
                subtitle: 'Watch video - 4 mins',
                color: const Color(0xFF9AC6FF),
                iconBgColor: const Color(0xFF2671FF),
                icon: Icons.code,
              ),
              _buildRecentCard(
                title: 'Flutter UI',
                subtitle: 'Watch video - 12 mins',
                color: const Color(0xFF2671FF),
                iconBgColor: const Color(0xFF9AC6FF),
                icon: Icons.phone_android,
              ),
              _buildRecentCard(
                title: 'Riverpod state',
                subtitle: 'Watch video - 20 mins',
                color: const Color(0xFF805BFF),
                iconBgColor: const Color(0xFFFFA1B2),
                icon: Icons.bolt,
              ),
            ],
          ),
        ].animate(interval: 50.ms).fade(duration: 400.ms).slideY(begin: 0.1, end: 0),
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0: return _buildMainContent();
      case 1: return const SearchScreen();
      case 2: return const ActivityScreen();
      case 3: return const NotificationsScreen();
      case 4: return const ProfileScreen();
      default: return _buildMainContent();
    }
  }

  Widget _buildBottomIcon(int index, IconData icon) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              height: 4,
              width: isActive ? 20 : 0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isActive ? 1.0 : 0.5,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String subtitle,
    required String sections,
    required Color color,
    required Color iconBgColor,
    required IconData icon,
  }) {
    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: iconBgColor,
                child: Icon(icon, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            sections,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Avatars row
          Row(
            children: [
              _buildAvatar('https://randomuser.me/api/portraits/women/44.jpg'),
              Transform.translate(
                offset: const Offset(-10, 0),
                child: _buildAvatar('https://randomuser.me/api/portraits/women/45.jpg'),
              ),
              Transform.translate(
                offset: const Offset(-20, 0),
                child: _buildAvatar('https://randomuser.me/api/portraits/men/46.jpg'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String url) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(url),
      ),
    );
  }

  Widget _buildRecentCard({
    required String title,
    required String subtitle,
    required Color color,
    required Color iconBgColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: iconBgColor,
            child: Icon(icon, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
