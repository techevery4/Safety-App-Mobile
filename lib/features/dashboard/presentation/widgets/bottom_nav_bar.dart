import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

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
      selectedItemColor: AppColors.navActive,
      unselectedItemColor: AppColors.navInactive,
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: AppStrings.home),
        BottomNavigationBarItem(icon: Icon(Icons.contacts), label: AppStrings.contacts),
        BottomNavigationBarItem(icon: Icon(Icons.location_on), label: AppStrings.location),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: AppStrings.settings),
      ],
    );
  }
}
