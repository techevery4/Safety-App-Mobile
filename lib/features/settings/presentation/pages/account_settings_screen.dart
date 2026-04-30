import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Account Settings', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Header
            const Center(
              child: CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'), // dummy profile
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Jane Doe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text(
                'jane.doe@example.com',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 40),
            
            // Options List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildOptionRow(
                      icon: Icons.person_outline,
                      iconBgColor: AppColors.surfaceGrey,
                      iconColor: AppColors.textPrimary,
                      title: 'Edit Profile',
                      onTap: () => context.pushNamed(AppRoutes.editProfile),
                    ),
                    const Divider(height: 1, thickness: 1, indent: 56, color: AppColors.border),
                    _buildOptionRow(
                      icon: Icons.lock_outline,
                      iconBgColor: AppColors.surfaceGrey,
                      iconColor: AppColors.textPrimary,
                      title: 'Change Password',
                      onTap: () => context.pushNamed(AppRoutes.changePassword),
                    ),
                    const Divider(height: 1, thickness: 1, indent: 56, color: AppColors.border),
                    _buildOptionRow(
                      icon: Icons.logout,
                      iconBgColor: const Color(0xFFFFEBEE), // Light red
                      iconColor: AppColors.error,
                      title: 'Log Out',
                      titleColor: AppColors.error,
                      showChevron: false,
                      onTap: () {
                        // TODO: Implement logout logic and navigate to login
                        context.goNamed(AppRoutes.login);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    Color titleColor = AppColors.textPrimary,
    bool showChevron = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: titleColor, fontSize: 16)),
      trailing: showChevron ? const Icon(Icons.chevron_right, color: AppColors.textSecondary) : null,
      onTap: onTap,
    );
  }
}
