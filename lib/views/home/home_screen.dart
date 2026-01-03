import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import 'widgets/checkin_modal.dart';
import 'widgets/mood_statistics.dart';
import 'package:provider/provider.dart';
import '../../controllers/activity_controller.dart';
import '../../models/activity_model.dart'; // Fix: Import to see Mood.label extension
// import 'widgets/activity_item.dart'; // We can inline this for now

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
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        // Open the Drawer from the parent Scaffold (NavScreen)
                        Scaffold.of(context).openDrawer();
                      },
                    ),
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

              const SizedBox(height: 40),

              // RECENT ACTIVITY (Timeline)
              Text(
                "Recent Activity",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),

              Consumer<ActivityController>(
                builder: (context, controller, child) {
                  final logs = controller.logs;
                  if (logs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text("No check-ins yet. Start now!",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logs.length > 5 ? 5 : logs.length, // Show max 5
                    separatorBuilder: (c, i) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            // Mood Icon (Placeholder)
                            CircleAvatar(
                              backgroundColor: Colors.white10,
                              child: Text(
                                log.mood.label.substring(0, 1), // First letter
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    log.mood.label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')} • ${log.tags.join(', ')}",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 40), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
