import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import 'widgets/checkin_modal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showCheckInModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full height
      backgroundColor: Colors.transparent,
      builder: (context) => const CheckInModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size; // Unused

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Stack(
                alignment: Alignment.center,
                children: [
                  // Menu Icon (Left)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.menu, color: Colors.white),
                  ),
                  // Logo (Center)
                  Image.asset(
                    'assets/images/logo_white.png',
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                "Welcome back,\nMinh Duc!",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                "How are you feeling today?",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),

              // BIG CHECK-IN CARD (Call to Action)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFF7F2FA), // Light cream/white like Figma
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Check in",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.black, // Dark text on light card
                            fontSize: 24,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Let us know what's your feeling now?",
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 20),

                    // Button & Image Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Real "Check In" Button
                        ElevatedButton(
                          onPressed: () => _showCheckInModal(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                          child: const Text("Start"), // Or an arrow icon
                        ),

                        // Placeholder Heart Helper Image
                        // Image.asset('assets/images/heart_mascot.png', height: 100),
                        Icon(Icons.favorite,
                            color: Colors.redAccent,
                            size: 80), // Temp placeholder
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Recommendations / Quote (Replacement for Chart)
              Text(
                "Daily Advice",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.amber),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Take a deep breath before your next meeting.",
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
