import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tasksmanager/models/TaskModel.dart';
import 'package:tasksmanager/provider/taskProvider.dart';
import 'package:tasksmanager/screens/create_task.dart';
import 'package:tasksmanager/screens/home.dart';
import 'package:tasksmanager/main.dart';
import 'package:tasksmanager/widgets/TaskTile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MyApp Widget Tests', () {
    testWidgets('starts with no tasks listed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TaskProvider()),
          ],
          child: MyApp(),
        ),
      );
      expect(find.byType(Home), findsNothing);
      expect(find.text('There are no tasks currently. Please add a task.'),
          findsOneWidget);
    });

    testWidgets('has a button that navigates to the create task widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TaskProvider()),
          ],
          child: MyApp(),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(CreateTask), findsOneWidget);
    });

    testWidgets('shows a separate widget for each task',
        (WidgetTester tester) async {
      TaskProvider tasksProvider = TaskProvider();
      tasksProvider.addTask(TaskModel(
          id: 0,
          title: 'Task 1',
          description: 'Description for task 1',
          status: "Open"));
      tasksProvider.addTask(TaskModel(
          id: 1,
          title: 'Task 2',
          description: 'Description for task 2',
          status: "Open"));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => tasksProvider),
          ],
          child: MyApp(),
        ),
      );
      expect(find.byType(Home), findsOneWidget);
      expect(find.byType(TaskTile), findsNWidgets(2));
    });

    test('Task name is displayed correctly in ListTasksWidget', () {
      final taskProvider = TaskProvider();
      taskProvider.addTask(TaskModel(
          id: 1, title: "Test Task", description: "dessssds", status: 'Open'));

      // Create a MaterialApp widget that uses taskProvider
      final app = MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => taskProvider),
          ],
          child: Home(),
        ),
      );

      // Build a ListTasksWidget widget and extract its text
      final textFinder = find.byType(Home);
      final widget = textFinder.evaluate().first.widget;
      final text = widget.toStringDeep();

      expect(text, contains('Test Task'));
    });

    testWidgets('Navigation to CreateTask widget when button is clicked',
        (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TaskProvider()),
        ],
        child: MyApp(),
      ));

      expect(find.byType(CreateTask), findsNothing);

      // Tap the add button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify that CreateTask widget is displayed
      expect(find.byType(CreateTask), findsOneWidget);
    });

    testWidgets('Task produced by CreateTaskWidget matches user input',
        (WidgetTester tester) async {
      // Create the task provider
      TaskProvider taskProvider = TaskProvider();

      // Build the widget tree
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => taskProvider),
          ],
          child: MaterialApp(
            home: CreateTask(id: 0),
          ),
        ),
      );

      // Enter the task name in the text field
      await tester.enterText(find.byKey(Key('title')), 'Test Task Name');

      // Tap the add task button
      await tester.tap(find.byKey(Key('addTaskButton')));
      await tester.pump();

      // Verify that the task has been added to the task provider
      TaskModel task = taskProvider.tasks[0];
      expect(task.title, 'Test Task Name');
    });

    testWidgets(
        'EditTaskWidget updates existing task instead of creating new task',
        (tester) async {
      final task1 = TaskModel(
          id: 0,
          title: 'Task 1',
          description: 'Task 1 description',
          status: 'Open');
      final taskProvider = TaskProvider();
      taskProvider.addTask(task1);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: taskProvider),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CreateTask(
                isFirst: false,
                id: 0,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final formKey = GlobalKey<FormState>();
      final titleFinder = find.byKey(Key('title'));
      final descriptionFinder = find.byKey(Key('description'));
      final updateButtonFinder = find.byKey(Key('update'));

      expect(taskProvider.tasks.length, 1);

      // Check if the existing task is displayed
      expect(taskProvider.tasks[0].title, task1.title);
      expect(taskProvider.tasks[0].description, task1.description);

      // Update the existing task
      await tester.enterText(titleFinder, 'Task 1 updated');
      await tester.enterText(descriptionFinder, 'Task 1 description updated');
      await tester.tap(updateButtonFinder);
      await tester.pumpAndSettle();

      // Check if the task has been updated
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks[0].title, 'Task 1 updated');
      expect(taskProvider.tasks[0].description, 'Task 1 description updated');
    });
  });
}
