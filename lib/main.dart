import 'package:flutter/material.dart';
import 'package:roamsafe/core/config/app_config.dart';
import 'package:roamsafe/core/config/flavor_config.dart';
import 'package:roamsafe/core/di/injection.dart';
import 'package:roamsafe/core/services/background_service.dart';
import 'package:roamsafe/core/services/region/region_service.dart';
import 'package:roamsafe/features/location/presentation/bloc/location_bloc.dart';
import 'package:roamsafe/features/location/presentation/bloc/location_event.dart';
import 'package:roamsafe/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up development flavor config
  FlavorConfig.initialize(AppConfig.dev);
  
  // Initialize dependency injection
  await configureDependencies();

  // Initialize background service
  await initializeBackgroundService();

  // Detect region silently in background — don't block app launch
  sl<RegionService>().detectAndSaveRegion().catchError((_) {
    // Fail silently — fallback numbers are already set in detectAndSaveRegion
  });

  // Start location tracking immediately on app start
  sl<LocationBloc>().add(StartLocationTrackingEvent());
  
  runApp(const RoamSafeApp());
}
