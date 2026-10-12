import 'dart:convert';

/// Перелік можливих статусів завдання (enum)
enum TaskStatus { active, done }

/// Модель завдання (Model class) із 4 обов'язковими типами полів:
/// - int (ідентифікатор)
/// - String (назва завдання)
/// - bool (прапорець обраного)
/// - enum TaskStatus (поточний статус виконання)
class TaskModel {
  final int id;
  String title;
  bool isFavorite;
  TaskStatus status;

  TaskModel({
    required this.id,
    required this.title,
    this.isFavorite = false,
    this.status = TaskStatus.active,
  });

  /// Конструктор для створення об'єкта з JSON (п. 6 ТЗ)
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      status: json['status'] == 'done' ? TaskStatus.done : TaskStatus.active,
    );
  }

  /// Метод для серіалізації об'єкта у JSON-мапу (п. 6 ТЗ)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isFavorite': isFavorite,
      'status': status.name,
    };
  }

  /// Зручний геттер для перевірки завершеності
  bool get isDone => status == TaskStatus.done;

  /// Метод для створення модифікованої копії
  TaskModel copyWith({
    int? id,
    String? title,
    bool? isFavorite,
    TaskStatus? status,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isFavorite: isFavorite ?? this.isFavorite,
      status: status ?? this.status,
    );
  }
}

/// Перетворення JSON-рядка у список моделей (п. 7 ТЗ)
List<TaskModel> tasksFromJson(String jsonString) {
  final List<dynamic> data = jsonDecode(jsonString) as List<dynamic>;
  return data
      .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
      .toList();
}

/// Серіалізація списку моделей у відформатований JSON-рядок
String tasksToJson(List<TaskModel> tasks) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(tasks.map((e) => e.toJson()).toList());
}
