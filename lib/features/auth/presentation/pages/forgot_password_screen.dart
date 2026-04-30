import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onConfirmPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Navigate to success
      context.goNamed(AppRoutes.forgotPasswordSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Email',
                        hintText: 'Enter your email address',
                        // prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'New Password',
                        hintText: 'Enter new password',
                        // prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                        controller: _newPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'New password is required';
                          if (value.length < 6)
                            return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Confirm Password',
                        hintText: 'Confirm new password',
                        // prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                        controller: _confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value != _newPasswordController.text)
                            return 'Passwords do not match';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  text: 'Confirm Password',
                  onPressed: _onConfirmPassword,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
