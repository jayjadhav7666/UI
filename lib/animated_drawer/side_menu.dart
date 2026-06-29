import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  final VoidCallback onClosePress;
  const SideMenu({super.key, required this.onClosePress});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String selectedMenu = 'Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: 288,
          height: double.infinity,
          color: const Color(0xFF17203A),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  top: 32,
                  bottom: 32,
                  right: 24,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Software Engineer',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onClosePress,
                      child: const CircleAvatar(
                        backgroundColor: Colors.white24,
                        radius: 16,
                        child: Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 24, bottom: 16),
                child: Text(
                  'BROWSE',
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildMenuItem(Icons.home, 'Home'),
              _buildMenuItem(Icons.search, 'Search'),
              _buildMenuItem(Icons.star_border, 'Favorites'),
              _buildMenuItem(Icons.help_outline, 'Help'),
              const Padding(
                padding: EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  'HISTORY',
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildMenuItem(Icons.history, 'History'),
              _buildMenuItem(Icons.notifications_none, 'Notification'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    bool isActive = selectedMenu == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenu = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
        height: 56, // fixed height to allow stack
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              width: isActive ? 240 : 0,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF2972FE),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Center(
              child: ListTile(
                leading: Icon(icon, color: Colors.white),
                title: Text(title, style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
