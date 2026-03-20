import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background, appBar: AppBar(title: const Text('Notification Settings'), centerTitle: true), body: const Center(child: Text('Notification Settings')));
  }
}
