import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  Future<int> getTotalUsers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.length;
  }

  Future<int> getTotalReflections() async {
    final users =
        await FirebaseFirestore.instance.collection('users').get();

    int total = 0;

    for (var user in users.docs) {
      final reflections = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('reflections')
          .get();

      total += reflections.docs.length;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        getTotalUsers(),
        getTotalReflections(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final totalUsers = snapshot.data![0];
        final totalReflections = snapshot.data![1];

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Dashboard Overview",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  dashboardCard(
                    "Total Users",
                    totalUsers.toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                  const SizedBox(width: 20),
                  dashboardCard(
                    "Total Reflections",
                    totalReflections.toString(),
                    Icons.book,
                    Colors.purple,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                  "Recent Activity",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget dashboardCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}