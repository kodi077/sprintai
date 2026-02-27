import 'package:flutter/material.dart';

import '../config/app_constants.dart';
import '../widgets/main_panel/main_panel_widget.dart';
import '../widgets/sidebar/sidebar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: <Widget>[
          SizedBox(width: AppSizes.sidebarWidth, child: SidebarWidget()),
          VerticalDivider(width: 1, color: AppColors.border),
          Expanded(child: MainPanelWidget()),
        ],
      ),
    );
  }
}
