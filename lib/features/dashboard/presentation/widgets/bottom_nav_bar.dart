import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNavBar({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.navInactive,
      backgroundColor: Colors.white,
      elevation: 0,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        _buildNavItem(
          iconPath: AppAssets.homeInactive,
          activeIconPath: AppAssets.homeActive,
          label: AppStrings.home,
        ),
        _buildNavItem(
          iconPath: AppAssets.contactInactive,
          activeIconPath: AppAssets.contactActive,
          label: AppStrings.contacts,
        ),
        _buildNavItem(
          iconPath: AppAssets.locationInactive,
          activeIconPath: AppAssets.locationInactive, // Using inactive as base
          label: AppStrings.location,
          isLocation: true,
        ),
        _buildNavItem(
          iconPath: AppAssets.settingsInactive,
          activeIconPath: AppAssets.settingsActive,
          label: AppStrings.settings,
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String iconPath,
    required String activeIconPath,
    required String label,
    bool isLocation = false,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Image.asset(iconPath, width: 24, height: 24),
      ),
      activeIcon: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          activeIconPath,
          width: 20,
          height: 20,
          color: isLocation ? Colors.white : null, // Tint location active white
        ),
      ),
      label: label,
    );
  }
}
