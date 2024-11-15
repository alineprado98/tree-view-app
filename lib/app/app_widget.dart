import 'package:flutter/material.dart';
import 'package:tree_view_app/app/common/routes/routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tree view app',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Color(0xFF17192D),
        ),
        useMaterial3: false,
      ),
      routerConfig: AppRoutes.routes,
    );
  }
}
