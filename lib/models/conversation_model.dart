import 'sprint_plan_model.dart';

class Conversation {
  const Conversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.plan,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final SprintPlan plan;
}
