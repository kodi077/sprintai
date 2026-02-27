import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_constants.dart';
import '../../providers/app_provider.dart';
import 'sprint_plan_result_widget.dart';

class SprintPlanDisplayWidget extends StatelessWidget {
  const SprintPlanDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              AppStrings.analyzing,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline, color: AppColors.error, size: 32),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage!,
              style: const TextStyle(color: AppColors.error, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => provider.setError(null),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (provider.currentSprintPlan != null) {
      return SprintPlanResultWidget(plan: provider.currentSprintPlan!);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.rocket_launch_outlined,
            size: 48,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            '스택을 선택하고 PRD를 붙여넣은 후\n분석하기를 눌러주세요.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
