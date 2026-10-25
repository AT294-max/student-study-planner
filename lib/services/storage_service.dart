import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/study_task.dart';
import '../models/subject.dart';

/// Lightweight persistence service leveraging SharedPreferences to safely
/// serialize and persist subjects and study tasks across app restarts.
class StorageService {
  static const String _subjectsKey = 'study_planner_subjects';
  static const String _tasksKey = 'study_planner_tasks';

  /// Loads the persisted subjects list.
  /// Safely returns an empty list `[]` on fresh installations or if data is corrupt.
  static Future<List<Subject>> loadSubjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_subjectsKey);
      if (jsonString == null || jsonString.trim().isEmpty) {
        return [];
      }
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) {
        return [];
      }
      return decoded.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return Subject.fromJson(map);
      }).toList();
    } catch (_) {
      // In case of parsing failure or missing data, fail safely to an empty list
      return [];
    }
  }

  /// Persists the subjects list to SharedPreferences.
  static Future<void> saveSubjects(List<Subject> subjects) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listMaps = subjects.map((s) => s.toJson()).toList();
      final jsonString = jsonEncode(listMaps);
      await prefs.setString(_subjectsKey, jsonString);
    } catch (_) {}
  }

  /// Loads the persisted tasks list.
  /// Safely returns an empty list `[]` on fresh installations or if data is corrupt.
  static Future<List<StudyTask>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_tasksKey);
      if (jsonString == null || jsonString.trim().isEmpty) {
        return [];
      }
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) {
        return [];
      }
      return decoded.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return StudyTask.fromJson(map);
      }).toList();
    } catch (_) {
      // In case of parsing failure or missing data, fail safely to an empty list
      return [];
    }
  }

  /// Persists the tasks list to SharedPreferences.
  static Future<void> saveTasks(List<StudyTask> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listMaps = tasks.map((t) => t.toJson()).toList();
      final jsonString = jsonEncode(listMaps);
      await prefs.setString(_tasksKey, jsonString);
    } catch (_) {}
  }

  /// Clears stored study planner data (useful for resets or testing).
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_subjectsKey);
      await prefs.remove(_tasksKey);
    } catch (_) {}
  }
}
