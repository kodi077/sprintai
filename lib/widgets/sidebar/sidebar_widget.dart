import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_constants.dart';
import '../../providers/app_provider.dart';
import 'conversation_list_widget.dart';
import 'login_button_widget.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sidebar,
      width: AppSizes.sidebarWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              AppStrings.appTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                final provider = Provider.of<AppProvider>(
                  context,
                  listen: false,
                );
                provider.clearSession();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text(AppStrings.newConversation),
            ),
          ),
          const Expanded(child: ConversationListWidget()),
          const Divider(color: AppColors.border, height: 1),
          const LoginButtonWidget(),
        ],
      ),
    );
  }
}
