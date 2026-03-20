import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}
