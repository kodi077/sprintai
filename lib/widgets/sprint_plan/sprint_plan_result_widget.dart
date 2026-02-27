import 'package:flutter/material.dart';

import '../../config/app_constants.dart';
import '../../models/sprint_plan_model.dart';
import '../../utils/export_utils.dart';
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
                onPressed: () => ExportUtils.exportToJiraCsv(plan),
                icon: const Icon(Icons.download),
                label: const Text(AppStrings.exportJira),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => ExportUtils.exportToNotionMarkdown(plan),
                icon: const Icon(Icons.description),
                label: const Text(AppStrings.exportNotion),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Wrap(
            spacing: 6,
            children: <Widget>[
              if ((plan.stack.frontend ?? '').isNotEmpty)
                _buildBadge(plan.stack.frontend!),
              if ((plan.stack.backend ?? '').isNotEmpty)
                _buildBadge(plan.stack.backend!),
              if (plan.stack.database != null &&
                  plan.stack.database!.isNotEmpty)
                _buildBadge(plan.stack.database!),
            ],
          ),
        ),
        const Divider(color: AppColors.border),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: plan.epics.length,
          itemBuilder: (BuildContext context, int index) {
            return EpicCardWidget(epic: plan.epics[index]);
          },
        ),
      ],
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
