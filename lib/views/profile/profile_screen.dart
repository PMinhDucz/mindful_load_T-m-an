import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../configs/app_colors.dart';
import '../../controllers/activity_controller.dart';

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
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueGrey[800],
            border: Border.all(color: AppColors.primary, width: 2),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/logo_white.png'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "MinhDuc",
          style: TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Hanoi, Vietnam",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
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

        for (var log in controller.logs) {
          // Check range
          if (log.timestamp
                  .isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
              log.timestamp.isBefore(endOfWeek.add(const Duration(days: 1)))) {
            dailyCounts[log.timestamp.weekday] =
                (dailyCounts[log.timestamp.weekday] ?? 0) + 1;
          }
        }

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
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
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
                          const days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ];
                          final index = value.toInt();
                          if (index >= 0 && index < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(days[index],
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 10)),
                            );
                          }
                          return const Text('');
                        },
                      ))),
                  barGroups: List.generate(7, (index) {
                    // index 0 = Mon (weekday 1)
                    return _makeGroupData(index, dailyCounts[index + 1] ?? 0);
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary.withOpacity(0.8),
          width: 12,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10, // Max height
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
