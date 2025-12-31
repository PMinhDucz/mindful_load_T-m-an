import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'configs/app_theme.dart';
import 'configs/routes.dart';
import 'controllers/activity_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ActivityController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tâm An',
        theme: AppTheme.darkTheme,
        // --- Navigation ---
        // initialRoute: AppRoutes.splash, // Uncomment when Auth is ready
        // initialRoute: AppRoutes.splash, // Correct flow for Demo
        initialRoute: AppRoutes.home, // Bypass Login for UI Development
        routes: AppRoutes.define(),
      ),
    );
  }
}
