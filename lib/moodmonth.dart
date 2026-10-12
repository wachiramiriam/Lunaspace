import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthMoodChart extends StatefulWidget {
  const MonthMoodChart({super.key});

  @override
  State<MonthMoodChart> createState() => _MonthMoodChartState();
}

class _MonthMoodChartState extends State<MonthMoodChart> {
  @override
  Widget build(BuildContext context) {
    return const MoodChart();
  }
}


class MoodChart extends StatelessWidget {
  const MoodChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> moods = [6, 7, 5, 8, 7, 9, 4];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Title
            const Text(
              "Monthly Mood Trends",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 10,

                  // ✨ Clean grid
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                  ),

                  // 📅 Labels
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
                          ];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        reservedSize: 28,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  borderData: FlBorderData(
                    show: false,
                  ),

                  // 📈 Line
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      barWidth: 4,

                      // 🎨 Gradient line
                      gradient: const LinearGradient(
                        colors: [Colors.deepPurple, Colors.purpleAccent],
                      ),

                      // Points
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.deepPurple,
                          );
                        },
                      ),

                      // 🌈 Area below
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.withOpacity(0.3),
                            Colors.purpleAccent.withOpacity(0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),

                      spots: List.generate(
                        moods.length,
                        (index) => FlSpot(index.toDouble(), moods[index]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}