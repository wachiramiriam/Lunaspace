import 'package:flutter/material.dart';
import 'dart:math';

class ReleasePage extends StatefulWidget {
  const ReleasePage({super.key});

  @override
  State<ReleasePage> createState() => _ReleasePageState();
}

class _ReleasePageState extends State<ReleasePage>
    with SingleTickerProviderStateMixin {
  TextEditingController _controller = TextEditingController();
  late AnimationController _animController;
  bool isReleasing = false;
  bool showCalmMessage = false;

  final Random random = Random();
  List<ParticleLetter> particles = [];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  void releaseText() {
    if (_controller.text.isEmpty) return;

    // Hide text immediately
    setState(() {
      isReleasing = true;
      showCalmMessage = false;
    });

    // Create particle for each letter
    final text = _controller.text;
    particles.clear();

    double x = 16; // padding left
    double y = 16; // padding top
    const lineHeight = 24;

    for (var char in text.characters) {
      particles.add(ParticleLetter(
        char: char,
        startX: x,
        startY: y,
        dx: (random.nextDouble() - 0.5) * 200,
        dy: -random.nextDouble() * 150,
        opacity: 1.0,
      ));
      x += 12; // spacing between letters
      if (x > 350) {
        x = 16;
        y += lineHeight;
      }
    }

    _animController.forward(from: 0);

    // Show calm message after animation
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        isReleasing = false;
        showCalmMessage = true;
        _controller.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "LunaSpace 🌙",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Hey Hero,time to let the unsaid drift away like stardust.You've got this! 🚀",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(width: 10),
              
              const SizedBox(height: 20),
              Expanded(
                child: Stack(
                  children: [
                    // TextField hidden during release
                    if (!isReleasing && !showCalmMessage)
                      TextField(
                        controller: _controller,
                        maxLines: null,
                        expands: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Write the unsaid...",
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                    // Particle animation
                    if (isReleasing)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: TextParticlePainter(
                            particles: particles,
                            progress: _animController.value,
                          ),
                        ),
                      ),

                    // Calm message
                    if (showCalmMessage)
                      Center(
                        child: AnimatedOpacity(
                          duration: const Duration(seconds: 1),
                          opacity: 1,
                          child: const Text(
                            "You did it Hero 😊",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: isReleasing ? null : releaseText,
                icon: const Icon(Icons.flight_takeoff),
                label: const Text("Release"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),

              SizedBox(width: 15),

              Text('Whatever you write here and let go disappears forever, so write your heart out!',
              style: TextStyle(color: Colors.white70, fontSize: 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,),
              textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParticleLetter {
  String char;
  double startX, startY;
  double dx, dy;
  double opacity;

  ParticleLetter({
    required this.char,
    required this.startX,
    required this.startY,
    required this.dx,
    required this.dy,
    required this.opacity,
  });
}

class TextParticlePainter extends CustomPainter {
  final List<ParticleLetter> particles;
  final double progress;

  TextParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var p in particles) {
      final x = p.startX + p.dx * progress;
      final y = p.startY + p.dy * progress;
      final alpha = ((1 - progress) * 255).toInt().clamp(0, 255);

      final textPainter = TextPainter(
        text: TextSpan(
          text: p.char,
          style: TextStyle(
            color: Colors.white.withAlpha(alpha),
            fontSize: 18,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}