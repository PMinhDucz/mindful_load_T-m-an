import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'widgets/settings_modal.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Spacer to balance
                  const Text(
                    "Profile",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const SettingsModal(),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Icon(Icons.spa, color: Colors.white, size: 40), // Top Logo

              const SizedBox(height: 30),

              // Avatar Circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey[800], // Placeholder color
                  border: Border.all(color: AppColors.primary, width: 2),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                        'assets/images/logo_white.png'), // Placeholder for Avatar
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Name & Location
              const Text(
                "MinhDuc",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "Hanoi, Vietnam",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 30),

              // Tabs (Stats / Achievements)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text("STATS",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(height: 2, color: AppColors.primary),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text("ACHIEVEMENTS",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(height: 2, color: Colors.white10),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Moved Chart Here
              Align(
                alignment: Alignment.centerLeft,
                child: Text("This Week's Stats",
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
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
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
                              'Sat'
                            ];
                            if (value.toInt() < days.length) {
                              return Text(days[value.toInt()],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10));
                            }
                            return Text('');
                          },
                        ))),
                    barGroups: [
                      _makeGroupData(0, 3), // Mon
                      _makeGroupData(1, 4), // Tue
                      _makeGroupData(2, 6), // Wed
                      _makeGroupData(3, 8), // Thu
                      _makeGroupData(4, 5), // Fri
                      _makeGroupData(5, 7), // Sat
                      _makeGroupData(6, 9), // Sun
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary.withOpacity(0.7),
          width: 12,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10,
            color: Colors.white10,
          ),
        ),
      ],
    );
  }
}
