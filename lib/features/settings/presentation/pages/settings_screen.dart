import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../dashboard/presentation/widgets/bottom_nav_bar.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/domain/entities/user_entity.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(LoadSettingsEvent());
  }

  void _onNavTap(int index) {
    if (index == 3) return; // already here
    if (index == 0) {
      context.goNamed(AppRoutes.dashboard);
    } else if (index == 1) {
      context.goNamed(AppRoutes.contacts);
    } else if (index == 2) {
      context.goNamed(AppRoutes.locationSharing); // location sharing
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsUpdateFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Update failed: ${state.message}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          //   onPressed: () => context.pop(),
          // ),
        ),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          buildWhen: (previous, current) =>
              current is SettingsLoading ||
              current is SettingsLoaded ||
              current is SettingsError,
          builder: (context, state) {
            if (state is SettingsInitial || state is SettingsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is SettingsError) {
              return Center(
                child: Text('Failed to load settings: ${state.message}'),
              );
            }

            if (state is! SettingsLoaded) {
              return const SizedBox.shrink();
            }

            final settings = state.settings;

            return SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                children: [
                  _buildProfileCard(),
                  const SizedBox(height: 24),
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    child: _buildToggleRow(
                      icon: Icons.location_on,
                      iconColor: AppColors.primary,
                      title: 'Emergency Sharing',
                      subtitle: 'Live location sharing during alerts',
                      value: settings.emergencySharing,
                      onChanged: (val) => context.read<SettingsBloc>().add(
                        UpdateSettingsEvent(emergencySharing: val),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Emergency',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    child: Column(
                      children: [
                        _buildToggleRow(
                          icon: Icons.vibration,
                          iconColor: const Color(0xFFFF7043),
                          title: 'Shake Trigger',
                          subtitle: 'Trigger alert by shaking phone',
                          value: settings.shakeTrigger,
                          onChanged: (val) => context.read<SettingsBloc>().add(
                            UpdateSettingsEvent(shakeTrigger: val),
                          ),
                        ),
                        const Divider(
                          height: 24,
                          thickness: 1,
                          indent: 48,
                          color: AppColors.border,
                        ),
                        _buildToggleRow(
                          icon: Icons.notifications_active,
                          iconColor: const Color(0xFFE53935),
                          title: 'Alarm Sound',
                          subtitle: 'Enable emergency alarm sound',
                          value: settings.alarmSound,
                          onChanged: (val) => context.read<SettingsBloc>().add(
                            UpdateSettingsEvent(alarmSound: val),
                          ),
                        ),
                        const Divider(
                          height: 24,
                          thickness: 1,
                          indent: 48,
                          color: AppColors.border,
                        ),
                        _buildToggleRow(
                          icon: Icons.call_split,
                          iconColor: AppColors.primary,
                          title: 'Auto Re-routing',
                          subtitle: 'Enable re-routing to emergency contacts',
                          value: settings.autoRerouting,
                          onChanged: (val) => context.read<SettingsBloc>().add(
                            UpdateSettingsEvent(autoRerouting: val),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSettingsCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _SettingsIconBadge(
                        color: const Color(0xFF7E57C2),
                        icon: Icons.campaign,
                      ),
                      title: const Text(
                        'Ad Manager',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                      onTap: () => context.pushNamed(AppRoutes.adManager),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: 3, onTap: _onNavTap),
      ),
    );
  }

  Widget _buildProfileCard() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        String fullName = 'User';
        String email = '';
        String? profilePictureUrl;

        UserEntity? user;

        if (authState is AuthAuthenticated) {
          user = authState.user;
        } else if (authState is AuthRegistrationSuccess) {
          user = authState.user;
        } else if (authState is AuthProfileSetupSuccess) {
          user = authState.user;
        }

        if (user != null) {
          fullName = '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
          email = user.email;
          profilePictureUrl = user.profilePictureUrl;
        }

        return GestureDetector(
          onTap: () => context.pushNamed(AppRoutes.accountSettings),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage: profilePictureUrl != null
                      ? NetworkImage(profilePictureUrl)
                      : null,
                  child: profilePictureUrl == null
                      ? const Icon(Icons.person, color: AppColors.primary)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _SettingsIconBadge(color: iconColor, icon: icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: AppColors.primary,
        ),
      ],
    );
  }
}

class _SettingsIconBadge extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _SettingsIconBadge({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}
