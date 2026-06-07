import 'package:flutter/material.dart';
import 'car_model.dart';

class CarDetailsView extends StatelessWidget {
  final Car car;
  final Animation<double> animation;

  const CarDetailsView({
    super.key,
    required this.car,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: Stack(
          children: [
            // Right Specs Column
            Align(
              alignment: const Alignment(0.85, -0.4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'SPECS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildSpecItem(Icons.local_gas_station, '${car.range} GAS'),
                  const SizedBox(height: 30),
                  _buildSpecItem(Icons.event_seat, '${car.seats} SEATS'),
                  const SizedBox(height: 30),
                  _buildSpecItem(Icons.speed, '${car.horsePower} HORSE POWER'),
                ],
              ),
            ),

            // Bottom Gallery
            Align(
              alignment: const Alignment(0, 0.7),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'TAKE A LOOK',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: car.galleryImages.map((img) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                img,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            // Rent Now Button
            Align(
              alignment: const Alignment(0, 0.95),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA10015), // Deep red color
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Rent Now',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String text) {
    // Split the text to make the number bold and the rest smaller (e.g. "800 KM" and "GAS")
    final parts = text.split(' ');
    final value = parts.length > 1 ? '${parts[0]} ${parts[1]}' : parts[0];
    final label = parts.length > 2 ? parts.sublist(2).join(' ') : (parts.length == 2 ? parts[1] : '');

    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.black87),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
        ]
      ],
    );
  }
}
