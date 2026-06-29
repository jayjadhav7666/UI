import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class FlavorData {
  final String title;
  final String subtitle;
  final String flavorName;
  final String price;
  final Color bgColor;
  final Color primaryColor;
  final Color splashColor;
  final String imagePath;

  const FlavorData({
    required this.title,
    required this.subtitle,
    required this.flavorName,
    required this.price,
    required this.bgColor,
    required this.primaryColor,
    required this.splashColor,
    required this.imagePath,
  });
}

const List<FlavorData> flavors = [
  FlavorData(
    title: 'Sip into',
    subtitle: 'Freshness',
    flavorName: 'Caramel Flavour',
    price: '\$25.50',
    bgColor: Color(0xFFB55D37), // Caramel
    primaryColor: Color(0xFFD67341),
    splashColor: Color(0xFFFFDAB9),
    imagePath: 'asset/primo_website/caramel_cream.png',
  ),
  FlavorData(
    title: 'Sip into',
    subtitle: 'Freshness',
    flavorName: 'Lime Flavour',
    price: '\$25.50',
    bgColor: Color(0xFF80B33A), // Green
    primaryColor: Color(0xFF93CA48),
    splashColor: Color(0xFFE2F9B8),
    imagePath: 'asset/primo_website/subline_lime.png',
  ),
  FlavorData(
    title: 'Sip into',
    subtitle: 'Freshness',
    flavorName: 'Creamy Coffee',
    price: '\$25.50',
    bgColor: Color(0xFF674032), // Brown
    primaryColor: Color(0xFF815241),
    splashColor: Color(0xFFDABBA8),
    imagePath: 'asset/primo_website/creamy_cofee.png',
  ),
];

class PrimoWebScreen extends StatefulWidget {
  const PrimoWebScreen({super.key});

  @override
  State<PrimoWebScreen> createState() => _PrimoWebScreenState();
}

class _PrimoWebScreenState extends State<PrimoWebScreen> {
  final PageController _pageController = PageController();
  double _pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    if (_pageOffset < 0) return flavors.first.bgColor;
    if (_pageOffset > flavors.length - 1) return flavors.last.bgColor;

    int lowerIndex = _pageOffset.floor();
    int upperIndex = lowerIndex + 1;
    if (upperIndex >= flavors.length) return flavors.last.bgColor;

    double fraction = _pageOffset - lowerIndex;
    return Color.lerp(flavors[lowerIndex].bgColor, flavors[upperIndex].bgColor, fraction)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: _getBackgroundColor(),
        child: Stack(
          children: [
            // The 3D scrolling pages
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: flavors.length,
              itemBuilder: (context, index) {
                return _buildPageContent(context, index);
              },
            ),

            // Fixed Header
            _buildHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo area
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'P',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Primo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            // Navigation Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Product',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      'Contact',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            
            // Icons Right
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 20, color: Colors.black),
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_cart, size: 20, color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(BuildContext context, int index) {
    final flavor = flavors[index];
    
    // Calculate offsets based on page scroll
    double pageDifference = (_pageOffset - index);
    double parallaxOffset = pageDifference * MediaQuery.of(context).size.height * 0.8;
    
    // Opacity fades out slightly as you scroll away, but mostly we want it visible while entering
    double opacity = (1 - pageDifference.abs() * 1.5).clamp(0.0, 1.0);
    
    // To give a cool 3D entry effect, the bottle scales up slightly
    double scale = 1.0 - (pageDifference.abs() * 0.2);

    return Opacity(
      opacity: opacity,
      child: Stack(
        children: [
          // Left Text Column
          Positioned(
            left: MediaQuery.of(context).size.width * 0.1,
            top: MediaQuery.of(context).size.height * 0.35,
            child: Transform.translate(
              offset: Offset(0, parallaxOffset * 0.5), // Slower parallax for text
              child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flavor.title,
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      flavor.subtitle,
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      '500 ml',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 100),
                    Text(
                      'Discover a world of vibrant flavors with our premium juice selection. At Fresh & Juicy, we believe in the power of nature\'s finest ingredients.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Center Bottle
          Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(0, parallaxOffset),
              child: Transform.scale(
                scale: scale,
                child: Hero(
                  tag: 'bottle_$index',
                  child: Image.asset(
                    flavor.imagePath,
                    height: MediaQuery.of(context).size.height * 0.85,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      size: 400,
                      color: flavor.splashColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Right Interaction Column
          Positioned(
            right: MediaQuery.of(context).size.width * 0.1,
            top: MediaQuery.of(context).size.height * 0.45,
            child: Transform.translate(
              offset: Offset(0, parallaxOffset * 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    flavor.flavorName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildSizeSelector('500\nml', true),
                      const SizedBox(width: 10),
                      _buildSizeSelector('750\nml', false),
                      const SizedBox(width: 10),
                      _buildSizeSelector('1\nL', false),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Price and Buy Now
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Transform.translate(
              offset: Offset(0, parallaxOffset * 0.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    flavor.price,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.play_circle_outline, color: Colors.white, size: 28),
                      const SizedBox(width: 15),
                      const Icon(Icons.share, color: Colors.white, size: 24),
                      const SizedBox(width: 15),
                      const Icon(Icons.favorite_border, color: Colors.white, size: 24),
                      const SizedBox(width: 40),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelector(String text, bool isSelected) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ),
    );
  }


}
