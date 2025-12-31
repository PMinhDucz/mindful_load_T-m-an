import 'package:uuid/uuid.dart';

enum Mood {
  veryGood,
  good,
  neutral,
  bad,
  veryBad, // Equivalent to Angry/Stress
}

// Extension to get display data for Mood
extension MoodExtension on Mood {
  String get label {
    switch (this) {
      case Mood.veryGood:
        return 'Happy';
      case Mood.good:
        return 'Good';
      case Mood.neutral:
        return 'Neutral';
      case Mood.bad:
        return 'Sad';
      case Mood.veryBad:
        return 'Stress';
    }
  }

  String get assetPath {
    // Placeholder assets, will need to be mapped to actual files
    switch (this) {
      case Mood.veryGood:
        return 'assets/icons/happy.png';
      case Mood.good:
        return 'assets/icons/good.png';
      case Mood.neutral:
        return 'assets/icons/neutral.png';
      case Mood.bad:
        return 'assets/icons/sad.png';
      case Mood.veryBad:
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
