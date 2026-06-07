import 'package:flutter/material.dart';
import 'car_data.dart';
import 'animated_car_background_text.dart';
import 'car_details_view.dart';

class CarShowcaseScreen extends StatefulWidget {
  const CarShowcaseScreen({super.key});

  @override
  State<CarShowcaseScreen> createState() => _CarShowcaseScreenState();
}

class _CarShowcaseScreenState extends State<CarShowcaseScreen> with TickerProviderStateMixin {
  int currentIndex = 0;
  bool showDetails = false;
  bool movingForward = true;

  late AnimationController _detailsAnimController;
  late Animation<double> _detailsAnimation;

  @override
  void initState() {
    super.initState();
    _detailsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _detailsAnimation = CurvedAnimation(
      parent: _detailsAnimController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _detailsAnimController.dispose();
    super.dispose();
  }

  void _nextCar() {
    if (currentIndex < carList.length - 1) {
      setState(() {
        movingForward = true;
        currentIndex++;
        showDetails = false;
      });
      _detailsAnimController.reverse();
    }
  }

  void _prevCar() {
    if (currentIndex > 0) {
      setState(() {
        movingForward = false;
        currentIndex--;
        showDetails = false;
      });
      _detailsAnimController.reverse();
    }
  }

  void _toggleDetails() {
    setState(() {
      showDetails = !showDetails;
    });
    if (showDetails) {
      _detailsAnimController.forward();
    } else {
      _detailsAnimController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCar = carList[currentIndex];
    
    // Background color roughly matching the images
    final bgColor = const Color(0xFFE2E2E2);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // 1. Top Navigation Bar
          Positioned(
            top: 40,
            left: 60,
            right: 60,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: showDetails ? 0.0 : 1.0,
              child: IgnorePointer(
                ignoring: showDetails,
                child: _buildNavBar(),
              ),
            ),
          ),

          // 2. Social Media Icons (Left)
          if (!showDetails)
            Positioned(
              left: 60,
              bottom: 100,
              child: _buildSocialIcons(),
            ),

          // 3. Brand Subtitle (Top Center - moving with details)
          AnimatedAlign(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: showDetails ? const Alignment(0, -0.85) : const Alignment(0, -0.55),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                currentCar.brand,
                key: ValueKey(currentCar.brand),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          // 4. Large Background Text (Model Name)
          AnimatedAlign(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: showDetails ? const Alignment(0, -0.65) : const Alignment(0, -0.25),
            child: AnimatedCarBackgroundText(
              text: currentCar.modelName,
              fontSize: showDetails ? 80 : 180,
            ),
          ),

          // 5. Car Image
          AnimatedAlign(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: showDetails ? const Alignment(0, -0.1) : const Alignment(0, 0.2),
            child: SizedBox(
              height: showDetails ? 300 : 450,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (child, animation) {
                  final inOffset = movingForward ? const Offset(1, 0) : const Offset(-1, 0);
                  final outOffset = movingForward ? const Offset(-1, 0) : const Offset(1, 0);
                  
                  if (child.key == ValueKey(currentCar.mainImage)) {
                     return SlideTransition(
                      position: Tween<Offset>(begin: inOffset, end: Offset.zero).animate(animation),
                      child: child,
                    );
                  } else {
                     return SlideTransition(
                      position: Tween<Offset>(begin: outOffset, end: Offset.zero).animate(animation),
                      child: child,
                    );
                  }
                },
                child: Image.asset(
                  currentCar.mainImage,
                  key: ValueKey(currentCar.mainImage),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // 6. Navigation Arrows
          if (!showDetails) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 60),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: _prevCar,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _nextCar,
                ),
              ),
            ),
          ],

          // 7. Back Arrow for Details View
          if (showDetails)
            Positioned(
              left: 60,
              top: 60,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: _toggleDetails,
              ),
            ),

          // 8. Buttons (Rent Now, Details)
          if (!showDetails)
            Align(
              alignment: const Alignment(0, 0.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F4A59), // Dark Blue/Grey
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Rent Now', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: _toggleDetails,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black54),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Details', style: TextStyle(color: Colors.black87)),
                  ),
                ],
              ),
            ),
            
          // 9. Pagination Dots
          if (!showDetails)
            Align(
              alignment: const Alignment(0, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(carList.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentIndex ? Colors.black87 : Colors.black26,
                    ),
                  );
                }),
              ),
            ),

          // 10. Details View
          if (showDetails)
            CarDetailsView(car: currentCar, animation: _detailsAnimation),
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Arcar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            _navItem('HOME', true),
            _navItem('ELECTRIC CARS', false),
            _navItem('SPORTS CARS', false),
            _navItem('SUV', false),
          ],
        ),
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 16,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'MY ACCOUNT',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }

  Widget _navItem(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          color: isSelected ? Colors.black87 : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildSocialIcons() {
    return const Column(
      children: [
        Icon(Icons.facebook, color: Colors.black87),
        SizedBox(height: 20),
        Icon(Icons.flutter_dash, color: Colors.black87), // Placeholder for Twitter
        SizedBox(height: 20),
        Icon(Icons.g_mobiledata, color: Colors.black87, size: 32), // Placeholder for G+
        SizedBox(height: 20),
        Icon(Icons.camera_alt, color: Colors.black87), // Placeholder for Instagram
        SizedBox(height: 20),
        Icon(Icons.pin_drop, color: Colors.black87), // Placeholder for Pinterest
      ],
    );
  }
}
