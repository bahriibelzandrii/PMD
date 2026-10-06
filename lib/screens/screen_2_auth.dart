import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_widgets.dart';

/// Екран 2: Авторизація та реєстрація — Варіант B (Таб-картка)
/// Цільові лабораторні: Лабораторна №8 (Валідація форми) та №10 (SharedPreferences сесія).
class AuthScreen extends StatefulWidget {
  final VoidCallback onSuccess;

  const AuthScreen({super.key, required this.onSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'student@univ.edu.ua');
  final _passwordController = TextEditingController(text: '123456');
  final _nameController = TextEditingController(text: 'Андрій Коваленко');
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgObsidian,
      appBar: AppBar(
        title: const Text('Вхід до системи'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Картка з табами
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Перемикач вкладок Вхід / Створити
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.bgSurface,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: AppColors.limePrimary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: AppColors.textInverse,
                          unselectedLabelColor: AppColors.textSecondary,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          tabs: const [
                            Tab(text: 'Вхід'),
                            Tab(text: 'Реєстрація'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Поля форми
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Email або логін',
                          hintText: 'student@univ.edu.ua',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (val) {
                          if (val == null || !val.contains('@')) {
                            return 'Введіть коректний email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          labelText: 'Пароль',
                          hintText: 'Введіть пароль',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (val) {
                          if (val == null || val.length < 6) {
                            return 'Мінімум 6 символів';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Запам'ятати мене
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Запам'ятати мене",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          Switch(
                            value: _rememberMe,
                            activeThumbColor: AppColors.limePrimary,
                            onChanged: (val) => setState(() => _rememberMe = val),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      AppButton(
                        text: 'Авторизуватись',
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Вхід через Campus ID
              OutlinedButton.icon(
                onPressed: widget.onSuccess,
                icon: const Icon(Icons.school_outlined, size: 20),
                label: const Text('Увійти через Campus ID ↗'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.cyanAccent,
                  side: const BorderSide(color: AppColors.borderSubtle),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
