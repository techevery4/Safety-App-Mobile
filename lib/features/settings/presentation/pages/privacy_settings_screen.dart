import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background, appBar: AppBar(title: const Text('Privacy Settings'), centerTitle: true), body: const Center(child: Text('Privacy Settings')));
  }
}
