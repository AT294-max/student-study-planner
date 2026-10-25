import 'package:flutter/material.dart';

import '../models/exam.dart';
import '../models/subject.dart';
import '../theme/app_theme.dart';

/// Shows a dialog to add an upcoming exam.
Future<void> showAddExamDialog(
  BuildContext context, {
  required List<Subject> subjects,
  required void Function(Exam) onExamAdded,
}) async {
  final newExam = await showDialog<Exam>(
    context: context,
    builder: (context) {
      return AddExamDialog(subjects: subjects);
    },
  );

  if (newExam != null) {
    onExamAdded(newExam);
  }
}

class AddExamDialog extends StatefulWidget {
  final List<Subject> subjects;

  const AddExamDialog({super.key, required this.subjects});

  @override
  State<AddExamDialog> createState() => _AddExamDialogState();
}

class _AddExamDialogState extends State<AddExamDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late DateTime _selectedDate;
  late String _selectedSubject;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _locationController = TextEditingController(text: 'Room 101');
    _selectedDate = DateTime.now().add(const Duration(days: 7));
    _selectedSubject = widget.subjects.isNotEmpty
        ? widget.subjects.first.name
        : 'General';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final title = _titleController.text.trim();
    final location = _locationController.text.trim().isEmpty
        ? 'Main Hall'
        : _locationController.text.trim();

    final exam = Exam(
      title: title,
      subject: _selectedSubject,
      date: _selectedDate,
      location: location,
    );
    Navigator.of(context).pop(exam);
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
        'Add Upcoming Exam',
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
                  labelText: 'Exam Title',
                  hintText: 'e.g. Midterm Examination',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an exam title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Location / Room',
                  hintText: 'e.g. Science Block Room 204',
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Exam Date',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
                subtitle: Text(
                  '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_rounded,
                    color: AppTheme.primaryAccent,
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (context, child) {
                        return Theme(data: AppTheme.darkTheme, child: child!);
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
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
          child: const Text('Add Exam'),
        ),
      ],
    );
  }
}
