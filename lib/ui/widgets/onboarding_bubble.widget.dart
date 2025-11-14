import 'package:flutter/material.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class OnboardingBubbleWidget extends StatefulWidget {
  final String text;
  final Rect rect;
  final int currentStep;
  const OnboardingBubbleWidget({
    super.key,
    required this.text,
    required this.rect,
    required this.currentStep,
  });

  @override
  State<OnboardingBubbleWidget> createState() => _OnboardingBubbleWidgetState();
}

class _OnboardingBubbleWidgetState extends State<OnboardingBubbleWidget> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final AnimationController _typewriterController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _typewriterController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.text.length * 75)),
    )..forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) {
        return Positioned(
          left: widget.rect.left,
          top: widget.rect.top,
          width: widget.rect.width,
          height: widget.rect.height,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withAlpha(200),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.white, width: 2.0)
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '>_',
                        style: GoogleFonts.spaceMono(
                            color: Colors.white60,
                            fontSize: 9.5,
                            decoration: TextDecoration.none
                        ),
                      ),
                      Text(
                        'ONB-${widget.currentStep}',
                        style: GoogleFonts.spaceMono(
                            color: Colors.white60,
                            fontSize: 9.5,
                            decoration: TextDecoration.none
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedBuilder(
                      animation: _typewriterController,
                      builder: (_, __) {
                        final fullText = widget.text;
                        final progress = _typewriterController.value;
                        final charCount = (progress * fullText.length).clamp(0, fullText.length).toInt();
                        final displayedText = fullText.substring(0, charCount);
                        late double cursorOpacity;
                        if (progress < 1.0) {
                          cursorOpacity = 1.0;
                        } else if (_animationController.value <= 0.25 || (_animationController.value > 0.5 && _animationController.value <= 0.75)) {
                          cursorOpacity = 1.0;
                        } else {
                          cursorOpacity = 0.0;
                        }

                        return RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.spaceMono(
                              color: Colors.white,
                              fontSize: 15,
                              decoration: TextDecoration.none,
                            ),
                            children: [
                              TextSpan(text: displayedText),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Opacity(
                                  opacity: cursorOpacity,
                                  child: Container(
                                    width: 9,
                                    height: 18,
                                    color: Colors.white,
                                  ),
                                )
                              )
                            ]
                          )
                        );
                      }
                    )
                  ),
                ),
                Spacer(),
                Opacity(
                  opacity: _typewriterController.value == 1 ? 0.2 + 0.8 * ((1 + sin(2 * pi * _animationController.value)) / 2) : 0,
                  child: Text(
                    'Press anywhere to continue',
                    style: GoogleFonts.spaceMono(
                      color: Colors.white70,
                      fontSize: 10.5,
                      decoration: TextDecoration.none,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}