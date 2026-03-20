import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.contacts), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      body: const Center(child: Text('Trusted Contacts', style: TextStyle(fontSize: 16, color: AppColors.textSecondary))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () { /* TODO: navigate to add contact */ },
      ),
    );
  }
}
