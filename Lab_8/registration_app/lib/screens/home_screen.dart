import 'package:flutter/material.dart';

/// Головний екран HomeScreen (п. 8 ТЗ)
/// Отримує ім'я користувача (п. 9 ТЗ) та інші дані реєстрації
class HomeScreen extends StatelessWidget {
  final String username;
  final String? email;
  final String? birthDate;

  const HomeScreen({
    super.key,
    required this.username,
    this.email,
    this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F13),
      appBar: AppBar(
        title: const Text(
          'Головний екран',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF15181F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF8B949E)),
          tooltip: 'Назад',
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFFF5252)),
            tooltip: 'Вийти з акаунта',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              // 1. Картка привітання (п. 10 ТЗ: «Вітаємо, Ім’я!»)
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1F2430), Color(0xFF15181F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD4FF00), width: 1.5),
                  boxShadow: [
                    BoxStyle(
                      color: const Color(0xFFD4FF00).withValues(alpha: 0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4FF00).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFFD4FF00),
                        size: 54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Вітаємо, $username! 🎉',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Реєстрація пройшла успішно! Валідацію всіх полів форми пройдено без помилок.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8B949E),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 2. Блок відображення переданих даних
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF15181F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2A3142)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.badge_outlined, color: Color(0xFF4FC3F7), size: 22),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Дані зареєстрованого профілю',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF2A3142), height: 24),
                    _buildDataRow(
                      icon: Icons.person_outline,
                      label: "Ім'я користувача:",
                      value: username,
                      highlight: true,
                    ),
                    if (email != null && email!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildDataRow(
                        icon: Icons.email_outlined,
                        label: 'Електронна пошта:',
                        value: email!,
                      ),
                    ],
                    if (birthDate != null && birthDate!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildDataRow(
                        icon: Icons.cake_outlined,
                        label: 'Дата народження:',
                        value: birthDate!,
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildDataRow(
                      icon: Icons.verified_user_outlined,
                      label: 'Статус акаунта:',
                      value: 'Активний / Верифікований',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 3. Кнопка виходу / повернення на екран реєстрації
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD4FF00),
                  side: const BorderSide(color: Color(0xFFD4FF00), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'Повернутися до реєстрації',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF8B949E)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF8B949E),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
              color: highlight ? const Color(0xFFD4FF00) : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class BoxStyle extends BoxShadow {
  const BoxStyle({
    required super.color,
    required super.blurRadius,
    required super.spreadRadius,
  });
}
