import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class SafetyStatusIndicator extends StatelessWidget {
  final bool isSafe;
  const SafetyStatusIndicator({super.key, this.isSafe = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSafe ? AppColors.safeGreen.withValues(alpha: 0.15) : AppColors.emergencyRed.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSafe ? Icons.check_circle : Icons.warning,
            size: 18,
            color: isSafe ? AppColors.safeGreen : AppColors.emergencyRed,
          ),
          const SizedBox(width: 6),
          Text(
            isSafe ? AppStrings.statusSafe : AppStrings.statusEmergency,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSafe ? AppColors.safeGreen : AppColors.emergencyRed,
            ),
          ),
        ],
      ),
    );
  }
}
