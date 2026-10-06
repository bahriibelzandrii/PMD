import 'package:flutter/material.dart';
import 'design_system/app_theme.dart';
import 'design_system/task_model.dart';

import 'screens/screen_1_onboarding.dart';
import 'screens/screen_2_auth.dart';
import 'screens/screen_3_dashboard.dart';
import 'screens/screen_4_projects.dart';
import 'screens/screen_5_kanban.dart';
import 'screens/screen_6_task_details.dart';
import 'screens/screen_7_create_task.dart';
import 'screens/screen_8_favorites.dart';
import 'screens/screen_9_analytics.dart';
import 'screens/screen_10_profile.dart';

void main() {
  runApp(const TaskMasterApp());
}

/// Головний застосунок TaskMaster (Лабораторні №1-10)
class TaskMasterApp extends StatefulWidget {
  const TaskMasterApp({super.key});

  @override
  State<TaskMasterApp> createState() => _TaskMasterAppState();
}

class _TaskMasterAppState extends State<TaskMasterApp> {
  // Стан темної/світлої теми (Лабораторна №9)
  bool _isDarkMode = true;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskMaster — Менеджер завдань',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainNavigationWrapper(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

/// Навігаційний каркас із BottomNavigationBar (Лабораторна №2)
class MainNavigationWrapper extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const MainNavigationWrapper({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  void _navigateToDetails(TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(
          task: task,
          onToggleFavorite: () => setState(() {}),
        ),
      ),
    );
  }

  void _navigateToCreateTask() async {
    final result = await Navigator.push<TaskModel>(
      context,
      MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
    );

    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Створено завдання: ${result.title}')),
      );
    }
  }

  void _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesScreen(
          onTaskTap: _navigateToDetails,
        ),
      ),
    );
  }

  void _navigateToOnboarding() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardingScreen(
          onStart: () => Navigator.pop(context),
          onLogin: () {
            Navigator.pop(context);
            _navigateToAuth();
          },
        ),
      ),
    );
  }

  void _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuthScreen(
          onSuccess: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 5 основних вкладок застосунку
    final screens = [
      DashboardScreen(
        onAddTask: _navigateToCreateTask,
        onTaskTap: _navigateToDetails,
        onViewAllTasks: () => setState(() => _currentIndex = 2),
      ),
      ProjectsScreen(
        onSelectCategory: (category) => setState(() => _currentIndex = 2),
      ),
      KanbanBoardScreen(
        onTaskTap: _navigateToDetails,
      ),
      const AnalyticsScreen(),
      ProfileScreen(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        onClearCache: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Кеш SharedPreferences очищено!')),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMaster', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.star_rounded),
            tooltip: 'Обрані завдання',
            onPressed: _navigateToFavorites,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Вітальний екран',
            onPressed: _navigateToOnboarding,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Дашборд',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_rounded),
            label: 'Проєкти',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_kanban_rounded),
            label: 'Дошка',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Аналітика',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Профіль',
          ),
        ],
      ),
    );
  }
}
