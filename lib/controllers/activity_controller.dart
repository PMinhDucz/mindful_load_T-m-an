import 'package:flutter/material.dart';
import '../models/activity_model.dart';

class ActivityController extends ChangeNotifier {
  List<ActivityLog> _logs = [];

  List<ActivityLog> get logs => _logs;

  // Mock data for initial testing
  ActivityController() {
    _loadMockData();
  }

  void _loadMockData() {
    _logs = [
      ActivityLog(
        mood: Mood.good,
        tags: ['Home', 'Dinner'],
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ActivityLog(
        mood: Mood.veryBad,
        tags: ['Work', 'Deadline'],
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      ),
      ActivityLog(
        mood: Mood.neutral,
        tags: ['School', 'Reading'],
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
    notifyListeners();
  }

  void addLog(Mood mood, List<String> tags, String? note) {
    final newLog = ActivityLog(mood: mood, tags: tags, note: note);
    _logs.insert(0, newLog); // Add to top of list
    notifyListeners();
    // TODO: Save to SharedPrefs
  }

  void deleteLog(String id) {
    _logs.removeWhere((log) => log.id == id);
    notifyListeners();
  }
}
