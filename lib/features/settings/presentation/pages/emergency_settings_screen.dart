import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
class EmergencySettingsScreen extends StatelessWidget {
  const EmergencySettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background, appBar: AppBar(title: const Text('Emergency Settings'), centerTitle: true), body: const Center(child: Text('Emergency Settings')));
  }
}
