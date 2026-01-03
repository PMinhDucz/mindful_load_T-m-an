import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/activity_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../services/notification_service.dart';

class SettingsModal extends StatefulWidget {
  const SettingsModal({super.key});

  @override
  State<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>(); // Read for logout
    final user = context.watch<AuthController>(); // Watch for UI updates

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
                    Text(user.userId != null ? "User #${user.userId}" : "Guest",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text("Vietnam",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMenuItem(context, "Management",
                      icon: Icons.keyboard_arrow_right,
                      onTap: () => _showComingSoon(context)),
                  _buildMenuItem(context, "Change Language",
                      icon: Icons.language,
                      onTap: () => _showLanguageDialog(context)),
                  _buildMenuItem(context, "Downloads",
                      icon: Icons.download,
                      onTap: () => _showComingSoon(context)),

                  // Toggle Switch Item
                  _buildToggleItem("Notifications", _notificationsEnabled,
                      (val) {
                    setState(() => _notificationsEnabled = val);
                    if (val) {
                      NotificationService().scheduleRandomNotifications();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Notifications On")));
                    } else {
                      NotificationService().cancelAll();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Notifications Off")));
                    }
                  }),

                  _buildMenuItem(context, "Help & Support",
                      icon: Icons.help_outline,
                      onTap: () => _showComingSoon(context)),
                  _buildMenuItem(context, "About",
                      icon: Icons.info_outline,
                      onTap: () => showAboutDialog(
                              context: context,
                              applicationName: "Mindful Load",
                              applicationVersion: "1.0.0",
                              children: [
                                const Text("Built with ❤️ by Antigravity")
                              ])),
                  _buildMenuItem(context, "Rate Us",
                      icon: Icons.star_rate_rounded,
                      onTap: () => _showComingSoon(context)),

                  const SizedBox(height: 20),

                  // DANGER ZONE
                  _buildMenuItem(context, "Clear All Data", isDestructive: true,
                      onTap: () async {
                    // Confirm Dialog
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: const Color(0xFF2C2C2E),
                        title: const Text("Delete All History?",
                            style: TextStyle(color: Colors.white)),
                        content: const Text("This action cannot be undone.",
                            style: TextStyle(color: Colors.white70)),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text("DELETE",
                                  style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await context.read<ActivityController>().clearAllLogs();
                      Navigator.pop(context); // Close Settings
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("All data cleared!")));
                    }
                  }),

                  _buildMenuItem(context, "Log out", isDestructive: true,
                      onTap: () {
                    auth.logout();
                    Navigator.pop(context); // Close modal
                    // App will rebuild and go to splash
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title,
      {IconData? icon, bool isDestructive = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
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
                  color: isDestructive ? const Color(0xFFFF6B6B) : Colors.white,
                  fontWeight:
                      isDestructive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16),
            ),
            if (icon != null) Icon(icon, color: Colors.white54, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Feature coming soon!")));
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text("Select Language",
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title:
                  const Text("English", style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.check, color: Colors.green),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              title: const Text("Tiếng Việt",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đã chuyển sang Tiếng Việt")));
              },
            ),
          ],
        ),
      ),
    );
  }
}
