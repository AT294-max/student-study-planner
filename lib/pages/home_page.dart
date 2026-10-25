import 'package:flutter/material.dart';

import '../models/study_task.dart';
import '../models/subject.dart';
import '../theme/app_theme.dart';

/// The Home dashboard displaying daily overview, stats, and task preview.
class HomePage extends StatelessWidget {
  final List<StudyTask> tasks;
  final List<Subject> subjects;
  final void Function(int index) onToggleTask;
  final void Function(int index) onDeleteTask;
  final VoidCallback onAddTask;
  final VoidCallback onNavigateToTasks;

  const HomePage({
    super.key,
    required this.tasks,
    required this.subjects,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onAddTask,
    required this.onNavigateToTasks,
  });

  int get _completedCount => tasks.where((t) => t.isCompleted).length;
  int get _pendingCount => tasks.length - _completedCount;
  double get _progress => tasks.isEmpty ? 0.0 : _completedCount / tasks.length;

  Subject _findSubject(String name) {
    return subjects.firstWhere(
      (s) => s.name == name,
      orElse: () => Subject(
        name: name,
        icon: Icons.bookmark_border_rounded,
        color: AppTheme.primaryAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final percentInt = (_progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.school_rounded, color: AppTheme.primaryAccent, size: 24),
            SizedBox(width: 8),
            Text('Study Planner'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_task_rounded,
              color: AppTheme.secondaryAccent,
            ),
            tooltip: 'Quick Add Task',
            onPressed: onAddTask,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Welcome Greeting
            _buildWelcomeHeader(),
            const SizedBox(height: 16),

            // 2. Today's Progress Card
            _buildProgressCard(percentInt),
            const SizedBox(height: 16),

            // 3. Task Stats (Total, Completed, Pending)
            _buildStatsRow(),
            const SizedBox(height: 24),

            // 4. Tasks Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Study Tasks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: onNavigateToTasks,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const Text('View All'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.secondaryAccent,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 5. Preview of tasks
            _buildTasksPreview(),
            const SizedBox(height: 24),

            // 6. Quick Action banner
            _buildQuickActionCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome back, Student! 👋',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Here is your study summary and focus plan for today.',
          style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
        ),
      ],
    );
  }

  Widget _buildProgressCard(int percent) {
    return Card(
      color: AppTheme.cardNavy,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryAccent.withAlpha(40),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.insights_rounded,
                        color: AppTheme.primaryAccent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Today\'s Study Progress',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 8,
                backgroundColor: AppTheme.cardNavyElevated,
                valueColor: AlwaysStoppedAnimation<Color>(
                  percent == 100
                      ? AppTheme.completedGreen
                      : AppTheme.primaryAccent,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_completedCount of ${tasks.length} tasks completed',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
                Text(
                  percent == 100 ? 'All done! 🎉' : '$_pendingCount remaining',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: percent == 100
                        ? AppTheme.completedGreen
                        : AppTheme.secondaryAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            label: 'Total Tasks',
            value: '${tasks.length}',
            icon: Icons.assignment_outlined,
            iconColor: AppTheme.secondaryAccent,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatItem(
            label: 'Completed',
            value: '$_completedCount',
            icon: Icons.check_circle_outline_rounded,
            iconColor: AppTheme.completedGreen,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatItem(
            label: 'Pending',
            value: '$_pendingCount',
            icon: Icons.pending_actions_rounded,
            iconColor: AppTheme.pendingAmber,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardNavy,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderSlate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Icon(icon, size: 18, color: iconColor),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksPreview() {
    if (tasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.cardNavy,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderSlate),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.checklist_rounded,
              size: 40,
              color: AppTheme.textMuted,
            ),
            const SizedBox(height: 8),
            const Text(
              'No study tasks scheduled yet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Create a task to kickstart your daily study plan.',
              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onAddTask,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Task'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Show up to first 3 tasks as preview
    final previewCount = tasks.length > 3 ? 3 : tasks.length;

    return Column(
      children: List.generate(previewCount, (index) {
        final task = tasks[index];
        final subject = _findSubject(task.subject);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 2,
            ),
            leading: Checkbox(
              value: task.isCompleted,
              activeColor: AppTheme.completedGreen,
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: const BorderSide(color: AppTheme.textMuted, width: 1.5),
              onChanged: (_) => onToggleTask(index),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: task.isCompleted
                    ? AppTheme.textMuted
                    : AppTheme.textPrimary,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(subject.icon, size: 13, color: subject.color),
                const SizedBox(width: 4),
                Text(
                  task.subject,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: task.isCompleted
                        ? AppTheme.textMuted
                        : subject.color,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              color: AppTheme.textMuted,
              tooltip: 'Delete task',
              onPressed: () => onDeleteTask(index),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildQuickActionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryAccent.withAlpha(40), AppTheme.cardNavy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryAccent.withAlpha(80)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryAccent.withAlpha(60),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppTheme.secondaryAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Action',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Add a study session or assignment target.',
                  style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: onAddTask,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryAccent,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Add Task', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
