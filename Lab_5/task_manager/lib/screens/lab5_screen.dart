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
