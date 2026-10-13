import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../theme/app_theme.dart';
import 'task_manager_screen.dart';

/// Екран реєстрації користувача RegisterScreen (п. 1 ТЗ)
class RegisterScreen extends StatefulWidget {
  /// Колбек перемикання теми, який передається далі по навігації (п. 2 ТЗ ЛР 9)
  final ValueChanged<bool>? onToggleTheme;

  const RegisterScreen({super.key, this.onToggleTheme});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Ключ форми для централізованої валідації (п. 2 ТЗ)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController для кожного поля форми (п. 6 ТЗ)
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Стан видимості паролів
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    // Обов'язкове звільнення ресурсів контролерів для запобігання витокам пам'яті
    _usernameController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Вибір дати народження за допомогою DatePicker
  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = DateTime(2004, 1, 1);
    final DateTime firstDate = DateTime(1900);
    final DateTime lastDate = now;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Оберіть дату народження',
      cancelText: 'Скасувати',
      confirmText: 'Обрати',
      builder: (context, child) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: (isDark ? AppTheme.darkTheme : AppTheme.lightTheme).copyWith(
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.card(isDark),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final String formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() {
        _birthDateController.text = formatted;
      });
    }
  }

  // Обробник натискання кнопки «Зареєструватися» (п. 7, 8, 13 ТЗ)
  void _submitForm() {
    // Перевірка валідації форми перед переходом (п. 13 ТЗ)
    if (_formKey.currentState!.validate()) {
      final String username = _usernameController.text.trim();
      final String email = _emailController.text.trim();

      // Навігація на TaskManagerScreen із передачею даних користувача
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskManagerScreen(
            username: username,
            email: email,
            onToggleTheme: widget.onToggleTheme,
          ),
        ),
      );
    } else {
      // Якщо є помилки, інформуємо користувача через SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Будь ласка, виправте виділені помилки у формі!',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.alert,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Допоміжна функція швидкого заповнення демо-даними
  void _fillDemoData() {
    setState(() {
      _usernameController.text = 'Андрій Багрій-Белз';
      _birthDateController.text = '2004-05-15';
      _emailController.text = 'andrii.bagriy@nulp.ua';
      _passwordController.text = 'flutter2026';
      _confirmPasswordController.text = 'flutter2026';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Оформлення з використанням Scaffold, AppBar, Padding, Column (п. 12 ТЗ)
    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      appBar: AppBar(
        title: Text(
          'Реєстрація',
          style: AppStyles.title(isDark: isDark).copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.card(isDark),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Заповнити тестовими даними',
            icon: Icon(Icons.auto_fix_high, color: AppColors.accent(isDark)),
            onPressed: _fillDemoData,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey, // Прив'язка Form до _formKey (п. 2 ТЗ)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Заголовок форми
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.accent(isDark).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accent(isDark).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                      color: AppColors.accent(isDark),
                      size: 38,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Створіть свій обліковий запис',
                  textAlign: TextAlign.center,
                  style: AppStyles.title(isDark: isDark).copyWith(fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  'Заповніть усі обов’язкові поля для входу в систему',
                  textAlign: TextAlign.center,
                  style: AppStyles.subtitle(isDark: isDark)
                      .copyWith(fontSize: 13),
                ),
                const SizedBox(height: 24),

                // 1. Поле: ім’я користувача (п. 3, 4, 5 ТЗ)
                TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.name,
                  style: TextStyle(color: AppColors.text(isDark)),
                  decoration: _inputDecoration(
                    isDark: isDark,
                    labelText: "Ім'я користувача",
                    hintText: 'Введіть ваше ім’я або нікнейм',
                    prefixIcon: Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Поле імені користувача не може бути порожнім";
                    }
                    if (value.trim().length < 3) {
                      return "Ім'я користувача повинно містити щонайменше 3 символи";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 2. Поле: дата народження (п. 3, 4, 5 ТЗ)
                TextFormField(
                  controller: _birthDateController,
                  readOnly: false,
                  keyboardType: TextInputType.datetime,
                  style: TextStyle(color: AppColors.text(isDark)),
                  decoration: _inputDecoration(
                    isDark: isDark,
                    labelText: 'Дата народження',
                    hintText: 'РРРР-ММ-ДД або ДД.ММ.РРРР',
                    prefixIcon: Icons.cake_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.accent(isDark),
                      ),
                      tooltip: 'Обрати дату з календаря',
                      onPressed: () => _selectBirthDate(context),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введіть дату народження';
                    }
                    final trimmed = value.trim();
                    // Перевірка формату дати: РРРР-ММ-ДД або ДД.ММ.РРРР
                    final dateRegex = RegExp(
                      r'^((\d{4}[-/.]\d{2}[-/.]\d{2})|(\d{2}[-/.]\d{2}[-/.]\d{4}))$',
                    );
                    if (!dateRegex.hasMatch(trimmed)) {
                      return 'Некоректний формат дати (приклад: 2004-05-15 або 15.05.2004)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 3. Поле: email (п. 3, 4, 5 ТЗ)
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: AppColors.text(isDark)),
                  decoration: _inputDecoration(
                    isDark: isDark,
                    labelText: 'Електронна пошта (Email)',
                    hintText: 'user@example.com',
                    prefixIcon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введіть адресу електронної пошти';
                    }
                    final trimmed = value.trim();
                    if (!trimmed.contains('@')) {
                      return 'Email повинен містити символ @';
                    }
                    if (!trimmed.contains('.') ||
                        trimmed.indexOf('@') > trimmed.lastIndexOf('.')) {
                      return 'Email повинен містити коректне доменне ім’я';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 4. Поле: пароль (п. 3, 4, 5 ТЗ)
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(color: AppColors.text(isDark)),
                  decoration: _inputDecoration(
                    isDark: isDark,
                    labelText: 'Пароль',
                    hintText: 'Не менше 6 символів',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary(isDark),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введіть пароль';
                    }
                    if (value.length < 6) {
                      return 'Пароль повинен містити не менше 6 символів';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 5. Поле: підтвердження пароля (п. 3, 4, 5 ТЗ)
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: TextStyle(color: AppColors.text(isDark)),
                  decoration: _inputDecoration(
                    isDark: isDark,
                    labelText: 'Підтвердження пароля',
                    hintText: 'Повторіть введений пароль',
                    prefixIcon: Icons.lock_reset_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary(isDark),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Підтвердіть пароль';
                    }
                    if (value != _passwordController.text) {
                      return 'Поле підтвердження пароля повинно збігатися з паролем';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // 6. Кнопка «Зареєструватися» (п. 7 ТЗ)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent(isDark),
                    foregroundColor: AppColors.onAccent(isDark),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  onPressed: _submitForm,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.how_to_reg, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Зареєструватися',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Пояснювальний статус
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.card(isDark),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border(isDark)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.secondary,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Усі поля перевіряються автоматично. Перехід на головний екран можливий лише за відсутності помилок.',
                          style: AppStyles.caption(isDark: isDark)
                              .copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Загальний стиль оформлення текстових полів
  InputDecoration _inputDecoration({
    required bool isDark,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: AppColors.textSecondary(isDark),
        fontSize: 14,
      ),
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.textHint(isDark), fontSize: 13),
      prefixIcon: Icon(
        prefixIcon,
        color: AppColors.textSecondary(isDark),
        size: 20,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.card(isDark),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border(isDark)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border(isDark)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.accent(isDark), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
    );
  }
}
