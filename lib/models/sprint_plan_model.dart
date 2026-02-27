import 'stack_model.dart';

class Subtask {
  Subtask({required this.name, required this.storyPoints});

  final String name;
  final int storyPoints;

  Subtask.fromJson(Map<String, dynamic> json)
    : name = json['name'] as String,
      storyPoints = _asInt(json['story_points']);

  Map<String, dynamic> toJson() => {'name': name, 'story_points': storyPoints};
}

class SprintTask {
  SprintTask({
    required this.id,
    required this.name,
    required this.description,
    required this.storyPoints,
    required this.subtasks,
    required this.acceptanceCriteria,
    required this.risks,
  });

  final String id;
  final String name;
  final String description;
  final int storyPoints;
  final List<Subtask> subtasks;
  final List<String> acceptanceCriteria;
  final List<String> risks;

  SprintTask.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      name = json['name'] as String,
      description = json['description'] as String,
      storyPoints = _asInt(json['story_points']),
      subtasks = (json['subtasks'] as List<dynamic>)
          .map((item) => Subtask.fromJson(item as Map<String, dynamic>))
          .toList(),
      acceptanceCriteria = (json['acceptance_criteria'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      risks = (json['risks'] as List<dynamic>)
          .map((item) => item as String)
          .toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'story_points': storyPoints,
    'subtasks': subtasks.map((s) => s.toJson()).toList(),
    'acceptance_criteria': acceptanceCriteria,
    'risks': risks,
  };
}

class Epic {
  Epic({
    required this.id,
    required this.name,
    required this.description,
    required this.storyPoints,
    required this.tasks,
  });

  final String id;
  final String name;
  final String description;
  final int storyPoints;
  final List<SprintTask> tasks;

  Epic.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      name = json['name'] as String,
      description = json['description'] as String,
      storyPoints = _asInt(json['story_points']),
      tasks = (json['tasks'] as List<dynamic>)
          .map((item) => SprintTask.fromJson(item as Map<String, dynamic>))
          .toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'story_points': storyPoints,
    'tasks': tasks.map((t) => t.toJson()).toList(),
  };
}

class SprintPlan {
  SprintPlan({
    required this.projectTitle,
    required this.stack,
    required this.epics,
  });

  final String projectTitle;
  final StackSelection stack;
  final List<Epic> epics;

  SprintPlan.fromJson(Map<String, dynamic> json)
    : projectTitle = json['project_title'] as String,
      stack = _stackFromJson(json['stack'] as Map<String, dynamic>),
      epics = (json['epics'] as List<dynamic>)
          .map((item) => Epic.fromJson(item as Map<String, dynamic>))
          .toList();

  Map<String, dynamic> toJson() => {
    'project_title': projectTitle,
    'stack': {
      'frontend': stack.frontend,
      'backend': stack.backend,
      'database': stack.database,
    },
    'epics': epics.map((e) => e.toJson()).toList(),
  };
}

StackSelection _stackFromJson(Map<String, dynamic> json) {
  return StackSelection(
    frontend: json['frontend'] as String?,
    backend: json['backend'] as String?,
    database: json['database'] as String?,
  );
}

int _asInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}
