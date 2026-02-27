import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_constants.dart';
import '../../models/conversation_model.dart';
import '../../providers/app_provider.dart';

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
          onTap: () {},
          selected: conversation.id == provider.activeConversation?.id,
          selectedTileColor: AppColors.primary.withValues(alpha: 0.15),
        );
      },
    );
  }
}
