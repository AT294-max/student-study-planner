import 'package:flutter/material.dart';

import '../models/study_task.dart';
import '../models/subject.dart';
import '../theme/app_theme.dart';

/// Dedicated Subjects screen showing all academic courses and task loads.
class SubjectsPage extends StatelessWidget {
  final List<Subject> subjects;
  final List<StudyTask> tasks;
  final VoidCallback onAddSubject;
  final void Function(int index)? onDeleteSubject;

  const SubjectsPage({
    super.key,
    required this.subjects,
    required this.tasks,
    required this.onAddSubject,
    this.onDeleteSubject,
  });

  int _getSubjectTotalTasks(String subjectName) {
    return tasks.where((t) => t.subject == subjectName).length;
  }

  int _getSubjectCompletedTasks(String subjectName) {
    return tasks.where((t) => t.subject == subjectName && t.isCompleted).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_rounded,
              color: AppTheme.secondaryAccent,
            ),
            tooltip: 'Add Subject',
            onPressed: onAddSubject,
          ),
        ],
      ),
      body: subjects.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderBanner(),
                  const SizedBox(height: 16),
                  const Text(
                    'Your Enrolled Courses',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSubjectsList(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAddSubject,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Subject'),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardNavy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSlate),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryAccent.withAlpha(40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: AppTheme.secondaryAccent,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${subjects.length} Enrolled ${subjects.length == 1 ? 'Subject' : 'Subjects'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Track task distribution and study progress per course.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final subject = subjects[index];
        final totalTasks = _getSubjectTotalTasks(subject.name);
        final completedTasks = _getSubjectCompletedTasks(subject.name);
        final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: subject.color.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: subject.color.withAlpha(100)),
                      ),
                      child: Icon(subject.icon, color: subject.color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          if (subject.code.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              subject.code,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: subject.color,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.cardNavyElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.borderSlate),
                      ),
                      child: Text(
                        '$totalTasks ${totalTasks == 1 ? 'task' : 'tasks'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (onDeleteSubject != null) ...[
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                        ),
                        color: AppTheme.textMuted,
                        tooltip: 'Delete subject',
                        onPressed: () => onDeleteSubject!(index),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppTheme.cardNavyElevated,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 && totalTasks > 0
                          ? AppTheme.completedGreen
                          : subject.color,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$completedTasks of $totalTasks completed',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}% done',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardNavyElevated,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.borderSlate),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 48,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No subjects enrolled',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add your subjects to organize study sessions, tasks, and exam schedules.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAddSubject,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Your First Subject'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
