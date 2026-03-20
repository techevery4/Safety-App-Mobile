import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.shield, size: 70, color: Colors.white),
              ),
              const SizedBox(height: 32),
              const Text(AppStrings.appName,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              const Text('Your personal safety companion',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              const Spacer(),
              CustomButton(text: AppStrings.getStarted, onPressed: () => context.goNamed(AppRoutes.register)),
              const SizedBox(height: 16),
              CustomButton(text: AppStrings.logIn, onPressed: () => context.goNamed(AppRoutes.login), isOutlined: true),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
