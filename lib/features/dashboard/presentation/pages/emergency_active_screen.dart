import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:roamsafe/core/constants/app_colors.dart';
import 'package:roamsafe/core/router/app_routes.dart';
import 'package:roamsafe/core/services/calling/call_service.dart';
import 'package:roamsafe/core/services/region/region_service.dart';
import 'package:roamsafe/core/di/injection.dart';
import 'package:roamsafe/features/emergency/presentation/bloc/emergency_bloc.dart';
import 'package:roamsafe/features/emergency/presentation/bloc/emergency_event.dart';
import 'package:roamsafe/features/location/presentation/bloc/location_bloc.dart';
import 'package:roamsafe/features/location/presentation/bloc/location_state.dart';

class EmergencyActiveScreen extends StatefulWidget {
  final bool autoCall;

  const EmergencyActiveScreen({
    super.key,
    this.autoCall = false,
  });

  @override
  State<EmergencyActiveScreen> createState() => _EmergencyActiveScreenState();
}

class _EmergencyActiveScreenState extends State<EmergencyActiveScreen> {
  final CallService _callService = sl<CallService>();
  late final EmergencyNumbers _numbers;

  @override
  void initState() {
    super.initState();
    _numbers = sl<RegionService>().getEmergencyNumbers();
    
    if (widget.autoCall) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openDialler();
      });
    }
  }

  Future<void> _openDialler() async {
    try {
      final uri = Uri(scheme: 'tel', path: _numbers.primary);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('❌ Failed to open dialler: $e');
    }
  }

  void _stopEmergency() {
    context.read<EmergencyBloc>().add(StopEmergencyEvent());
    context.goNamed(AppRoutes.dashboard);
  }

  void _makeCall(String number) {
    _callService.call(number);
  }

  String _formatLastPing(DateTime? lastUpdated) {
    if (lastUpdated == null) return 'Last ping: --';
    final diff = DateTime.now().difference(lastUpdated);
    if (diff.inSeconds < 60) {
      return 'Last ping: ${diff.inSeconds}s ago';
    } else {
      return 'Last ping: ${diff.inMinutes}m ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRedAlertBanner(),
                  const SizedBox(height: 12),
                  _buildLocationSharingBanner(),
                  const SizedBox(height: 24),
                  
                  const Text('Live Coordinates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  BlocBuilder<LocationBloc, LocationState>(
                    builder: (context, state) {
                      final coords = state is LocationLoaded
                          ? state.formattedCoordinates
                          : 'Acquiring location...';
                      final lastPing = state is LocationLoaded
                          ? _formatLastPing(state.lastUpdated)
                          : 'Last ping: --';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coords,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            lastPing,
                            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Row(
                    children: [
                      Expanded(child: _buildCallButton(_numbers.primary, 'Call ${_numbers.primary}')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildCallButton(_numbers.secondary, 'Call ${_numbers.secondaryName}')),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Emergency Contacts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      GestureDetector(
                        onTap: () => context.pushNamed(AppRoutes.contacts),
                        child: const Text('View All', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildContactRow(
                        name: 'Contact ${index + 1}',
                        email: 'contact${index + 1}@example.com',
                        phone: '0800000000$index',
                        color: index == 0 ? Colors.purple : (index == 1 ? Colors.orange : Colors.teal),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _stopEmergency,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('Stop Emergency Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRedAlertBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_rounded, color: Colors.white, size: 24),
          SizedBox(width: 8),
          Text('Emergency Alert is Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildLocationSharingBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE), // Light salmon/red
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on, color: AppColors.error, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Live location sharing is active', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('Your coordinates are being sent to your trusted contacts.', style: TextStyle(color: AppColors.error.withValues(alpha: 0.8), fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton(String number, String label) {
    return GestureDetector(
      onTap: () => _makeCall(number),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          border: Border.all(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone, color: AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow({required String name, required String email, required String phone, required Color color}) {
    final initials = name.substring(0, 1).toUpperCase();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Text(initials, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 16)),
                Text(email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _makeCall(phone),
            icon: const Icon(Icons.phone, color: AppColors.primary),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
