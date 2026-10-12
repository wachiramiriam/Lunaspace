import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodAnalyticsChart extends StatefulWidget {
  const MoodAnalyticsChart({super.key});

  @override
  State<MoodAnalyticsChart> createState() => _MoodAnalyticsChartState();
}

class _MoodAnalyticsChartState extends State<MoodAnalyticsChart> {
  Map<String, int> moodCounts = {
    "happy": 0,
    "neutral": 0,
    "sad": 0,
    "angry": 0,
    "overwhelmed": 0,
  };

  @override
  void initState() {
    super.initState();
    loadMoods();
  }

  Future<void> loadMoods() async {
    final users =
        await FirebaseFirestore.instance.collection('users').get();

    for (var user in users.docs) {
      final reflections = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('reflections')
          .get();

      for (var doc in reflections.docs) {
        String mood = (doc['mood'] ?? "neutral").toLowerCase();

        if (moodCounts.containsKey(mood)) {
          moodCounts[mood] = moodCounts[mood]! + 1;
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int total = moodCounts.values.fold(0, (a, b) => a + b);

    if (total == 0) {
      return const Center(child: Text("No mood data yet"));
    }

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: moodCounts.entries.map((entry) {
                final value = entry.value.toDouble();

                return PieChartSectionData(
                  value: value,
                  title: "${entry.key}\n${value.toInt()}",
                  radius: 70,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(width: 20),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: moodCounts.entries.map((e) {
              return Text(
                "${e.key}: ${e.value}",
                style: const TextStyle(fontSize: 16),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}