import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_typography.dart';

/// Екран 4: Проєкти та категорії — Варіант A (2-Column Bento Grid)
/// Цільові лабораторні: Лабораторна №3, №4, №6.
class ProjectsScreen extends StatelessWidget {
  final Function(String category) onSelectCategory;

  const ProjectsScreen({super.key, required this.onSelectCategory});

  @override
  Widget build(BuildContext context) {
    final projects = [
      _ProjectItem(
        title: 'ПМД Лабораторні',
        icon: '🎓',
        totalTasks: 10,
        completedTasks: 8,
        progress: 0.8,
        accentColor: AppColors.limePrimary,
      ),
      _ProjectItem(
        title: 'Курсова робота',
        icon: '💼',
        totalTasks: 11,
        completedTasks: 5,
        progress: 0.45,
        accentColor: AppColors.cyanAccent,
      ),
      _ProjectItem(
        title: 'Робочий IT проєкт',
        icon: '💻',
        totalTasks: 20,
        completedTasks: 12,
        progress: 0.60,
        accentColor: AppColors.cardPeachText,
      ),
      _ProjectItem(
        title: 'Особисті звички',
        icon: '🏃',
        totalTasks: 10,
        completedTasks: 9,
        progress: 0.90,
        accentColor: AppColors.cardBlueText,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgObsidian,
      appBar: AppBar(
        title: const Text('Проєкти та категорії'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add, color: AppColors.limePrimary),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '4 Активні розділи',
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Оберіть категорію для фільтрації задач',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: projects.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final p = projects[index];
                    return InkWell(
                      onTap: () => onSelectCategory(p.title),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(p.icon, style: const TextStyle(fontSize: 26)),
                                Text(
                                  '${(p.progress * 100).toInt()}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: p.accentColor,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${p.completedTasks} з ${p.totalTasks} здано',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    value: p.progress,
                                    backgroundColor: AppColors.bgSurface,
                                    valueColor: AlwaysStoppedAnimation(p.accentColor),
                                    minHeight: 5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectItem {
  final String title;
  final String icon;
  final int totalTasks;
  final int completedTasks;
  final double progress;
  final Color accentColor;

  _ProjectItem({
    required this.title,
    required this.icon,
    required this.totalTasks,
    required this.completedTasks,
    required this.progress,
    required this.accentColor,
  });
}
