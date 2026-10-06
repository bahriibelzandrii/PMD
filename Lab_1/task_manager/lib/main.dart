import 'package:flutter/material.dart';

/// Лабораторна робота №1 з дисципліни «Програмування мобільних додатків»
/// Тема: «Створення Flutter-проєкту та ознайомлення зі структурою застосунку»
/// Варіант 1: «Менеджер завдань»
///
/// Студент: Багрій-Белз Андрій
/// Група: КН-2327Б

void main() {
  runApp(const TaskManagerApp());
}

/// Головний кореневий віджет застосунку (StatelessWidget)
class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Менеджер завдань',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4FF00),
          brightness: Brightness.dark,
          primary: const Color(0xFFD4FF00),
          onPrimary: const Color(0xFF0B0D11),
          surface: const Color(0xFF15181F),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0F13),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF15181F),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const TaskManagerHomePage(title: 'Менеджер завдань'),
    );
  }
}

/// Проста модель завдання для демонстрації списку в Лаб 1
class TaskItem {
  final String title;
  final String category;
  bool isCompleted;

  TaskItem({
    required this.title,
    required this.category,
    this.isCompleted = false,
  });
}

/// Головний екран застосунку з підтримкою стану (StatefulWidget)
class TaskManagerHomePage extends StatefulWidget {
  final String title;

  const TaskManagerHomePage({super.key, required this.title});

  @override
  State<TaskManagerHomePage> createState() => _TaskManagerHomePageState();
}

class _TaskManagerHomePageState extends State<TaskManagerHomePage> {
  // Список початкових завдань для Варіанту 1
  final List<TaskItem> _tasks = [
    TaskItem(
      title: 'Встановити Android Studio та Flutter SDK',
      category: 'Навчання',
      isCompleted: true,
    ),
    TaskItem(
      title: 'Налаштувати емулятор Android',
      category: 'Навчання',
      isCompleted: true,
    ),
    TaskItem(
      title: 'Створити Flutter-проєкт для Варіанту 1',
      category: 'ПМД Лаб 1',
      isCompleted: true,
    ),
    TaskItem(
      title: 'Оформити звіт з лабораторної роботи №1',
      category: 'ПМД Лаб 1',
      isCompleted: false,
    ),
    TaskItem(
      title: 'Підготувати відповіді на контрольні запитання',
      category: 'ПМД Лаб 1',
      isCompleted: false,
    ),
  ];

  final TextEditingController _taskController = TextEditingController();

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _addNewTask() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF15181F),
          title: const Text('Нове завдання', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _taskController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Введіть назву завдання...',
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _taskController.clear();
                Navigator.of(ctx).pop();
              },
              child: const Text('Скасувати', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4FF00),
                foregroundColor: const Color(0xFF0B0D11),
              ),
              onPressed: () {
                final text = _taskController.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _tasks.add(TaskItem(title: text, category: 'Загальне'));
                  });
                  _taskController.clear();
                }
                Navigator.of(ctx).pop();
              },
              child: const Text('Додати'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Про застосунок',
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Менеджер завдань',
                applicationVersion: '1.0.0 (Лабораторна робота №1)',
                applicationLegalese: 'ПМД — Студент Багрій-Белз Андрій, група КН-2327Б',
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Інформаційна картка студента та варіанту
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF15181F),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF272D3A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Варіант 1: Менеджер завдань',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4FF00),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4FF00).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_completedCount / ${_tasks.length}',
                          style: const TextStyle(
                            color: Color(0xFFD4FF00),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Студент: Багрій-Белз Андрій • Група: КН-2327Б',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Заголовок списку
            const Text(
              'Список завдань',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // Список завдань
            Expanded(
              child: ListView.separated(
                itemCount: _tasks.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Card(
                    color: const Color(0xFF15181F),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF272D3A)),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        activeColor: const Color(0xFFD4FF00),
                        checkColor: const Color(0xFF0B0D11),
                        side: const BorderSide(color: Colors.white38, width: 1.8),
                        onChanged: (val) => _toggleTask(index),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 15,
                          color: task.isCompleted ? Colors.white38 : Colors.white,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        task.category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20, color: Colors.white38),
                        onPressed: () {
                          setState(() {
                            _tasks.removeAt(index);
                          });
                        },
                      ),
                      onTap: () => _toggleTask(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewTask,
        backgroundColor: const Color(0xFFD4FF00),
        foregroundColor: const Color(0xFF0B0D11),
        icon: const Icon(Icons.add),
        label: const Text('Додати завдання'),
      ),
    );
  }
}
