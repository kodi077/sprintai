import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_constants.dart';
import '../../models/stack_model.dart';
import '../../providers/app_state.dart';
import '../sprint_plan/sprint_plan_view.dart';

class MainPanel extends StatelessWidget {
  const MainPanel({
    super.key,
    required this.onAnalyze,
  });

  final Future<void> Function() onAnalyze;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Wrap(
                spacing: AppSizes.padding,
                runSpacing: AppSizes.padding,
                children: <Widget>[
                  SizedBox(
                    width: 280,
                    child: _StackDropdown(
                      label: AppStrings.frontendLabel,
                      value: state.stack.frontend,
                      options: StackSelection.frontendOptions,
                      onChanged: state.setFrontend,
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: _StackDropdown(
                      label: AppStrings.backendLabel,
                      value: state.stack.backend,
                      options: StackSelection.backendOptions,
                      onChanged: state.setBackend,
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: _StackDropdown(
                      label: AppStrings.databaseLabel,
                      value: state.stack.database,
                      options: StackSelection.databaseOptions,
                      onChanged: state.setDatabase,
                      optional: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.padding),
              TextFormField(
                key: ValueKey<String>(state.prdText),
                initialValue: state.prdText,
                minLines: 12,
                maxLines: 20,
                decoration: const InputDecoration(hintText: AppStrings.prdInputHint),
                onChanged: state.setPrdText,
              ),
              const SizedBox(height: AppSizes.paddingSmall),
              Row(
                children: <Widget>[
                  OutlinedButton.icon(
                    onPressed: state.pickPrdFile,
                    icon: const Icon(Icons.upload_file),
                    label: const Text(AppStrings.uploadFile),
                  ),
                  const SizedBox(width: AppSizes.paddingSmall),
                  if (state.isLoading)
                    const Text(
                      AppStrings.analyzing,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.padding),
              ElevatedButton(
                onPressed: state.isLoading ? null : onAnalyze,
                child: const Text(AppStrings.analyzeButton),
              ),
              const SizedBox(height: AppSizes.paddingLarge),
              if (state.currentPlan != null)
                SprintPlanView(
                  plan: state.currentPlan!,
                  onExportJira: state.exportJira,
                  onExportNotion: state.exportNotion,
                )
              else
                const _EmptyState(),
            ],
          ),
        );
      },
    );
  }
}

class _StackDropdown extends StatelessWidget {
  const _StackDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.optional = false,
  });

  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: optional ? '$label (선택)' : label),
      items: <DropdownMenuItem<String>>[
        if (optional)
          const DropdownMenuItem<String>(
            value: null,
            child: Text('선택 안 함'),
          ),
        ...options.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))),
      ],
      onChanged: onChanged,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              '분석 결과가 여기에 표시됩니다.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text('프레임워크와 백엔드를 선택한 후 PRD를 입력하고 분석하기를 눌러주세요.'),
          ],
        ),
      ),
    );
  }
}
