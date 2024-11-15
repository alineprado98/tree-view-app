import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tree_view_app/app/app_widget.dart';
import 'package:tree_view_app/app/core/services/locator/dependency_locator_service.dart';

void main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await setupInitialize();
  runApp(const AppWidget());
}

Future<void> setupInitialize() async {
  await DependencyLocatorService.setup();
}
