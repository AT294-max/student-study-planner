/// Represents a single study task with title, subject, and completion status.
class StudyTask {
  String title;
  String subject;
  bool isCompleted;
  DateTime? dueDate;

  StudyTask({
    required this.title,
    required this.subject,
    this.isCompleted = false,
    this.dueDate,
  });

  /// Serializes the StudyTask into a JSON-compatible Map.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subject': subject,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  /// Deserializes a StudyTask from a JSON Map with safe defaults.
  factory StudyTask.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['dueDate'] != null) {
      parsedDate = DateTime.tryParse(json['dueDate'].toString());
    }

    return StudyTask(
      title: json['title'] as String? ?? '',
      subject: json['subject'] as String? ?? 'General',
      isCompleted: json['isCompleted'] as bool? ?? false,
      dueDate: parsedDate,
    );
  }
}
