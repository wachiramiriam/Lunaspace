import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoodChart extends StatelessWidget {
  final List<double> moods; // Receive moods from parent
  const MoodChart({super.key, required this.moods});

  @override
  Widget build(BuildContext context) {
    // Ensure we always show exactly 7 points
    final displayedMoods = List<double>.from(moods);
    while (displayedMoods.length < 7) {
      displayedMoods.insert(0, 0); // fill missing with 0
    }
    if (displayedMoods.length > 7) {
      displayedMoods.removeRange(0, displayedMoods.length - 7);
    }

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
            const Text(
              "Mood Trends",
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

                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
                          int index = value.toInt();
                          if (index >= 0 && index < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(days[index], style: const TextStyle(fontSize: 12)),
                            );
                          }
                          return const SizedBox();
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
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),

                  borderData: FlBorderData(show: false),

                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      barWidth: 4,
                      gradient: const LinearGradient(
                        colors: [Colors.deepPurple, Colors.purpleAccent],
                      ),
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
                        displayedMoods.length,
                        (index) => FlSpot(index.toDouble(), displayedMoods[index]),
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