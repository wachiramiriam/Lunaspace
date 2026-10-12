import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersAdminScreen extends StatefulWidget {
  const UsersAdminScreen({super.key});

  @override
  State<UsersAdminScreen> createState() => _UsersAdminScreenState();
}

class _UsersAdminScreenState extends State<UsersAdminScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin - Users"),
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search users...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // 📦 USER LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: usersStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final data =
                        user.data() as Map<String, dynamic>;

                    final isBanned = data['isBanned'] ?? false;

                    final name =
                        (data['name'] ?? '').toString().toLowerCase();
                    final email =
                        (data['email'] ?? '').toString().toLowerCase();

                    if (searchQuery.isNotEmpty &&
                        !name.contains(searchQuery) &&
                        !email.contains(searchQuery)) {
                      return const SizedBox.shrink();
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      child: ListTile(
                        title: Text(data['name'] ?? 'No name'),
                        subtitle: Text(data['email'] ?? 'No email'),
                        trailing: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                isBanned ? Colors.green : Colors.red,
                          ),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.id)
                                .update({
                              'isBanned': !isBanned,
                            });
                          },
                          child: Text(isBanned ? "Unban" : "Ban"),
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
    );
  }
}