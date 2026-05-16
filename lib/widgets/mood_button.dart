import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../painters/mood_face_painter.dart';

class MoodButton extends StatefulWidget {
  final MoodType mood;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodButton({
    super.key,
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<MoodButton> createState() => _MoodButtonState();
}

class _MoodButtonState extends State<MoodButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();
  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final mood = widget.mood;
    final isSelected = widget.isSelected;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: 110,
            height: 140,
            decoration: BoxDecoration(
              color: isSelected ? mood.lightColor : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? mood.color
                    : (_isHovered
                        ? mood.color.withOpacity(0.4)
                        : Colors.grey.shade200),
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? mood.color.withOpacity(0.30)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: isSelected ? 16 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.08 : (_isHovered ? 1.04 : 1.0),
                  duration: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: CustomPaint(
                      painter: MoodFacePainter(
                        mood: mood,
                        faceColor: mood.color,
                        featureColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  mood.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? mood.gradientEnd : Colors.grey.shade600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
