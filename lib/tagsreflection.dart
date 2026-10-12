import 'package:flutter/material.dart';

class TopTagsCard extends StatelessWidget {
  const TopTagsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = [
      {"name": "Work", "count": 12},
      {"name": "Gym", "count": 8},
      {"name": "Family", "count": 6},
      {"name": "Stress", "count": 5},
    ];

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
              "Top Tags",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${tag["name"]} (${tag["count"]})",
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}