import 'package:flutter/material.dart';
import '../../../configs/app_colors.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark surface color
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (Title & Close Button)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24), // Spacer to center title
                const Text(
                  "Settings",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),

          // User Info Card
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF333333), // Lighter grey for card
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[400],
                  child: const Icon(Icons.person,
                      color: Colors.white), // Placeholder Avatar
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Bharanidharan N R",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text("Age 22, Male",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          _buildMenuItem(context, "Management",
              icon: Icons.keyboard_arrow_down),
          _buildMenuItem(context, "Change Language",
              icon: Icons.keyboard_arrow_down),
          _buildMenuItem(context, "Downloads"),
          _buildMenuItem(context, "Notifications"),
          _buildMenuItem(context, "Help & Support"),
          _buildMenuItem(context, "About"),
          _buildMenuItem(context, "Rate Us"),
          _buildMenuItem(context, "Log out", isDestructive: true),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title,
      {IconData? icon, bool isDestructive = false}) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: isDestructive ? Colors.white : Colors.white,
                  fontWeight:
                      isDestructive ? FontWeight.normal : FontWeight.normal,
                  fontSize: 16),
            ),
            if (icon != null) Icon(icon, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
