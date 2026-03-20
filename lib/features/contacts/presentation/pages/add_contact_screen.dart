import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AddContactScreen extends StatelessWidget {
  const AddContactScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Add Contact'), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      body: const Center(child: Text('Search by email to add trusted contacts')),
    );
  }
}
