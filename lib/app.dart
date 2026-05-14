import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roamsafe/core/constants/app_strings.dart';
import 'package:roamsafe/core/theme/app_theme.dart';
import 'package:roamsafe/core/router/app_router.dart';
import 'package:roamsafe/core/router/app_routes.dart';
import 'package:roamsafe/core/router/navigator_key.dart';
import 'package:roamsafe/core/di/injection.dart';
import 'package:roamsafe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:roamsafe/features/emergency/presentation/bloc/emergency_bloc.dart';
import 'package:roamsafe/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:roamsafe/features/location/presentation/bloc/location_bloc.dart';

class RoamSafeApp extends StatefulWidget {
  const RoamSafeApp({super.key});

  @override
  State<RoamSafeApp> createState() => _RoamSafeAppState();
}

class _RoamSafeAppState extends State<RoamSafeApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _listenForBackgroundEmergency();
    _checkInitialEmergencyState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkInitialEmergencyState();
    }
  }

  Future<void> _checkInitialEmergencyState() async {
    final prefs = await SharedPreferences.getInstance();
    final isActive = prefs.getBool('is_emergency_active') ?? false;
    debugPrint('🔄 AppLifecycle: Checking emergency state - isActive: $isActive');
    
    if (isActive) {
      // Ensure we're not already on the emergency screen
      final routerContext = AppRouter.router.routerDelegate.navigatorKey.currentContext;
      if (routerContext != null) {
        AppRouter.router.go('/emergency-active');
      }
    }
  }

  void _listenForBackgroundEmergency() {
    // Listen for emergency_triggered events from the background service
    // and navigate to the emergency active screen
    FlutterBackgroundService().on('emergency_triggered').listen((_) {
      debugPrint('📱 Emergency signal received — navigating to EmergencyActiveScreen');
      _navigateToEmergency();
    });
  }

  void _navigateToEmergency() {
    final context = navigatorKey.currentContext;
    if (context == null) {
      // App just launched — wait for context to be ready
      debugPrint('⚠️ Navigator context null, retrying navigation...');
      Future.delayed(const Duration(milliseconds: 800), _navigateToEmergency);
      return;
    }
    context.goNamed(AppRoutes.emergencyActive, extra: true);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<EmergencyBloc>(), lazy: false),
        BlocProvider(create: (context) => sl<SettingsBloc>()),
        BlocProvider.value(value: sl<LocationBloc>()),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
