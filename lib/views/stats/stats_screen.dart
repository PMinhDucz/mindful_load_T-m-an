import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../controllers/activity_controller.dart';
import '../../configs/app_colors.dart';
import '../../models/activity_model.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _touchedIndex = -1;

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
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  Image.asset(
                    'assets/images/logo_white.png',
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Consumer<ActivityController>(
                builder: (context, controller, child) {
                  // --- CALCULATE CHART DATA ---
                  final logs =
                      controller.logs; // All logs or limit? Use all for stats.
                  final Map<String, int> moodCounts = {};
                  int total = 0;

                  for (var log in logs) {
                    // Grouping: Happy/Joy -> "Happy", Sad/Anxious -> "Stress", etc.
                    // Or just use the exact Mood labels?
                    // The UI shows: 35% Happy, 40% (Grey), 25% (Red/Stress)
                    // Let's use 3 groups for simplicity to match UI, or just mapping

                    String group = 'Neutral';
                    if (log.mood == Mood.good) {
                      group = 'Happy';
                    } else if (log.mood == Mood.stress ||
                        log.mood == Mood.angry ||
                        log.mood == Mood.anxious ||
                        log.mood == Mood.sad) {
                      group = 'Stress';
                    }

                    moodCounts[group] = (moodCounts[group] ?? 0) + 1;
                    total++;
                  }

                  // Default if empty
                  if (total == 0) {
                    moodCounts['Happy'] = 1; // Fake data to show empty ring?
                    // actually better to show empty state, but let's keep UI structure
                  }

                  // Calculate Percentages
                  final List<PieChartSectionData> sections = [];
                  final groups = ['Happy', 'Neutral', 'Stress'];
                  final colors = {
                    'Happy': AppColors.primary,
                    'Neutral': const Color(0xFF2E3A3F),
                    'Stress': const Color(0xFFE57373)
                  };

                  int dataIndex = 0;
                  for (var group in groups) {
                    final count = moodCounts[group] ?? 0;
                    if (total > 0 && count > 0) {
                      final percent = (count / total) * 100;
                      final isTouched = dataIndex == _touchedIndex;
                      final radius = isTouched ? 60.0 : 50.0;
                      final fontSize = isTouched ? 20.0 : 12.0;

                      sections.add(PieChartSectionData(
                          color: colors[group] ?? Colors.grey,
                          value: count.toDouble(),
                          title: '${percent.toInt()}%',
                          radius: radius,
                          titleStyle: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)));
                      dataIndex++;
                    }
                  }

                  // If no data, show full gray ring
                  if (sections.isEmpty) {
                    sections.add(PieChartSectionData(
                        color: Colors.white10,
                        value: 100,
                        title: '',
                        radius: 50));
                  }

                  // --- CALCULATE TOP STRESSORS ---
                  // Count tags associated with "Stress" group
                  final Map<String, int> stressorCounts = {};
                  for (var log in logs) {
                    final isStress = [
                      Mood.stress,
                      Mood.angry,
                      Mood.anxious,
                      Mood.sad
                    ].contains(log.mood);
                    if (isStress) {
                      for (var tag in log.tags) {
                        stressorCounts[tag] = (stressorCounts[tag] ?? 0) + 1;
                      }
                    }
                  }
                  // Sort
                  final sortedStressors = stressorCounts.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
                  final top3Stressors = sortedStressors.take(3).toList();

                  // Find dominant group for Center Text
                  String dominantGroup = 'Happy';
                  int maxCount = 0;
                  moodCounts.forEach((key, value) {
                    if (value > maxCount) {
                      maxCount = value;
                      dominantGroup = key;
                    }
                  });

                  return Column(
                    children: [
                      // PIE CHART SECTION
                      SizedBox(
                        height: 250,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        _touchedIndex = -1;
                                        return;
                                      }
                                      _touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                borderData: FlBorderData(show: false),
                                sectionsSpace: 0,
                                centerSpaceRadius: 60, // Donut shape
                                sections: sections,
                              ),
                            ),
                            // Text in middle of Donut
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    total > 0
                                        ? "${((moodCounts[dominantGroup] ?? 0) / total * 100).toInt()}%"
                                        : "0%",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                Text(dominantGroup,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 50), // Gap

                      // ANALYSIS HEADER
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text("AI Analysis & Insights",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // DYNAMIC INSIGHTS LIST
                      Column(
                        children: controller.insights.map((insight) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 8,
                                    offset: Offset(0, 4)),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.lightbulb_outline,
                                    color: Colors.yellowAccent, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    insight,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 30),

                      // TOP STRESSORS LIST
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Top Stressors",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.grey)),
                      ),
                      const SizedBox(height: 10),

                      if (top3Stressors.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text("Chưa đủ dữ liệu phân tích.",
                              style: TextStyle(color: Colors.white54)),
                        )
                      else
                        ...top3Stressors.asMap().entries.map((e) {
                          final index = e.key;
                          final entry = e.value;
                          final colors = [
                            Colors.redAccent,
                            Colors.orangeAccent,
                            Colors.yellow
                          ];
                          return _buildStressorItem(
                              rank: index + 1,
                              tag: entry.key,
                              count: entry.value,
                              color: colors[index % colors.length]);
                        }).toList(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStressorItem(
      {required int rank,
      required String tag,
      required int count,
      required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text("#$rank",
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 16),
          Expanded(
              child: Text(tag,
                  style: const TextStyle(color: Colors.white, fontSize: 16))),
          Text("$count times",
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}
