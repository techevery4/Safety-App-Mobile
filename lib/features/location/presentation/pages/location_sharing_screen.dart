import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class LocationSharingScreen extends StatelessWidget {
  const LocationSharingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.location), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      body: const Center(child: Text('Location Sharing', style: TextStyle(fontSize: 16, color: AppColors.textSecondary))),
    );
  }
}
