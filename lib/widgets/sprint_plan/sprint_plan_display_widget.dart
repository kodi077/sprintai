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
      return const Expanded(
        child: Center(
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
        ),
      );
    }

    if (provider.errorMessage != null) {
      return Expanded(
        child: Center(
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
        ),
      );
    }

    if (provider.currentSprintPlan != null) {
      return Expanded(
        child: SprintPlanResultWidget(plan: provider.currentSprintPlan!),
      );
    }

    return const Expanded(child: SizedBox.shrink());
  }
}
