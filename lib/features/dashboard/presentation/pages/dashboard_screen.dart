import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/emergency_button.dart';
import '../widgets/safety_status_indicator.dart';
import '../widgets/ad_carousel_widget.dart';
import '../widgets/bottom_nav_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
    switch (index) {
      case 1:
        context.pushNamed(AppRoutes.contacts);
        break;
      case 2:
        context.pushNamed(AppRoutes.locationSharing);
        break;
      case 3:
        context.pushNamed(AppRoutes.settings);
        break;
    }
  }

  void _onSOSTapped() {
    // TODO: trigger emergency via EmergencyBloc
    // Alert must activate within 2 seconds of trigger
    context.pushNamed(AppRoutes.emergencyActive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar with avatar, greeting, and notification bell
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primaryLight,
                    child: const Icon(Icons.person, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '${AppStrings.welcome} Adenike',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),

            // Safety status indicator
            const Center(child: SafetyStatusIndicator(isSafe: true)),
            const SizedBox(height: 20),

            // Ad carousel
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(AppStrings.advertisement,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
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
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
