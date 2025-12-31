import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import '../../configs/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller để quản lý dữ liệu nhập
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // 1. Lấy kích thước màn hình
    final size = MediaQuery.of(context).size;
    final double screenHeight = size.height;
    final double screenWidth = size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      // SafeArea để tránh tai thỏ
      body: SafeArea(
        // 2. QUAN TRỌNG: Dùng SingleChildScrollView để cuộn khi bàn phím hiện lên
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08), // Lề 2 bên 8%
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Căn trái toàn bộ
              children: [
                // Đo khoảng cách từ trên xuống (dùng % chiều cao màn hình)
                SizedBox(height: screenHeight * 0.05),

                // --- LOGO & TIÊU ĐỀ ---
                Center(
                  child: Image.asset(
                    'assets/images/logo_white.png', // Nhớ thay ảnh thật
                    width: screenWidth * 0.2, // Logo rộng 20% màn hình
                    height: screenWidth * 0.2,
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontFamily: 'Serif',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Sign up now for free and start analysis your feeling, and explore more about your self.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                SizedBox(height: screenHeight * 0.05), // Khoảng cách đến Form

                // --- FORM NHẬP LIỆU --
                const SizedBox(height: 8),
                _buildTextField(
                    controller: _nameController,
                    hint: "Name"
                ),
                const SizedBox(height: 20),
                // Ô Email
                const SizedBox(height: 8),
                _buildTextField(
                    controller: _emailController,
                    hint: "Email Address"
                ),

                const SizedBox(height: 20),
                // Ô Password
                const SizedBox(height: 8),
                _buildTextField(
                    controller: _passController,
                    hint: "Password",
                    isPassword: true
                ),

                // Quên mật khẩu
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password?", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05), // Khoảng cách đến nút

                // --- NÚT LOGIN ---
                SizedBox(
                  width: double.infinity,
                  height: 50, // Nút bấm nên fix cứng chiều cao để dễ bấm
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      // Giả lập login thành công
                      Navigator.pushNamed(context, AppRoutes.home);
                    },
                    child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // --- DÒNG CUỐI CÙNG ---
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

                // Khoảng trống dưới cùng để khi cuộn không bị sát đáy
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HÀM TÁCH CODE (REUSABLE WIDGETS) ---
  // Viết tách ra thế này để code chính đỡ rối và dễ sửa style đồng loạt

  Widget _buildLabel(String text) {
    return Text(
        text,
        style: const TextStyle(color: Colors.grey, fontSize: 12)
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
        filled: true,
        fillColor: Colors.transparent, // Hoặc Colors.grey[900] nếu muốn có nền
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        // Gạch chân mặc định
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        // Gạch chân khi bấm vào (Màu xanh)
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}