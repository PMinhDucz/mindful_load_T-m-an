import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import 'home_screen.dart';
import '../profile/profile_screen.dart';
import '../stats/stats_screen.dart';
import 'widgets/side_menu.dart';

import '../history/history_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const StatsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(), // Enable Drawer here
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: AppColors.background, // Match background
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/logo_white.png'),
                size: 24), // Use App Logo
            activeIcon:
                ImageIcon(AssetImage('assets/images/logo_white.png'), size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined, size: 24), // History Icon
            activeIcon: Icon(Icons.calendar_month, size: 24),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq, size: 28), // Stats/Resources
            activeIcon: Icon(Icons.graphic_eq, size: 28),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 28), // Profile
            activeIcon: Icon(Icons.person, size: 28),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
