import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/app_constants.dart';
import '../models/app_error.dart';
import '../providers/app_state.dart';
import '../widgets/main_panel/main_panel.dart';
import '../widgets/sidebar/sidebar_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final isCompact = MediaQuery.of(context).size.width < 1000;

          if (isCompact) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 240,
                  child: SidebarPanel(onShowGuestHistoryNotice: () => _showGuestHistoryNotice(context)),
                ),
                const Divider(height: 1),
                Expanded(
                  child: MainPanel(
                    onAnalyze: () => _onAnalyze(context),
                  ),
                ),
              ],
            );
          }

          return Row(
            children: <Widget>[
              SizedBox(
                width: AppSizes.sidebarWidth,
                child: SidebarPanel(onShowGuestHistoryNotice: () => _showGuestHistoryNotice(context)),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: MainPanel(
                  onAnalyze: () => _onAnalyze(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onAnalyze(BuildContext context) async {
    final state = context.read<AppState>();

    try {
      await state.analyze();
    } on AppError catch (error) {
      if (!context.mounted) {
        return;
      }
      await _showErrorDialog(context, error);
    }
  }

  Future<void> _showErrorDialog(BuildContext context, AppError error) {
    String title = AppStrings.serverErrorTitle;
    String message = AppStrings.serverErrorMessage;

    switch (error.code) {
      case ErrorCode.rateLimited:
        title = AppStrings.rateLimitedTitle;
        message = AppStrings.rateLimitedMessage;
        break;
      case ErrorCode.dailyLimit:
        title = AppStrings.dailyLimitTitle;
        message = AppStrings.dailyLimitMessage;
        break;
      case ErrorCode.badRequest:
        title = AppStrings.serverErrorTitle;
        message = error.message;
        break;
      case ErrorCode.serverError:
        title = AppStrings.serverErrorTitle;
        message = AppStrings.serverErrorMessage;
        break;
    }

    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _showGuestHistoryNotice(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.login),
        content: const Text(AppStrings.guestNoHistory),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }
}
