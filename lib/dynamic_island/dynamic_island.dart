import 'dart:ui';
import 'package:flutter/material.dart';

enum IslandState { idle, call, music, delivery }

class DynamicIsland extends StatelessWidget {
  final IslandState state;

  const DynamicIsland({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    double width;
    double height;

    switch (state) {
      case IslandState.idle:
        width = 130;
        height = 35;
        break;
      case IslandState.call:
        width = 340;
        height = 85;
        break;
      case IslandState.music:
        width = 340;
        height = 160;
        break;
      case IslandState.delivery:
        width = 340;
        height = 85;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticOut,
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 15),
          ),
        ],
        borderRadius: BorderRadius.circular(40),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.75),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
            ),
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxWidth: 340,
              maxHeight: 160,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: _buildContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (state) {
      case IslandState.idle:
        return const SizedBox(key: ValueKey('idle'), width: 130, height: 35);
      case IslandState.call:
        return const SizedBox(key: ValueKey('call'), width: 340, height: 85, child: _CallContent());
      case IslandState.music:
        return const SizedBox(key: ValueKey('music'), width: 340, height: 160, child: _MusicContent());
      case IslandState.delivery:
        return const SizedBox(key: ValueKey('delivery'), width: 340, height: 85, child: _DeliveryContent());
    }
  }
}

class _CallContent extends StatelessWidget {
  const _CallContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  radius: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('John Appleseed', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  Text('Mobile', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.call_end, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.call, color: Colors.black, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MusicContent extends StatelessWidget {
  const _MusicContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?q=80&w=500&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Midnight City', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('M83', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
              const Icon(Icons.graphic_eq, color: Colors.deepPurpleAccent, size: 28),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.skip_previous_rounded, color: Colors.white, size: 40),
              SizedBox(width: 24),
              Icon(Icons.pause_circle_filled_rounded, color: Colors.white, size: 52),
              SizedBox(width: 24),
              Icon(Icons.skip_next_rounded, color: Colors.white, size: 40),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeliveryContent extends StatelessWidget {
  const _DeliveryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.fastfood, color: Colors.orangeAccent, size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Food Delivery', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Arriving in 3 mins', style: TextStyle(color: Colors.orangeAccent, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Track', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
