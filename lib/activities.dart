import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityMoodChart extends StatefulWidget {
  const ActivityMoodChart({super.key});

  @override
  State<ActivityMoodChart> createState() => _ActivityMoodChartState();
}

class _ActivityMoodChartState extends State<ActivityMoodChart> {
  int selectedIndex = 0;

  final List<String> activities = [
    "Exercise",
    "Work",
    "Friends",
    "Relax"
  ];

  // Icons
  final List<IconData> activityIcons = [
    Icons.directions_run,
    Icons.work,
    Icons.people,
    Icons.spa,
  ];

  // Colors per activity
  final List<Color> activityColors = [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.purple,
  ];

  //Mood data
  final Map<String, List<double>> moodData = {
    "Exercise": [7, 8, 6, 9, 8, 9, 7],
    "Work": [5, 6, 4, 6, 5, 4, 5],
    "Friends": [8, 9, 7, 8, 9, 10, 9],
    "Relax": [6, 7, 6, 7, 8, 8, 7],
  };

  @override
  Widget build(BuildContext context) {
    String selectedActivity = activities[selectedIndex];
    List<double> data = moodData[selectedActivity]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Text(
          "Activities & Mood",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        //  Activity buttons with icons
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(activities.length, (index) {
              bool isSelected = index == selectedIndex;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? activityColors[index]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color:
                                    activityColors[index].withOpacity(0.4),
                                blurRadius: 6,
                              )
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          activityIcons[index],
                          size: 18,
                          color:
                              isSelected ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          activities[index],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 20),

        //  Bar Chart
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 10,

              titlesData: FlTitlesData(
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

                      if (value.toInt() < days.length) {
                        return Text(days[value.toInt()]);
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),

              borderData: FlBorderData(show: false),

              // Bars
              barGroups: List.generate(data.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data[index],
                      width: 16,
                      color: activityColors[selectedIndex],
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}