import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SharedLocationHistoryScreen extends StatelessWidget {
  const SharedLocationHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Location History'), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      body: const Center(child: Text('Shared Location History')),
    );
  }
}
