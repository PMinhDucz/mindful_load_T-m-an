import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/activity_model.dart';

class ActivityController extends ChangeNotifier {
  List<ActivityLog> _logs = [];
  List<ActivityLog> get logs => _logs;

  List<String> _insights = [];
  List<String> get insights => _insights;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _authToken;
  String? _userId;

  // Initial Default Tags
  Map<String, List<String>> _tagCategories = {
    'Where?': ['Home', 'Company', 'Road', 'Coffee'],
    'What?': ['Meeting', 'Code', 'Facebook', 'Eating', 'Deadline'],
    'With whom?': ['Family', 'Alone', 'Boss', 'Colleague', 'Wife'],
  };
  Map<String, List<String>> get tagCategories => _tagCategories;

  void update(String? token, String? userId) {
    _authToken = token;
    _userId = userId;
    // Reload data when user changes
    if (_authToken != null) {
      loadData();
      loadTags(); // Load custom tags
    } else {
      _logs = [];
      notifyListeners();
    }
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_userId != null) 'x-user-id': _userId!,
      };

  String get baseUrl {
    if (Platform.isAndroid) return 'http://10.0.2.2:3000/api';
    return 'http://localhost:3000/api';
  }

  ActivityController(); // No loadData in constructor anymore.

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('$baseUrl/logs'), headers: _headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _logs = data.map((json) {
          return ActivityLog(
            id: json['id'].toString(),
            mood: _parseMood(json['mood']),
            tags: (json['tags'] is String)
                ? List<String>.from(jsonDecode(json['tags']))
                : List<String>.from(json['tags'] ?? []),
            note: json['note'],
            timestamp: DateTime.parse(json['timestamp']).toLocal(),
          );
        }).toList();

        // ONLINE: Save to Cache & Sync Pending
        await _saveToCache(_logs);
        await _syncPendingLogs();
        await fetchInsights();
      }
    } catch (e) {
      print("Offline Mode: Loading from Cache ($e)");
      // OFFLINE: Load Cache + Pending
      _logs = await _loadFromCache();
      final pending = await _loadPendingLogs();
      // Insert pending at top
      _logs.insertAll(0, pending);
      _insights = ["You are offline. Showing cached data."];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLog(Mood mood, List<String> tags, String? note) async {
    // Create optimistic log
    final newLog = ActivityLog(
      id: const Uuid().v4(), // Temporary ID
      mood: mood,
      tags: tags,
      note: note,
      timestamp: DateTime.now(),
    );

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logs'),
        headers: _headers,
        body: jsonEncode({
          'mood': mood.name,
          'tags': tags,
          'note': note,
          'timestamp': newLog.timestamp.toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        await loadData(); // Success: Reload from server
      } else {
        throw Exception("Server Error");
      }
    } catch (e) {
      print("Offline Mode: Saving locally ($e)");
      // OFFLINE: Add to UI & Save Pending
      _logs.insert(0, newLog);
      notifyListeners();
      await _savePendingLog(newLog);
    }
  }

  Future<void> deleteLog(String id) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/logs/$id'), headers: _headers);
      if (response.statusCode == 200) {
        _logs.removeWhere((log) => log.id == id);
        notifyListeners();
        fetchInsights();
      }
    } catch (e) {
      print("Error deleting log: $e");
    }
  }

  Future<void> clearAllLogs() async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/cleanup'), headers: _headers);
      if (response.statusCode == 200) {
        _logs = [];
        _insights = [];
        notifyListeners();
      }
    } catch (e) {
      print("Error clearing logs: $e");
    }
  }

  Future<void> fetchInsights() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/analyze'), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _insights = List<String>.from(data['insights']);
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching insights: $e");
      _insights = ["Could not connect to AI Server."];
      notifyListeners();
    }
  }

  // --- TAG MANAGEMENT (NFR3) ---

  Future<void> loadTags() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('custom_tags_$_userId');
    if (data != null) {
      final Map<String, dynamic> decoded = jsonDecode(data);
      // Merge with default tags (avoid duplicates)
      decoded.forEach((category, tags) {
        if (_tagCategories.containsKey(category)) {
          final List<dynamic> list = tags;
          for (var tag in list) {
            if (!_tagCategories[category]!.contains(tag)) {
              _tagCategories[category]!.add(tag.toString());
            }
          }
        }
      });
      notifyListeners();
    }
  }

  Future<void> addCustomTag(String category, String newTag) async {
    if (_tagCategories.containsKey(category)) {
      if (!_tagCategories[category]!.contains(newTag)) {
        _tagCategories[category]!.add(newTag);
        notifyListeners();
        await _saveTags();
      }
    }
  }

  Future<void> _saveTags() async {
    final prefs = await SharedPreferences.getInstance();
    // We only need to save the "Custom" ones really, but saving the whole map is easier for now
    // Ideally we separate "System Tags" vs "User Tags" to avoid growing defaults,
    // but for this MVP scope, full save is fine.
    await prefs.setString('custom_tags_$_userId', jsonEncode(_tagCategories));
  }

  // --- OFFLINE HELPER METHODS ---

  Future<void> _saveToCache(List<ActivityLog> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(logs
        .map((e) => {
              'id': e.id,
              'mood': e.mood.name,
              'tags': e.tags,
              'note': e.note,
              'timestamp': e.timestamp.toIso8601String(),
            })
        .toList());
    await prefs.setString('cached_logs_$_userId', data);
  }

  Future<List<ActivityLog>> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('cached_logs_$_userId');
    if (data == null) return [];

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList
        .map((json) => ActivityLog(
              id: json['id'],
              mood: _parseMood(json['mood']),
              tags: List<String>.from(json['tags']),
              note: json['note'],
              timestamp: DateTime.parse(json['timestamp']),
            ))
        .toList();
  }

  Future<void> _savePendingLog(ActivityLog log) async {
    final prefs = await SharedPreferences.getInstance();
    final String key = 'pending_logs_$_userId';
    List<String> pending = prefs.getStringList(key) ?? [];

    // Serialize
    final String jsonLog = jsonEncode({
      'id': log.id,
      'mood': log.mood.name,
      'tags': log.tags,
      'note': log.note,
      'timestamp': log.timestamp.toIso8601String(),
    });

    pending.add(jsonLog);
    await prefs.setStringList(key, pending);
  }

  Future<List<ActivityLog>> _loadPendingLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> pending =
        prefs.getStringList('pending_logs_$_userId') ?? [];

    return pending.map((str) {
      final json = jsonDecode(str);
      return ActivityLog(
        id: json['id'],
        mood: _parseMood(json['mood']),
        tags: List<String>.from(json['tags']),
        note: json['note'],
        timestamp: DateTime.parse(json['timestamp']),
      );
    }).toList();
  }

  Future<void> _syncPendingLogs() async {
    final pending = await _loadPendingLogs();
    if (pending.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final List<String> remaining = []; // Keep logs that fail to sync

    for (var log in pending) {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/logs'),
          headers: _headers,
          body: jsonEncode({
            'mood': log.mood.name,
            'tags': log.tags,
            'note': log.note,
            'timestamp': log.timestamp.toIso8601String(),
          }),
        );
        if (response.statusCode != 201) {
          throw Exception("Failed to sync");
        }
      } catch (e) {
        // Keep in pending if failed
        remaining.add(jsonEncode({
          'id': log.id,
          'mood': log.mood.name,
          'tags': log.tags,
          'note': log.note,
          'timestamp': log.timestamp.toIso8601String(),
        }));
      }
    }

    if (remaining.isEmpty) {
      await prefs.remove('pending_logs_$_userId');
      loadData(); // Reload from server to get correct IDs/Time
    } else {
      await prefs.setStringList('pending_logs_$_userId', remaining);
    }
  }

  Mood _parseMood(String moodStr) {
    return Mood.values.firstWhere(
      (e) => e.name == moodStr,
      orElse: () => Mood.neutral,
    );
  }
}
