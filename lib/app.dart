import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roamsafe/core/constants/app_strings.dart';
import 'package:roamsafe/core/theme/app_theme.dart';
import 'package:roamsafe/core/router/app_router.dart';
import 'package:roamsafe/core/di/injection.dart';
import 'package:roamsafe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:roamsafe/features/emergency/presentation/bloc/emergency_bloc.dart';
import 'package:roamsafe/features/settings/presentation/bloc/settings_bloc.dart';

class RoamSafeApp extends StatelessWidget {
  const RoamSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<EmergencyBloc>()),
        BlocProvider(create: (context) => sl<SettingsBloc>()),
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
