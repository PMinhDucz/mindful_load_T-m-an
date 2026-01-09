import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../configs/app_colors.dart';
import '../../controllers/activity_controller.dart';
import '../../controllers/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentTab = 0; // 0: Stats, 1: Achievements

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              _buildHeader(context),
              const SizedBox(height: 30),

              // Avatar & Info
              _buildUserInfo(),
              const SizedBox(height: 16),

              // Tabs
              const SizedBox(height: 30),
              _buildTabs(),
              const SizedBox(height: 30),

              // Dynamic Content
              _currentTab == 0
                  ? _buildStats(context)
                  : _buildAchievements(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        Image.asset(
          'assets/images/logo_white.png',
          width: 40,
          height: 40,
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        final handle = (auth.username?.contains('@') ?? false)
            ? auth.username!
            : "@${auth.username ?? 'user'}";

        return Column(
          children: [
            GestureDetector(
              onTap: _showAvatarPicker,
              child: Stack(
                children: [
                  _buildAvatarWidget(auth.avatarIndex, 120),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.black, size: 20),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              auth.fullName ?? "User",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              handle,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        );
      },
    );
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Choose Avatar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: List.generate(6, (index) {
                  return GestureDetector(
                    onTap: () {
                      context.read<AuthController>().setAvatar(index);
                      Navigator.pop(context);
                    },
                    child: _buildAvatarWidget(index, 70),
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarWidget(int index, double size) {
    if (index == 0) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueGrey[800],
          border: Border.all(color: AppColors.primary, width: 2),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/logo_white.png'),
          ),
        ),
      );
    }

    final colors = [
      Colors.blue, // 1
      Colors.pink, // 2
      Colors.amber, // 3
      Colors.green, // 4
      Colors.purple, // 5
    ];

    final icons = [
      Icons.face,
      Icons.face_3,
      Icons.emoji_emotions,
      Icons.smart_toy,
      Icons.pets,
    ];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors[index - 1],
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Icon(icons[index - 1], color: Colors.white, size: size * 0.5),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => setState(() => _currentTab = 0),
            child: Column(
              children: [
                Text("STATS",
                    style: TextStyle(
                        color: _currentTab == 0 ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                    height: 2,
                    color: _currentTab == 0
                        ? AppColors.primary
                        : Colors.transparent),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () => setState(() => _currentTab = 1),
            child: Column(
              children: [
                Text("ACHIEVEMENTS",
                    style: TextStyle(
                        color: _currentTab == 1 ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                    height: 2,
                    color: _currentTab == 1
                        ? AppColors.primary
                        : Colors.transparent),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    return Consumer<ActivityController>(
      builder: (context, controller, child) {
        // Prepare Data for Chart (This Week)
        final now = DateTime.now();
        // Calculate start of week (Monday)
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));

        final Map<int, double> dailyCounts = {
          1: 0,
          2: 0,
          3: 0,
          4: 0,
          5: 0,
          6: 0,
          7: 0
        };

        double maxY = 0;
        for (var log in controller.logs) {
          // Check range
          if (log.timestamp
                  .isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
              log.timestamp.isBefore(endOfWeek.add(const Duration(days: 1)))) {
            final day = log.timestamp.weekday;
            dailyCounts[day] = (dailyCounts[day] ?? 0) + 1;
            if (dailyCounts[day]! > maxY) maxY = dailyCounts[day]!;
          }
        }

        // Ensure some height even if empty
        if (maxY < 5) maxY = 5;

        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("This Week's Activity",
                  style: Theme.of(context).textTheme.labelMedium),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY + 2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.blueGrey,
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} logs',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.white10,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                  ),
                  titlesData: FlTitlesData(
                      leftTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          final index =
                              value.toInt() - 1; // 0-indexed for array
                          if (index >= 0 && index < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(days[index],
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            );
                          }
                          return const Text('');
                        },
                      ))),
                  barGroups: List.generate(7, (index) {
                    // index 0 = Mon (weekday 1)
                    return _makeGroupData(
                        index + 1, dailyCounts[index + 1] ?? 0, maxY);
                  }),
                ),
                swapAnimationDuration:
                    const Duration(milliseconds: 500), // Smooth animation
                swapAnimationCurve: Curves.easeInOut,
              ),
            ),
          ],
        );
      },
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, double maxY) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: const LinearGradient(
            colors: [
              Colors.green,
              Colors.teal,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 14,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY + 2, // Dynamic max height
            color: Colors.white10,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements(BuildContext context) {
    return Consumer<ActivityController>(builder: (context, controller, child) {
      final totalCheckins = controller.logs.length;
      final uniqueTags = controller.tagCategories.values
          .expand((x) => x)
          .length; // Rough proxy

      // Badges Logic
      final badges = [
        _Badge("Newbie", "First Check-in", totalCheckins >= 1, Icons.start),
        _Badge("Explorer", "5 Check-ins", totalCheckins >= 5, Icons.explore),
        _Badge(
            "Dedicated", "10 Check-ins", totalCheckins >= 10, Icons.favorite),
        _Badge("Master", "20 Check-ins", totalCheckins >= 20, Icons.school),
        // Add more fun ones
        _Badge("Tag Lover", "Use Custom Tags", uniqueTags > 15,
            Icons.local_offer), // Just an example logic
      ];

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(16),
              border: badge.unlocked
                  ? Border.all(color: AppColors.primary, width: 2)
                  : Border.all(color: Colors.grey, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(badge.icon,
                    size: 30,
                    color: badge.unlocked ? AppColors.primary : Colors.grey),
                const SizedBox(height: 8),
                Text(badge.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
                const SizedBox(height: 4),
                Text(badge.desc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          );
        },
      );
    });
  }
}

class _Badge {
  final String name;
  final String desc;
  final bool unlocked;
  final IconData icon;

  _Badge(this.name, this.desc, this.unlocked, this.icon);
}
