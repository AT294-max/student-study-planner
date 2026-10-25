import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The More page providing links to upcoming tools, analytics, and settings.
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  void _showComingSoon(BuildContext context, String featureName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.cardNavyElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppTheme.borderSlate),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppTheme.secondaryAccent,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$featureName is coming in an upcoming update!',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More Options')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile card
            _buildProfileCard(),
            const SizedBox(height: 20),

            // Section 1: Academic Tools
            _buildSectionHeader('Academic Tools'),
            const SizedBox(height: 8),
            _buildMenuItem(
              context: context,
              icon: Icons.calculate_outlined,
              iconColor: AppTheme.primaryAccent,
              title: 'GPA Calculator',
              subtitle: 'Calculate and project semester GPAs and grade targets',
              featureName: 'GPA Calculator',
            ),
            const SizedBox(height: 8),
            _buildMenuItem(
              context: context,
              icon: Icons.insights_rounded,
              iconColor: AppTheme.secondaryAccent,
              title: 'Study Analytics',
              subtitle:
                  'Visual statistics on completed tasks and study sessions',
              featureName: 'Study Analytics',
            ),
            const SizedBox(height: 8),
            _buildMenuItem(
              context: context,
              icon: Icons.timer_outlined,
              iconColor: AppTheme.purpleAccent,
              title: 'Pomodoro Focus Timer',
              subtitle:
                  'Focus intervals and break timers for productive sessions',
              featureName: 'Focus Timer',
            ),
            const SizedBox(height: 20),

            // Section 2: Preferences
            _buildSectionHeader('Preferences & App'),
            const SizedBox(height: 8),
            _buildMenuItem(
              context: context,
              icon: Icons.tune_rounded,
              iconColor: AppTheme.completedGreen,
              title: 'Settings',
              subtitle: 'Theme customization, reminders, and defaults',
              featureName: 'Settings',
            ),
            const SizedBox(height: 20),

            // Section 3: App info
            _buildAppInfoCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardNavy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSlate),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppTheme.primaryAccent.withAlpha(40),
            child: const Icon(
              Icons.person_rounded,
              color: AppTheme.secondaryAccent,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student Study Space',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Offline-first • Privacy focused',
                  style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppTheme.textMuted,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String featureName,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showComingSoon(context, featureName),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.cardNavyElevated,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.borderSlate),
                ),
                child: const Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondaryAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardNavy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSlate),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.terminal_rounded,
                size: 16,
                color: AppTheme.secondaryAccent,
              ),
              SizedBox(width: 6),
              Text(
                'Student Study Planner • v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'Built with Flutter & Dart for fast, distraction-free study management.',
            style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}
