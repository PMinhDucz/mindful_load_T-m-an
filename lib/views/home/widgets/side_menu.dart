import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/auth_controller.dart';
import '../../../services/notification_service.dart';
import '../../auth/welcome_screen.dart';

class SideMenu extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const SideMenu({super.key, this.onProfileTap});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotifPrefs();
  }

  Future<void> _loadNotifPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>();

    return Drawer(
      backgroundColor: const Color(0xFF1C1C1E), // Dark background
      child: SafeArea(
        child: Column(
          children: [
            // User Info Header
            GestureDetector(
              onTap: () {
                if (widget.onProfileTap != null) {
                  Navigator.pop(context); // Close drawer
                  widget.onProfileTap!();
                }
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildAvatar(user.avatarIndex),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.isAuthenticated
                                ? (user.fullName ?? "User")
                                : "Guest",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (user.username?.contains('@') ?? false)
                                ? user.username!
                                : "@${user.username ?? 'user'}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildMenuItem("Management",
                      hasSubmenu: true, onTap: _comingSoon),
                  // _buildMenuItem("Change Language",
                  //     hasSubmenu: true, onTap: _showLanguageDialog),
                  _buildDivider(),
                  _buildMenuItem("Downloads", onTap: _comingSoon),
                  _buildDivider(),

                  // Notifications Custom Item
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Notifications",
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    subtitle: _notificationsEnabled
                        ? GestureDetector(
                            onTap: () {
                              NotificationService().showNotificationNow();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Đã gửi thông báo test! Hãy kiểm tra thanh trạng thái.")));
                            },
                            child: const Text(
                              "Test Now (Click me)",
                              style: TextStyle(
                                  color: Colors.greenAccent, fontSize: 12),
                            ),
                          )
                        : null,
                    trailing: Switch(
                      value: _notificationsEnabled,
                      activeColor: Colors.green,
                      onChanged: (val) async {
                        setState(() => _notificationsEnabled = val);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('notifications_enabled', val);

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
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const WelcomeScreen()),
                        (route) => false,
                      );
                    }
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

  Widget _buildAvatar(int index) {
    if (index == 0) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey[400],
        backgroundImage: const AssetImage('assets/images/logo_white.png'),
      );
    }
    final colors = [
      Colors.blue,
      Colors.pink,
      Colors.amber,
      Colors.green,
      Colors.purple
    ];
    final icons = [
      Icons.face,
      Icons.face_3,
      Icons.emoji_emotions,
      Icons.smart_toy,
      Icons.pets
    ];
    return CircleAvatar(
      radius: 24,
      backgroundColor: colors[index - 1],
      child: Icon(icons[index - 1], color: Colors.white, size: 30),
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
