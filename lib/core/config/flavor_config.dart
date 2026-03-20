import 'app_config.dart';

/// Flavor configuration for build variants.
class FlavorConfig {
  static late AppConfig _config;

  static void initialize(AppConfig config) {
    _config = config;
  }

  static AppConfig get instance => _config;
}
