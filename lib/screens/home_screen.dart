import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mood_entry.dart';
import '../providers/mood_provider.dart';
import '../widgets/mood_button.dart';
import '../widgets/timeline_item.dart';
import '../painters/mood_face_painter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  MoodType? _selectedMood;
  bool _showSuccessBanner = false;
  late AnimationController _bannerController;
  late Animation<double> _bannerSlide;

  @override
  void initState() {
    super.initState();
    _bannerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _bannerSlide = CurvedAnimation(
        parent: _bannerController, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _logMood() {
    if (_selectedMood == null) return;
    context.read<MoodProvider>().logMood(_selectedMood!);
    setState(() {
      _showSuccessBanner = true;
      _selectedMood = null;
    });
    _bannerController.forward(from: 0.0);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _bannerController.reverse().then((_) {
          if (mounted) setState(() => _showSuccessBanner = false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackground(),
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 48.0 : 20.0,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 36),
                        _buildMoodSelectorCard(isWide),
                        const SizedBox(height: 32),
                        _buildTimelineSection(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Success banner
            if (_showSuccessBanner)
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: ScaleTransition(
                    scale: _bannerSlide,
                    child: FadeTransition(
                      opacity: _bannerSlide,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade500,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.check,
                                  size: 13, color: Colors.green),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Mood logged!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: CustomPaint(painter: _BackgroundPainter()),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CustomPaint(
            painter: MoodFacePainter(
              mood: MoodType.happy,
              faceColor: Colors.transparent,
              featureColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mood Tracker',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'How are you feeling today?',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodSelectorCard(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? 32 : 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Log your mood',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pick how you\'re feeling right now',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          // Mood buttons
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: MoodType.values.map((mood) {
              return MoodButton(
                mood: mood,
                isSelected: _selectedMood == mood,
                onTap: () => setState(() => _selectedMood = mood),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Log button
          AnimatedOpacity(
            opacity: _selectedMood != null ? 1.0 : 0.45,
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              width: double.infinity,
              child: _LogButton(
                enabled: _selectedMood != null,
                selectedMood: _selectedMood,
                onPressed: _logMood,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Consumer<MoodProvider>(
      builder: (context, provider, _) {
        final entries = provider.entries;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Recent Moods',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${entries.length}/7',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              entries.isEmpty
                  ? 'Your logged moods will appear here'
                  : 'Tap any entry to see it react',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 16),
            if (entries.isEmpty)
              _buildEmptyTimeline()
            else
              _buildTimeline(entries),
          ],
        );
      },
    );
  }

  Widget _buildTimeline(List<MoodEntry> entries) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Timeline connector line + dots
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: _TimelineConnector(entries: entries),
          ),
          // Horizontal scrollable cards
          SizedBox(
            height: 185,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: entries.length,
              itemBuilder: (ctx, i) => TimelineItem(
                entry: entries[i],
                isFirst: i == 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTimeline() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: Colors.grey.shade100, width: 1.5,
            style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timeline_rounded,
                size: 36, color: Colors.grey.shade300),
            const SizedBox(height: 10),
            Text(
              'No moods logged yet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Select a mood above and tap Log',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade300),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Log Button
// ------------------------------------------------------------
class _LogButton extends StatefulWidget {
  final bool enabled;
  final MoodType? selectedMood;
  final VoidCallback onPressed;

  const _LogButton({
    required this.enabled,
    required this.selectedMood,
    required this.onPressed,
  });

  @override
  State<_LogButton> createState() => _LogButtonState();
}

class _LogButtonState extends State<_LogButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final mood = widget.selectedMood;
    final gradient = mood != null
        ? LinearGradient(
            colors: [mood.gradientStart, mood.gradientEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.enabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                      color: (mood?.color ?? const Color(0xFF6C63FF))
                          .withValues(alpha: _isHovered ? 0.45 : 0.28),
                      blurRadius: _isHovered ? 20 : 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: AnimatedScale(
              scale: _isHovered && widget.enabled ? 1.03 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_circle_outline_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    mood != null
                        ? 'Log ${mood.label} Mood'
                        : 'Select a mood first',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Timeline connector dots
// ------------------------------------------------------------
class _TimelineConnector extends StatelessWidget {
  final List<MoodEntry> entries;

  const _TimelineConnector({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 0),
      child: Row(
        children: List.generate(entries.length * 2 - 1, (i) {
          if (i.isOdd) {
            // Connector line
            return Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      entries[i ~/ 2].mood.color.withValues(alpha: 0.3),
                      entries[i ~/ 2 + 1].mood.color.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            );
          } else {
            final mood = entries[i ~/ 2].mood;
            return Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: mood.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: mood.color.withValues(alpha: 0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}

// ------------------------------------------------------------
// Decorative background blobs
// ------------------------------------------------------------
class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFF6C63FF).withValues(alpha: 0.04);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.12),
        size.width * 0.30, paint1);

    final paint2 = Paint()
      ..color = const Color(0xFFFFB703).withValues(alpha: 0.05);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.65),
        size.width * 0.22, paint2);

    final paint3 = Paint()
      ..color = const Color(0xFF7E57C2).withValues(alpha: 0.04);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.90),
        size.width * 0.18, paint3);
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) => false;
}
