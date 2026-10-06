# ЗВІТ
про виконання лабораторної роботи №3  
«Розмітка інтерфейсу (Layout Widgets)»  
з дисципліни «Програмування мобільних додатків»  
Студента групи КН-2327Б  
**Багрія-Белза Андрія**  

---

**Завдання:** Створити екран Flutter-застосунку згідно Варіанту 1 (Група 1: «Менеджер завдань», макет «Картка зображення зверху: Column → Row») без використання списків та навігації, застосувавши обов'язкові layout-віджети: Column, Row, Container, Padding, Expanded, Flexible та Spacer.

---

### 1 Написання коду-розв’язку завдання:
Вихідний код розташований у `Lab_3/task_manager/lib/main.dart`:
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
      home: const TaskDetailsScreen(),
    );
  }
}

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool _isFavorite = false;

  void _showMessage(String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF0D0F13),
            fontWeight: FontWeight.bold,
          ),
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
        title: const Text('Деталі'),
        centerTitle: true,
        backgroundColor: const Color(0xFF15181F),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2430),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2A3142),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 80,
                    color: Color(0xFFD4FF00),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Оптимізація бази даних',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.redAccent : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      _showMessage(
                        _isFavorite
                            ? 'Додано до обраного'
                            : 'Видалено з обраного',
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  'Необхідно провести комплексний аналіз запитів до бази даних, налаштувати індексацію для прискорення вибірки та видалити застарілі кешовані записи. Це дозволить суттєво підвищити швидкодію мобільного застосунку та знизити навантаження на серверну частину під час пікових навантажень.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.grey.shade300,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showMessage('Завдання успішно виконано!'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4FF00),
                        foregroundColor: const Color(0xFF0D0F13),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Виконати'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showMessage('Завдання відкладено'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFF2A3142),
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Відкласти'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

### 2 Результат виконання коду:
- Робота застосунку на емуляторі Android 16 (API 36) із демонстрацією макета Групи 1 (Column → Row, картка із зображенням зверху, назва з іконкою, опис, притиснуті кнопки та взаємодія через SnackBar): `Lab_3/assets/emulator_duo.png`

---

### Контрольні запитання:

1. **Що таке розмітка інтерфейсу у Flutter?**  
Розмітка інтерфейсу (Layout) у Flutter — це процес просторового розташування, вирівнювання та визначення розмірів елементів за допомогою ієрархії вкладених layout-віджетів за правилом передачі обмежень зверху вниз.

2. **У чому різниця між віджетами Row та Column?**  
Віджет `Row` розміщує свої дочірні елементи горизонтально в один рядок, тоді як `Column` компонує їх вертикально у стовпчик уздовж своєї головної осі.

3. **Яке призначення віджета Container?**  
`Container` — універсальний віджет, що поєднує можливості задання розмірів (width, height), внутрішніх і зовнішніх відступів, а також стилізації фону, меж і радіуса заокруглень.

4. **Для чого використовується віджет Padding?**  
`Padding` використовується для створення внутрішніх відступів навколо свого дочірнього елемента без додавання фону чи додаткового візуального оформлення.

5. **Як працює віджет Expanded?**  
`Expanded` змушує дочірній елемент зайняти весь вільний доступний простір уздовж головної осі в `Row` або `Column` пропорційно до встановленого значення коефіцієнта `flex`.

6. **Чим відрізняється Expanded від Flexible?**  
Віджет `Expanded` вимагає обов'язкового заповнення всього виділеного простору (`FlexFit.tight`), а `Flexible` дозволяє займати лише потрібний розмір у межах виділеного простору (`FlexFit.loose`).

7. **Чому не бажано використовувати фіксовані розміри елементів?**  
Фіксовані розміри призводять до помилок переповнення екрана (`RenderFlex overflowed`) на невеликих пристроях або до порожніх неадаптивних зон на великих екранах.

8. **Як layout-віджети допомагають створювати адаптивний інтерфейс?**  
Вони динамічно перерозподіляють доступний екранний простір на основі відносних пропорцій і поточних розмірів вікна без жорсткої прив'язки до фізичних пікселів.

---

**Висновок:** На цій лабораторній роботі, я опанував принципи побудови адаптивних макетів користувацького інтерфейсу у Flutter, створив екран детального перегляду завдання за Варіантом 1 (Група 1) із використанням віджетів Column, Row, Container, Padding, Expanded, Flexible та Spacer, а також перевірив коректність відображення та інтерактивних дій на емуляторі Android.
