class StackSelection {
  StackSelection({this.frontend, this.backend, this.database});

  StackSelection.empty() : frontend = null, backend = null, database = null;

  String? frontend;
  String? backend;
  String? database;

  bool get isValid {
    return (frontend ?? '').trim().isNotEmpty &&
        (backend ?? '').trim().isNotEmpty;
  }

  StackSelection copyWith({
    String? frontend,
    String? backend,
    String? database,
    bool clearDatabase = false,
  }) {
    return StackSelection(
      frontend: frontend ?? this.frontend,
      backend: backend ?? this.backend,
      database: clearDatabase ? null : (database ?? this.database),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'frontend': frontend ?? '',
      'backend': backend ?? '',
      'database': database ?? '',
    };
  }

  Map<String, dynamic> toJson() {
    return {'frontend': frontend, 'backend': backend, 'database': database};
  }

  static const List<String> frontendOptions = [
    'Flutter',
    'React',
    'iOS (Swift)',
    'Android (Kotlin)',
  ];

  static const List<String> backendOptions = [
    'Python (FastAPI / Django)',
    'Node.js (Express / NestJS)',
    'Supabase',
    'Firebase',
  ];

  static const List<String> databaseOptions = [
    'PostgreSQL',
    'MySQL',
    'MongoDB',
    'Supabase',
  ];
}
