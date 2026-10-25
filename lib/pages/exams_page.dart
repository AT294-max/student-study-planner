import 'package:flutter/material.dart';

import '../models/exam.dart';
import '../models/subject.dart';
import '../theme/app_theme.dart';

/// Dedicated Exams page displaying upcoming quizzes, midterms, and finals.
class ExamsPage extends StatelessWidget {
  final List<Exam> exams;
  final List<Subject> subjects;
  final VoidCallback onAddExam;
  final void Function(int index) onDeleteExam;

  const ExamsPage({
    super.key,
    required this.exams,
    required this.subjects,
    required this.onAddExam,
    required this.onDeleteExam,
  });

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

  String _getMonthAbbreviation(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[(month - 1) % 12];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exams & Quizzes'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_rounded,
              color: AppTheme.secondaryAccent,
            ),
            tooltip: 'Add Exam',
            onPressed: onAddExam,
          ),
        ],
      ),
      body: exams.isEmpty
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
                    'Upcoming Schedule',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildExamsList(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAddExam,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Exam'),
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
              color: AppTheme.purpleAccent.withAlpha(40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_note_rounded,
              color: AppTheme.purpleAccent,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${exams.length} Upcoming ${exams.length == 1 ? 'Exam' : 'Exams'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Prepare ahead and plan revision milestones for test days.',
                  style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exams.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final exam = exams[index];
        final subject = _findSubject(exam.subject);
        final monthStr = _getMonthAbbreviation(exam.date.month);
        final dayStr = exam.date.day.toString();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Date box
                Container(
                  width: 52,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryAccent.withAlpha(35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryAccent.withAlpha(80),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        monthStr,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryAccent,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dayStr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Exam details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: subject.color.withAlpha(35),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  subject.icon,
                                  size: 11,
                                  color: subject.color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  exam.subject,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: subject.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.place_outlined,
                            size: 13,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              exam.location,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  color: AppTheme.textMuted,
                  tooltip: 'Delete exam',
                  onPressed: () => onDeleteExam(index),
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
                Icons.calendar_month_rounded,
                size: 48,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No upcoming exams scheduled',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add exam deadlines and quiz dates to stay prepared ahead of time.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAddExam,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Upcoming Exam'),
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
