import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/task_model.dart';

/// Екран 7: Створення завдання — Варіант C (Покроковий візард)
/// Цільові лабораторні: Лабораторна №8 (Форми введення, валідація, Navigator.pop з результатом).
class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  int _currentStep = 0;

  // Контролери
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _hoursController = TextEditingController(text: '2.0');
  final _subtaskController = TextEditingController();

  String _category = '🎓 Програмування МД';
  TaskPriority _priority = TaskPriority.medium;
  DateTime _deadline = DateTime.now().add(const Duration(days: 3));
  final List<String> _initialSubtasks = [];

  final List<String> _categories = [
    '🎓 Програмування МД',
    '💼 Курсова робота',
    '💻 IT Проєкт',
    '🏃 Особисті справи',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _hoursController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  void _finish() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введіть назву завдання на першому кроці!')),
      );
      return;
    }

    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: _priority,
      status: TaskStatus.todo,
      category: _category,
      deadline: _deadline,
      estimatedHours: double.tryParse(_hoursController.text) ?? 1.0,
      subtasks: _initialSubtasks
          .map((s) => Subtask(
                id: UniqueKey().toString(),
                title: s,
                isCompleted: false,
              ))
          .toList(),
    );

    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgObsidian,
      appBar: AppBar(
        title: const Text('Нове завдання (Візард)'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.limePrimary,
                ),
          ),
          child: Stepper(
            type: StepperType.vertical,
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() => _currentStep += 1);
              } else {
                _finish();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              } else {
                Navigator.pop(context);
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.limePrimary,
                        foregroundColor: AppColors.textInverse,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      ),
                      child: Text(
                        _currentStep == 2 ? 'Створити завдання ✓' : 'Далі →',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: Text(
                        _currentStep == 0 ? 'Скасувати' : 'Назад',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              );
            },
            steps: [
              // Крок 1: Суть завдання
              Step(
                title: const Text('Суть завдання', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Назва, опис та категорія', style: TextStyle(fontSize: 11)),
                isActive: _currentStep >= 0,
                content: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Назва завдання *',
                        hintText: 'Наприклад: Звіт до Лаб 8',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      dropdownColor: AppColors.bgCard,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'Категорія'),
                      items: _categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _category = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descController,
                      maxLines: 2,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Опис та вимоги',
                        hintText: 'Вимоги викладача...',
                      ),
                    ),
                  ],
                ),
              ),

              // Крок 2: Терміни та пріоритет
              Step(
                title: const Text('Терміни та пріоритет', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Дедлайн, пріоритет, оцінка часу', style: TextStyle(fontSize: 11)),
                isActive: _currentStep >= 1,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Пріоритет:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildPriorityChip('Низький', TaskPriority.low),
                        const SizedBox(width: 8),
                        _buildPriorityChip('Середній', TaskPriority.medium),
                        const SizedBox(width: 8),
                        _buildPriorityChip('Високий 🔥', TaskPriority.high),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Дедлайн', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      subtitle: Text(
                        '${_deadline.day}.${_deadline.month}.${_deadline.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                      ),
                      trailing: const Icon(Icons.calendar_month, color: AppColors.limePrimary),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _deadline,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) setState(() => _deadline = picked);
                      },
                    ),
                    TextField(
                      controller: _hoursController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Оцінка часу (години)',
                        prefixIcon: Icon(Icons.timer_outlined),
                      ),
                    ),
                  ],
                ),
              ),

              // Крок 3: Чеклист підзавдань
              Step(
                title: const Text('Підзавдання (Чеклист)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Додайте початкові пункти', style: TextStyle(fontSize: 11)),
                isActive: _currentStep >= 2,
                content: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _subtaskController,
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                            decoration: const InputDecoration(hintText: 'Новий пункт...'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            final val = _subtaskController.text.trim();
                            if (val.isNotEmpty) {
                              setState(() {
                                _initialSubtasks.add(val);
                                _subtaskController.clear();
                              });
                            }
                          },
                          icon: const Icon(Icons.add, color: AppColors.limePrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._initialSubtasks.map((s) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.check_box_outline_blank, size: 18, color: AppColors.textMuted),
                          title: Text(s, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String label, TaskPriority p) {
    final isSelected = _priority == p;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _priority = p),
      selectedColor: AppColors.limePrimary,
      backgroundColor: AppColors.bgSurface,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.textInverse : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}
