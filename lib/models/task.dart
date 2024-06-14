import 'dart:convert';

class Task {
  String title;
  bool isCompleted;
  DateTime? dueDate;
  bool isAlarm;
  int? priority;
  List<SubTask> subTasks;

  Task({
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.isAlarm = false,
    this.priority,
    List<SubTask>? subTasks,
  }) : this.subTasks = subTasks ?? [];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isAlarm': isAlarm,
      'priority': priority,
      'subTasks': subTasks.map((subTask) => subTask.toJson()).toList(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isCompleted: json['isCompleted'],
      dueDate: json['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(json['dueDate']) : null,
      isAlarm: json['isAlarm'],
      priority: json['priority'],
      subTasks: (json['subTasks'] as List<dynamic>).map((subTaskJson) => SubTask.fromJson(subTaskJson)).toList(),
    );
  }
}

class SubTask {
  String title;
  bool isCompleted;

  SubTask({
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }
}
