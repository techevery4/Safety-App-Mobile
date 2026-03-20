import 'package:flutter/material.dart';
import 'core/config/app_config.dart';
import 'core/config/flavor_config.dart';
import 'core/di/injection.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up development flavor config
  FlavorConfig.initialize(AppConfig.dev);
  
  // Initialize dependency injection
  await configureDependencies();
  
  runApp(const RoamSafeApp());
}
