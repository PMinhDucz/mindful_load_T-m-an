import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'configs/app_theme.dart';
import 'controllers/activity_controller.dart';
import 'controllers/auth_controller.dart';
import 'services/notification_service.dart';
import 'views/home/nav_screen.dart';
import 'views/auth/welcome_screen.dart';
import 'views/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Notifications & Schedule Random Reminders
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.scheduleRandomNotifications();

  // Set safe timezone
  tz.initializeTimeZones();

  // System UI Overlay Style (Status Bar Color)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Transparent status bar
    statusBarIconBrightness: Brightness.light, // White icons
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProxyProvider<AuthController, ActivityController>(
          create: (_) => ActivityController(),
          update: (_, auth, previous) =>
              previous!..update(auth.token, auth.userId),
        ),
      ],
      child: Consumer<AuthController>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Mindful Load',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          // Logic: If Authenticated -> NavScreen. Else -> WelcomeScreen.
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
