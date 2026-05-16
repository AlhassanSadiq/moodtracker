import 'package:flutter/material.dart';

enum MoodType { happy, neutral, sad, excited }

extension MoodTypeExtension on MoodType {
  String get label {
    switch (this) {
      case MoodType.happy:
        return 'Happy';
      case MoodType.neutral:
        return 'Neutral';
      case MoodType.sad:
        return 'Sad';
      case MoodType.excited:
        return 'Excited';
    }
  }

  Color get color {
    switch (this) {
      case MoodType.happy:
        return const Color(0xFFFFB703);
      case MoodType.neutral:
        return const Color(0xFF90A4AE);
      case MoodType.sad:
        return const Color(0xFF7E57C2);
      case MoodType.excited:
        return const Color(0xFFFF6D00);
    }
  }

  Color get lightColor {
    switch (this) {
      case MoodType.happy:
        return const Color(0xFFFFF8E1);
      case MoodType.neutral:
        return const Color(0xFFECEFF1);
      case MoodType.sad:
        return const Color(0xFFEDE7F6);
      case MoodType.excited:
        return const Color(0xFFFFF3E0);
    }
  }

  Color get gradientStart {
    switch (this) {
      case MoodType.happy:
        return const Color(0xFFFFD54F);
      case MoodType.neutral:
        return const Color(0xFFB0BEC5);
      case MoodType.sad:
        return const Color(0xFF9575CD);
      case MoodType.excited:
        return const Color(0xFFFFAB40);
    }
  }

  Color get gradientEnd {
    switch (this) {
      case MoodType.happy:
        return const Color(0xFFFB8C00);
      case MoodType.neutral:
        return const Color(0xFF546E7A);
      case MoodType.sad:
        return const Color(0xFF4527A0);
      case MoodType.excited:
        return const Color(0xFFDD2C00);
    }
  }
}

class MoodEntry {
  final String id;
  final MoodType mood;
  final DateTime createdAt;

  MoodEntry({
    required this.id,
    required this.mood,
    required this.createdAt,
  });
}
