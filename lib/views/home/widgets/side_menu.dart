import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_controller.dart';
import '../../../services/notification_service.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool _notificationsEnabled = true; // Simple local state for demo

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>();

    return Drawer(
      backgroundColor: const Color(0xFF1C1C1E), // Dark background
      child: SafeArea(
        child: Column(
          children: [
            // User Info Header
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[400],
                    child:
                        const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.isAuthenticated
                            ? "User #${user.userId}"
                            : "Minh Duc",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Vietnam",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildMenuItem("Management",
                      hasSubmenu: true, onTap: _comingSoon),
                  _buildMenuItem("Change Language",
                      hasSubmenu: true, onTap: _showLanguageDialog),
                  _buildDivider(),
                  _buildMenuItem("Downloads", onTap: _comingSoon),
                  _buildDivider(),

                  // Notifications Custom Item
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Notifications",
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    trailing: Switch(
                      value: _notificationsEnabled,
                      activeColor: Colors.green,
                      onChanged: (val) {
                        setState(() => _notificationsEnabled = val);
                        if (val) {
                          NotificationService().scheduleRandomNotifications();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Notifications On")));
                        } else {
                          NotificationService().cancelAll();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Notifications Off")));
                        }
                      },
                    ),
                  ),

                  _buildDivider(),
                  _buildMenuItem("Help & Support", onTap: _comingSoon),
                  _buildDivider(),
                  _buildMenuItem("About", onTap: () {
                    showAboutDialog(
                        context: context,
                        applicationName: "Mindful Load",
                        applicationVersion: "1.0.0",
                        children: [const Text("Built with ❤️ by Antigravity")]);
                  }),
                  _buildDivider(),
                  _buildMenuItem("Rate Us", onTap: _comingSoon),
                  _buildDivider(),
                  _buildMenuItem("Log out", onTap: () async {
                    // Safe Logout
                    final auth = context.read<AuthController>();
                    // Close Drawer first
                    Navigator.pop(context);
                    await auth.logout();
                    // AuthController listener in MyApp will handle redirect
                  }),
                  _buildDivider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title,
      {bool hasSubmenu = false, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      trailing: hasSubmenu
          ? const Icon(Icons.keyboard_arrow_right, color: Colors.white54)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.white10, height: 1);
  }

  void _comingSoon() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Feature coming soon!")));
  }

  void _showLanguageDialog() {
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
