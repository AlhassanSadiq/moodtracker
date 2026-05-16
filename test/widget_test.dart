import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/providers/mood_provider.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => MoodProvider(),
        child: const MoodTrackerApp(),
      ),
    );
    expect(find.text('Mood Tracker'), findsOneWidget);
  });
}
