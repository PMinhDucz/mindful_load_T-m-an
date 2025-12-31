import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/app_colors.dart';
import '../../configs/routes.dart';

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
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Lấy thông số màn hình
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        width: double.infinity,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa dọc
          children: [
            // 2. CHỮ TÂM AN (Co giãn theo bề ngang)
            Text(
              'Tâm an',
              style: GoogleFonts.lobsterTwo(
                textStyle: TextStyle( // Lưu ý: Bỏ từ khóa 'const' ở đây vì ta dùng biến
                  color: Colors.white,
                  // Mẹo: Đặt cỡ chữ bằng 15% chiều rộng màn hình
                  // iPhone thường (375px) -> chữ 56px
                  // iPad (800px) -> chữ 120px (To đẹp luôn)
                  fontSize: screenWidth * 0.15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Khoảng cách tỷ lệ (3% chiều cao màn hình)
            SizedBox(height: screenHeight * 0.03),

            // 3. LOGO (Co giãn theo bề ngang)
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