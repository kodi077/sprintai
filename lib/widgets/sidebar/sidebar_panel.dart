import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_constants.dart';
import '../../providers/app_state.dart';

class SidebarPanel extends StatelessWidget {
  const SidebarPanel({
    super.key,
    required this.onShowGuestHistoryNotice,
  });

  final VoidCallback onShowGuestHistoryNotice;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Container(
          color: AppColors.sidebar,
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                AppStrings.appTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSizes.padding),
              ElevatedButton.icon(
                onPressed: state.startNewConversation,
                icon: const Icon(Icons.add),
                label: const Text(AppStrings.newConversation),
              ),
              const SizedBox(height: AppSizes.padding),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      state.userLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _handleAuthAction(context, state),
                    child: Text(state.isAuthenticated ? AppStrings.logout : AppStrings.login),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingSmall),
              Text(
                AppStrings.conversationHistory,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSizes.paddingSmall),
              Expanded(
                child: state.isAuthenticated
                    ? _ConversationList(selectedId: state.selectedConversationId)
                    : Center(
                        child: OutlinedButton(
                          onPressed: onShowGuestHistoryNotice,
                          child: const Text(AppStrings.conversationHistory),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleAuthAction(BuildContext context, AppState state) async {
    if (state.isAuthenticated) {
      state.logout();
      return;
    }

    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(AppStrings.login),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '이메일 주소 입력'),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                state.login(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text(AppStrings.login),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }
}

class _ConversationList extends StatelessWidget {
  const _ConversationList({required this.selectedId});

  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (state.conversations.isEmpty) {
      return const Center(child: Text('저장된 대화가 없습니다.'));
    }

    return ListView.separated(
      itemCount: state.conversations.length,
      separatorBuilder: (_, _) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final conversation = state.conversations[index];
        final selected = conversation.id == selectedId;

        return Card(
          color: selected ? const Color(0xFFEAF2FF) : null,
          child: ListTile(
            dense: true,
            title: Text(
              conversation.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${conversation.createdAt.year}-${conversation.createdAt.month.toString().padLeft(2, '0')}-${conversation.createdAt.day.toString().padLeft(2, '0')}',
            ),
            onTap: () => state.selectConversation(conversation.id),
          ),
        );
      },
    );
  }
}
