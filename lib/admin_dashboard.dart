import 'package:flutter/material.dart';
import 'admin_users.dart';
import 'admin_home.dart';
import 'admin_analytics.dart';
import 'admin_reflection.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  final pages = [
    const DashboardHome(),        // 0 Dashboard (overview)
    const UsersAdminScreen(),     // 1 Users
    const ReflectionsAdminScreen(),
    const MoodAnalyticsChart(),    // 2 Reflections (placeholder)      // 3 Analytics
  ];

  final titles = [
    "Dashboard",
    "Users",
    "Reflections",
    "Analytics",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 250,
            color: Colors.deepPurpleAccent,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  "ADMIN PANEL",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                ...List.generate(titles.length, (index) {
                  return sidebarItem(titles[index], index);
                }),
              ],
            ),
          ),

          // MAIN CONTENT
          Expanded(
            child: pages[selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget sidebarItem(String title, int index) {
    final isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white24 : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}