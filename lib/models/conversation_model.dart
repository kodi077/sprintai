import 'sprint_plan_model.dart';

class ConversationModel {
  ConversationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.frontendStack,
    required this.backendStack,
    required this.databaseStack,
    required this.createdAt,
  });

  final String id;
  final String? userId;
  final String title;
  final String frontendStack;
  final String backendStack;
  final String? databaseStack;
  final DateTime createdAt;

  ConversationModel.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      userId = json['user_id'] as String?,
      title = json['title'] as String,
      frontendStack = json['frontend_stack'] as String,
      backendStack = json['backend_stack'] as String,
      databaseStack = json['database_stack'] as String?,
      createdAt = DateTime.parse(json['created_at'] as String);

  Map<String, dynamic> toInsertMap() => {
    'user_id': userId,
    'title': title,
    'frontend_stack': frontendStack,
    'backend_stack': backendStack,
    'database_stack': databaseStack,
  };
}

class MessageModel {
  MessageModel({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String conversationId;
  final String role;
  final String content;
  final DateTime createdAt;

  MessageModel.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      conversationId = json['conversation_id'] as String,
      role = json['role'] as String,
      content = json['content'] as String,
      createdAt = DateTime.parse(json['created_at'] as String);

  Map<String, dynamic> toInsertMap() => {
    'conversation_id': conversationId,
    'role': role,
    'content': content,
  };
}

class Conversation {
  Conversation({
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
