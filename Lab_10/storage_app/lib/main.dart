import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'models/user_model.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/registration_screen.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StorageApp());
}

/// Головний віджет застосунку (п. 4, 8, 10 ТЗ)
class StorageApp extends StatefulWidget {
  final StorageService? storageService;

  const StorageApp({super.key, this.storageService});

  @override
  State<StorageApp> createState() => _StorageAppState();
}

class _StorageAppState extends State<StorageApp> {
  late final StorageService _storageService;

  bool _isLoading = true;
  UserModel? _currentUser;
  List<String> _favoriteIds = [];

  @override
  void initState() {
    super.initState();
    _storageService = widget.storageService ?? StorageService();
    _bootstrap();
  }

  /// Завантаження даних користувача та favorites ids після запуску (п. 4, 8 ТЗ)
  Future<void> _bootstrap() async {
    setState(() => _isLoading = true);

    final user = await _storageService.loadUser();
    final favIds = await _storageService.loadFavoriteIds();

    if (!mounted) return;
    setState(() {
      _currentUser = user;
      _favoriteIds = favIds;
      _isLoading = false;
    });
  }

  /// Обробник успішної реєстрації
  Future<void> _handleRegistrationSuccess() async {
    final user = await _storageService.loadUser();
    final favIds = await _storageService.loadFavoriteIds();
    setState(() {
      _currentUser = user;
      _favoriteIds = favIds;
    });
  }

  /// Обробник виходу з профілю
  Future<void> _handleLogout() async {
    await _storageService.clearUser();
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Локальне збереження даних — Лабораторна №10',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0.5,
          centerTitle: true,
        ),
      ),
      home: _isLoading
          ? const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Завантаження даних із SharedPreferences...',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : _currentUser == null
              ? RegistrationScreen(
                  storageService: _storageService,
                  onRegistered: _handleRegistrationSuccess,
                )
              : MainNavigationScreen(
                  storageService: _storageService,
                  initialUser: _currentUser!,
                  initialFavoriteIds: _favoriteIds,
                  onLogout: _handleLogout,
                ),
    );
  }
}
