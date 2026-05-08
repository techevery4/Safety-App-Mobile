import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.goNamed(AppRoutes.login);
        }
      },
      child: Scaffold(
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
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              String fullName = 'User';
              String email = '';
              String? profilePictureUrl;

              if (state is AuthAuthenticated) {
                fullName = state.user.fullName;
                email = state.user.email;
                profilePictureUrl = state.user.profilePictureUrl;
              }

              return Column(
                children: [
                  const SizedBox(height: 24),
                  // Profile Header
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage: profilePictureUrl != null ? NetworkImage(profilePictureUrl) : null,
                      child: profilePictureUrl == null ? const Icon(Icons.person, color: AppColors.primary, size: 48) : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      fullName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      email,
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
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
                            iconBgColor: const Color(0xFFFFEBEE),
                            iconColor: AppColors.error,
                            title: 'Log Out',
                            titleColor: AppColors.error,
                            showChevron: false,
                            onTap: () {
                              context.read<AuthBloc>().add(AuthLogoutRequested());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
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
