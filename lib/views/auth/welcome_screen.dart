import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import '../../configs/routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Lấy thông số màn hình hiện tại
    final size = MediaQuery.of(context).size;
    final double screenHeight = size.height;
    final double screenWidth = size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      // Dùng SafeArea để tránh bị tai thỏ (Notch) che mất nội dung
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08), // Lề 2 bên = 8% màn hình
          child: Column(
            children: [
              // --- PHẦN TRÊN: LOGO & TEXT ---

              // Thay vì SizedBox(height: 138), ta dùng Spacer để nó tự co giãn
              const Spacer(flex: 3), // Chiếm 3 phần khoảng trống

              Image.asset(
                'assets/images/logo_white.png',
                width: screenWidth * 0.6, // Logo luôn rộng bằng 30% màn hình
                fit: BoxFit.contain,
              ),

              const Spacer(flex: 1), // Khoảng cách nhỏ

              const Text(
                "WELCOME",
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: 28, // Font size có thể chỉnh theo tỷ lệ nếu muốn kỹ hơn
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Listen your feeling. Stay focused.\nLive a healthy life.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              // --- PHẦN GIỮA: KHOẢNG TRỐNG LỚN ---
              const Spacer(flex: 4), // Chiếm 4 phần (Đẩy nút xuống dưới)

              // --- PHẦN DƯỚI: BUTTON ---

              SizedBox(
                width: double.infinity, // Full chiều ngang cho phép (đã trừ padding)
                height: 50, // Chiều cao nút bấm thì NÊN cố định (để ngón tay bấm dễ)
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                  child: const Text(
                    "Login With Email",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                    child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

              const Spacer(flex: 1), // Khoảng hở nhỏ dưới đáy
            ],
          ),
        ),
      ),
    );
  }
}