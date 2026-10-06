# ЗВІТ
про виконання лабораторної роботи №1  
«Створення Flutter-проєкту та ознайомлення зі структурою застосунку»  
з дисципліни «Програмування мобільних додатків»  
Студента групи КН-2327Б  
**Багрія-Белза Андрія**  

---

**Завдання:** Встановити Android Studio та Flutter SDK, створити Flutter-проєкт згідно Варіанту 1 («Менеджер завдань»), налаштувати емулятор та виконати запуск застосунку.

---

### 1 Написання коду-розв’язку завдання:
Вихідний код розташований у `Lab_1/task_manager/lib/main.dart`:
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const TaskManagerApp());
}

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
          surface: const Color(0xFF15181F),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0F13),
      ),
      home: const TaskManagerHomePage(title: 'Менеджер завдань'),
    );
  }
}

class TaskItem {
  final String title;
  final String category;
  bool isCompleted;
  TaskItem({required this.title, required this.category, this.isCompleted = false});
}

class TaskManagerHomePage extends StatefulWidget {
  final String title;
  const TaskManagerHomePage({super.key, required this.title});

  @override
  State<TaskManagerHomePage> createState() => _TaskManagerHomePageState();
}

class _TaskManagerHomePageState extends State<TaskManagerHomePage> {
  final List<TaskItem> _tasks = [
    TaskItem(title: 'Встановити Android Studio та Flutter SDK', category: 'Навчання', isCompleted: true),
    TaskItem(title: 'Налаштувати емулятор Android', category: 'Навчання', isCompleted: true),
    TaskItem(title: 'Створити Flutter-проєкт для Варіанту 1', category: 'ПМД Лаб 1', isCompleted: true),
    TaskItem(title: 'Оформити звіт з лабораторної роботи №1', category: 'ПМД Лаб 1', isCompleted: true),
    TaskItem(title: 'Підготувати відповіді на контрольні запитання', category: 'ПМД Лаб 1', isCompleted: false),
  ];

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Варіант 1: Менеджер завдань ($_completedCount / ${_tasks.length})'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, i) => Card(
                  child: ListTile(
                    leading: Checkbox(value: _tasks[i].isCompleted, onChanged: (_) => _toggleTask(i)),
                    title: Text(_tasks[i].title),
                    subtitle: Text(_tasks[i].category),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFFD4FF00),
        foregroundColor: const Color(0xFF0B0D11),
        icon: const Icon(Icons.add),
        label: const Text('Додати завдання'),
      ),
    );
  }
}
```

---

### 2 Результат виконання коду:
- Діагностика середовища розробки: `Lab_1/assets/doctor_terminal.png`
- Запуск застосунку на Android-емуляторі (Android 16 / API 36): `Lab_1/assets/emulator_duo_tasks.png`

---

### Контрольні запитання:

1. **Що таке Flutter та для чого він використовується?**  
Flutter — це відкритий кросплатформний UI-фреймворк від компанії Google, призначений для створення компільованих застосунків для мобільних систем (Android, iOS), настільних ОС та Web на основі єдиної кодової бази мовою Dart.

2. **Яке призначення Flutter SDK?**  
Flutter SDK містить компілятор мови Dart, набір базових віджетів Material Design та Cupertino, утиліти командного рядка (flutter CLI) та інструменти для налагодження й збірки проєкту.

3. **Що таке віджет у Flutter?**  
Віджет — це базовий будівельний блок інтерфейсу у Flutter. Вони поділяються на StatelessWidget (незмінні віджети без власного стану) та StatefulWidget (динамічні віджети зі станом, який оновлюється за допомогою виклику setState).

4. **Яку роль виконує Android Studio під час розробки Flutter-застосунків?**  
Android Studio слугує інтегрованим середовищем розробки (IDE): надає зручний редактор коду з підсвічуванням та автодоповненням, засоби керування Android SDK, емулятори пристроїв (Device Manager) та підтримку швидкого перезавантаження (Hot Reload).

5. **Для чого використовується команда flutter doctor?**  
Команда виконує повну діагностику системи: перевіряє версію Flutter SDK, наявність і ліцензії Android SDK, засоби збірки під платформи та виявляє підключені пристрої й емулятори.

6. **Яка структура стандартного Flutter-проєкту?**  
Каталог lib/ містить вихідний код мовою Dart (точка входу main.dart), каталоги android/ та ios/ — конфігурацію під нативні платформи, test/ — модульні та віджет-тести, а файл pubspec.yaml описує конфігурацію і залежності проєкту.

---

**Висновок:** На цій лабораторній роботі, я встановив Android Studio та Flutter SDK, створив перший проєкт за Варіантом 1 («Менеджер завдань»), налаштував емулятор і перевірив роботу застосунку.
