import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/emergency_button.dart';
import '../widgets/safety_status_indicator.dart';
import '../widgets/ad_carousel_widget.dart';
import '../widgets/bottom_nav_bar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../ads/presentation/bloc/ads_bloc.dart';
import '../../../ads/presentation/bloc/ads_event.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../emergency/presentation/bloc/emergency_bloc.dart';
import '../../../emergency/presentation/bloc/emergency_event.dart';

import 'package:flutter_background_service/flutter_background_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _startBackgroundService();
  }

  Future<void> _startBackgroundService() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (!isRunning) {
      service.startService();
    }
  }

  void _onNavTap(int index) {
    if (index == 0) return;
    switch (index) {
      case 1:
        context.goNamed(AppRoutes.contacts);
        break;
      case 2:
        context.goNamed(AppRoutes.locationSharing);
        break;
      case 3:
        context.goNamed(AppRoutes.settings);
        break;
    }
  }

  void _onSOSTapped() {
    context.read<EmergencyBloc>().add(TriggerEmergencyEvent());
    context.pushNamed(AppRoutes.emergencyActive, extra: false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdsBloc>()..add(AdsLoadRequested()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            String firstName = 'User';
            bool isSafe = true;
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
              firstName = user.firstName ?? 'User';
              isSafe = user.status?.toUpperCase() != 'EMERGENCY';
              profilePictureUrl = user.profilePictureUrl;
            }

            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar with avatar, greeting, and notification bell
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primaryLight,
                          backgroundImage: profilePictureUrl != null
                              ? NetworkImage(profilePictureUrl)
                              : null,
                          child: profilePictureUrl == null
                              ? const Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${AppStrings.welcome} $firstName',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Safety status indicator
                  Center(child: SafetyStatusIndicator(isSafe: isSafe)),
                  const SizedBox(height: 20),

                  // Ad carousel
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      AppStrings.advertisement,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const AdCarouselWidget(),
                  const SizedBox(height: 16),

                  // SOS Button
                  Expanded(
                    child: Center(
                      child: EmergencyButton(onPressed: _onSOSTapped),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentNavIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}
