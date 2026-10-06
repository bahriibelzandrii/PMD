import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import 'catalog_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'registration_screen.dart';

/// Головний навігаційний екран застосунку з BottomNavigationBar (п. 4, 8, 9 ТЗ)
class MainNavigationScreen extends StatefulWidget {
  final StorageService storageService;
  final UserModel initialUser;
  final List<String> initialFavoriteIds;
  final VoidCallback onLogout;

  const MainNavigationScreen({
    super.key,
    required this.storageService,
    required this.initialUser,
    required this.initialFavoriteIds,
    required this.onLogout,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late UserModel _currentUser;
  late List<String> _favoriteIds;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.initialUser;
    _favoriteIds = List<String>.from(widget.initialFavoriteIds);
  }

  /// Додавання / вилучення курсу з обраного (п. 6, 7 ТЗ)
  Future<void> _handleToggleFavorite(String id) async {
    await widget.storageService.toggleFavorite(id);
    final updated = await widget.storageService.loadFavoriteIds();
    setState(() {
      _favoriteIds = updated;
    });
  }

  /// Повне очищення списку обраного
  Future<void> _handleClearAllFavorites() async {
    await widget.storageService.clearFavorites();
    setState(() {
      _favoriteIds = [];
    });
  }

  /// Перехід у режим редагування профілю
  void _handleEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RegistrationScreen(
          storageService: widget.storageService,
          initialUser: _currentUser,
          onRegistered: () async {
            final reloaded = await widget.storageService.loadUser();
            if (reloaded != null) {
              setState(() {
                _currentUser = reloaded;
              });
            }
            if (ctx.mounted) {
              Navigator.of(ctx).pop();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      // Вкладка 0: Каталог курсів
      CatalogScreen(
        favoriteIds: _favoriteIds,
        onToggleFavorite: _handleToggleFavorite,
      ),

      // Вкладка 1: Обране (п. 8, 9 ТЗ)
      FavoritesScreen(
        favoriteIds: _favoriteIds,
        onToggleFavorite: _handleToggleFavorite,
        onClearAllFavorites: _handleClearAllFavorites,
        onNavigateToCatalog: () {
          setState(() => _currentIndex = 0);
        },
      ),

      // Вкладка 2: Профіль користувача (п. 5 ТЗ)
      ProfileScreen(
        user: _currentUser,
        favoritesCount: _favoriteIds.length,
        onEditProfile: _handleEditProfile,
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        destinations: [
          const NavigationDestination(
            key: Key('nav_catalog'),
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school, color: AppColors.primary),
            label: 'Каталог',
          ),
          NavigationDestination(
            key: const Key('nav_favorites'),
            icon: Badge(
              isLabelVisible: _favoriteIds.isNotEmpty,
              label: Text('${_favoriteIds.length}'),
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: Badge(
              isLabelVisible: _favoriteIds.isNotEmpty,
              label: Text('${_favoriteIds.length}'),
              child: const Icon(Icons.favorite, color: AppColors.favorite),
            ),
            label: 'Обране',
          ),
          NavigationDestination(
            key: const Key('nav_profile'),
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person, color: AppColors.primary),
            label: 'Профіль',
          ),
        ],
      ),
    );
  }
}
