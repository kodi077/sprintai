class SprintPlan {
  const SprintPlan({
    required this.projectTitle,
    required this.stack,
    required this.epics,
  });

  final String projectTitle;
  final SprintStack stack;
  final List<Epic> epics;

  factory SprintPlan.fromJson(Map<String, dynamic> json) {
    return SprintPlan(
      projectTitle: json['project_title'] as String? ?? 'Untitled Project',
      stack: SprintStack.fromJson((json['stack'] as Map?)?.cast<String, dynamic>() ?? const {}),
      epics: ((json['epics'] as List?) ?? const [])
          .whereType<Map>()
          .map((item) => Epic.fromJson(item.cast<String, dynamic>()))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project_title': projectTitle,
      'stack': stack.toJson(),
      'epics': epics.map((item) => item.toJson()).toList(),
    };
  }
}

class SprintStack {
  const SprintStack({
    required this.frontend,
    required this.backend,
    required this.database,
  });

  final String frontend;
  final String backend;
  final String? database;

  factory SprintStack.fromJson(Map<String, dynamic> json) {
    return SprintStack(
      frontend: json['frontend'] as String? ?? '',
      backend: json['backend'] as String? ?? '',
      database: json['database'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frontend': frontend,
      'backend': backend,
      'database': database,
    };
  }
}

class Epic {
  const Epic({
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

  factory Epic.fromJson(Map<String, dynamic> json) {
    return Epic(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      storyPoints: _toInt(json['story_points']),
      tasks: ((json['tasks'] as List?) ?? const [])
          .whereType<Map>()
          .map((item) => SprintTask.fromJson(item.cast<String, dynamic>()))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'story_points': storyPoints,
      'tasks': tasks.map((item) => item.toJson()).toList(),
    };
  }
}

class SprintTask {
  const SprintTask({
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

  factory SprintTask.fromJson(Map<String, dynamic> json) {
    return SprintTask(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      storyPoints: _toInt(json['story_points']),
      subtasks: ((json['subtasks'] as List?) ?? const [])
          .whereType<Map>()
          .map((item) => Subtask.fromJson(item.cast<String, dynamic>()))
          .toList(),
      acceptanceCriteria: ((json['acceptance_criteria'] as List?) ?? const [])
          .map((item) => item.toString())
          .toList(),
      risks: ((json['risks'] as List?) ?? const []).map((item) => item.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'story_points': storyPoints,
      'subtasks': subtasks.map((item) => item.toJson()).toList(),
      'acceptance_criteria': acceptanceCriteria,
      'risks': risks,
    };
  }
}

class Subtask {
  const Subtask({
    required this.name,
    required this.storyPoints,
  });

  final String name;
  final int storyPoints;

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      name: json['name'] as String? ?? '',
      storyPoints: _toInt(json['story_points']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'story_points': storyPoints,
    };
  }
}

int _toInt(dynamic value) {
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
