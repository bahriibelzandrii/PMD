# ЗВІТ
про виконання лабораторної роботи №2  
«Базова структура Flutter проєкту та основи Flutter UI»  
з дисципліни «Програмування мобільних додатків»  
Студента групи КН-2327Б  
**Багрія-Белза Андрія**  

---

**Завдання:** Створити головний екран застосунку згідно Варіанту 1 («Менеджер завдань») з використанням віджетів Scaffold, AppBar, Center з ElevatedButton("Додати завдання") та BottomNavigationBar із двома пунктами («Список» та іконка задачі).

---

### 1 Написання коду-розв’язку завдання:
Вихідний код розташований у `Lab_2/task_manager/lib/main.dart`:
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onAddTaskPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Нове завдання успішно додано!',
          style: TextStyle(color: Color(0xFF0D0F13), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFD4FF00),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Менеджер завдань'),
        centerTitle: true,
        backgroundColor: const Color(0xFF15181F),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _onAddTaskPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4FF00),
            foregroundColor: const Color(0xFF0D0F13),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Додати завдання'),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFD4FF00),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF15181F),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Список',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Завдання',
          ),
        ],
      ),
    );
  }
}
```

---

### 2 Результат виконання коду:
- Робота застосунку на емуляторі Android 16 (API 36) із демонстрацією структури Scaffold, AppBar, кнопки по центру та перемикання навігації: `Lab_2/assets/emulator_duo.png`

---

### Контрольні запитання:

1. **Що таке віджет у Flutter?**  
Віджет — це базовий будівельний блок інтерфейсу користувача у Flutter, який описує його конфігурацію, візуальний вигляд та поведінку (поділяються на StatelessWidget без власного стану та StatefulWidget зі станом).

2. **Яке призначення віджета Scaffold?**  
Scaffold реалізує базову візуальну структуру екрана Material Design, надаючи стандартні слоти для розміщення верхньої панелі (appBar), основного вмісту (body), плаваючої кнопки (floatingActionButton) та нижньої навігації (bottomNavigationBar).

3. **Для чого використовується AppBar у Flutter?**  
Він слугує верхньою панеллю інструментів екрана для відображення заголовка поточної сторінки, кнопок переходу назад та виклику додаткових дій користувача (actions).

4. **Які елементи інтерфейсу можуть розміщуватися у властивості body віджета Scaffold?**  
У властивості body можна розмістити будь-який віджет Flutter: поодинокі елементи (Center, Container, Text, Image), кнопки (ElevatedButton) або складені макети зі списком елементів (Column, Row, ListView).

5. **Яке призначення віджета ElevatedButton і як обробляється натискання на кнопку?**  
ElevatedButton — це стандартна кнопка з фоновим кольором і тінню, натискання якої обробляється викликом колбек-функції у властивості onPressed (якщо передано null, кнопка стає неактивною).

6. **Для чого використовується BottomNavigationBar?**  
BottomNavigationBar слугує нижньою панеллю навігації для швидкого перемикання між основними розділами або вкладками застосунку в межах одного екрана.

7. **Які обовʼязкові елементи містить навігаційна панель BottomNavigationBar?**  
Вона обов'язково повинна містити список items щонайменше з двох елементів BottomNavigationBarItem із заданими властивостями icon та label.

8. **Чим відрізняється текстовий пункт BottomNavigationBarItem від пункту з іконкою або зображенням?**  
Текстовий пункт використовує іконку тексту або стандартний текстовий підпис label, тоді як пункт із зображенням замість іконки зі шрифту Icon передає віджет зображення Image (Image.asset або Image.network).

9. **Для чого використовуються віджети Container, Padding та SizedBox?**  
Container використовується для комплексного позиціонування, фону, меж і відступів; Padding — виключно для додавання внутрішніх відступів навколо віджета; а SizedBox — для задання фіксованих розмірів або проміжків.

---

**Висновок:** На цій лабораторній роботі, я опанував базову структуру Flutter-проєкту та компоненти Flutter UI, реалізував головний екран за Варіантом 1 («Менеджер завдань») із використанням віджетів Scaffold, AppBar, Center з кнопкою ElevatedButton та BottomNavigationBar, а також перевірив роботу інтерфейсу на емуляторі Android.
