import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

/// Екран реєстрації користувача (п. 2, 3 ТЗ)
/// Зберігає ім'я, email, пароль та супутні поля у SharedPreferences
class RegistrationScreen extends StatefulWidget {
  final StorageService storageService;
  final VoidCallback onRegistered;
  final UserModel? initialUser;

  const RegistrationScreen({
    super.key,
    required this.storageService,
    required this.onRegistered,
    this.initialUser,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final init = widget.initialUser;
    _nameController = TextEditingController(text: init?.name ?? '');
    _emailController = TextEditingController(text: init?.email ?? '');
    _passwordController = TextEditingController(text: init?.password ?? '');
    _phoneController = TextEditingController(
      text: init?.phone ?? '+380 67 123 45 67',
    );
    _bioController = TextEditingController(
      text: init?.bio ?? 'Студент НУ «Львівська політехніка», група КН-2327Б',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _fillDemoData() {
    setState(() {
      _nameController.text = 'Багрій-Белз Андрій';
      _emailController.text = 'andrii.bagriy@nulp.ua';
      _passwordController.text = 'SecurePass2026!';
      _phoneController.text = '+380 67 987 65 43';
      _bioController.text = 'Студент групи КН-2327Б | Лабораторна робота №10';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Демо-дані успішно підставлено у форму'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final user = UserModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phone: _phoneController.text.trim(),
      bio: _bioController.text.trim(),
      registeredAt: DateTime.now().toLocal().toString().split('.')[0],
    );

    // Збереження даних користувача у SharedPreferences (п. 2, 3 ТЗ)
    await widget.storageService.saveUser(user);

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Дані успішно збережено в SharedPreferences!'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );

    widget.onRegistered();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Реєстрація користувача'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Іконка та заголовок
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Створення профілю',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Введені дані будуть локально збережені у SharedPreferences та відновлюватимуться при повторному запуску',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),

                // 1. Поле імені користувача (п. 3.a)
                TextFormField(
                  key: const Key('name_field'),
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Ім’я користувача *',
                    hintText: 'Введіть ваше ім’я або ПІБ',
                    prefixIcon: const Icon(Icons.badge_outlined),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Будь ласка, вкажіть ім’я користувача';
                    }
                    if (value.trim().length < 2) {
                      return 'Ім’я має містити щонайменше 2 символи';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 2. Поле email (п. 3.b)
                TextFormField(
                  key: const Key('email_field'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Електронна пошта (email) *',
                    hintText: 'example@domain.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Будь ласка, введіть email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Введіть коректну адресу email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 3. Поле пароля (п. 3.c)
                TextFormField(
                  key: const Key('password_field'),
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Пароль *',
                    hintText: 'Введіть безпечний пароль',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Будь ласка, введіть пароль';
                    }
                    if (value.trim().length < 4) {
                      return 'Пароль має містити не менше 4 символів';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 4. Додаткове поле номера телефону
                TextFormField(
                  key: const Key('phone_field'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Номер телефону',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Поле опису/статусу/групи
                TextFormField(
                  key: const Key('bio_field'),
                  controller: _bioController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Статус / Навчальна група',
                    prefixIcon: const Icon(Icons.school_outlined),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Кнопка реєстрації
                ElevatedButton(
                  key: const Key('register_button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _isLoading ? null : _submitRegistration,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Зареєструватися та зберегти дані',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 12),

                // Кнопка швидкого демо-заповнення
                OutlinedButton.icon(
                  key: const Key('demo_fill_button'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('Заповнити демо-даними (КН-2327Б)'),
                  onPressed: _fillDemoData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
