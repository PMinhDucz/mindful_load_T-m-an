import 'package:flutter/material.dart';
// Import các màn hình (Tạm thời cứ import, tí nữa mình tạo file sau cũng được)
import '../views/auth/splash_screen.dart';
import '../views/auth/welcome_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';

import '../views/home/nav_screen.dart';

class AppRoutes {
  // 1. Đặt tên đường (URL)
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home'; // Tạm thời chưa làm Home

  // 2. Ánh xạ Tên -> Màn hình
  static Map<String, WidgetBuilder> define() {
    return {
      splash: (context) => const SplashScreen(),
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const NavScreen(),
    };
  }
}
