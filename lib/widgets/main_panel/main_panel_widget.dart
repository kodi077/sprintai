import 'package:flutter/material.dart';

import '../../config/app_constants.dart';
import '../sprint_plan/sprint_plan_display_widget.dart';
import 'prd_input_widget.dart';
import 'stack_selector_widget.dart';

class MainPanelWidget extends StatelessWidget {
  const MainPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const StackSelectorWidget(),
        const Divider(height: 1, color: AppColors.border),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                const PrdInputWidget(),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 400,
                    maxHeight: double.infinity,
                  ),
                  child: const SprintPlanDisplayWidget(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
