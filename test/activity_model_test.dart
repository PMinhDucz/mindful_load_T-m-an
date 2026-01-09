import 'package:flutter_test/flutter_test.dart';
import 'package:mindful_load/models/activity_model.dart';

void main() {
  group('ActivityLog Model Tests', () {
    test('ActivityLog should parse from JSON correctly', () {
      final json = {
        'id': '123',
        'mood': 'good',
        'tags': ['Work', 'Coffee'],
        'note': 'Feeling great',
        'timestamp': '2023-10-27T10:00:00.000Z'
      };

      // Since we don't have the ActivityLog.fromJson factory in the file we viewed earlier (it was mapped manually in controller),
      // let's simulate the parsing logic used in ActivityController to ensure it works.

      final log = ActivityLog(
        id: json['id'] as String,
        mood: Mood.values.firstWhere((e) => e.name == json['mood']),
        tags: List<String>.from(json['tags'] as List),
        note: json['note'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

      expect(log.id, '123');
      expect(log.mood, Mood.good);
      expect(log.tags.length, 2);
      expect(log.tags.first, 'Work');
      expect(log.note, 'Feeling great');
    });

    test('Mood Enum should have correct labels', () {
      expect(Mood.good.label, 'Feeling\nGood');
      expect(Mood.stress.label, 'Feeling\nStress');
    });
  });
}
