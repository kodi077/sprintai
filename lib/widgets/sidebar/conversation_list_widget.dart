import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_constants.dart';
import '../../models/conversation_model.dart' show ConversationModel;
import '../../models/message_model.dart' show MessageModel;
import '../../models/sprint_plan_model.dart';
import '../../providers/app_provider.dart';
import '../../services/database_service.dart';

class ConversationListWidget extends StatelessWidget {
  const ConversationListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    if (provider.currentUser == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '로그인하면 대화 기록이 표시됩니다.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }

    if (provider.conversations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '대화 기록이 없습니다.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }

    return ListView.builder(
      itemCount: provider.conversations.length,
      itemBuilder: (BuildContext context, int index) {
        final ConversationModel conversation = provider.conversations[index];
        return ListTile(
          title: Text(
            conversation.title,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () async {
            provider.setActiveConversation(conversation);
            provider.setSprintPlan(null);
            provider.setLoading(true);
            provider.setError(null);
            try {
              final dbService = DatabaseService();
              final messages = await dbService.fetchMessages(conversation.id);
              final MessageModel assistantMsg = messages.lastWhere(
                (m) => m.role == 'assistant',
                orElse: () => throw Exception('No assistant message found'),
              );
              final jsonMap =
                  jsonDecode(assistantMsg.content) as Map<String, dynamic>;
              final plan = SprintPlan.fromJson(jsonMap);
              provider.setSprintPlan(plan);
            } catch (_) {
              provider.setError('대화를 불러오는 데 실패했습니다.');
            } finally {
              provider.setLoading(false);
            }
          },
          selected: conversation.id == provider.activeConversation?.id,
          selectedTileColor: AppColors.primary.withValues(alpha: 0.15),
        );
      },
    );
  }
}
