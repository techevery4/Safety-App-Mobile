import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  const ProfileAvatar({super.key, this.imageUrl, this.radius = 40});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null ? Icon(Icons.person, size: radius, color: AppColors.primary) : null,
    );
  }
}
