import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background, appBar: AppBar(title: const Text('About'), centerTitle: true), body: const Center(child: Text('RoamSafe v1.0.0')));
  }
}
