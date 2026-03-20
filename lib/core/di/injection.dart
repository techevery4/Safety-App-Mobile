import 'package:get_it/get_it.dart';

/// Global GetIt service locator instance.
final GetIt sl = GetIt.instance;

/// Initialise all dependency injection bindings.
Future<void> configureDependencies() async {
  // TODO: Register all services, repositories, blocs
  // Example:
  // sl.registerLazySingleton(() => ApiClient(config: AppConfig.dev));
  // sl.registerLazySingleton(() => NetworkInfo());
  // sl.registerFactory(() => AuthBloc(loginUseCase: sl(), registerUseCase: sl()));
}
