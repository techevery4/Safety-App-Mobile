import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
class AppPermissionsScreen extends StatelessWidget {
  const AppPermissionsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background, appBar: AppBar(title: const Text('App Permissions'), centerTitle: true), body: const Center(child: Text('App Permissions')));
  }
}
