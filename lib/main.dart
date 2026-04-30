import 'package:flutter/material.dart';
import 'package:roamsafe/core/config/app_config.dart';
import 'package:roamsafe/core/config/flavor_config.dart';
import 'package:roamsafe/core/di/injection.dart';
import 'package:roamsafe/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up development flavor config
  FlavorConfig.initialize(AppConfig.dev);
  
  // Initialize dependency injection
  await configureDependencies();
  
  runApp(const RoamSafeApp());
}
