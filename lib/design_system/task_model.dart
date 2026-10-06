/// Enums and Data Models for TaskMaster (Lab 6, 7, 8, 10)

enum TaskPriority {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Низький';
      case TaskPriority.medium:
        return 'Середній';
      case TaskPriority.high:
        return 'Високий 🔥';
    }
  }

  static TaskPriority fromString(String val) {
    switch (val.toLowerCase()) {
      case 'high':
        return TaskPriority.high;
      case 'medium':
        return TaskPriority.medium;
      case 'low':
      default:
        return TaskPriority.low;
    }
  }
}

enum TaskStatus {
  todo,
  inProgress,
  review,
  completed;

  static const TaskStatus done = TaskStatus.completed;
  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return 'До виконання';
      case TaskStatus.inProgress:
        return 'В процесі';
      case TaskStatus.review:
        return 'На перевірці';
      case TaskStatus.completed:
        return 'Виконано';
    }
  }

  static TaskStatus fromString(String val) {
    switch (val.toLowerCase()) {
      case 'inprogress':
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'review':
        return TaskStatus.review;
      case 'completed':
      case 'done':
        return TaskStatus.completed;
      case 'todo':
      default:
        return TaskStatus.todo;
    }
  }
}

typedef Subtask = SubtaskModel;

class SubtaskModel {
  final String id;
  final String title;
  bool isCompleted;

  SubtaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
  SubtaskModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return SubtaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
      };

  factory SubtaskModel.fromJson(Map<String, dynamic> json) => SubtaskModel(
        id: json['id'] as String,
        title: json['title'] as String,
        isCompleted: json['isCompleted'] as bool? ?? false,
      );
}

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final TaskPriority priority;
  TaskStatus status;
  final DateTime dueDate;
  final double estimatedHours;
  bool isFavorite;
  final List<SubtaskModel> subtasks;
  final List<String> attachments;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    DateTime? dueDate,
    DateTime? deadline,
    this.estimatedHours = 1.0,
    this.isFavorite = false,
    List<SubtaskModel>? subtasks,
    this.attachments = const [],
  })  : dueDate = dueDate ?? deadline ?? DateTime.now(),
        subtasks = subtasks != null ? List.from(subtasks) : [];

  DateTime get deadline => dueDate;
  bool get isCompleted => status == TaskStatus.completed;
  set isCompleted(bool val) {
    status = val ? TaskStatus.completed : TaskStatus.inProgress;
  }
  double get progress {
    if (subtasks.isEmpty) {
      return status == TaskStatus.completed ? 1.0 : 0.0;
    }
    final completedCount = subtasks.where((s) => s.isCompleted).length;
    return completedCount / subtasks.length;
  }

  int get completedSubtasksCount => subtasks.where((s) => s.isCompleted).length;

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    double? estimatedHours,
    bool? isFavorite,
    List<SubtaskModel>? subtasks,
    List<String>? attachments,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      isFavorite: isFavorite ?? this.isFavorite,
      subtasks: subtasks ?? this.subtasks,
      attachments: attachments ?? this.attachments,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'priority': priority.name,
        'status': status.name,
        'dueDate': dueDate.toIso8601String(),
        'estimatedHours': estimatedHours,
        'isFavorite': isFavorite,
        'subtasks': subtasks.map((s) => s.toJson()).toList(),
        'attachments': attachments,
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        category: json['category'] as String,
        priority: TaskPriority.fromString(json['priority'] as String? ?? 'medium'),
        status: TaskStatus.fromString(json['status'] as String? ?? 'todo'),
        dueDate: DateTime.parse(json['dueDate'] as String),
        estimatedHours: (json['estimatedHours'] as num?)?.toDouble() ?? 1.0,
        isFavorite: json['isFavorite'] as bool? ?? false,
        subtasks: (json['subtasks'] as List<dynamic>?)
                ?.map((e) => SubtaskModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        attachments: (json['attachments'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );
}

class ProjectModel {
  final String id;
  final String name;
  final String tag;
  final int totalTasks;
  final int completedTasks;
  final String colorHex;

  ProjectModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.totalTasks,
    required this.completedTasks,
    required this.colorHex,
  });

  double get progressPercentage =>
      totalTasks == 0 ? 0.0 : (completedTasks / totalTasks);
}
