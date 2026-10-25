import 'package:flutter/material.dart';

import '../models/study_task.dart';
import '../models/subject.dart';
import '../theme/app_theme.dart';

/// Shows a dialog to create a new study task.
Future<void> showAddTaskDialog(
  BuildContext context, {
  required List<Subject> subjects,
  required void Function(StudyTask) onTaskAdded,
}) async {
  final newTask = await showDialog<StudyTask>(
    context: context,
    builder: (context) {
      return AddTaskDialog(subjects: subjects);
    },
  );

  if (newTask != null) {
    onTaskAdded(newTask);
  }
}

class AddTaskDialog extends StatefulWidget {
  final List<Subject> subjects;

  const AddTaskDialog({super.key, required this.subjects});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late String _selectedSubject;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _selectedSubject = widget.subjects.isNotEmpty
        ? widget.subjects.first.name
        : 'General';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final trimmed = _titleController.text.trim();
    final task = StudyTask(title: trimmed, subject: _selectedSubject);
    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.cardNavy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.borderSlate),
      ),
      title: const Text(
        'Add Study Task',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'e.g. Solve problem set 3, read ch. 4',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Subject',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedSubject,
                dropdownColor: AppTheme.cardNavy,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                items: widget.subjects.map((subject) {
                  return DropdownMenuItem<String>(
                    value: subject.name,
                    child: Row(
                      children: [
                        Icon(subject.icon, size: 18, color: subject.color),
                        const SizedBox(width: 10),
                        Text(
                          subject.name,
                          style: const TextStyle(color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSubject = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppTheme.textMuted),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primaryAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _submit,
          child: const Text('Add Task'),
        ),
      ],
    );
  }
}
