import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReflectionsAdminScreen extends StatefulWidget {
  const ReflectionsAdminScreen({super.key});

  @override
  State<ReflectionsAdminScreen> createState() =>
      _ReflectionsAdminScreenState();
}

class _ReflectionsAdminScreenState extends State<ReflectionsAdminScreen> {
  String? selectedUserId;
  String? selectedUserName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // LEFT: USERS LIST
        Container(
          width: 250,
          color: Colors.deepPurple.shade50,
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data!.docs;

              return ListView(
                children: users.map((user) {
                  return ListTile(
                    title: Text(user['name'] ?? "User"),
                    subtitle: Text(user.id),
                    selected: selectedUserId == user.id,
                    onTap: () {
                      setState(() {
                        selectedUserId = user.id;
                        selectedUserName = user['name'] ?? "User";
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),

        // RIGHT: REFLECTIONS
        Expanded(
          child: selectedUserId == null
              ? const Center(
                  child: Text("Select a user to view reflections"),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.deepPurple,
                      child: Text(
                        "Reflections of $selectedUserName",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(selectedUserId)
                            .collection('reflections')
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final reflections = snapshot.data!.docs;

                          if (reflections.isEmpty) {
                            return const Center(
                              child: Text("No reflections yet"),
                            );
                          }

                          return ListView.builder(
                            itemCount: reflections.length,
                            itemBuilder: (context, index) {
                              final data = reflections[index];

                              return Card(
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text(data['reflection'] ?? ""),
                                  subtitle: Text(
                                    "Mood: ${data['mood'] ?? 'unknown'}",
                                  ),
                                  trailing: Text(
                                    data['createdAt']
                                            ?.toDate()
                                            .toString()
                                            .substring(0, 16) ??
                                        "",
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}