import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/task_model.dart';

/// Екран 8: Обрані завдання — Варіант C (Групування за категоріями)
/// Цільові лабораторні: Лабораторна №6 (Колекції Map/List) та №10 (SharedPreferences favorites_ids).
class FavoritesScreen extends StatefulWidget {
  final Function(TaskModel) onTaskTap;

  const FavoritesScreen({super.key, required this.onTaskTap});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Список обраних задач
  late List<TaskModel> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = [
      TaskModel(
        id: 'f1',
        title: 'Захист Лабораторної №5',
        description: 'Демонстрація StatefulWidget та чеклиста підзадач',
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        category: '🎓 Лабораторні (ПМД)',
        isFavorite: true,
      ),
      TaskModel(
        id: 'f2',
        title: 'Звіт до Лабораторної №6',
        description: 'Опис моделей та фільтрації завдань',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        category: '🎓 Лабораторні (ПМД)',
        isFavorite: true,
      ),
      TaskModel(
        id: 'f3',
        title: 'Скласти діаграму класів БД',
        description: 'Сутності, зв\'язки 1:N та M:N для курсової',
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        category: '💼 Курсовий проєкт',
        isFavorite: true,
      ),
      TaskModel(
        id: 'f4',
        title: 'Підготувати презентацію захисту',
        description: '10 слайдів з результатами розробки',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        category: '💼 Курсовий проєкт',
        isFavorite: true,
      ),
    ];
  }

  void _removeFavorite(TaskModel task) {
    setState(() {
      task.isFavorite = false;
      _favorites.removeWhere((t) => t.id == task.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Групування за категоріями (Лаб 6: Map<String, List<TaskModel>>)
    final Map<String, List<TaskModel>> grouped = {};
    for (var task in _favorites) {
      grouped.putIfAbsent(task.category, () => []).add(task);
    }

    return Scaffold(
      backgroundColor: AppColors.bgObsidian,
      appBar: AppBar(
        title: const Text('Обрані завдання'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Інформаційний банер про сховище (Лаб 10)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bookmark_added_rounded, color: AppColors.limePrimary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Синхронізація: ${_favorites.length} задач у favorites_ids (SharedPreferences)',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (_favorites.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'Список обраного порожній.\nДодайте завдання через зірочку ★',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ...grouped.entries.map((entry) {
                final categoryName = entry.key;
                final tasks = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.limePrimary,
                        ),
                      ),
                    ),
                    ...tasks.map((task) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: AppColors.bgCard,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: AppColors.borderSubtle),
                        ),
                        child: ListTile(
                          onTap: () => widget.onTaskTap(task),
                          title: Text(
                            task.title,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          subtitle: Text(
                            task.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.star_rounded, color: AppColors.limePrimary, size: 24),
                            onPressed: () => _removeFavorite(task),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }
}
