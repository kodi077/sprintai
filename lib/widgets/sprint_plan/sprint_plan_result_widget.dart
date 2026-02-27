import 'package:flutter/material.dart';

import '../../config/app_constants.dart';
import '../../models/sprint_plan_model.dart';
import 'epic_card_widget.dart';

class SprintPlanResultWidget extends StatelessWidget {
  const SprintPlanResultWidget({required this.plan, super.key});

  final SprintPlan plan;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  plan.projectTitle,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text(AppStrings.exportJira),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.description),
                label: const Text(AppStrings.exportNotion),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.border),
        Expanded(
          child: ListView.builder(
            itemCount: plan.epics.length,
            itemBuilder: (BuildContext context, int index) {
              return EpicCardWidget(epic: plan.epics[index]);
            },
          ),
        ),
      ],
    );
  }
}
