import 'dart:ui';
import 'package:flutter/material.dart';
import 'dynamic_island.dart';

class DynamicIslandScreen extends StatefulWidget {
  const DynamicIslandScreen({super.key});

  @override
  State<DynamicIslandScreen> createState() => _DynamicIslandScreenState();
}

class _DynamicIslandScreenState extends State<DynamicIslandScreen> {
  IslandState _currentState = IslandState.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image to showcase Glassmorphism
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=2564&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
          ),
          
          // The Dynamic Island
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: DynamicIsland(state: _currentState),
              ),
            ),
          ),
          
          // Floating Controls at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildControlButton('Idle', IslandState.idle, Icons.remove),
                        const SizedBox(width: 8),
                        _buildControlButton('Call', IslandState.call, Icons.call),
                        const SizedBox(width: 8),
                        _buildControlButton('Music', IslandState.music, Icons.music_note),
                        const SizedBox(width: 8),
                        _buildControlButton('Food', IslandState.delivery, Icons.fastfood),
                      ],
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

  Widget _buildControlButton(String label, IslandState state, IconData icon) {
    final isSelected = _currentState == state;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentState = state;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.white, size: 18),
            if (isSelected) const SizedBox(width: 6),
            if (isSelected)
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
