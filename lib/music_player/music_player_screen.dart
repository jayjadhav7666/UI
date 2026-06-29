import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

final List<Map<String, dynamic>> songs = [
  {
    'title': 'Neon Skyline',
    'artist': 'Retro Synthwave',
    'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    'image': 'https://picsum.photos/seed/synthwave/200/200',
    'gradient': [const Color(0xFF6B00B6), const Color(0xFF1A0033)],
    'discColor': const Color(0xFFE040FB),
    'waveColor': const Color(0xFFE040FB),
  },
  {
    'title': 'Midnight Lofi',
    'artist': 'Chill Beats',
    'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    'image': 'https://picsum.photos/seed/lofi/200/200',
    'gradient': [const Color(0xFF003B6F), const Color(0xFF001428)],
    'discColor': const Color(0xFF00E5FF),
    'waveColor': const Color(0xFF00E5FF),
  },
  {
    'title': 'Fire Rush',
    'artist': 'Energy Boost',
    'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    'image': 'https://picsum.photos/seed/fire/200/200',
    'gradient': [const Color(0xFF8B1A00), const Color(0xFF1A0500)],
    'discColor': const Color(0xFFFF6D00),
    'waveColor': const Color(0xFFFF6D00),
  },
  {
    'title': 'Starlight Journey',
    'artist': 'Cosmic Explorers',
    'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    'image': 'https://picsum.photos/seed/starlight/200/200',
    'gradient': [const Color(0xFF00B66B), const Color(0xFF00331A)],
    'discColor': const Color(0xFF40FBE0),
    'waveColor': const Color(0xFF40FBE0),
  },
  {
    'title': 'Desert Mirage',
    'artist': 'Acoustic Vibes',
    'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    'image': 'https://picsum.photos/seed/desert/200/200',
    'gradient': [const Color(0xFFB6A000), const Color(0xFF332000)],
    'discColor': const Color(0xFFFBE040),
    'waveColor': const Color(0xFFFBE040),
  },
];

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>
    with TickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  int _currentIndex = 0;

  late AnimationController _rotationController;
  late AnimationController _playPauseController;
  late AnimationController _heartController;
  late AnimationController _discPopController;
  late List<AnimationController> _waveControllers;
  late AnimationController _particleController;

  late Animation<double> _heartBounce;
  late Animation<double> _discPopScale;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _isLiked = false;
  bool _isLoading = true;

  final List<double> _waveRandoms = List.generate(
    30,
    (index) => math.Random().nextDouble(),
  );

  // Particles state
  final List<Offset> _particles = List.generate(
    6,
    (index) => Offset(math.Random().nextDouble(), math.Random().nextDouble()),
  );

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 1 full rotation per 3 seconds
    );

    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _heartBounce = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.4,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.4,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.9,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
    ]).animate(_heartController);

    _discPopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _discPopScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.1,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.1,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_discPopController);

    _waveControllers = List.generate(30, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + (math.Random().nextInt(400))),
      );
    });

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _initAudio();
  }

  Future<void> _initAudio() async {
    final playlist = ConcatenatingAudioSource(
      children: songs.map((s) => AudioSource.uri(Uri.parse(s['url']))).toList(),
    );

    try {
      await _player.setAudioSource(playlist);
      _setupPlayerStreams();
    } catch (e) {
      debugPrint("Error loading audio source: $e");
    }
  }

  void _setupPlayerStreams() {
    _player.positionStream.listen((pos) {
      setState(() => _position = pos);
    });

    _player.durationStream.listen((dur) {
      setState(() => _duration = dur ?? Duration.zero);
    });

    _player.currentIndexStream.listen((index) {
      if (index != null && index != _currentIndex) {
        setState(() {
          _currentIndex = index;
          _discPopController.forward(from: 0);
          _isLiked = false; // Reset like state for new song
        });
      }
    });

    _player.playerStateStream.listen((state) {
      final isPlaying = state.playing;
      final processingState = state.processingState;

      setState(() {
        _isLoading =
            processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering;
      });

      if (processingState == ProcessingState.completed) {
        // Just audio concatenating source handles auto-play next if we're playing
      }

      if (isPlaying != _isPlaying) {
        _isPlaying = isPlaying;
        if (_isPlaying) {
          _playPauseController.forward();
          _rotationController.repeat();
          for (var c in _waveControllers) {
            c.repeat(reverse: true);
          }
        } else {
          _playPauseController.reverse();
          // Decelerate disc
          _rotationController
              .animateTo(
                _rotationController.value + 0.1,
                duration: const Duration(milliseconds: 800),
                curve: Curves.decelerate,
              )
              .then((_) {
                if (!_isPlaying) _rotationController.stop();
              });

          for (var c in _waveControllers) {
            c.animateTo(
              0.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _rotationController.dispose();
    _playPauseController.dispose();
    _heartController.dispose();
    _discPopController.dispose();
    _particleController.dispose();
    for (var c in _waveControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _togglePlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void _playNext() {
    if (_player.hasNext) {
      _player.seekToNext();
    } else {
      _player.seek(Duration.zero, index: 0); // Loop to start
    }
  }

  void _playPrevious() {
    if (_player.hasPrevious) {
      _player.seekToPrevious();
    } else {
      _player.seek(Duration.zero);
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildWaveform(Color waveColor) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(30, (index) {
          return AnimatedBuilder(
            animation: _waveControllers[index],
            builder: (context, child) {
              double baseHeight = 5.0;
              double animatedHeight =
                  _waveControllers[index].value * 75 * _waveRandoms[index];
              return Container(
                width: 4,
                height: baseHeight + animatedHeight,
                decoration: BoxDecoration(
                  color: waveColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(_particles.length, (index) {
            double progress = (_particleController.value + (index * 0.2)) % 1.0;
            double topOffset =
                -50 +
                (MediaQuery.of(context).size.height + 100) * (1 - progress);
            double leftOffset =
                MediaQuery.of(context).size.width * _particles[index].dx;

            // Adding a slight sway
            leftOffset += math.sin(progress * math.pi * 4) * 20;

            return Positioned(
              top: topOffset,
              left: leftOffset,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1 * (1 - progress)),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final song = songs[_currentIndex];
    final gradientColors = song['gradient'] as List<Color>;
    final discColor = song['discColor'] as Color;
    final waveColor = song['waveColor'] as Color;

    return Scaffold(
      body: Stack(
        children: [
          // Background Animated Gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
          ),

          // Particles Background
          _buildParticles(),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Disc Art
                Expanded(
                  flex: 5,
                  child: Center(
                    child: ScaleTransition(
                      scale: _discPopScale,
                      child: GestureDetector(
                        onTap: _togglePlayPause,
                        child: AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationController.value * 2 * math.pi,
                              child: child,
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Circular Visualizer
                              SizedBox(
                                width: 300,
                                height: 300,
                                child: CustomPaint(
                                  painter: CircularVisualizerPainter(
                                    _waveControllers,
                                    _waveRandoms,
                                    waveColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: 280,
                                height: 280,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 30,
                                      offset: const Offset(0, 15),
                                    ),
                                  ],
                                ),
                                child: CustomPaint(
                                  painter: VinylPainter(discColor),
                                ),
                              ),
                              if (_isLoading)
                                const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Glassmorphism Control Card
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 50,
                      bottom: 10,
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Song Info
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      transitionBuilder:
                                          (
                                            Widget child,
                                            Animation<double> animation,
                                          ) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(0.1, 0.0),
                                                  end: Offset.zero,
                                                ).animate(animation),
                                                child: child,
                                              ),
                                            );
                                          },
                                      child: Row(
                                        key: ValueKey<int>(_currentIndex),
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              song['image'] as String,
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  song['title'] as String,
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  song['artist'] as String,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.6),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ScaleTransition(
                                    scale: _heartBounce,
                                    child: IconButton(
                                      iconSize: 32,
                                      icon: Icon(
                                        _isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: _isLiked
                                            ? Colors.pinkAccent
                                            : Colors.white70,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isLiked = !_isLiked;
                                        });
                                        _heartController.forward(from: 0.0);
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              // Progress Bar
                              SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 4,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 6,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 14,
                                  ),
                                  activeTrackColor: waveColor,
                                  inactiveTrackColor: Colors.white.withValues(
                                    alpha: 0.2,
                                  ),
                                  thumbColor: Colors.white,
                                  overlayColor: waveColor.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                                child: Slider(
                                  value: _position.inSeconds.toDouble().clamp(
                                    0.0,
                                    _duration.inSeconds.toDouble(),
                                  ),
                                  min: 0,
                                  max: _duration.inSeconds > 0
                                      ? _duration.inSeconds.toDouble()
                                      : 1.0,
                                  onChanged: (value) {
                                    _player.seek(
                                      Duration(seconds: value.toInt()),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(_position),
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(_duration),
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              // Playback Controls
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      size: 40,
                                    ),
                                    color: Colors.white,
                                    onPressed: _playPrevious,
                                  ),
                                  AnimatedBuilder(
                                    animation: _playPauseController,
                                    builder: (context, child) {
                                      double scale =
                                          1.0 +
                                          (_playPauseController.value * 0.1);
                                      return Transform.scale(
                                        scale: scale,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withValues(
                                              alpha: 0.15,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.3,
                                              ),
                                            ),
                                          ),
                                          child: IconButton(
                                            iconSize: 40,
                                            color: Colors.white,
                                            icon: AnimatedIcon(
                                              icon: AnimatedIcons.play_pause,
                                              progress: _playPauseController,
                                            ),
                                            onPressed: _togglePlayPause,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.skip_next, size: 40),
                                    color: Colors.white,
                                    onPressed: _playNext,
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Waveform Base
                _buildWaveform(waveColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for the Vinyl Record
class VinylPainter extends CustomPainter {
  final Color centerColor;

  VinylPainter(this.centerColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Base black vinyl
    final basePaint = Paint()
      ..color = const Color(0xFF121212)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, basePaint);

    // Grooves
    final groovePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (int i = 2; i <= 20; i++) {
      canvas.drawCircle(center, radius - (i * 6), groovePaint);
    }

    // Colored Label with Gradient to make rotation obvious
    final labelPaint = Paint()
      ..shader = SweepGradient(
        colors: [centerColor, centerColor.withValues(alpha: 0.4), centerColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.3))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.3, labelPaint);

    // Add some asymmetric "text" blocks on the label to show rotation
    final textPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(center.dx + 10, center.dy - 10, 30, 4),
      textPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(center.dx + 10, center.dy - 2, 20, 3),
      textPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(center.dx - 40, center.dy + 15, 25, 4),
      textPaint,
    );

    // Label details
    final detailPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius * 0.28, detailPaint);
    canvas.drawCircle(center, radius * 0.25, detailPaint);

    // Center hole
    final holePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.08, holePaint);

    // Spindle hole
    final spindlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.03, spindlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CircularVisualizerPainter extends CustomPainter {
  final List<AnimationController> controllers;
  final List<double> randoms;
  final Color color;

  CircularVisualizerPainter(this.controllers, this.randoms, this.color)
    : super(repaint: Listenable.merge(controllers));

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    int count = controllers.length;
    double angleStep = (2 * math.pi) / count;

    for (int i = 0; i < count; i++) {
      double angle = i * angleStep;
      double value = controllers[i].value;
      double height = 5.0 + (value * 40 * randoms[i]);

      final start = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      final end = Offset(
        center.dx + math.cos(angle) * (radius + height),
        center.dy + math.sin(angle) * (radius + height),
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
