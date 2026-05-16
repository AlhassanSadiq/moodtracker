import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mood_entry.dart';
import 'animated_mood_card.dart';

class TimelineItem extends StatefulWidget {
  final MoodEntry entry;
  final bool isFirst;

  const TimelineItem({
    super.key,
    required this.entry,
    required this.isFirst,
  });

  @override
  State<TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<TimelineItem>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedMoodCardState> _cardKey = GlobalKey();
  bool _isHovered = false;
  late AnimationController _highlightController;
  late Animation<double> _highlightAnim;

  @override
  void initState() {
    super.initState();
    _highlightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _highlightAnim = CurvedAnimation(
      parent: _highlightController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _highlightController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _cardKey.currentState?.triggerAnimation();
    _highlightController.forward(from: 0.0);
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDay = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(entryDay).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('MMM d').format(dt);
  }

  String _formatTime(DateTime dt) => DateFormat('h:mm a').format(dt);

  @override
  Widget build(BuildContext context) {
    final mood = widget.entry.mood;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _highlightAnim,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 110,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                color: _isHovered ? mood.lightColor : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _highlightAnim.value > 0.01
                      ? mood.color
                          .withOpacity(0.5 + 0.5 * _highlightAnim.value)
                      : (_isHovered
                          ? mood.color.withOpacity(0.45)
                          : Colors.grey.shade100),
                  width: 1.5 + _highlightAnim.value * 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: mood.color.withOpacity(
                        0.08 + (_isHovered ? 0.12 : 0) +
                            _highlightAnim.value * 0.22),
                    blurRadius: 12 + _highlightAnim.value * 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mood face
                AnimatedMoodCard(
                  key: _cardKey,
                  mood: mood,
                  size: 58,
                ),
                const SizedBox(height: 10),
                // Mood label
                Text(
                  mood.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: mood.gradientEnd,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                // Date
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: mood.lightColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _formatDate(widget.entry.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: mood.color,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(widget.entry.createdAt),
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
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
