import 'package:flutter/material.dart';
import 'package:spacex_app/logic/cubit/onboarding.cubit.dart';
import 'package:spacex_app/ui/widgets/onboarding_bubble.widget.dart';

class OnboardingWidget extends StatefulWidget {
  final Map<String, GlobalKey> globalKeys;
  final OnboardingType type;
  final int currentStepIndex;
  final VoidCallback onNextStep;
  const OnboardingWidget({
    super.key,
    required this.globalKeys,
    required this.type,
    required this.currentStepIndex,
    required this.onNextStep
  });

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  late List<FeatureStep> steps;

  @override
  void initState() {
    super.initState();
    if (widget.type == OnboardingType.home) {
      steps = [
      FeatureStep(
        key: null,
        text: 'Welcome to the SpaceX Launches App! Here you can explore all SpaceX launches.',
        bubbleRect: Rect.fromLTWH(0, 0, 250, 150),
        backgroundAlpha: 150
      ),
      FeatureStep(
          key: widget.globalKeys['favoritesButtonKey'],
          text: 'Tap this button to filter your favorite launches.',
          bubbleRect: Rect.fromLTWH(20, -200, 230, 120),
          backgroundAlpha: 50
      ),
      FeatureStep(
        key: widget.globalKeys['viewToggleButtonKey'],
        text: 'Use this button to toggle between list and grid views.',
        bubbleRect: Rect.fromLTWH(30, -190, 230, 120),
        backgroundAlpha: 50
      ),
      FeatureStep(
        key: null,
        text: 'Now try clicking on a launch to see more details!',
        bubbleRect: Rect.fromLTWH(0, 0, 250, 150),
        backgroundAlpha: 150
      )
    ];
    } else if (widget.type == OnboardingType.detail) {
      steps = [
        FeatureStep(
          key: null,
          text: 'This is the launch detail page where you can find more information about the selected launch.',
          bubbleRect: Rect.fromLTWH(0, 0, 250, 150),
          backgroundAlpha: 150
        ),
        FeatureStep(
          key: widget.globalKeys['favoriteDetailButtonKey'],
          text: 'Tap this button to mark or unmark this launch as a favorite.',
          bubbleRect: Rect.fromLTWH(30, -190, 230, 120),
          backgroundAlpha: 50
        ),
        FeatureStep(
          key: widget.globalKeys['backButtonKey'],
          text: 'Use this button to go back to the launches list.',
          bubbleRect: Rect.fromLTWH(-40, -190, 230, 120),
          backgroundAlpha: 50
        ),
        FeatureStep(
          key: null,
          text: 'Enjoy exploring the launch details!',
          bubbleRect: Rect.fromLTWH(0, 0, 250, 150),
          backgroundAlpha: 150
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = steps[widget.currentStepIndex];
    final screenSize = MediaQuery.of(context).size;
    final left = screenSize.width * 0.5 - currentStep.bubbleRect.width * 0.5 + currentStep.bubbleRect.left;
    final top = screenSize.height * 0.5 - currentStep.bubbleRect.height * 0.5 + currentStep.bubbleRect.top;


    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onNextStep,
        child: Stack(
          children: [
            Container(
              color: Colors.black.withAlpha(currentStep.backgroundAlpha),
            ),
            OnboardingBubbleWidget(
              text: currentStep.text,
              rect: Rect.fromLTWH(
                left,
                top,
                currentStep.bubbleRect.width,
                currentStep.bubbleRect.height
              ),
            ),
            if (currentStep.key != null)
              CustomPaint(
                size: screenSize,
                painter: ArrowPainter(
                  bubbleRect: Rect.fromLTWH(
                    left,
                    top,
                    currentStep.bubbleRect.width,
                    currentStep.bubbleRect.height
                  ),
                  targetRect: _getWidgetRect(currentStep.key!)
                ),
              ),
          ],
        )
      )
    );
  }
}

class FeatureStep {
  final GlobalKey? key;
  final String text;
  final Rect bubbleRect;
  final int backgroundAlpha;

  FeatureStep({
    required this.key,
    required this.text,
    required this.bubbleRect,
    required this.backgroundAlpha
  });
}

Rect _getWidgetRect(GlobalKey key) {
  final context = key.currentContext;
  if (context == null) return Rect.zero;
  final box = context.findRenderObject() as RenderBox;
  return box.localToGlobal(Offset.zero) & box.size;
}

class ArrowPainter extends CustomPainter {
  final Rect bubbleRect;
  final Rect targetRect;
  ArrowPainter({required this.bubbleRect, required this.targetRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final startX = bubbleRect.left + bubbleRect.width * 0.8;
    final startY = bubbleRect.top;
    final endX = targetRect.left + targetRect.width / 2;
    final endY = targetRect.bottom + 8.0;

    path.moveTo(startX, startY);
    path.lineTo(endX, endY);

    // Draw arrowhead
    const arrowSize = 6.0;
    path.moveTo(endX, endY);
    path.lineTo(endX - arrowSize, endY + arrowSize);
    path.moveTo(endX, endY);
    path.lineTo(endX + arrowSize, endY + arrowSize);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}