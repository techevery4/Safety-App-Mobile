import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_routes.dart';
import '../di/injection.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/onboarding_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/auth/presentation/pages/otp_verification_screen.dart';
import '../../features/auth/presentation/pages/setup_profile_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/forgot_password_screen.dart';
import '../../features/auth/presentation/pages/forgot_password_success_screen.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/dashboard/presentation/pages/emergency_active_screen.dart';
import '../../features/emergency/presentation/pages/emergency_triggered_screen.dart';
import '../../features/contacts/presentation/pages/contacts_screen.dart';
import '../../features/contacts/presentation/pages/add_contact_screen.dart';
import '../../features/contacts/presentation/bloc/contacts_bloc.dart';
import '../../features/contacts/presentation/bloc/contacts_event.dart';
import '../../features/ads/presentation/pages/ad_manager_screen.dart';
import '../../features/ads/presentation/bloc/ads_bloc.dart';
import '../../features/location/presentation/pages/location_sharing_screen.dart';
import '../../features/location/presentation/pages/shared_location_history_screen.dart';

import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../../features/settings/presentation/pages/account_settings_screen.dart';
import '../../features/settings/presentation/pages/emergency_settings_screen.dart';
import '../../features/settings/presentation/pages/notification_settings_screen.dart';
import '../../features/settings/presentation/pages/privacy_settings_screen.dart';
import '../../features/settings/presentation/pages/app_permissions_screen.dart';
import '../../features/settings/presentation/pages/about_screen.dart';
import '../../features/settings/presentation/pages/edit_profile_screen.dart';
import '../../features/settings/presentation/pages/change_password_screen.dart';
import '../../features/settings/presentation/pages/change_password_success_screen.dart';

/// GoRouter configuration for the entire app.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/register',
        name: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        name: AppRoutes.otpVerification,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/setup-profile',
        name: AppRoutes.setupProfile,
        builder: (context, state) => const SetupProfileScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/forgot-password-success',
        name: AppRoutes.forgotPasswordSuccess,
        builder: (context, state) => const ForgotPasswordSuccessScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/emergency-active',
        name: AppRoutes.emergencyActive,
        builder: (context, state) => const EmergencyActiveScreen(),
      ),
      GoRoute(
        path: '/emergency-triggered',
        name: AppRoutes.emergencyTriggered,
        builder: (context, state) => const EmergencyTriggeredScreen(),
      ),
      GoRoute(
        path: '/contacts',
        name: AppRoutes.contacts,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<ContactsBloc>()..add(LoadContactsEvent()),
          child: const ContactsScreen(),
        ),
      ),
      GoRoute(
        path: '/contacts/add',
        name: AppRoutes.addContact,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<ContactsBloc>(),
          child: const AddContactScreen(),
        ),
      ),
      GoRoute(
        path: '/ad-manager',
        name: AppRoutes.adManager,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AdsBloc>(),
          child: const AdManagerScreen(),
        ),
      ),
      GoRoute(
        path: '/location-sharing',

        name: AppRoutes.locationSharing,
        builder: (context, state) => const LocationSharingScreen(),
      ),
      GoRoute(
        path: '/location-history',
        name: AppRoutes.locationHistory,
        builder: (context, state) => const SharedLocationHistoryScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/account-settings',
        name: AppRoutes.accountSettings,
        builder: (context, state) => const AccountSettingsScreen(),
      ),
      GoRoute(
        path: '/emergency-settings',
        name: AppRoutes.emergencySettings,
        builder: (context, state) => const EmergencySettingsScreen(),
      ),
      GoRoute(
        path: '/notification-settings',
        name: AppRoutes.notificationSettings,
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/privacy-settings',
        name: AppRoutes.privacySettings,
        builder: (context, state) => const PrivacySettingsScreen(),
      ),
      GoRoute(
        path: '/app-permissions',
        name: AppRoutes.appPermissions,
        builder: (context, state) => const AppPermissionsScreen(),
      ),
      GoRoute(
        path: '/about',
        name: AppRoutes.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/change-password',
        name: AppRoutes.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/change-password-success',
        name: AppRoutes.changePasswordSuccess,
        builder: (context, state) => const ChangePasswordSuccessScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}

