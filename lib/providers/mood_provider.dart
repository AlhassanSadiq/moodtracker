import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class MoodProvider extends ChangeNotifier {
  final List<MoodEntry> _entries = [];
  static const int _maxEntries = 7;

  List<MoodEntry> get entries => List.unmodifiable(_entries);

  void logMood(MoodType mood) {
    final entry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mood: mood,
      createdAt: DateTime.now(),
    );

    _entries.insert(0, entry);

    if (_entries.length > _maxEntries) {
      _entries.removeRange(_maxEntries, _entries.length);
    }

    notifyListeners();
  }
}
