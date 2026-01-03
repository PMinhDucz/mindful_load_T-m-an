import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/activity_controller.dart';
import '../../../models/activity_model.dart';

class MoodStatistics extends StatelessWidget {
  const MoodStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityController>(
      builder: (context, controller, _) {
        // FORCE LIMIT: Only take top 20 logs for stats, ignoring old cache
        final logs = controller.logs.take(20).toList();

        if (logs.isEmpty) return const SizedBox();

        // 1. Calculate Mood Counts (Last 7 Days)
        final Map<Mood, int> moodCounts = {};
        final now = DateTime.now();
        final sevenDaysAgo = now.subtract(const Duration(days: 7));

        for (var log in logs) {
          if (log.timestamp.isAfter(sevenDaysAgo)) {
            moodCounts[log.mood] = (moodCounts[log.mood] ?? 0) + 1;
          }
        }

        final total = logs.length;

        // 2. Prepare Chart Sections
        final List<PieChartSectionData> sections =
            moodCounts.entries.map((entry) {
          final mood = entry.key;
          final count = entry.value;
          final percentage = (count / total) * 100;

          return PieChartSectionData(
            color: mood.color,
            value: count.toDouble(),
            title: '${percentage.toInt()}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E), // Dark Card
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Weekly Summary",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white70),
                    onPressed: () {
                      context.read<ActivityController>().loadData();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // CHART
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 30,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // LEGEND
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: moodCounts.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: entry.key.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.key.label,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                ),
                              ),
                              Text(
                                '${entry.value}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
