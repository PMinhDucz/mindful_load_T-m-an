import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../configs/app_colors.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.menu, color: Colors.white),
                  Image.asset('assets/images/logo_white.png',
                      width: 40, height: 40),
                ],
              ),
              const SizedBox(height: 30),

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
                                  pieTouchResponse.touchedSection == null) {
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
                        sections: _showingSections(),
                      ),
                    ),
                    // Text in middle of Donut
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("35%",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        Text("Happy",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 30),

              // ANALYSIS HEADER
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text("AI Analysis & Insights",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 16),

              // 1. MAIN INSIGHT CARD (Pattern Detection)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2C3E50),
                      Color(0xFF4CA1AF)
                    ], // Strong Blue-Green Gradient
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45,
                        blurRadius: 8,
                        offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.orangeAccent, size: 24),
                        const SizedBox(width: 8),
                        Text("High Stress Detected",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "You often feel 'Stressed' on Monday mornings when at 'Work'.",
                      style: TextStyle(
                          color: Colors.white, fontSize: 15, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.white24),
                    const SizedBox(height: 8),
                    Text("Suggestion: Try a 5-minute break at 10:00 AM.",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontStyle: FontStyle.italic)),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 2. TOP STRESSORS LIST
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Top Stressors",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.grey)),
              ),
              const SizedBox(height: 10),

              _buildStressorItem(
                  rank: 1, tag: "Meeting", count: 12, color: Colors.redAccent),
              _buildStressorItem(
                  rank: 2,
                  tag: "Deadline",
                  count: 8,
                  color: Colors.orangeAccent),
              _buildStressorItem(
                  rank: 3, tag: "Commute", count: 5, color: Colors.yellow),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build Pie Chart Data
  List<PieChartSectionData> _showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 20.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.primary,
            value: 35,
            title: '35%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xFF2E3A3F),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          );
        case 2:
          return PieChartSectionData(
            color: Color(0xFFE57373), // Red for Stress
            value: 25,
            title: '25%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          );
        default:
          throw Error();
      }
    });
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
                  style: TextStyle(color: Colors.white, fontSize: 16))),
          Text("$count times",
              style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}
