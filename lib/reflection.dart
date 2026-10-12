import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReflectionsCard extends StatelessWidget {
  ReflectionsCard({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('reflections')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        // BUILD INSIGHTS LOGIC
        
        List<String> insights = [];

        int stress = 0;
        int happy = 0;
        int calm = 0;

        for (var d in docs) {
          final text =
              (d['reflection'] ?? '').toString().toLowerCase();

          if (text.contains("stress") ||
              text.contains("tired") ||
              text.contains("overwhelmed")) {
            stress++;
          }

          if (text.contains("happy") ||
              text.contains("good") ||
              text.contains("great")) {
            happy++;
          }

          if (text.contains("calm") ||
              text.contains("peace")) {
            calm++;
          }
        }

        if (docs.isEmpty) {
          insights.add("Start writing reflections to see insights ✨");
        } else {
          if (happy > stress) {
            insights.add("You’ve been mostly positive lately 😊");
          }

          if (stress > happy) {
            insights.add("You seem a bit stressed recently 🌧");
          }

          if (calm > 0) {
            insights.add("You are finding moments of peace 🌿");
          }
        }

        // UI FOR INSIGHTS CARD
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
                  "Reflections Insights",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Column(
                  children: insights.map((text) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb,
                              color: Colors.purple),
                          const SizedBox(width: 10),
                          Expanded(child: Text(text)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}