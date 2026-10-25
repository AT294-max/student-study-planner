import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:student_study_planner/main.dart';
import 'package:student_study_planner/pages/subjects_page.dart';

void main() {
  setUp(() {
    // Reset SharedPreferences before each test
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Fresh install starts with empty lists and navigates cleanly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const StudyPlannerApp());
    await tester.pumpAndSettle();

    // Home Screen with empty state
    expect(find.text('Study Planner'), findsOneWidget);
    expect(find.text('Welcome back, Student! 👋'), findsOneWidget);
    expect(find.text('No study tasks scheduled yet'), findsOneWidget);

    // Verify bottom navigation
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Subjects'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);

    // Navigate to Subjects -> shows clean empty state
    await tester.tap(find.text('Subjects'));
    await tester.pumpAndSettle();
    expect(find.text('No subjects enrolled'), findsOneWidget);
  });

  testWidgets(
    'Adding a subject persists it and displays immediately in the list',
    (WidgetTester tester) async {
      await tester.pumpWidget(const StudyPlannerApp());
      await tester.pumpAndSettle();

      // Navigate to Subjects
      await tester.tap(find.text('Subjects'));
      await tester.pumpAndSettle();

      // Open Add Subject
      final addSubjectBtn = find.widgetWithText(
        FloatingActionButton,
        'Add Subject',
      );
      await tester.tap(addSubjectBtn);
      await tester.pumpAndSettle();

      // Enter Subject name and code
      final nameField = find.byType(TextFormField).first;
      await tester.enterText(nameField, 'Mathematics');
      final codeField = find.byType(TextFormField).at(1);
      await tester.enterText(codeField, 'MATH101');

      // Submit
      final submitBtn = find.widgetWithText(FilledButton, 'Add Subject');
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Verify in UI
      expect(find.text('Mathematics'), findsOneWidget);
      expect(find.text('MATH101'), findsOneWidget);

      // Verify persisted in SharedPreferences storage
      final loadedSubjects = await StorageService.loadSubjects();
      expect(loadedSubjects.length, 1);
      expect(loadedSubjects.first.name, 'Mathematics');
      expect(loadedSubjects.first.code, 'MATH101');
    },
  );

  testWidgets(
    'Tasks persist across app restart and maintain completion status',
    (WidgetTester tester) async {
      // 1. Seed storage with 1 subject and 1 task
      final sampleSubject = const Subject(
        name: 'Physics',
        code: 'PHYS101',
        icon: Icons.science_rounded,
        color: Colors.teal,
      );
      final sampleTask = StudyTask(
        title: 'Complete Lab Report',
        subject: 'Physics',
        isCompleted: false,
      );

      await StorageService.saveSubjects([sampleSubject]);
      await StorageService.saveTasks([sampleTask]);

      // 2. Launch the app
      await tester.pumpWidget(const StudyPlannerApp());
      await tester.pumpAndSettle();

      // Verify task loaded on Home
      expect(find.text('Complete Lab Report'), findsOneWidget);
      expect(find.text('0 of 1 tasks completed'), findsOneWidget);

      // 3. Toggle task completion
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Verify progress updated on Home
      expect(find.text('1 of 1 tasks completed'), findsOneWidget);

      // 4. Verify completion was saved to SharedPreferences
      final savedTasks = await StorageService.loadTasks();
      expect(savedTasks.first.isCompleted, true);

      // 5. Navigate to Tasks tab and verify consistency
      await tester.tap(find.text('Tasks'));
      await tester.pumpAndSettle();
      expect(find.text('Overall Task Completion'), findsOneWidget);
      expect(find.text('1 of 1 tasks marked complete'), findsOneWidget);
    },
  );

  testWidgets('SubjectsPage standalone empty state widget test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SubjectsPage(
          subjects: const [],
          tasks: const [],
          onAddSubject: () {},
        ),
      ),
    );

    expect(find.text('No subjects enrolled'), findsOneWidget);
    expect(find.text('Add Your First Subject'), findsOneWidget);
  });
}
