import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 48, bottom: 24),
            child: Text(
              'Notifications',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'New',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _buildNotificationCard(
                title: 'New Course Available!',
                subtitle: 'Check out the new SwiftUI masterclass.',
                time: '2m ago',
                color: const Color(0xFF2671FF),
                iconBgColor: const Color(0xFF9AC6FF),
                icon: Icons.star,
                isUnread: true,
              ),
              _buildNotificationCard(
                title: 'Goal Achieved',
                subtitle: 'You completed your 60 min daily goal.',
                time: '1h ago',
                color: const Color(0xFF805BFF),
                iconBgColor: const Color(0xFFFFA1B2),
                icon: Icons.emoji_events,
                isUnread: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Earlier',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _buildNotificationCard(
                title: 'Update Required',
                subtitle: 'A new version of the app is available.',
                time: '1d ago',
                color: Colors.white,
                textColor: Colors.black87,
                iconBgColor: Colors.grey.shade200,
                iconColor: Colors.black54,
                icon: Icons.system_update,
              ),
              _buildNotificationCard(
                title: 'Welcome to Courses',
                subtitle: 'Thanks for joining our learning platform!',
                time: '3d ago',
                color: Colors.white,
                textColor: Colors.black87,
                iconBgColor: Colors.grey.shade200,
                iconColor: Colors.black54,
                icon: Icons.waving_hand,
              ),
            ],
          ),
          const SizedBox(height: 100), // padding for bottom nav
        ].animate(interval: 50.ms).fade(duration: 400.ms).slideY(begin: 0.1, end: 0),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required String time,
    required Color color,
    required Color iconBgColor,
    required IconData icon,
    Color textColor = Colors.white,
    Color? iconColor,
    bool isUnread = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: color == Colors.white
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconBgColor,
            child: Icon(icon, color: iconColor ?? Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFA1B2),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: textColor.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
