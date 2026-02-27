import 'package:flutter/material.dart';

import '../../config/app_constants.dart';
import '../../models/sprint_plan_model.dart';

class SprintPlanView extends StatelessWidget {
  const SprintPlanView({
    super.key,
    required this.plan,
    required this.onExportJira,
    required this.onExportNotion,
  });

  final SprintPlan plan;
  final VoidCallback onExportJira;
  final VoidCallback onExportNotion;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              plan.projectTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSizes.paddingSmall),
            Text('Frontend: ${plan.stack.frontend}'),
            Text('Backend: ${plan.stack.backend}'),
            Text('Database: ${plan.stack.database ?? 'Not specified'}'),
            const SizedBox(height: AppSizes.padding),
            ...plan.epics.map((epic) => _EpicTile(epic: epic)),
            const SizedBox(height: AppSizes.padding),
            Wrap(
              spacing: AppSizes.paddingSmall,
              children: <Widget>[
                OutlinedButton.icon(
                  onPressed: onExportJira,
                  icon: const Icon(Icons.table_chart),
                  label: const Text(AppStrings.exportJira),
                ),
                OutlinedButton.icon(
                  onPressed: onExportNotion,
                  icon: const Icon(Icons.description),
                  label: const Text(AppStrings.exportNotion),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EpicTile extends StatelessWidget {
  const _EpicTile({required this.epic});

  final Epic epic;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text('${epic.id} · ${epic.name} (${epic.storyPoints} ${AppStrings.storyPoints})'),
        subtitle: Text(epic.description),
        children: epic.tasks.map((task) => _TaskTile(task: task)).toList(),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});

  final SprintTask task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${task.id} · ${task.name} (${task.storyPoints} ${AppStrings.storyPoints})',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(task.description),
              const SizedBox(height: 8),
              const Text(
                'Subtasks',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ...task.subtasks.map(
                (subtask) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('- ${subtask.name} (${subtask.storyPoints} ${AppStrings.storyPoints})'),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.acceptanceCriteria,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ...task.acceptanceCriteria.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('- $item'),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.risks,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ...task.risks.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('- $item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
