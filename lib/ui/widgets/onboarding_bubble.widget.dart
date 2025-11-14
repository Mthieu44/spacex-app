import 'package:flutter/material.dart';

class OnboardingBubbleWidget extends StatelessWidget {
  final String text;
  final Rect rect;
  const OnboardingBubbleWidget({super.key, required this.text, required this.rect});

  @override
  Widget build(BuildContext context) {

    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(180),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.white, width: 2.0)
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                decoration: TextDecoration.none
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}