import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background, appBar: AppBar(title: const Text('Account Settings'), centerTitle: true), body: const Center(child: Text('Account Settings')));
  }
}
