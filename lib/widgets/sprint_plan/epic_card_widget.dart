import 'package:flutter/material.dart';

import '../../config/app_constants.dart';
import '../../models/sprint_plan_model.dart';
import 'task_card_widget.dart';

class EpicCardWidget extends StatefulWidget {
  const EpicCardWidget({required this.epic, super.key});

  final Epic epic;

  @override
  State<EpicCardWidget> createState() => _EpicCardWidgetState();
}

class _EpicCardWidgetState extends State<EpicCardWidget> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.epic.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${widget.epic.storyPoints} ${AppStrings.storyPoints}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Text(
                  widget.epic.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            if (_expanded)
              Column(
                children: widget.epic.tasks
                    .map((task) => TaskCardWidget(task: task))
                    .toList(),
              ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 12,
                  top: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '총 ${widget.epic.tasks.fold(0, (sum, t) => sum + t.storyPoints)} SP',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
