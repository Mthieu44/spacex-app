import 'dart:math';
import 'package:flutter/material.dart';

class NightSkyBackground extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  const NightSkyBackground({
    super.key,
    required this.child,
    required this.scrollController,
  });

  @override
  State<NightSkyBackground> createState() => _NightSkyBackgroundState();
}

class _NightSkyBackgroundState extends State<NightSkyBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.scrollController, _animationController]),
      builder: (context, child) {
        final offset =
          widget.scrollController.hasClients ? widget.scrollController.offset * 0.1 : 0.0;
        final maxScroll = widget.scrollController.hasClients
            ? widget.scrollController.position.maxScrollExtent
            : 0.0;

        return Stack(
          children: [
            Positioned(
              top: -offset,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height + maxScroll,
              child: CustomPaint(
                painter: _NightSkyPainter(animationValue: _animationController.value)
              ),
            ),
            widget.child,
          ],
        );
      },
    );
  }
}

class Star {
  final Offset position;
  final double size;

  Star(this.position, this.size);
}

class _NightSkyPainter extends CustomPainter {
  final double _segmentHeight = 300;
  final int _starsPerSegment = 30;
  final double animationValue;
  _NightSkyPainter({this.animationValue = 0.0});

  List<Star> _generateStars(Size size) {
    final List<Star> stars = [];
    final random = Random(42);
    final width = size.width;
    final height = size.height;
    final segments = (height / _segmentHeight).ceil() + 2;

    for (int i = 0; i < segments; i++) {
      final segmentTop = i * _segmentHeight;
      for (int j = 0; j < _starsPerSegment; j++) {
        final x = random.nextDouble() * width;
        final y = random.nextDouble() * _segmentHeight + segmentTop;
        final size = random.nextDouble() * 1.2 + 0.3;
        stars.add(Star(Offset(x, y), size));
      }
    }
    return stars;
  }


  @override
  void paint(Canvas canvas, Size size) {
    // Dessin du fond
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF02030A), Color(0xFF050A1B)],
    );
    final paintBg = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paintBg);

    // Dessin des étoiles
    final paintStar = Paint();
    final stars = _generateStars(size);
    for (var star in stars) {
      final flicker = (sin((animationValue * 2 * pi) + star.position.dx) + 1) / 2;
      paintStar.color = Colors.white.withOpacity(0.5 + 0.5 * flicker);
      if (star.position.dy > size.height) continue;
      canvas.drawCircle(star.position, star.size, paintStar);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}