class Task {
  final String id;
  final String title;
  final String description;
  final int priority;
  final bool isCompleted;
  final DateTime created_at;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
    required this.created_at,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String,
      priority: json['priority'] as int,
      isCompleted: json['isCompleted'] as bool,
      created_at: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'isCompleted': isCompleted,
      'created_at': created_at.toIso8601String(),
    };
  }
}
