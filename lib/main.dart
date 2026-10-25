import 'package:flutter/material.dart';

import 'models/exam.dart';
import 'models/study_task.dart';
import 'models/subject.dart';
import 'pages/exams_page.dart';
import 'pages/home_page.dart';
import 'pages/more_page.dart';
import 'pages/subjects_page.dart';
import 'pages/tasks_page.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'widgets/add_exam_dialog.dart';
import 'widgets/add_subject_dialog.dart';
import 'widgets/add_task_dialog.dart';

// Re-export models and services for convenient imports across the project
export 'models/exam.dart';
export 'models/study_task.dart';
export 'models/subject.dart';
export 'services/storage_service.dart';

void main() {
  runApp(const StudyPlannerApp());
}

/// Root widget configuring the Material 3 dark indigo/navy theme.
class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Study Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationScreen(),
    );
  }
}

/// Central multi-page scaffold hosting the 5-destination bottom navigation bar
/// and managing shared state persisted with SharedPreferences.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;

  // Shared Subjects List (Persisted via StorageService)
  List<Subject> _subjects = [];

  // Shared Tasks List (Persisted via StorageService)
  List<StudyTask> _tasks = [];

  // Shared Exams List
  late final List<Exam> _exams = [
    Exam(
      title: 'Calculus Midterm Exam',
      subject: 'Mathematics',
      date: DateTime.now().add(const Duration(days: 5)),
      location: 'Hall B - Room 201',
    ),
    Exam(
      title: 'Data Structures Quiz',
      subject: 'Computer Science',
      date: DateTime.now().add(const Duration(days: 12)),
      location: 'Lab 3',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  /// Loads persisted subjects and tasks from local SharedPreferences.
  Future<void> _loadStoredData() async {
    final loadedSubjects = await StorageService.loadSubjects();
    final loadedTasks = await StorageService.loadTasks();

    if (mounted) {
      setState(() {
        _subjects = loadedSubjects;
        _tasks = loadedTasks;
        _isLoading = false;
      });
    }
  }

  // --- Task actions (Mutates state & persists to disk) ---

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    StorageService.saveTasks(_tasks);
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    StorageService.saveTasks(_tasks);
  }

  void _openAddTaskDialog() {
    showAddTaskDialog(
      context,
      subjects: _subjects,
      onTaskAdded: (task) {
        setState(() {
          _tasks.add(task);
        });
        StorageService.saveTasks(_tasks);
      },
    );
  }

  // --- Subject actions (Mutates state & persists to disk) ---

  void _openAddSubjectDialog() {
    showAddSubjectDialog(
      context,
      existingSubjects: _subjects,
      onSubjectAdded: (subject) {
        setState(() {
          _subjects.add(subject);
        });
        StorageService.saveSubjects(_subjects);
      },
    );
  }

  void _deleteSubject(int index) {
    setState(() {
      _subjects.removeAt(index);
    });
    StorageService.saveSubjects(_subjects);
  }

  // --- Exam actions ---

  void _openAddExamDialog() {
    showAddExamDialog(
      context,
      subjects: _subjects,
      onExamAdded: (exam) {
        setState(() {
          _exams.add(exam);
        });
      },
    );
  }

  void _deleteExam(int index) {
    setState(() {
      _exams.removeAt(index);
    });
  }

  // --- Tab Navigation ---

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToTasksTab() {
    setState(() {
      _selectedIndex = 2; // Tasks is at index 2
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryAccent),
        ),
      );
    }

    // List of page destinations
    final pages = <Widget>[
      // 0: Home
      HomePage(
        tasks: _tasks,
        subjects: _subjects,
        onToggleTask: _toggleTask,
        onDeleteTask: _deleteTask,
        onAddTask: _openAddTaskDialog,
        onNavigateToTasks: _navigateToTasksTab,
      ),

      // 1: Subjects
      SubjectsPage(
        subjects: _subjects,
        tasks: _tasks,
        onAddSubject: _openAddSubjectDialog,
        onDeleteSubject: _deleteSubject,
      ),

      // 2: Tasks
      TasksPage(
        tasks: _tasks,
        subjects: _subjects,
        onToggleTask: _toggleTask,
        onDeleteTask: _deleteTask,
        onAddTask: _openAddTaskDialog,
      ),

      // 3: Exams
      ExamsPage(
        exams: _exams,
        subjects: _subjects,
        onAddExam: _openAddExamDialog,
        onDeleteExam: _deleteExam,
      ),

      // 4: More
      const MorePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.borderSlate, width: 0.8),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'Subjects',
            ),
            NavigationDestination(
              icon: Icon(Icons.task_alt_outlined),
              selectedIcon: Icon(Icons.task_alt_rounded),
              label: 'Tasks',
            ),
            NavigationDestination(
              icon: Icon(Icons.event_note_outlined),
              selectedIcon: Icon(Icons.event_note_rounded),
              label: 'Exams',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz_outlined),
              selectedIcon: Icon(Icons.more_horiz_rounded),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
