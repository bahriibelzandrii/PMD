import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/course_item.dart';

/// Екран списку обраних курсів (п. 8, 9 ТЗ)
/// Відображає виключно ті елементи, id яких збережені у SharedPreferences
class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteIds;
  final ValueChanged<String> onToggleFavorite;
  final VoidCallback onClearAllFavorites;
  final VoidCallback onNavigateToCatalog;

  const FavoritesScreen({
    super.key,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.onClearAllFavorites,
    required this.onNavigateToCatalog,
  });

  @override
  Widget build(BuildContext context) {
    // Фільтрація: відображаємо лише ті елементи, id яких містяться у favoriteIds (п. 9 ТЗ)
    final favoriteCourses = CourseItem.sampleCourses
        .where((c) => favoriteIds.contains(c.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Обрані курси'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        actions: [
          if (favoriteCourses.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Очистити все обране',
              onPressed: () => _confirmClearFavorites(context),
            ),
        ],
      ),
      body: SafeArea(
        child: favoriteCourses.isEmpty
            ? _buildEmptyState(context)
            : _buildFavoritesList(context, favoriteCourses),
      ),
    );
  }

  /// Відображення порожнього стану, коли в SharedPreferences немає збережених id
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.favorite.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 64,
                color: AppColors.favorite,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Список обраного порожній',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ви ще не додали жодного курсу. Перейдіть до каталогу та позначте серцем те, що вас цікавить.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.search),
              label: const Text('Перейти до каталогу'),
              onPressed: onNavigateToCatalog,
            ),
          ],
        ),
      ),
    );
  }

  /// Список збережених елементів
  Widget _buildFavoritesList(
    BuildContext context,
    List<CourseItem> favoriteCourses,
  ) {
    return Column(
      children: [
        // Інформаційний банер
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: AppColors.surface,
          child: Row(
            children: [
              const Icon(Icons.favorite, size: 20, color: AppColors.favorite),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Збережено елементів у SharedPreferences: ${favoriteCourses.length}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                'IDs: ${favoriteIds.join(", ")}',
                style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.border),

        // Список карток обраного
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favoriteCourses.length,
            itemBuilder: (context, index) {
              final course = favoriteCourses[index];

              return Card(
                key: Key('fav_card_${course.id}'),
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: AppColors.border,
                    width: 1.0,
                  ),
                ),
                color: AppColors.surface,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Іконка курсу
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: course.accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          course.icon,
                          color: course.accentColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Опис
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              course.category,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: course.accentColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${course.rating}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  course.duration,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Кнопка видалення з обраного
                      IconButton(
                        key: Key('remove_fav_${course.id}'),
                        icon: const Icon(
                          Icons.favorite,
                          color: AppColors.favorite,
                          size: 26,
                        ),
                        tooltip: 'Вилучити з обраного',
                        onPressed: () {
                          onToggleFavorite(course.id);
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '«${course.title}» вилучено з обраного',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmClearFavorites(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Очистити список обраного?'),
        content: const Text(
          'Усі збережені ідентифікатори курсів будуть видалені з SharedPreferences.',
        ),
        actions: [
          TextButton(
            child: const Text('Скасувати'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Очистити'),
            onPressed: () {
              Navigator.of(ctx).pop();
              onClearAllFavorites();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Список обраного повністю очищено'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
