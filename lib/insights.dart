import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soulscript/mood.dart';
import 'package:soulscript/reflection.dart';
import 'activities.dart';
import 'tagsreflection.dart';


double convertMoodToScore(String mood) {
  switch (mood) {
    case "😊 Peaceful":
    case "😀 Happy":
      return 5;
    case "😐 Neutral":
      return 3;
    case "😔 Sad":
    case "😢 Overwhelmed":
    case "😠 Angry":
      return 1;
    default:
      return 3;
  }
}


class InsightsPage extends StatelessWidget {
  final List<double> moods;

  const InsightsPage({super.key, required this.moods});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('reflections')
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          final totalEntries = docs.length;

          // MOOD AVERAGE (safe version)
          double moodScore = 0;

for (var d in docs) {
  final mood = d['mood'] ?? "";
  moodScore += convertMoodToScore(mood);
}

double avgMood = docs.isEmpty ? 0 : moodScore / docs.length;

              

          // STREAK (simple)
          Set<String> days = {};

          for (var d in docs) {
            DateTime date =
                (d['createdAt'] as Timestamp).toDate();

            days.add("${date.year}-${date.month}-${date.day}");
          }

          int streak = days.length;

          String bestWeek = "This Week";

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [

                  // ROW 1
                  Row(
                    children: [
                      Expanded(
                        child: buildCard(
                          "😊",
                          "Mood",
                          avgMood.toStringAsFixed(1),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: buildCard(
                          "📘",
                          "Entries",
                          totalEntries.toString(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ROW 2
                  Row(
                    children: [
                      Expanded(
                        child: buildCard(
                          "🔥",
                          "Streak",
                          "$streak days",
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: buildCard(
                          "⭐",
                          "Best Week",
                          bestWeek,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  MoodChart(moods: moods),
                  const SizedBox(height: 15),
                  ActivityMoodChart(),
                  const SizedBox(height: 15),
                  TopTagsCard(),
                  const SizedBox(height: 15),
                  ReflectionsCard(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCard(String icon, String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}