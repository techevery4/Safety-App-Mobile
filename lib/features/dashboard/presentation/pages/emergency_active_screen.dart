import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';

class EmergencyActiveScreen extends StatelessWidget {
  const EmergencyActiveScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.emergencyRed,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text('EMERGENCY ACTIVE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              const Text('Alerting your trusted contacts...', style: TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 48),
              CustomButton(
                text: 'STOP ALARM',
                onPressed: () => Navigator.of(context).pop(),
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
