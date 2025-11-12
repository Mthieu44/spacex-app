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
  final double _segmentHeight = 300;
  final int _starsPerSegment = 150;
  List<Star>? _stars;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _stars ??= _generateStars(
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height + 2000,
        )
      );
  }

  List<Star> _generateStars(Size size)  {
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
        final flickerOffset = random.nextDouble() * 2 * pi;
        final depth = random.nextDouble();
        stars.add(Star(Offset(x, y), size, flickerOffset, depth));
      }
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    if (_stars == null) {
      return SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([widget.scrollController, _animationController]),
      builder: (context, child) {
        final hasClients = widget.scrollController.hasClients;

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _NightSkyPainter(
                  stars: _stars!,
                  animationValue: _animationController.value,
                  scrollOffset: hasClients ? widget.scrollController.offset : 0.1
                )
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
  final double flickerOffset;
  final double depth;

  Star(
    this.position,
    this.size,
    this.flickerOffset,
    this.depth
  );
}

class _NightSkyPainter extends CustomPainter {
  final double animationValue;
  final List<Star> stars;
  final double scrollOffset;

  _NightSkyPainter({
    required this.stars,
    this.animationValue = 0.0,
    this.scrollOffset = 0.1,
  });

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
    for (var star in stars) {
      final flicker = 0.5 + 0.5 * sin(2 * pi * animationValue + star.flickerOffset);
      paintStar.color = Colors.white.withAlpha((150 + (105 * flicker)).toInt());

      final parallaxFactor = 0.05 + (1 - star.depth) * 0.15;
      final adjustedY = star.position.dy - scrollOffset * parallaxFactor;
      if (adjustedY > size.height || adjustedY < 0) continue;
      canvas.drawCircle(Offset(star.position.dx, adjustedY), star.size, paintStar);
    }
  }

  @override
  bool shouldRepaint(covariant _NightSkyPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.stars != stars ||
        oldDelegate.scrollOffset != scrollOffset;
  }
}