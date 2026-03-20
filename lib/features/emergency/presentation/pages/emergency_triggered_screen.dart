import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class EmergencyTriggeredScreen extends StatelessWidget {
  const EmergencyTriggeredScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.emergencyRed,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sos, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text('Emergency Triggered', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              const Text('Help is on the way', style: TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: const Text('Cancel Emergency', style: TextStyle(color: AppColors.emergencyRed)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
