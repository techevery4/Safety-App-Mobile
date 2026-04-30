import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

import '../../../../core/router/app_routes.dart';
import '../../../dashboard/presentation/widgets/bottom_nav_bar.dart';

class LocationSharingScreen extends StatefulWidget {
  const LocationSharingScreen({super.key});

  @override
  State<LocationSharingScreen> createState() => _LocationSharingScreenState();
}

class _LocationSharingScreenState extends State<LocationSharingScreen> {
  bool _isSharing = false;

  void _toggleSharing() {
    // TODO: Request permission, dispatch ShareLocationEvent to LocationBloc
    setState(() {
      _isSharing = !_isSharing;
    });
  }

  void _onNavTap(int index) {
    if (index == 2) return; // already here
    if (index == 0) {
      context.goNamed(AppRoutes.dashboard);
    } else if (index == 1) {
      context.goNamed(AppRoutes.contacts);
    } else if (index == 3) {
      context.goNamed(AppRoutes.settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Share Location', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your Live Coordinates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              
              // Coordinates Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    // TODO: Replace with real GPS data when Google APIs are available
                    const Text('LAT:--.- N|LONG:--.- W', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.5)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Info Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE), // Light salmon/red
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 8, height: 8,
                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your real time coordinates will be sent to all your trusted contacts. This will allow them follow your movement until you stop sharing.', 
                        style: TextStyle(color: AppColors.error.withValues(alpha: 0.9), fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              const Text('Recipients', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              _buildAvatarStack(7), // Rendering dummy 7 avatars
              
              const SizedBox(height: 24),
              const Text('Location Share History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              
              Expanded(
                child: ListView.separated(
                  itemCount: 4, // dummy history count
                  separatorBuilder: (_, __) => const Divider(height: 24, color: AppColors.border),
                  itemBuilder: (context, index) {
                    return _buildHistoryRow(index);
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _toggleSharing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSharing ? AppColors.error : AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(_isSharing ? 'Stop Sharing' : 'Share Location', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Active on Location
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildAvatarStack(int totalCount) {
    const int maxDisplay = 5;
    final displayCount = totalCount > maxDisplay ? maxDisplay : totalCount;
    final List<Widget> avatars = [];

    final colors = [Colors.purple, Colors.orange, Colors.teal, Colors.blue, Colors.pink];

    for (int i = 0; i < displayCount; i++) {
      avatars.add(
        Positioned(
          left: i * 28.0,
          child: Container(
            padding: const EdgeInsets.all(2), // White border effect bridging stack
            decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: colors[i % colors.length].withValues(alpha: 0.2),
              child: Text('C${i+1}', style: TextStyle(color: colors[i % colors.length], fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      );
    }

    if (totalCount > maxDisplay) {
      final remaining = totalCount - maxDisplay;
      avatars.add(
        Positioned(
          left: maxDisplay * 28.0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceGrey,
              child: Text('+$remaining', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      width: (displayCount * 28.0) + (totalCount > maxDisplay ? 40.0 : 12.0),
      child: Stack(
        children: avatars.reversed.toList(), // Reverse to have the first ones on top
      ),
    );
  }

  Widget _buildHistoryRow(int index) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
          child: const Text('LA', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location Alert ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 15)),
              const SizedBox(height: 4),
              const Text('LAT:--.- N|LONG:--.- W', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        Text('Yesterday, 4:50pm', style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.7), fontSize: 12)),
      ],
    );
  }
}
