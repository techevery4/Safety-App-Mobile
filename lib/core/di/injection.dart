import 'package:get_it/get_it.dart';
import 'package:roamsafe/core/config/flavor_config.dart';
import 'package:roamsafe/core/network/api_client.dart';
import 'package:roamsafe/core/services/calling/call_service.dart';
import 'package:roamsafe/core/services/alarm/alarm_service.dart';
import 'package:roamsafe/core/services/location/location_service.dart';
import 'package:roamsafe/core/services/storage/secure_storage_service.dart';
import 'package:roamsafe/core/services/storage/local_storage_service.dart';
import 'package:roamsafe/core/services/storage/onboarding_storage_service.dart';
import 'package:roamsafe/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:roamsafe/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:roamsafe/features/auth/domain/repositories/auth_repository.dart';
import 'package:roamsafe/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:roamsafe/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:roamsafe/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:roamsafe/features/auth/domain/usecases/setup_profile_usecase.dart';
import 'package:roamsafe/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:roamsafe/features/auth/domain/usecases/logout_usecase.dart';
import 'package:roamsafe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:roamsafe/features/settings/domain/repositories/settings_repository.dart';
import 'package:roamsafe/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:roamsafe/features/emergency/presentation/bloc/emergency_bloc.dart';
import 'package:roamsafe/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:roamsafe/features/contacts/domain/repositories/contacts_repository.dart';
import 'package:roamsafe/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:roamsafe/features/contacts/data/datasources/contacts_remote_datasource.dart';
import 'package:roamsafe/features/contacts/domain/usecases/get_confirmed_contacts_usecase.dart';
import 'package:roamsafe/features/contacts/domain/usecases/get_pending_contacts_usecase.dart';
import 'package:roamsafe/features/contacts/domain/usecases/add_contact_usecase.dart';
import 'package:roamsafe/features/contacts/domain/usecases/remove_contact_usecase.dart';
import 'package:roamsafe/features/contacts/domain/usecases/respond_to_contact_request_usecase.dart';
import 'package:roamsafe/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:roamsafe/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:roamsafe/features/ads/presentation/bloc/ads_bloc.dart';
import 'package:roamsafe/features/advertising/domain/repositories/ads_repository.dart';
import 'package:roamsafe/features/advertising/data/repositories/ads_repository_impl.dart';
import 'package:roamsafe/features/advertising/domain/usecases/get_active_ads_usecase.dart';
import 'package:roamsafe/features/advertising/domain/usecases/create_ad_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global GetIt service locator instance.
final GetIt sl = GetIt.instance;

/// Initialise all dependency injection bindings.
Future<void> configureDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core — Network
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(config: FlavorConfig.instance),
  );

  // Core — Storage
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );
  sl.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(sl()),
  );
  sl.registerLazySingleton<OnboardingStorageService>(
    () => OnboardingStorageService(sl()),
  );

  // Services
  sl.registerLazySingleton<CallService>(() => CallService());
  sl.registerLazySingleton<AlarmService>(() => AlarmService());
  sl.registerLazySingleton<LocationService>(() => LocationService());

  // Auth — Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // Auth — Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      onboardingStorage: sl(),
    ),
  );

  // Auth — Use Cases
  sl.registerLazySingleton<RegisterUserUseCase>(
    () => RegisterUserUseCase(sl()),
  );
  sl.registerLazySingleton<LoginUserUseCase>(
    () => LoginUserUseCase(sl()),
  );
  sl.registerLazySingleton<SetupProfileUseCase>(
    () => SetupProfileUseCase(sl()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl()),
  );

  // Contacts — Data Sources
  sl.registerLazySingleton<ContactsRemoteDatasource>(
    () => ContactsRemoteDatasource(sl<ApiClient>().dio),
  );

  // Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ContactsRepository>(
    () => ContactsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AdsRepository>(
    () => AdsRepositoryImpl(),
  );

  // Use Cases — Contacts
  sl.registerLazySingleton<GetConfirmedContactsUseCase>(
    () => GetConfirmedContactsUseCase(sl()),
  );
  sl.registerLazySingleton<GetPendingContactsUseCase>(
    () => GetPendingContactsUseCase(sl()),
  );
  sl.registerLazySingleton<AddContactUsecase>(
    () => AddContactUsecase(sl()),
  );
  sl.registerLazySingleton<RemoveContactUsecase>(
    () => RemoveContactUsecase(sl()),
  );
  sl.registerLazySingleton<RespondToContactRequestUseCase>(
    () => RespondToContactRequestUseCase(sl()),
  );
  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(sl()),
  );

  // Use Cases — Advertising
  sl.registerLazySingleton<GetActiveAdsUseCase>(
    () => GetActiveAdsUseCase(sl()),
  );
  sl.registerLazySingleton<CreateAdUseCase>(
    () => CreateAdUseCase(sl()),
  );

  // Blocs
  sl.registerFactory(() => AuthBloc(
    registerUseCase: sl(),
    loginUseCase: sl(),
    setupProfileUseCase: sl(),
    getCurrentUserUseCase: sl(),
    logoutUseCase: sl(),
    onboardingStorage: sl(),
  ));

  sl.registerFactory(() => EmergencyBloc(
    alarmService: sl(),
    callService: sl(),
    locationService: sl(),
    settingsRepository: sl(),
  ));

  sl.registerFactory(() => SettingsBloc(
    repository: sl(),
    changePasswordUseCase: sl(),
    authRepository: sl(),
  ));

  sl.registerFactory(() => ContactsBloc(
    getConfirmedContactsUseCase: sl(),
    getPendingContactsUseCase: sl(),
    addContactUseCase: sl(),
    removeContactUseCase: sl(),
    respondToContactRequestUseCase: sl(),
    authRepository: sl(),
  ));

  sl.registerFactory(() => AdsBloc(
    getActiveAdsUseCase: sl(),
    createAdUseCase: sl(),
  ));
}
