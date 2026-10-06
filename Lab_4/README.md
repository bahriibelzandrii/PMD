# ЗВІТ
про виконання лабораторної роботи №4  
«Власні віджети та компоненти інтерфейсу»  
з дисципліни «Програмування мобільних додатків»  
Студента групи КН-2327Б  
**Багрія-Белза Андрія**  

---

**Завдання:**
1. Продовжити роботу над проєктом, розпочатим у Лабораторній роботі №3.
2. На основі готового макета з Лабораторної роботи №3 переробити екран, використовуючи власні віджети.
3. Виділити елементи інтерфейсу в окремі компоненти (`StatelessWidget`), зокрема:
   - заголовок або верхній інформаційний блок;
   - інформаційну картку або текстовий блок;
   - блок кнопок дії;
   - блок із зображенням або іконкою.
4. Для кожного власного віджета:
   - створити окремий файл у папці `widgets/`;
   - реалізувати передачу даних через конструктор (`required` параметри).
5. Організувати структуру проєкту з використанням папок:
   - `screens/` — для екранів;
   - `widgets/` — для власних компонентів.
6. У файлі екрана (`lab4_screen.dart`) імпортувати та використати створені власні віджети.
7. Під час побудови інтерфейсу використати layout-віджети: `Column`, `Row`, `Container`, `Padding`, `Flexible` / `Expanded`, `Spacer`.
8. Забезпечити логічне розміщення елементів, наявність відступів між блоками та відсутність помилок верстки (overflow).
9. Перевірити коректну роботу застосунку на емуляторі або фізичному пристрої.

---

### 1 Написання коду-розв’язку завдання:

#### Точка входу (`Lab_4/task_manager/lib/main.dart`):
```dart
import 'package:flutter/material.dart';
import 'screens/lab4_screen.dart';

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
      home: const Lab4Screen(),
    );
  }
}
```

#### Головний екран (`Lab_4/task_manager/lib/screens/lab4_screen.dart`):
```dart
import 'package:flutter/material.dart';
import '../widgets/image_banner_card.dart';
import '../widgets/task_header.dart';
import '../widgets/task_info_card.dart';
import '../widgets/action_buttons_row.dart';

class Lab4Screen extends StatefulWidget {
  const Lab4Screen({super.key});

  @override
  State<Lab4Screen> createState() => _Lab4ScreenState();
}

class _Lab4ScreenState extends State<Lab4Screen> {
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
        title: const Text('Лабораторна робота №4'),
        centerTitle: true,
        backgroundColor: const Color(0xFF15181F),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ImageBannerCard(
                icon: Icons.image_outlined,
                height: 200,
                iconColor: Color(0xFFD4FF00),
                backgroundColor: Color(0xFF1F2430),
                borderColor: Color(0xFF2A3142),
              ),
              const SizedBox(height: 16),
              TaskHeader(
                title: 'Оптимізація бази даних',
                isFavorite: _isFavorite,
                onFavoriteToggle: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  _showMessage(
                    _isFavorite ? 'Додано до обраного' : 'Видалено з обраного',
                  );
                },
              ),
              const SizedBox(height: 12),
              const Flexible(
                child: TaskInfoCard(
                  description:
                      'Необхідно провести комплексний аналіз запитів до бази даних, налаштувати індексацію для прискорення вибірки та видалити застарілі кешовані записи. Це дозволить суттєво підвищити швидкодію мобільного застосунку та знизити навантаження на серверну частину під час пікових навантажень.',
                  backgroundColor: Color(0xFF15181F),
                  borderColor: Color(0xFF2A3142),
                  textColor: Color(0xFFE2E8F0),
                ),
              ),
              const Spacer(),
              ActionButtonsRow(
                primaryText: 'Виконати',
                secondaryText: 'Відкласти',
                onPrimaryPressed: () => _showMessage('Завдання успішно виконано!'),
                onSecondaryPressed: () => _showMessage('Завдання відкладено'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### Власні віджети:

1. **`Lab_4/task_manager/lib/widgets/image_banner_card.dart`** (блок із зображенням або іконкою):
```dart
import 'package:flutter/material.dart';

class ImageBannerCard extends StatelessWidget {
  final IconData icon;
  final double height;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;

  const ImageBannerCard({
    super.key,
    required this.icon,
    required this.height,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 80,
          color: iconColor,
        ),
      ),
    );
  }
}
```

2. **`Lab_4/task_manager/lib/widgets/task_header.dart`** (заголовок або верхній інформаційний блок):
```dart
import 'package:flutter/material.dart';

class TaskHeader extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const TaskHeader({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.redAccent : Colors.grey,
          ),
          onPressed: onFavoriteToggle,
        ),
      ],
    );
  }
}
```

3. **`Lab_4/task_manager/lib/widgets/task_info_card.dart`** (інформаційна картка або текстовий блок):
```dart
import 'package:flutter/material.dart';

class TaskInfoCard extends StatelessWidget {
  final String description;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const TaskInfoCard({
    super.key,
    required this.description,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: textColor,
        ),
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
```

4. **`Lab_4/task_manager/lib/widgets/action_buttons_row.dart`** (блок кнопок дії):
```dart
import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  final String primaryText;
  final String secondaryText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  const ActionButtonsRow({
    super.key,
    required this.primaryText,
    required this.secondaryText,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPrimaryPressed,
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
            child: Text(primaryText),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: onSecondaryPressed,
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
            child: Text(secondaryText),
          ),
        ),
      ],
    );
  }
}
```

---

### 2 Результат виконання коду:
- Робота застосунку на емуляторі Android 16 (API 36) із демонстрацією власних віджетів та показу сповіщення SnackBar: `Lab_4/assets/emulator_duo.png`

---

### Контрольні запитання:

1. **Що таке власний віджет у Flutter?**  
Власний віджет (custom widget) у Flutter — це окремий призначений для користувача клас (як правило, спадкоємець `StatelessWidget` або `StatefulWidget`), створений шляхом композиції стандартних віджетів фреймворку для інкапсуляції певної частини інтерфейсу та його логіки.

2. **Для чого створюють власні компоненти інтерфейсу?**  
Власні компоненти створюють для усунення дублювання коду (принцип DRY), спрощення структури віджетного дерева, полегшення підтримки та рефакторингу коду, підвищення читабельності та забезпечення повторного використання елементів інтерфейсу в різних частинах застосунку.

3. **Чому в цій лабораторній роботі використовуються саме StatelessWidget?**  
`StatelessWidget` використовується тому, що створені власні компоненти є презентаційними (відображувальними): вони не зберігають внутрішнього змінного стану, повністю залежать від переданих у конструктор даних і при їх зміні перебудовуються ззовні батьківським віджетом.

4. **Як передати дані у власний віджет?**  
Дані передаються через параметри конструктора класу власного віджета (наприклад, типи `String`, `IconData`, `Color`, `VoidCallback`) і зберігаються у незмінних (`final`) полях класу.

5. **Для чого використовується ключове слово required у конструкторі?**  
Ключове слово `required` в іменованих параметрах конструктора гарантує на етапі компіляції, що відповідний аргумент обов'язково буде переданий при створенні екземпляра віджета, запобігаючи виникненню помилок відсутності обов'язкових даних (`null`).

6. **Чому не рекомендується розміщувати весь код у файлі main.dart?**  
Розміщення всього коду в одному файлі призводить до надмірної складності («спагеті-код»), погіршення читабельності, ускладнення навігації, командної розробки та тестування. Файл `main.dart` повинен слугувати лише точкою входу для конфігурації та запуску застосунку.

7. **Яке призначення папок screens та widgets у Flutter-проєкті?**  
Папка `screens/` призначена для повноцінних екранів (сторінок) застосунку, які зазвичай містять каркас `Scaffold` і координують взаємодію між компонентами. Папка `widgets/` призначена для дрібних, автономних та повторно використовуваних UI-компонентів, з яких будуються ці екрани.

8. **Які переваги має повторне використання віджетів у Flutter?**  
Повторне використання скорочує обсяг кодової бази, забезпечує візуальну та поведінкову консистентність дизайну в усьому застосунку, прискорює розробку нових екранів і дозволяє вносити глобальні зміни в стиль чи логіку елемента лише в одному місці.

---

**Висновок:** На цій лабораторній роботі, я закріпив навички декомпозиції інтерфейсу у Flutter, виніс елементи екрана у власні StatelessWidget-компоненти (ImageBannerCard, TaskHeader, TaskInfoCard, ActionButtonsRow) із передачею даних через required-параметри конструкторів, структурував проєкт за папками screens/ та widgets/, а також перевірив коректність роботи оновленої архітектури за допомогою віджет-тестів та запуску на емуляторі Android.
