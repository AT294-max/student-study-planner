import 'package:flutter/material.dart';

import '../models/subject.dart';
import '../theme/app_theme.dart';

/// Opens the modal dialog to create a new subject.
/// Returns the created [Subject] upon confirmation, or null if cancelled.
Future<void> showAddSubjectDialog(
  BuildContext context, {
  required List<Subject> existingSubjects,
  required void Function(Subject) onSubjectAdded,
}) async {
  final newSubject = await showDialog<Subject>(
    context: context,
    builder: (dialogContext) {
      return AddSubjectDialog(existingSubjects: existingSubjects);
    },
  );

  if (newSubject != null) {
    onSubjectAdded(newSubject);
  }
}

/// A self-contained, stateful dialog for adding an academic subject.
/// Manages controller lifecycles cleanly within [State.dispose] to prevent
/// controller reuse or early disposal during dialog pop transitions.
class AddSubjectDialog extends StatefulWidget {
  final List<Subject> existingSubjects;

  const AddSubjectDialog({super.key, required this.existingSubjects});

  @override
  State<AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<AddSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;

  static const List<Color> _availableColors = [
    Colors.indigo,
    Colors.blue,
    Colors.teal,
    Colors.deepPurple,
    Colors.amber,
    Colors.pink,
    Color(0xFF10B981),
  ];

  static const List<IconData> _availableIcons = [
    Icons.menu_book_rounded,
    Icons.calculate_rounded,
    Icons.computer_rounded,
    Icons.science_rounded,
    Icons.biotech_rounded,
    Icons.history_edu_rounded,
    Icons.psychology_rounded,
    Icons.brush_rounded,
  ];

  late Color _selectedColor;
  late IconData _selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _codeController = TextEditingController();
    _selectedColor = _availableColors.first;
    _selectedIcon = _availableIcons.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final trimmedName = _nameController.text.trim();
    final trimmedCode = _codeController.text.trim();

    final newSubject = Subject(
      name: trimmedName,
      code: trimmedCode,
      icon: _selectedIcon,
      color: _selectedColor,
    );

    Navigator.of(context).pop(newSubject);
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
        'Add New Subject',
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
              // Subject Name
              TextFormField(
                controller: _nameController,
                autofocus: true,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Subject Name',
                  hintText: 'e.g. Artificial Intelligence, Biology',
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Please enter a subject name';
                  }
                  final duplicate = widget.existingSubjects.any(
                    (s) => s.name.trim().toLowerCase() == text.toLowerCase(),
                  );
                  if (duplicate) {
                    return 'A subject with this name already exists';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Subject Code
              TextFormField(
                controller: _codeController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Subject Code (Optional)',
                  hintText: 'e.g. CS301, MATH101',
                ),
              ),
              const SizedBox(height: 16),

              // Color Selection
              const Text(
                'Choose Color',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableColors.map((color) {
                  final isSelected = color == _selectedColor;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: color,
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Icon Selection
              const Text(
                'Choose Icon',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableIcons.map((icon) {
                  final isSelected = icon == _selectedIcon;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIcon = icon;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryAccent.withAlpha(80)
                            : AppTheme.cardNavyElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryAccent
                              : AppTheme.borderSlate,
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: isSelected ? Colors.white : AppTheme.textMuted,
                      ),
                    ),
                  );
                }).toList(),
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
          child: const Text('Add Subject'),
        ),
      ],
    );
  }
}
