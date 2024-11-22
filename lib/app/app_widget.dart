import 'package:flutter/material.dart';
import 'package:tree_view_app/app/common/routes/routes.dart';
import 'package:tree_view_app/app/common/theme/app_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tree view app',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes.routes,
    );
  }
}
