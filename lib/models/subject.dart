import 'package:flutter/material.dart';

/// Represents an academic course/subject in the study planner.
class Subject {
  final String name;
  final String code;
  final IconData icon;
  final Color color;

  const Subject({
    required this.name,
    required this.icon,
    required this.color,
    this.code = '',
  });

  /// Serializes the Subject into a JSON-compatible Map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'iconCodePoint': icon.codePoint,
      'colorValue': color.toARGB32(),
    };
  }

  /// Deserializes a Subject from a JSON Map with safe defaults.
  factory Subject.fromJson(Map<String, dynamic> json) {
    final iconCodePoint = json['iconCodePoint'] as int?;
    final colorValue = json['colorValue'] as int?;

    return Subject(
      name: json['name'] as String? ?? 'Untitled',
      code: json['code'] as String? ?? '',
      icon: _resolveIcon(iconCodePoint),
      color: colorValue != null ? Color(colorValue) : Colors.indigo,
    );
  }

  /// Maps stored codePoints back to compile-time constant Material Icons
  /// to satisfy Flutter's font tree-shaking requirements.
  static IconData _resolveIcon(int? codePoint) {
    if (codePoint == null) {
      return Icons.menu_book_rounded;
    }

    const availableIcons = <IconData>[
      Icons.menu_book_rounded,
      Icons.calculate_rounded,
      Icons.computer_rounded,
      Icons.science_rounded,
      Icons.biotech_rounded,
      Icons.history_edu_rounded,
      Icons.psychology_rounded,
      Icons.brush_rounded,
      Icons.bookmark_border_rounded,
    ];

    for (final icon in availableIcons) {
      if (icon.codePoint == codePoint) {
        return icon;
      }
    }
    return Icons.menu_book_rounded;
  }
}
