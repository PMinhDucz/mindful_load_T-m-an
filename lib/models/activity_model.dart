import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum Mood {
  good,
  neutral,
  sad,
  angry,
  anxious,
  stress,
}

// Extension to get display data for Mood
extension MoodExtension on Mood {
  String get label {
    switch (this) {
      case Mood.good:
        return 'Feeling\nGood';
      case Mood.neutral:
        return 'Feeling\nNeutral';
      case Mood.sad:
        return 'Feeling\nSad';
      case Mood.angry:
        return 'Feeling\nAngry';
      case Mood.anxious:
        return 'Feeling\nAnxious';
      case Mood.stress:
        return 'Feeling\nStress';
    }
  }

  Color get color {
    switch (this) {
      case Mood.good:
        return const Color(0xFFFFC107); // Amber (Darker Yellow)
      case Mood.neutral:
        return const Color(0xFF64B5F6); // Blue 300 (Darker)
      case Mood.sad:
        return const Color(0xFFE57373); // Red 300 (Darker)
      case Mood.angry:
        return const Color(0xFFC62828); // Red 800 (Darker)
      case Mood.anxious:
        return const Color(0xFFFFB74D); // Orange 300 (Darker)
      case Mood.stress:
        return const Color(0xFF90A4AE); // Blue Grey 300 (Darker)
    }
  }

  String get assetPath {
    // Placeholder assets, will need to be mapped to actual files
    switch (this) {
      case Mood.good:
        return 'assets/icons/happy.png';
      case Mood.neutral:
        return 'assets/icons/neutral.png';
      case Mood.sad:
        return 'assets/icons/sad.png';
      case Mood.angry:
        return 'assets/icons/stress.png'; // Placeholder
      case Mood.anxious:
        return 'assets/icons/stress.png'; // Placeholder
      case Mood.stress:
        return 'assets/icons/stress.png';
    }
  }
}

class ActivityLog {
  final String id;
  final Mood mood;
  final List<String> tags; // Context: "Work", "Family", "Home"
  final String? note;
  final DateTime timestamp;

  ActivityLog({
    String? id,
    required this.mood,
    required this.tags,
    this.note,
    DateTime? timestamp,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood.index,
      'tags': tags,
      'note': note,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create from Map
  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      id: map['id'],
      mood: Mood.values[map['mood'] ?? 2],
      tags: List<String>.from(map['tags'] ?? []),
      note: map['note'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
