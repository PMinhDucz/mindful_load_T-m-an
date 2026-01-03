import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../home/nav_screen.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // 1. Wait for Mock Splash Duration (2-3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // 2. Force Navigation to WelcomeScreen (User Request: Always show Login/Signup)
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get Screen Size
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // Match App Theme Background
      body: SizedBox(
        width: double.infinity,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 2. TEXT 'Tâm an'
            Text(
              'Tâm an',
              style: GoogleFonts.lobsterTwo(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // 3. LOGO
            Image.asset(
              'assets/images/logo_white.png',
              width: screenWidth * 0.6,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
