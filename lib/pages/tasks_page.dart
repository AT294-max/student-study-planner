import 'package:flutter/material.dart';

import '../models/study_task.dart';
import '../models/subject.dart';
import '../theme/app_theme.dart';

/// Filter choices for the study tasks list
enum TaskFilter { all, pending, completed }

/// Dedicated Tasks screen managing all study action items and filters.
class TasksPage extends StatefulWidget {
  final List<StudyTask> tasks;
  final List<Subject> subjects;
  final void Function(int originalIndex) onToggleTask;
  final void Function(int originalIndex) onDeleteTask;
  final VoidCallback onAddTask;

  const TasksPage({
    super.key,
    required this.tasks,
    required this.subjects,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onAddTask,
  });

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  TaskFilter _currentFilter = TaskFilter.all;

  Subject _findSubject(String name) {
    return widget.subjects.firstWhere(
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
    final total = widget.tasks.length;
    final completed = widget.tasks.where((t) => t.isCompleted).length;
    final pending = total - completed;
    final progress = total == 0 ? 0.0 : completed / total;

    // Filter tasks while preserving their original index in the parent list
    final filteredIndexedTasks = <MapEntry<int, StudyTask>>[];
    for (int i = 0; i < widget.tasks.length; i++) {
      final task = widget.tasks[i];
      if (_currentFilter == TaskFilter.all) {
        filteredIndexedTasks.add(MapEntry(i, task));
      } else if (_currentFilter == TaskFilter.completed && task.isCompleted) {
        filteredIndexedTasks.add(MapEntry(i, task));
      } else if (_currentFilter == TaskFilter.pending && !task.isCompleted) {
        filteredIndexedTasks.add(MapEntry(i, task));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Tasks'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_rounded,
              color: AppTheme.secondaryAccent,
            ),
            tooltip: 'Add Task',
            onPressed: widget.onAddTask,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Progress Banner
            _buildProgressBanner(completed, total, progress),
            const SizedBox(height: 16),

            // 2. Filter chips
            _buildFilterTabs(total, pending, completed),
            const SizedBox(height: 16),

            // 3. Task items or empty state
            if (filteredIndexedTasks.isEmpty)
              _buildEmptyState()
            else
              _buildTasksList(filteredIndexedTasks),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAddTask,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task'),
      ),
    );
  }

  Widget _buildProgressBanner(int completed, int total, double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardNavy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSlate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Task Completion',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppTheme.cardNavyElevated,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 && total > 0
                    ? AppTheme.completedGreen
                    : AppTheme.primaryAccent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completed of $total tasks marked complete',
            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(int total, int pending, int completed) {
    return Row(
      children: [
        _buildFilterChip('All ($total)', TaskFilter.all),
        const SizedBox(width: 8),
        _buildFilterChip('Pending ($pending)', TaskFilter.pending),
        const SizedBox(width: 8),
        _buildFilterChip('Done ($completed)', TaskFilter.completed),
      ],
    );
  }

  Widget _buildFilterChip(String label, TaskFilter filter) {
    final isSelected = _currentFilter == filter;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.white : AppTheme.textMuted,
        ),
      ),
      selected: isSelected,
      selectedColor: AppTheme.primaryAccent,
      backgroundColor: AppTheme.cardNavy,
      side: BorderSide(
        color: isSelected ? AppTheme.primaryAccent : AppTheme.borderSlate,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (val) {
        if (val) {
          setState(() {
            _currentFilter = filter;
          });
        }
      },
    );
  }

  Widget _buildTasksList(List<MapEntry<int, StudyTask>> indexedTasks) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: indexedTasks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final entry = indexedTasks[i];
        final originalIndex = entry.key;
        final task = entry.value;
        final subject = _findSubject(task.subject);

        return Card(
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
              onChanged: (_) => widget.onToggleTask(originalIndex),
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
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: subject.color.withAlpha(35),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: subject.color.withAlpha(80),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(subject.icon, size: 12, color: subject.color),
                        const SizedBox(width: 4),
                        Text(
                          task.subject,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: subject.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              color: AppTheme.textMuted,
              tooltip: 'Delete task',
              onPressed: () => widget.onDeleteTask(originalIndex),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final message = _currentFilter == TaskFilter.completed
        ? 'No completed tasks yet. Finish a task to see it here!'
        : _currentFilter == TaskFilter.pending
        ? 'Great job! You have no pending study tasks.'
        : 'No study tasks found. Tap "+ Add Task" to begin.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
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
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
          if (_currentFilter == TaskFilter.all) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: widget.onAddTask,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add Task'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
