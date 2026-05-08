import 'environment.dart';

/// Environment-based configuration for RoamSafe.
class AppConfig {
  final Environment environment;
  final String baseUrl;
  final String apiKey;

  const AppConfig({
    required this.environment,
    required this.baseUrl,
    this.apiKey = '',
  });

  static AppConfig get dev => const AppConfig(
    environment: Environment.dev,
    baseUrl: 'https://roam.techeverywhere.info/api/v1',
  );

  static AppConfig get staging => const AppConfig(
    environment: Environment.staging,
    baseUrl: '', // TODO: set staging URL
  );

  static AppConfig get prod => const AppConfig(
    environment: Environment.prod,
    baseUrl: '', // TODO: set production URL
  );

  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProd => environment == Environment.prod;
}
