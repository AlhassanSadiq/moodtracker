import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../painters/mood_face_painter.dart';

class AnimatedMoodCard extends StatefulWidget {
  final MoodType mood;
  final double size;

  const AnimatedMoodCard({super.key, required this.mood, required this.size});

  @override
  State<AnimatedMoodCard> createState() => AnimatedMoodCardState();
}

class AnimatedMoodCardState extends State<AnimatedMoodCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceScale;
  late Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.28)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.28, end: 0.92)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.92, end: 1.06)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.06, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(_controller);

    _glowOpacity = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 40),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 60),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void triggerAnimation() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceScale.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow ring behind the face
              if (_controller.isAnimating)
                Container(
                  width: widget.size + 12,
                  height: widget.size + 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.mood.color
                        .withOpacity(0.35 * _glowOpacity.value),
                  ),
                ),
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: MoodFacePainter(
                  mood: widget.mood,
                  faceColor: widget.mood.color,
                  featureColor: Colors.white,
                  animationValue: _controller.value,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
