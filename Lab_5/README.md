# ЗВІТ
про виконання лабораторної роботи №5  
«Управління станом застосунку з використанням StatefulWidget»  
з дисципліни «Програмування мобільних додатків»  
Студента групи КН-2327Б  
**Багрія-Белза Андрія**  

---

**Завдання:**
1. Продовжити роботу над проєктом, розпочатим у Лабораторній роботі №4.
2. Екран повинен бути реалізований як `StatefulWidget`.
3. Повинен бути створений окремий клас стану (`_ScreenNameState`).
4. Всі змінні стану повинні зберігатися всередині класу `State`.
5. Оновлення інтерфейсу повинно виконуватись виключно через `setState()`.
6. Обов’язкові змінні стану. У кожному варіанті мають бути використані мінімум:
   - `bool` — для Switch / Checkbox / обраного стану;
   - `int` — лічильник дії;
   - `String` — значення з TextField.
7. Обов’язкові інтерактивні елементи:
   - **Іконка «обране»:** змінює колір при натисканні, реалізується через `bool`;
   - **Кнопка дії:** збільшує лічильник, відображає поточне значення на екрані;
   - **Checkbox або Switch:** змінює відображення елементів інтерфейсу: показ/приховування тексту, зміна стилю, поява бейджа, зміна кольору;
   - **TextField:** зчитує введений текст, відображає результат нижче, використовує `onChanged`.

---

### 1 Написання коду-розв’язку завдання:

#### Точка входу (`Lab_5/task_manager/lib/main.dart`):
```dart
import 'package:flutter/material.dart';
import 'screens/lab5_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Менеджер завдань — Лабораторна №5',
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
      home: const Lab5Screen(),
    );
  }
}
```

#### Головний екран зі станом (`Lab_5/task_manager/lib/screens/lab5_screen.dart`):
```dart
import 'package:flutter/material.dart';
import '../widgets/image_banner_card.dart';
import '../widgets/task_header.dart';
import '../widgets/task_info_card.dart';
import '../widgets/priority_switch_card.dart';
import '../widgets/note_input_card.dart';
import '../widgets/action_buttons_row.dart';

class Lab5Screen extends StatefulWidget {
  const Lab5Screen({super.key});

  @override
  State<Lab5Screen> createState() => _Lab5ScreenState();
}

class _Lab5ScreenState extends State<Lab5Screen> {
  // 1. bool — стан іконки "обране"
  bool _isFavorite = false;

  // 2. bool — стан перемикача терміновості (Switch)
  bool _isUrgent = false;

  // 3. int — лічильник дій користувача
  int _executionCount = 0;

  // 4. String — значення, введене у TextField
  String _note = '';

  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

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
        title: const Text('Лабораторна робота №5'),
        centerTitle: true,
        backgroundColor: const Color(0xFF15181F),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Блок із зображенням / банером
              const ImageBannerCard(
                icon: Icons.developer_board_rounded,
                height: 180,
                iconColor: Color(0xFFD4FF00),
                backgroundColor: Color(0xFF1F2430),
                borderColor: Color(0xFF2A3142),
              ),
              const SizedBox(height: 16),

              // 1. Заголовок + іконка "обране" (bool _isFavorite)
              TaskHeader(
                title: 'Оптимізація бази даних',
                isFavorite: _isFavorite,
                isUrgent: _isUrgent,
                onFavoriteToggle: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  _showMessage(
                    _isFavorite ? 'Додано до обраного ❤️' : 'Видалено з обраного 🤍',
                  );
                },
              ),
              const SizedBox(height: 12),

              // 2. Інформаційна картка (змінює стиль, колір та показує додатковий текст при _isUrgent)
              TaskInfoCard(
                description:
                    'Необхідно провести комплексний аналіз запитів до бази даних, налаштувати індексацію для прискорення вибірки та видалити застарілі кешовані записи. Це дозволить підвищити швидкодію мобільного застосунку.',
                isUrgent: _isUrgent,
                backgroundColor: const Color(0xFF15181F),
                borderColor: const Color(0xFF2A3142),
                textColor: const Color(0xFFE2E8F0),
              ),
              const SizedBox(height: 16),

              // 3. Switch (bool _isUrgent) — змінює бейдж, стиль, колір та показує/приховує текст
              PrioritySwitchCard(
                isUrgent: _isUrgent,
                onChanged: (value) {
                  setState(() {
                    _isUrgent = value;
                  });
                  _showMessage(
                    value ? 'Увімкнено терміновий пріоритет 🔥' : 'Звичайний пріоритет',
                  );
                },
              ),
              const SizedBox(height: 16),

              // 4. TextField (String _note) — зчитує введений текст через onChanged та показує нижче
              NoteInputCard(
                noteText: _note,
                controller: _textController,
                onChanged: (value) {
                  setState(() {
                    _note = value;
                  });
                },
                onClear: () {
                  setState(() {
                    _textController.clear();
                    _note = '';
                  });
                },
              ),
              const SizedBox(height: 20),

              // 5. Кнопка дії (int _executionCount) — збільшує лічильник та відображає поточне значення
              ActionButtonsRow(
                executionCount: _executionCount,
                onExecute: () {
                  setState(() {
                    _executionCount++;
                  });
                  _showMessage('Дію зафіксовано! Всього: $_executionCount');
                },
                onReset: () {
                  setState(() {
                    _executionCount = 0;
                  });
                  _showMessage('Лічильник скинуто до 0');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### Власні віджети:

1. **`Lab_5/task_manager/lib/widgets/image_banner_card.dart`**:
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
          size: 72,
          color: iconColor,
        ),
      ),
    );
  }
}
```

2. **`Lab_5/task_manager/lib/widgets/task_header.dart`**:
```dart
import 'package:flutter/material.dart';

class TaskHeader extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final bool isUrgent;
  final VoidCallback onFavoriteToggle;

  const TaskHeader({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.isUrgent,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isUrgent ? const Color(0xFFFF6B6B) : Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
              if (isUrgent) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFFF6B6B),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFFF6B6B),
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'ВИСОКИЙ ПРІОРИТЕТ',
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        IconButton(
          tooltip: isFavorite ? 'Видалити з обраного' : 'Додати в обране',
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? const Color(0xFFFF4B6E) : const Color(0xFF8B949E),
            size: 28,
          ),
          onPressed: onFavoriteToggle,
        ),
      ],
    );
  }
}
```

3. **`Lab_5/task_manager/lib/widgets/task_info_card.dart`**:
```dart
import 'package:flutter/material.dart';

class TaskInfoCard extends StatelessWidget {
  final String description;
  final bool isUrgent;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const TaskInfoCard({
    super.key,
    required this.description,
    required this.isUrgent,
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
        color: isUrgent
            ? const Color(0xFF26181E)
            : backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUrgent ? const Color(0xFFFF6B6B) : borderColor,
          width: isUrgent ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isUrgent ? Colors.white : textColor,
              fontWeight: isUrgent ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          if (isUrgent) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.notification_important_rounded,
                    color: Color(0xFFFF6B6B),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Термінове завдання: вимагає першочергового закриття!',
                      style: TextStyle(
                        color: Color(0xFFFF8B8B),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

4. **`Lab_5/task_manager/lib/widgets/priority_switch_card.dart`**:
```dart
import 'package:flutter/material.dart';

class PrioritySwitchCard extends StatelessWidget {
  final bool isUrgent;
  final ValueChanged<bool> onChanged;

  const PrioritySwitchCard({
    super.key,
    required this.isUrgent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF15181F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFF2A3142),
          width: 1,
        ),
      ),
      child: SwitchListTile(
        title: const Text(
          'Терміновий статус',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          isUrgent
              ? 'Активовано бейдж, змінено стиль та підсвічування'
              : 'Увімкніть для виділення терміновості завдання',
          style: TextStyle(
            fontSize: 12,
            color: isUrgent ? const Color(0xFFFF8B8B) : const Color(0xFF8B949E),
          ),
        ),
        secondary: Icon(
          Icons.bolt,
          color: isUrgent ? const Color(0xFFFF6B6B) : const Color(0xFF8B949E),
        ),
        activeThumbColor: const Color(0xFFD4FF00),
        activeTrackColor: const Color(0xFFD4FF00).withValues(alpha: 0.3),
        inactiveThumbColor: const Color(0xFF8B949E),
        inactiveTrackColor: const Color(0xFF1F2430),
        value: isUrgent,
        onChanged: onChanged,
      ),
    );
  }
}
```

5. **`Lab_5/task_manager/lib/widgets/note_input_card.dart`**:
```dart
import 'package:flutter/material.dart';

class NoteInputCard extends StatelessWidget {
  final String noteText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const NoteInputCard({
    super.key,
    required this.noteText,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF15181F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2A3142),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Коментар або нотатка',
              labelStyle: const TextStyle(color: Color(0xFF8B949E)),
              hintText: 'Введіть деталі або оновлення...',
              hintStyle: const TextStyle(color: Color(0xFF555F70), fontSize: 13),
              prefixIcon: const Icon(
                Icons.edit_note,
                color: Color(0xFFD4FF00),
              ),
              suffixIcon: noteText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF8B949E)),
                      onPressed: onClear,
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFF1F2430),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD4FF00),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Введена нотатка: ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B949E),
                ),
              ),
              Expanded(
                child: Text(
                  noteText.isEmpty ? '— (поле порожнє)' : noteText,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: noteText.isEmpty ? FontStyle.italic : FontStyle.normal,
                    color: noteText.isEmpty
                        ? const Color(0xFF555F70)
                        : const Color(0xFFD4FF00),
                    fontWeight: noteText.isEmpty ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

6. **`Lab_5/task_manager/lib/widgets/action_buttons_row.dart`**:
```dart
import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  final int executionCount;
  final VoidCallback onExecute;
  final VoidCallback onReset;

  const ActionButtonsRow({
    super.key,
    required this.executionCount,
    required this.onExecute,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF15181F),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF2A3142),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: Color(0xFFD4FF00),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Кількість виконань:',
                    style: TextStyle(
                      color: Color(0xFF8B949E),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4FF00).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFD4FF00),
                    width: 1,
                  ),
                ),
                child: Text(
                  '$executionCount',
                  style: const TextStyle(
                    color: Color(0xFFD4FF00),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: onExecute,
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text('Виконати (+1)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4FF00),
                  foregroundColor: const Color(0xFF0D0F13),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: executionCount > 0 ? onReset : null,
                icon: const Icon(Icons.restart_alt, size: 18),
                label: const Text('Скинути'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: const Color(0xFF555F70),
                  side: BorderSide(
                    color: executionCount > 0
                        ? const Color(0xFF2A3142)
                        : const Color(0xFF1F2430),
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

### 2 Результат виконання коду:
- Робота застосунку на емуляторі Android 16 (API 36) із демонстрацією початкового та інтерактивного стану: `Lab_5/assets/emulator_duo.png`

---

### Контрольні запитання:

1. **Що таке стан (state) у Flutter-застосунку?**  
Стан (State) — це дані або сукупність інформації, яка може динамічно змінюватися під час життєвого циклу застосунку (внаслідок взаємодії користувача, відповідей сервера чи таймерів) та безпосередньо впливає на відображення графічного інтерфейсу (UI). У реактивній моделі Flutter інтерфейс є функцією від стану: $UI = f(State)$.

2. **Яке призначення методу createState()?**  
Метод `createState()` є обов'язковим перевизначеним методом класу `StatefulWidget`, який фреймворк викликає для інстанціювання та прив'язки відповідного екземпляра окремого класу стану (`State<T>`). Саме цей об'єкт `State` зберігає довготривалий змінний стан віджета в дереві елементів (Element Tree).

3. **Для чого використовується метод setState()?**  
Метод `setState()` слугує для повідомлення фреймворку Flutter про те, що внутрішній стан об'єкта `State` зазнав змін. Він приймає синхронний зворотний виклик (callback), у якому оновлюються поля стану, та сигналізує рушію рендерингу про необхідність перемалювання інтерфейсу.

4. **Що відбувається після виклику setState()?**  
Після виклику `setState()` відповідний `Element` віджета позначається як «брудний» (dirty) і планується до перебудови у черговому кадрі рендерингу (`SchedulerBinding`). Flutter викликає метод `build()`, зіставляє нове віджетне дерево з попереднім і точково оновлює змінені вузли в дереві рендерингу (RenderObject Tree).

5. **Чому не рекомендується виконувати довгі обчислення всередині setState()?**  
Метод `setState()` та передана до нього функція виконуються синхронно в головному потоці інтерфейсу (UI thread). Виконання важких обчислень чи синхронного введення/виведення призводить до блокування потоку, пропуску кадрів (jank / frame drops), сповільнення анімацій та зниження плавності взаємодії з користувачем.

6. **Які методи життєвого циклу має StatefulWidget?**  
Основні етапи та методи життєвого циклу: `createState()` (створення стану), `initState()` (одноразова ініціалізація під час монтування), `didChangeDependencies()` (викликається при зміні InheritedWidget), `build()` (побудова UI), `didUpdateWidget()` (оновлення конфігурації батьком), `setState()` (планування повторного build), `deactivate()` (вилучення з дерева) та `dispose()` (остаточне звільнення контролерів і ресурсів перед знищенням).

7. **Як реалізувати оновлення тексту під час введення даних у TextField?**  
Це реалізується шляхом передачі функції зворотного виклику в параметр `onChanged` віджета `TextField` (наприклад: `onChanged: (val) { setState(() { myText = val; }); }`). Під час введення символу `TextField` передає актуальний рядок, значення зберігається у змінній стану, а `setState()` запускає перебудову залежного віджету `Text(myText)`.

8. **Як зробити кнопку неактивною залежно від стану змінної?**  
У кнопках Flutter (`ElevatedButton`, `OutlinedButton`, `IconButton`) параметр `onPressed` приймає значення типу `VoidCallback?`. Якщо передати `null` замість функції за певної умови (наприклад: `onPressed: isEnabled ? () => doAction() : null`), фреймворк автоматично переводить кнопку в неактивний стан, змінює її кольорову гаму на приглушену та блокує обробку натискань.

9. **Які типи даних найчастіше використовуються для збереження стану?**  
Найчастіше використовуються: `bool` (для перемикачів Switch, Checkbox, прапорців видимості чи обраного стану), `int` / `double` (для лічильників, числових значень, слайдерів), `String` (для збереження тексту з полів введення), `List` / `Set` / `Map` (для динамічних колекцій елементів) та призначені для користувача класи моделей і `enum` (для статусів процесів).

10. **Що станеться, якщо змінити змінну стану без виклику setState()?**  
Змінна в пам'яті буде модифікована, проте фреймворк Flutter не отримає сповіщення про зміну даних. Екран не запланує перебудову, і користувацький інтерфейс залишиться зі застарілими відомостями доти, доки віджет випадково не перебудується з інших причин (наприклад, через глобальне оновлення батьківського вузла).

11. **У яких випадках доцільно використовувати StatefulWidget?**  
`StatefulWidget` доцільно використовувати, коли компонент інтерфейсу володіє власним динамічним станом, що змінюється внаслідок взаємодії користувача (форми введення, прапорці, анімації, лічильники), коли необхідно керувати життєвим циклом контролерів (`TextEditingController`, `AnimationController`, `ScrollController`) або відображати асинхронні зміни даних у межах одного екрана.

---

**Висновок:** На цій лабораторній роботі, я опанував механізми управління ефемерним станом у Flutter за допомогою StatefulWidget та класу State, реалізував динамічне оновлення інтерфейсу через виклики setState(), використав обов'язкові змінні стану різних типів (bool для обраного та перемикача терміновості, int для лічильника дій, String для зчитування тексту через onChanged у TextField), забезпечив зміну стилів, кольорів, показ бейджа та додаткового тексту відповідно до змін стану, а також перевірив стабільність роботи застосунку за допомогою автоматизованих тестів та на фізичному емуляторі Android.
