import 'package:flutter/material.dart';

import '../../config/app_constants.dart';
import '../../models/sprint_plan_model.dart';

class TaskCardWidget extends StatefulWidget {
  const TaskCardWidget({required this.task, super.key});

  final SprintTask task;

  @override
  State<TaskCardWidget> createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 4, bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: <Widget>[
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.task.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '${widget.task.storyPoints} SP',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.only(left: 34, right: 12, bottom: 8),
                child: Text(
                  widget.task.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            if (_expanded && widget.task.subtasks.isNotEmpty)
              Column(
                children: widget.task.subtasks
                    .map((subtask) => _buildSubtaskRow(subtask))
                    .toList(),
              ),
            if (_expanded)
              _buildSection(
                AppStrings.acceptanceCriteria,
                widget.task.acceptanceCriteria,
                AppColors.success,
              ),
            if (_expanded)
              _buildSection(
                AppStrings.risks,
                widget.task.risks,
                AppColors.error,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtaskRow(Subtask subtask) {
    return Padding(
      padding: const EdgeInsets.only(left: 34, right: 12, top: 2, bottom: 2),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.subdirectory_arrow_right,
            color: AppColors.textSecondary,
            size: 14,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              subtask.name,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            '${subtask.storyPoints} SP',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 34, right: 12, top: 6, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: <Widget>[
                  Icon(Icons.circle, size: 5, color: accentColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
