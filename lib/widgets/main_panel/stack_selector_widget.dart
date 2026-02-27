import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_constants.dart';
import '../../models/stack_model.dart';
import '../../providers/app_provider.dart';

class StackSelectorWidget extends StatelessWidget {
  const StackSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Container(
      color: AppColors.sidebar,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: <Widget>[
          _buildDropdown(
            label: AppStrings.frontendLabel,
            value: provider.stackSelection.frontend,
            options: StackSelection.frontendOptions,
            isRequired: true,
            onChanged: provider.setStackFrontend,
          ),
          _buildDropdown(
            label: AppStrings.backendLabel,
            value: provider.stackSelection.backend,
            options: StackSelection.backendOptions,
            isRequired: true,
            onChanged: provider.setStackBackend,
          ),
          _buildDropdown(
            label: AppStrings.databaseLabel,
            value: provider.stackSelection.database,
            options: StackSelection.databaseOptions,
            isRequired: false,
            onChanged: provider.setStackDatabase,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required bool isRequired,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 200,
          child: DropdownButtonFormField<String>(
            initialValue: value,
            hint: Text(
              isRequired ? 'Required' : 'Optional',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            onChanged: onChanged,
            items: options
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            dropdownColor: AppColors.surface,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
