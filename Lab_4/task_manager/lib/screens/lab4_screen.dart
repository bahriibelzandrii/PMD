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
