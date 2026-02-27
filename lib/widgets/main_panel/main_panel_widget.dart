import 'package:flutter/material.dart';

import '../../config/app_constants.dart';
import '../sprint_plan/sprint_plan_display_widget.dart';
import 'prd_input_widget.dart';
import 'stack_selector_widget.dart';

class MainPanelWidget extends StatelessWidget {
  const MainPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StackSelectorWidget(),
        Divider(height: 1, color: AppColors.border),
        Expanded(
          child: Column(
            children: <Widget>[PrdInputWidget(), SprintPlanDisplayWidget()],
          ),
        ),
      ],
    );
  }
}
