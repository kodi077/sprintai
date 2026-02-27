import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_constants.dart';
import '../../providers/app_provider.dart';

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextButton(
        onPressed: () {},
        child: Text(
          provider.currentUser == null ? AppStrings.login : AppStrings.logout,
          style: TextStyle(
            color: provider.currentUser == null
                ? AppColors.textSecondary
                : AppColors.error,
          ),
        ),
      ),
    );
  }
}
